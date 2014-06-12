Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbaFLQ0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:26:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39810 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbaFLQZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:25:55 -0400
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH -v2 2/3] MCE, CE: Wire in the CE collector
Date: Thu, 12 Jun 2014 18:22:29 +0200
Message-Id: <1402590150-9798-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402590150-9798-1-git-send-email-bp@alien8.de>
References: <1402590150-9798-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Add the CE collector to the polling path which collects the correctable
errors. Collect only DRAM ECC errors for now.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 64 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bb92f38153b2..f908b4cd7448 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -36,6 +36,7 @@
 #include <linux/nmi.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
+#include <linux/ras.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/debugfs.h>
@@ -577,6 +578,47 @@ static void mce_read_aux(struct mce *m, int i)
 
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
+static bool dram_ce_error(struct mce *m)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		/* ErrCodeExt[20:16] */
+		u8 xec = (m->status >> 16) & 0x1f;
+
+		return (xec == 0x0 || xec == 0x8);
+	} else if (c->x86_vendor == X86_VENDOR_INTEL)
+		/*
+		 * Tony: "You need to look at the low 16 bits of "status"
+		 * (the MCACOD) field and see which is the most significant bit
+		 * set (ignoring bit 12, the "filter" bit).  If the answer is
+		 * bit 7 - then this is a memory error. But you can't just
+		 * blindly check bit 7 because if bit 8 is set, then this is a
+		 * cache error, and if bit 11 is set, then it is a bus/ inter-
+		 * connect error - and either way bit 7 just gives more detail
+		 * on what cache/bus/interconnect error happened."
+		 */
+		return (m->status & 0xef80) == BIT(7);
+	else
+		return false;
+}
+
+static void __log_ce(struct mce *m, enum mcp_flags flags)
+{
+	/*
+	 * Don't get the IP here because it's unlikely to have anything to do
+	 * with the actual error location.
+	 */
+	if ((flags & MCP_DONTLOG) || mca_cfg.dont_log_ce)
+		return;
+
+	if (dram_ce_error(m))
+		ce_add_elem(m->addr >> PAGE_SHIFT);
+	else
+		mce_log(m);
+}
+
+
 /*
  * Poll for corrected events or events that happened before reset.
  * Those are just logged through /dev/mcelog.
@@ -630,12 +672,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
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
@@ -2555,5 +2593,17 @@ static int __init mcheck_debugfs_init(void)
 
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
2.0.0

