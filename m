Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaJ0A5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:57:46 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52991 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaJ0A5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:57:45 -0400
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH 1/2] x86, mce, severity: extend the the mce_severity mechanism to handle UCNA/DEFERRED error
Date: Mon, 27 Oct 2014 08:56:21 +0800
Message-Id: <1414371382-15491-2-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
References: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, the mce_severity mechanism can only identify the
severity of UCNA error as MCE_KEEP_SEVERITY. Meanwhile, it
is not able to filter out DEFERRED error for ADM platform.

This patch aims to extend the mce_severity mechanism for
handling UCNA/DEFERRED error. In order to do this, the patch
introduces a new severity level - MCE_UCNA/DEFERRED_SEVERITY.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/include/asm/mce.h                |    4 ++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    2 ++
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    6 +++++-
 arch/x86/kernel/cpu/mcheck/mce.c          |    3 ++-
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 958b90f..40b35a5 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -34,6 +34,10 @@
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
 
+/* AMD-specific bits */
+#define MCI_STATUS_DEFERRED	(1ULL<<44)  /* declare an uncorrected error */
+#define MCI_STATUS_POISON	(1ULL<<43)  /* access poisonous data */
+
 /*
  * Note that the full MCACOD field of IA32_MCi_STATUS MSR is
  * bits 15:0.  But bit 12 is the 'F' bit, defined for corrected
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 09edd0b..d32fcbb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -3,6 +3,8 @@
 
 enum severity_level {
 	MCE_NO_SEVERITY,
+	MCE_DEFERRED_SEVERITY,
+	MCE_UCNA_SEVERITY = MCE_DEFERRED_SEVERITY,
 	MCE_KEEP_SEVERITY,
 	MCE_SOME_SEVERITY,
 	MCE_AO_SEVERITY,
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index c370e1c..c12e0a7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -83,13 +83,17 @@ static struct severity {
 		KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
 		),
 	MCESEV(
+		DEFERRED, "Deferred error",
+		NOSER, MASK(MCI_STATUS_UC|MCI_STATUS_DEFERRED|MCI_STATUS_POISON, MCI_STATUS_DEFERRED)
+		),
+	MCESEV(
 		KEEP, "Corrected error",
 		NOSER, BITCLR(MCI_STATUS_UC)
 		),
 
 	/* ignore OVER for UCNA */
 	MCESEV(
-		KEEP, "Uncorrected no action required",
+		UCNA, "Uncorrected no action required",
 		SER, MASK(MCI_UC_SAR, MCI_STATUS_UC)
 		),
 	MCESEV(
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 61a9668ce..fdc422e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1101,7 +1101,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 * When machine check was for corrected handler don't touch,
 		 * unless we're panicing.
 		 */
-		if (severity == MCE_KEEP_SEVERITY && !no_way_out)
+		if ((severity == MCE_KEEP_SEVERITY ||
+		     severity == MCE_UCNA_SEVERITY) && !no_way_out)
 			continue;
 		__set_bit(i, toclear);
 		if (severity == MCE_NO_SEVERITY) {
-- 
1.7.10.4

