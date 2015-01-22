Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbbAVOZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:25:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAVOZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:25:16 -0500
Date: Thu, 22 Jan 2015 06:24:40 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-8d80696060eedf49c080c0f2cf39a20ae7e787f9@git.kernel.org>
Cc: tglx@linutronix.de, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, bp@alien8.de,
        joro@8bytes.org, hpa@zytor.com, tony.luck@intel.com
Reply-To: tony.luck@intel.com, hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, tglx@linutronix.de
In-Reply-To: <20150115211702.285038186@linutronix.de>
References: <20150115211702.285038186@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Avoid open coded x2apic detection
Git-Commit-ID: 8d80696060eedf49c080c0f2cf39a20ae7e787f9
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

Commit-ID:  8d80696060eedf49c080c0f2cf39a20ae7e787f9
Gitweb:     http://git.kernel.org/tip/8d80696060eedf49c080c0f2cf39a20ae7e787f9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:09 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:54 +0100

x86/apic: Avoid open coded x2apic detection

enable_IR_x2apic() grew a open coded x2apic detection. Implement a
proper helper function which shares the code with the already existing
x2apic_enabled().

Made it use rdmsrl_safe as suggested by Boris.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211702.285038186@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h | 19 ++++++++++---------
 arch/x86/kernel/apic/apic.c |  5 +----
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 465b309..1a8ba26 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -108,6 +108,15 @@ extern u64 native_apic_icr_read(void);
 
 extern int x2apic_mode;
 
+static inline bool apic_is_x2apic_enabled(void)
+{
+	u64 msr;
+
+	if (rdmsrl_safe(MSR_IA32_APICBASE, &msr))
+		return false;
+	return msr & X2APIC_ENABLE;
+}
+
 #ifdef CONFIG_X86_X2APIC
 /*
  * Make previous memory operations globally visible before
@@ -175,15 +184,7 @@ extern void check_x2apic(void);
 extern void enable_x2apic(void);
 static inline int x2apic_enabled(void)
 {
-	u64 msr;
-
-	if (!cpu_has_x2apic)
-		return 0;
-
-	rdmsrl(MSR_IA32_APICBASE, msr);
-	if (msr & X2APIC_ENABLE)
-		return 1;
-	return 0;
+	return cpu_has_x2apic && apic_is_x2apic_enabled();
 }
 
 #define x2apic_supported()	(cpu_has_x2apic)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 35e6d09..7ecfce1 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1625,10 +1625,7 @@ void __init enable_IR_x2apic(void)
 	int ret, ir_stat;
 
 	if (!IS_ENABLED(CONFIG_X86_X2APIC)) {
-		u64 msr;
-
-		rdmsrl(MSR_IA32_APICBASE, msr);
-		if (msr & X2APIC_ENABLE)
+		if (apic_is_x2apic_enabled())
 			panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
 	}
 
