Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaE0N1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:27:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52050 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbaE0N1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:27:19 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 2/3] MCE, CE: Wire in the CE collector
Date: Tue, 27 May 2014 15:27:14 +0200
Message-Id: <1401197235-13440-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401197235-13440-1-git-send-email-bp@alien8.de>
References: <1401197235-13440-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Add the CE collector to the polling path which collects the correctable
errors. Collect only DRAM ECC errors for now.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 62 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 55 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 882e79bb0cb6..732fbe61416d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -579,6 +579,46 @@ static void mce_read_aux(struct mce *m, int i)
 
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
+static bool is_a_memory_error(struct mce *m)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		/* ErrCodeExt[20:16] */
+		u8 xec = (m->status >> 16) & 0x1f;
+
+		return (xec == 0x0 || xec == 0x8);
+	} else if (c->x86_vendor == X86_VENDOR_INTEL)
+		return m->status & BIT(7);
+	else
+		return false;
+}
+
+static void __log_ce(struct mce *m, enum mcp_flags flags)
+{
+	int ret;
+
+	/*
+	 * Don't get the IP here because it's unlikely to have anything to do
+	 * with the actual error location.
+	 */
+	if ((flags & MCP_DONTLOG) || mca_cfg.dont_log_ce)
+		return;
+
+	if (is_a_memory_error(m)) {
+		ret = ce_add_elem(m->addr >> PAGE_SHIFT);
+		if (ret < 0) {
+			u64 pfn = ce_del_lru_elem();
+			if (pfn)
+				mce_ring_add(pfn);
+
+			ce_add_elem(m->addr >> PAGE_SHIFT);
+		}
+	} else
+		mce_log(m);
+}
+
+
 /*
  * Poll for corrected events or events that happened before reset.
  * Those are just logged through /dev/mcelog.
@@ -632,12 +672,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
-		/*
-		 * Don't get the IP here because it's unlikely to
-		 * have anything to do with the actual error location.
-		 */
-		if (!(flags & MCP_DONTLOG) && !mca_cfg.dont_log_ce)
-			mce_log(&m);
+
+		__log_ce(&m, flags);
 
 		/*
 		 * Clear state for this bank.
@@ -2530,5 +2566,17 @@ static int __init mcheck_debugfs_init(void)
 
 	return 0;
 }
-late_initcall(mcheck_debugfs_init);
+#else
+static int __init mcheck_debugfs_init(void) {}
 #endif
+
+static int __init mcheck_late_init(void)
+{
+	if (mcheck_debugfs_init())
+		pr_err("Error creating debugfs nodes!\n");
+
+	ce_init();
+
+	return 0;
+}
+late_initcall(mcheck_late_init);
-- 
1.9.0

