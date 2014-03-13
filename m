Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaCMXTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:19:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbaCMXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:18:57 -0400
Date: Thu, 13 Mar 2014 16:18:42 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-8f86a7373a1c8ee52d3cc64adf7f2ace13fd24ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1394384725-10796-3-git-send-email-bp@alien8.de>
References: <1394384725-10796-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, AMD:
  Convert to the new bit access MSR accessors
Git-Commit-ID: 8f86a7373a1c8ee52d3cc64adf7f2ace13fd24ed
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

Commit-ID:  8f86a7373a1c8ee52d3cc64adf7f2ace13fd24ed
Gitweb:     http://git.kernel.org/tip/8f86a7373a1c8ee52d3cc64adf7f2ace13fd24ed
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 9 Mar 2014 18:05:24 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Mar 2014 15:35:03 -0700

x86, AMD: Convert to the new bit access MSR accessors

... and save us a bunch of code.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1394384725-10796-3-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/amd.c | 48 ++++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c67ffa6..b85e43a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -233,9 +233,7 @@ static void init_amd_k7(struct cpuinfo_x86 *c)
 	if (c->x86_model >= 6 && c->x86_model <= 10) {
 		if (!cpu_has(c, X86_FEATURE_XMM)) {
 			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
-			rdmsr(MSR_K7_HWCR, l, h);
-			l &= ~0x00008000;
-			wrmsr(MSR_K7_HWCR, l, h);
+			msr_clear_bit(MSR_K7_HWCR, 15);
 			set_cpu_cap(c, X86_FEATURE_XMM);
 		}
 	}
@@ -509,14 +507,8 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 #endif
 
 	/* F16h erratum 793, CVE-2013-6885 */
-	if (c->x86 == 0x16 && c->x86_model <= 0xf) {
-		u64 val;
-
-		rdmsrl(MSR_AMD64_LS_CFG, val);
-		if (!(val & BIT(15)))
-			wrmsrl(MSR_AMD64_LS_CFG, val | BIT(15));
-	}
-
+	if (c->x86 == 0x16 && c->x86_model <= 0xf)
+		msr_set_bit(MSR_AMD64_LS_CFG, 15);
 }
 
 static const int amd_erratum_383[];
@@ -536,11 +528,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 	 * Errata 63 for SH-B3 steppings
 	 * Errata 122 for all steppings (F+ have it disabled by default)
 	 */
-	if (c->x86 == 0xf) {
-		rdmsrl(MSR_K7_HWCR, value);
-		value |= 1 << 6;
-		wrmsrl(MSR_K7_HWCR, value);
-	}
+	if (c->x86 == 0xf)
+		msr_set_bit(MSR_K7_HWCR, 6);
 #endif
 
 	early_init_amd(c);
@@ -623,14 +612,11 @@ static void init_amd(struct cpuinfo_x86 *c)
 	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
 	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
 
-		if (!rdmsrl_safe(0xc0011005, &value)) {
-			value |= 1ULL << 54;
-			wrmsrl_safe(0xc0011005, value);
+		if (msr_set_bit(0xc0011005, 54) > 0) {
 			rdmsrl(0xc0011005, value);
-			if (value & (1ULL << 54)) {
+			if (value & BIT_64(54)) {
 				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
-				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
-				  "disabled Topology Extensions Support\n");
+				pr_info(FW_INFO "CPU: Re-enabling disabled Topology Extensions Support.\n");
 			}
 		}
 	}
@@ -709,19 +695,12 @@ static void init_amd(struct cpuinfo_x86 *c)
 		 * Disable GART TLB Walk Errors on Fam10h. We do this here
 		 * because this is always needed when GART is enabled, even in a
 		 * kernel which has no MCE support built in.
-		 * BIOS should disable GartTlbWlk Errors themself. If
-		 * it doesn't do it here as suggested by the BKDG.
+		 * BIOS should disable GartTlbWlk Errors already. If
+		 * it doesn't, do it here as suggested by the BKDG.
 		 *
 		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
 		 */
-		u64 mask;
-		int err;
-
-		err = rdmsrl_safe(MSR_AMD64_MCx_MASK(4), &mask);
-		if (err == 0) {
-			mask |= (1 << 10);
-			wrmsrl_safe(MSR_AMD64_MCx_MASK(4), mask);
-		}
+		msr_set_bit(MSR_AMD64_MCx_MASK(4), 10);
 
 		/*
 		 * On family 10h BIOS may not have properly enabled WC+ support,
@@ -733,10 +712,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 		 * NOTE: we want to use the _safe accessors so as not to #GP kvm
 		 * guests on older kvm hosts.
 		 */
-
-		rdmsrl_safe(MSR_AMD64_BU_CFG2, &value);
-		value &= ~(1ULL << 24);
-		wrmsrl_safe(MSR_AMD64_BU_CFG2, value);
+		msr_clear_bit(MSR_AMD64_BU_CFG2, 24);
 
 		if (cpu_has_amd_erratum(c, amd_erratum_383))
 			set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
