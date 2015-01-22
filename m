Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbbAVO0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:26:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbAVO0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:26:36 -0500
Date: Thu, 22 Jan 2015 06:26:11 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-d524165cb8dbb2ce5916cd7682236b9324ae2644@git.kernel.org>
Cc: tglx@linutronix.de, hpa@zytor.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com, bp@alien8.de,
        mingo@kernel.org, joro@8bytes.org
Reply-To: joro@8bytes.org, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, tony.luck@intel.com, mingo@kernel.org,
        bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <20150115211702.702479404@linutronix.de>
References: <20150115211702.702479404@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Check x2apic early
Git-Commit-ID: d524165cb8dbb2ce5916cd7682236b9324ae2644
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d524165cb8dbb2ce5916cd7682236b9324ae2644
Gitweb:     http://git.kernel.org/tip/d524165cb8dbb2ce5916cd7682236b9324ae2644
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:17 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:54 +0100

x86/apic: Check x2apic early

No point in delaying the x2apic detection for the CONFIG_X86_X2APIC=n
case to enable_IR_x2apic(). We rather detect that before we try to
setup anything there.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211702.702479404@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |  2 +-
 arch/x86/kernel/apic/apic.c | 34 ++++++++++++++++++++--------------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 392bbcf..ca8deb4 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -178,7 +178,7 @@ static inline u64 native_x2apic_icr_read(void)
 
 extern int x2apic_mode;
 extern int x2apic_phys;
-extern void check_x2apic(void);
+extern void __init check_x2apic(void);
 extern void enable_x2apic(void);
 static inline int x2apic_enabled(void)
 {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fdc6c60..d5c3534 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1541,14 +1541,6 @@ static __init void disable_x2apic(void)
 	x2apic_disabled = 1;
 }
 
-void check_x2apic(void)
-{
-	if (x2apic_enabled()) {
-		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_mode = 1;
-	}
-}
-
 void enable_x2apic(void)
 {
 	u64 msr;
@@ -1568,7 +1560,26 @@ void enable_x2apic(void)
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
-#endif /* CONFIG_X86_X2APIC */
+
+void __init check_x2apic(void)
+{
+	if (x2apic_enabled()) {
+		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
+		x2apic_mode = 1;
+	}
+}
+#else /* CONFIG_X86_X2APIC */
+static int __init validate_x2apic(void)
+{
+	if (!apic_is_x2apic_enabled())
+		return 0;
+	/*
+	 * Checkme: Can we simply turn off x2apic here instead of panic?
+	 */
+	panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
+}
+early_initcall(validate_x2apic);
+#endif /* !CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
 {
@@ -1620,11 +1631,6 @@ void __init enable_IR_x2apic(void)
 	unsigned long flags;
 	int ret, ir_stat;
 
-	if (!IS_ENABLED(CONFIG_X86_X2APIC)) {
-		if (apic_is_x2apic_enabled())
-			panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
-	}
-
 	ir_stat = irq_remapping_prepare();
 	if (ir_stat < 0 && !x2apic_supported())
 		return;
