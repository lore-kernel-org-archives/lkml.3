Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3AaWpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:45:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45135 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab3AaWpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:45:19 -0500
Date: Thu, 31 Jan 2013 14:45:06 -0800
From: tip-bot for Boris Ostrovsky <boris.ostrovsky@amd.com>
Message-ID: <tip-f0322bd341fd63261527bf84afd3272bcc2e8dd3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359495169-23278-1-git-send-email-ostr@amd64.org>
References: <1359495169-23278-1-git-send-email-ostr@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, AMD:
  Enable WC+ memory type on family 10 processors
Git-Commit-ID: f0322bd341fd63261527bf84afd3272bcc2e8dd3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:45:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0322bd341fd63261527bf84afd3272bcc2e8dd3
Gitweb:     http://git.kernel.org/tip/f0322bd341fd63261527bf84afd3272bcc2e8dd3
Author:     Boris Ostrovsky <boris.ostrovsky@amd.com>
AuthorDate: Tue, 29 Jan 2013 16:32:49 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 13:35:38 -0800

x86, AMD: Enable WC+ memory type on family 10 processors

In some cases BIOS may not enable WC+ memory type on family 10
processors, instead converting what would be WC+ memory to CD type.
On guests using nested pages this could result in performance
degradation. This patch enables WC+.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Link: http://lkml.kernel.org/r/1359495169-23278-1-git-send-email-ostr@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/uapi/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/amd.c             | 21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 433a59f..158cde9 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -173,6 +173,7 @@
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_DC_CFG		0xc0011022
+#define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index dd4a5b6..721ef32 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -698,13 +698,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
-	/*
-	 * Disable GART TLB Walk Errors on Fam10h. We do this here
-	 * because this is always needed when GART is enabled, even in a
-	 * kernel which has no MCE support built in.
-	 */
 	if (c->x86 == 0x10) {
 		/*
+		 * Disable GART TLB Walk Errors on Fam10h. We do this here
+		 * because this is always needed when GART is enabled, even in a
+		 * kernel which has no MCE support built in.
 		 * BIOS should disable GartTlbWlk Errors themself. If
 		 * it doesn't do it here as suggested by the BKDG.
 		 *
@@ -718,6 +716,19 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 			mask |= (1 << 10);
 			wrmsrl_safe(MSR_AMD64_MCx_MASK(4), mask);
 		}
+
+		/*
+		 * On family 10h BIOS may not have properly enabled WC+ support,
+		 * causing it to be converted to CD memtype. This may result in
+		 * performance degradation for certain nested-paging guests.
+		 * Prevent this conversion by clearing bit 24 in
+		 * MSR_AMD64_BU_CFG2.
+		 */
+		if (c->x86 == 0x10) {
+			rdmsrl(MSR_AMD64_BU_CFG2, value);
+			value &= ~(1ULL << 24);
+			wrmsrl(MSR_AMD64_BU_CFG2, value);
+		}
 	}
 
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
