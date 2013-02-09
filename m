Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab3BIBJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:09:48 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:64473 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947665Ab3BIBIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:51 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 13/16] tools/power turbostat: decode MSR_IA32_POWER_CTL
Date: Fri,  8 Feb 2013 20:08:17 -0500
Message-Id: <679204183472af16e8e75d2b1479459ad19bc67c.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

When verbose is enabled, print the C1E-Enable
bit in MSR_IA32_POWER_CTL.

also delete some redundant tests on the verbose variable.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/uapi/asm/msr-index.h |  2 ++
 tools/power/x86/turbostat/turbostat.c | 13 +++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 433a59f..7bdaf7c 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -103,6 +103,8 @@
 #define DEBUGCTLMSR_BTS_OFF_USR		(1UL << 10)
 #define DEBUGCTLMSR_FREEZE_LBRS_ON_PMI	(1UL << 11)
 
+#define MSR_IA32_POWER_CTL		0x000001fc
+
 #define MSR_IA32_MC0_CTL		0x00000400
 #define MSR_IA32_MC0_STATUS		0x00000401
 #define MSR_IA32_MC0_ADDR		0x00000402
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index b326878..75f64e0 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -908,8 +908,7 @@ void print_verbose_header(void)
 
 	get_msr(0, MSR_NHM_PLATFORM_INFO, &msr);
 
-	if (verbose)
-		fprintf(stderr, "cpu0: MSR_NHM_PLATFORM_INFO: 0x%08llx\n", msr);
+	fprintf(stderr, "cpu0: MSR_NHM_PLATFORM_INFO: 0x%08llx\n", msr);
 
 	ratio = (msr >> 40) & 0xFF;
 	fprintf(stderr, "%d * %.0f = %.0f MHz max efficiency\n",
@@ -919,13 +918,16 @@ void print_verbose_header(void)
 	fprintf(stderr, "%d * %.0f = %.0f MHz TSC frequency\n",
 		ratio, bclk, ratio * bclk);
 
+	get_msr(0, MSR_IA32_POWER_CTL, &msr);
+	fprintf(stderr, "cpu0: MSR_IA32_POWER_CTL: 0x%08llx (C1E: %sabled)\n",
+		msr, msr & 0x2 ? "EN" : "DIS");
+
 	if (!do_ivt_turbo_ratio_limit)
 		goto print_nhm_turbo_ratio_limits;
 
 	get_msr(0, MSR_IVT_TURBO_RATIO_LIMIT, &msr);
 
-	if (verbose)
-		fprintf(stderr, "cpu0: MSR_IVT_TURBO_RATIO_LIMIT: 0x%08llx\n", msr);
+	fprintf(stderr, "cpu0: MSR_IVT_TURBO_RATIO_LIMIT: 0x%08llx\n", msr);
 
 	ratio = (msr >> 56) & 0xFF;
 	if (ratio)
@@ -1016,8 +1018,7 @@ print_nhm_turbo_ratio_limits:
 
 	get_msr(0, MSR_NHM_TURBO_RATIO_LIMIT, &msr);
 
-	if (verbose)
-		fprintf(stderr, "cpu0: MSR_NHM_TURBO_RATIO_LIMIT: 0x%08llx\n", msr);
+	fprintf(stderr, "cpu0: MSR_NHM_TURBO_RATIO_LIMIT: 0x%08llx\n", msr);
 
 	ratio = (msr >> 56) & 0xFF;
 	if (ratio)
-- 
1.8.1.3.535.ga923c31

