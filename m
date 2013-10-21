Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3JUTDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:03:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:50529 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab3JUTDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:03:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310717598"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
In-Reply-To: <20131019095753.GA26338@pd.tnic>
Date: Mon, 21 Oct 2013 12:03:20 -0700
Message-Id: <52657a78162905670f@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But yes, this is possible and it would make it all even cleaner
> and simpler by simply not needing the reg/dereg interfaces for
> mce_ext_err_print but adding it to the chain.

So this is on top of the 9 patch series (using the V4 that Chen Gong
posted for part 4/9 and V3 for all the others).  Obviously it should
be folded back into the series if we go this way.

It's a bit simplistic right now - the registered function just returns
NOTIFY_DONE in all cases so it will not disturb processing by any other
registered functions - we can make it smarter later.

-Tony

---

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 072b2f80a345..8b8e72522737 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -188,9 +188,6 @@ enum mcp_flags {
 	MCP_DONTLOG = (1 << 2),		/* only clear, don't log */
 };
 
-void register_elog_handler(int (*f)(const char *, int, int));
-void unregister_elog_handler(int (*f)(const char *, int, int));
-
 void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
 int mce_notify_irq(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 981e0d3ed49d..b3218cdee95f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -48,8 +48,6 @@
 
 #include "mce-internal.h"
 
-static int (*mce_ext_err_print)(const char *, int, int);
-
 static DEFINE_MUTEX(mce_chrdev_read_mutex);
 
 #define rcu_dereference_check_mce(p) \
@@ -578,21 +576,6 @@ static void mce_read_aux(struct mce *m, int i)
 
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
-void register_elog_handler(int (*f)(const char *, int, int))
-{
-	mce_ext_err_print = f;
-}
-EXPORT_SYMBOL_GPL(register_elog_handler);
-
-void unregister_elog_handler(int (*f)(const char *, int, int))
-{
-	if (f) {
-		WARN_ON(mce_ext_err_print != f);
-		mce_ext_err_print = NULL;
-	}
-}
-EXPORT_SYMBOL_GPL(unregister_elog_handler);
-
 /*
  * Poll for corrected events or events that happened before reset.
  * Those are just logged through /dev/mcelog.
@@ -641,9 +624,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
-		if (mce_ext_err_print)
-			mce_ext_err_print(NULL, m.extcpu, i);
-
 		mce_read_aux(&m, i);
 
 		if (!(flags & MCP_TIMESTAMP))
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 1bc657d3d053..eb0d7792ecc1 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -130,22 +130,26 @@ static int print_extlog_rcd(const char *pfx,
 	return 1;
 }
 
-static int extlog_print(const char *pfx, int cpu, int bank)
+static int extlog_print(struct notifier_block *nb, unsigned long val,
+			void *data)
 {
+	struct mce *mce = (struct mce *)data;
+	int	bank = mce->bank;
+	int	cpu = mce->extcpu;
 	struct acpi_generic_status *estatus;
 	int rc;
 
 	estatus = extlog_elog_entry_check(cpu, bank);
 	if (estatus == NULL)
-		return -EINVAL;
+		return NOTIFY_DONE;
 
 	memcpy(elog_buf, (void *)estatus, ELOG_ENTRY_LEN);
 	/* clear record status to enable BIOS to update it again */
 	estatus->block_status = 0;
 
-	rc = print_extlog_rcd(pfx, (struct acpi_generic_status *)elog_buf, cpu);
+	rc = print_extlog_rcd(NULL, (struct acpi_generic_status *)elog_buf, cpu);
 
-	return rc;
+	return NOTIFY_DONE;
 }
 
 static int extlog_get_dsm(acpi_handle handle, int rev, int func, u64 *ret)
@@ -213,6 +217,9 @@ static bool extlog_get_l1addr(void)
 
 	return true;
 }
+static struct notifier_block extlog_mce_dec = {
+	.notifier_call	= extlog_print,
+};
 
 static int __init extlog_init(void)
 {
@@ -279,7 +286,7 @@ static int __init extlog_init(void)
 	if (elog_buf == NULL)
 		goto err_release_elog;
 
-	register_elog_handler(extlog_print);
+	mce_register_decode_chain(&extlog_mce_dec);
 	/* enable OS to be involved to take over management from BIOS */
 	((struct extlog_l1_head *)extlog_l1_addr)->flags |= FLAG_OS_OPTIN;
 
@@ -300,7 +307,7 @@ err:
 
 static void __exit extlog_exit(void)
 {
-	unregister_elog_handler(extlog_print);
+	mce_unregister_decode_chain(&extlog_mce_dec);
 	((struct extlog_l1_head *)extlog_l1_addr)->flags &= ~FLAG_OS_OPTIN;
 	if (extlog_l1_addr)
 		acpi_os_unmap_memory(extlog_l1_addr, l1_size);
