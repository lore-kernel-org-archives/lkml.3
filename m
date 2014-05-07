Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbaEGPfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:35:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbaEGPfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:35:16 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, ak@linux.intel.com,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/5] x86, nmi:  Add new nmi type 'external'
Date: Wed,  7 May 2014 11:34:39 -0400
Message-Id: <1399476883-98970-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed when debugging a perf problem on a machine with GHES enabled,
perf seemed slow.  I then realized that the GHES NMI routine was taking
a global lock all the time to inspect the hardware.  This contended
with all the local perf counters which did not need a lock.  So each cpu
accidentally was synchronizing with itself when using perf.

This is because the way the nmi handler works.  It executes all the handlers
registered to a particular subtype (to deal with nmi sharing).  As a result
the GHES handler was executed on every PMI.

Fix this by creating a new nmi type called NMI_EXT, which is used by
handlers that need to probe external hardware and require a global lock
to do so.

Now the main NMI handler can check the internal NMI handlers first and
then the external ones if nothing is found.

This makes perf a little faster again on those machines with GHES enabled.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |    1 +
 arch/x86/kernel/nmi.c      |   41 ++++++++++++++++++++++++++---------------
 drivers/acpi/apei/ghes.c   |    4 ++--
 drivers/watchdog/hpwdt.c   |   10 ++--------
 4 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 86f9301..d6d26fa 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -24,6 +24,7 @@ extern int unknown_nmi_panic;
 
 enum {
 	NMI_LOCAL=0,
+	NMI_EXT,
 	NMI_UNKNOWN,
 	NMI_SERR,
 	NMI_IO_CHECK,
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 6fcb49c..72fcff7 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -34,29 +34,32 @@
 #include <trace/events/nmi.h>
 
 struct nmi_desc {
-	spinlock_t lock;
-	struct list_head head;
+	spinlock_t		lock;
+	struct list_head	head;
 };
 
 static struct nmi_desc nmi_desc[NMI_MAX] = 
 {
-	{
-		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[0].lock),
-		.head = LIST_HEAD_INIT(nmi_desc[0].head),
+	[NMI_LOCAL] = {
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[NMI_LOCAL].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[NMI_LOCAL].head),
 	},
-	{
-		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[1].lock),
-		.head = LIST_HEAD_INIT(nmi_desc[1].head),
+	[NMI_EXT] = {
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[NMI_EXT].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[NMI_EXT].head),
 	},
-	{
-		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[2].lock),
-		.head = LIST_HEAD_INIT(nmi_desc[2].head),
+	[NMI_UNKNOWN] = {
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[NMI_UNKNOWN].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[NMI_UNKNOWN].head),
 	},
-	{
-		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[3].lock),
-		.head = LIST_HEAD_INIT(nmi_desc[3].head),
+	[NMI_SERR] = {
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[NMI_SERR].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[NMI_SERR].head),
+	},
+	[NMI_IO_CHECK] = {
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[NMI_IO_CHECK].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[NMI_IO_CHECK].head),
 	},
-
 };
 
 struct nmi_stats {
@@ -317,8 +320,16 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 
 	__this_cpu_write(last_nmi_rip, regs->ip);
 
+	/* try local NMIs first */
 	handled = nmi_handle(NMI_LOCAL, regs, b2b);
 	__this_cpu_add(nmi_stats.normal, handled);
+
+	/* if unclaimed, try external NMIs next */
+	if (!handled) {
+		handled = nmi_handle(NMI_EXT, regs, b2b);
+		__this_cpu_add(nmi_stats.external, handled);
+	}
+
 	if (handled) {
 		/*
 		 * There are cases when a NMI handler handles multiple
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index dab7cb7..8b78bf5 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -976,7 +976,7 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		ghes_estatus_pool_expand(len);
 		mutex_lock(&ghes_list_mutex);
 		if (list_empty(&ghes_nmi))
-			register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
+			register_nmi_handler(NMI_EXT, ghes_notify_nmi, 0,
 						"ghes");
 		list_add_rcu(&ghes->list, &ghes_nmi);
 		mutex_unlock(&ghes_list_mutex);
@@ -1025,7 +1025,7 @@ static int ghes_remove(struct platform_device *ghes_dev)
 		mutex_lock(&ghes_list_mutex);
 		list_del_rcu(&ghes->list);
 		if (list_empty(&ghes_nmi))
-			unregister_nmi_handler(NMI_LOCAL, "ghes");
+			unregister_nmi_handler(NMI_EXT, "ghes");
 		mutex_unlock(&ghes_list_mutex);
 		/*
 		 * To synchronize with NMI handler, ghes can only be
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 2b75e8b..9617a4d 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -737,12 +737,9 @@ static int hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt");
 	if (retval)
 		goto error;
-	retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_EXT, hpwdt_pretimeout, 0, "hpwdt");
 	if (retval)
 		goto error1;
-	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt");
-	if (retval)
-		goto error2;
 
 	dev_info(&dev->dev,
 			"HP Watchdog Timer Driver: NMI decoding initialized"
@@ -750,8 +747,6 @@ static int hpwdt_init_nmi_decoding(struct pci_dev *dev)
 			(allow_kdump == 0) ? "OFF" : "ON");
 	return 0;
 
-error2:
-	unregister_nmi_handler(NMI_SERR, "hpwdt");
 error1:
 	unregister_nmi_handler(NMI_UNKNOWN, "hpwdt");
 error:
@@ -766,8 +761,7 @@ error:
 static void hpwdt_exit_nmi_decoding(void)
 {
 	unregister_nmi_handler(NMI_UNKNOWN, "hpwdt");
-	unregister_nmi_handler(NMI_SERR, "hpwdt");
-	unregister_nmi_handler(NMI_IO_CHECK, "hpwdt");
+	unregister_nmi_handler(NMI_EXT, "hpwdt");
 	if (cru_rom_addr)
 		iounmap(cru_rom_addr);
 }
-- 
1.7.1

