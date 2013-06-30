Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab3F3KC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 06:02:27 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:34113 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3F3KC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 06:02:26 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/mac: Allocate IOP message pool and queues dynamically
Date: Sun, 30 Jun 2013 12:02:22 +0200
Message-Id: <1372586542-1318-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the IOP message pool and queues are allocated statically,
wasting ca. 5 KiB when running a Mac or multi-platform kernel on a machine
not having a Mac IOP. Convert them to conditional dynamic memory
allocations to fix this.

As kzalloc() returns zeroed memory, there's no need to initialize (parts of)
the allocated structures to zeroes.

This required moving the call to iop_init() from mac_identify() to
mac_platform_init() (slab nor bootmem are available at mac_identify() call
time), and allowed to integrate iop_register_interrupts() into iop_init().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Untested due to lack of hardware

 arch/m68k/include/asm/mac_iop.h |    2 --
 arch/m68k/mac/config.c          |    3 ++-
 arch/m68k/mac/iop.c             |   57 ++++++++++++++++++---------------------
 arch/m68k/mac/macints.c         |    1 -
 4 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/arch/m68k/include/asm/mac_iop.h b/arch/m68k/include/asm/mac_iop.h
index fde874a..a2c7e6f 100644
--- a/arch/m68k/include/asm/mac_iop.h
+++ b/arch/m68k/include/asm/mac_iop.h
@@ -159,6 +159,4 @@ extern void iop_upload_code(uint, __u8 *, uint, __u16);
 extern void iop_download_code(uint, __u8 *, uint, __u16);
 extern __u8 *iop_compare_code(uint, __u8 *, uint, __u16);
 
-extern void iop_register_interrupts(void);
-
 #endif /* __ASSEMBLY__ */
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index afb95d5..a8d62a8 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -925,7 +925,6 @@ static void __init mac_identify(void)
 	printk(KERN_DEBUG " Machine ID: %ld CPUid: 0x%lx memory size: 0x%lx\n",
 		mac_bi_data.id, mac_bi_data.cpuid, mac_bi_data.memsize);
 
-	iop_init();
 	via_init();
 	oss_init();
 	psc_init();
@@ -983,6 +982,8 @@ int __init mac_platform_init(void)
 	if (!MACH_IS_MAC)
 		return -ENODEV;
 
+	iop_init();
+
 	/*
 	 * Serial devices
 	 */
diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index 8a4c446..6cc3055 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -104,6 +104,7 @@
  * should execute quickly.)
  */
 
+#include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -142,9 +143,9 @@ static volatile struct mac_iop *iop_base[NUM_IOPS];
  * IOP message queues
  */
 
-static struct iop_msg iop_msg_pool[NUM_IOP_MSGS];
-static struct iop_msg *iop_send_queue[NUM_IOPS][NUM_IOP_CHAN];
-static struct listener iop_listeners[NUM_IOPS][NUM_IOP_CHAN];
+static struct iop_msg *iop_msg_pool;
+static struct iop_msg **iop_send_queue[NUM_IOPS];
+static struct listener *iop_listeners[NUM_IOPS];
 
 irqreturn_t iop_ism_irq(int, void *);
 
@@ -260,47 +261,38 @@ void __init iop_preinit(void)
 	}
 }
 
+static void __init alloc_msg_queue(int iop_num)
+{
+	iop_send_queue[iop_num] =
+		kzalloc(NUM_IOP_CHAN * sizeof(**iop_send_queue), GFP_KERNEL);
+	iop_listeners[iop_num] =
+		kzalloc(NUM_IOP_CHAN * sizeof(**iop_listeners), GFP_KERNEL);
+}
+
 /*
  * Initialize the IOPs, if present.
  */
 
 void __init iop_init(void)
 {
-	int i;
+	if (!iop_scc_present && !iop_ism_present)
+		return;
+
+	iop_msg_pool = kzalloc(NUM_IOP_MSGS * sizeof(*iop_msg_pool),
+			       GFP_KERNEL);
 
 	if (iop_scc_present) {
 		printk("IOP: detected SCC IOP at %p\n", iop_base[IOP_NUM_SCC]);
+		alloc_msg_queue(IOP_NUM_SCC);
 	}
 	if (iop_ism_present) {
 		printk("IOP: detected ISM IOP at %p\n", iop_base[IOP_NUM_ISM]);
-		iop_start(iop_base[IOP_NUM_ISM]);
-		iop_alive(iop_base[IOP_NUM_ISM]); /* clears the alive flag */
-	}
-
-	/* Make the whole pool available and empty the queues */
-
-	for (i = 0 ; i < NUM_IOP_MSGS ; i++) {
-		iop_msg_pool[i].status = IOP_MSGSTATUS_UNUSED;
-	}
+		alloc_msg_queue(IOP_NUM_ISM);
 
-	for (i = 0 ; i < NUM_IOP_CHAN ; i++) {
-		iop_send_queue[IOP_NUM_SCC][i] = NULL;
-		iop_send_queue[IOP_NUM_ISM][i] = NULL;
-		iop_listeners[IOP_NUM_SCC][i].devname = NULL;
-		iop_listeners[IOP_NUM_SCC][i].handler = NULL;
-		iop_listeners[IOP_NUM_ISM][i].devname = NULL;
-		iop_listeners[IOP_NUM_ISM][i].handler = NULL;
-	}
-}
-
-/*
- * Register the interrupt handler for the IOPs.
- * TODO: might be wrong for non-OSS machines. Anyone?
- */
-
-void __init iop_register_interrupts(void)
-{
-	if (iop_ism_present) {
+		/*
+		 * Register the interrupt handler for the IOPs.
+		 * TODO: might be wrong for non-OSS machines. Anyone?
+		 */
 		if (macintosh_config->ident == MAC_MODEL_IIFX) {
 			if (request_irq(IRQ_MAC_ADB, iop_ism_irq, 0,
 					"ISM IOP", (void *)IOP_NUM_ISM))
@@ -315,6 +307,9 @@ void __init iop_register_interrupts(void)
 		} else {
 			printk("IOP: the ISM IOP seems to be alive.\n");
 		}
+
+		iop_start(iop_base[IOP_NUM_ISM]);
+		iop_alive(iop_base[IOP_NUM_ISM]); /* clears the alive flag */
 	}
 }
 
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index 5c1a6b2..da42c18 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -178,7 +178,6 @@ void __init mac_init_IRQ(void)
 		psc_register_interrupts();
 	if (baboon_present)
 		baboon_register_interrupts();
-	iop_register_interrupts();
 	if (request_irq(IRQ_AUTO_7, mac_nmi_handler, 0, "NMI",
 			mac_nmi_handler))
 		pr_err("Couldn't register NMI\n");
-- 
1.7.9.5

