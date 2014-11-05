Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaKEEtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:49:05 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58611 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaKEEtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:49:02 -0500
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de, tony.luck@intel.com
Cc: ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Date: Wed,  5 Nov 2014 12:47:52 +0800
Message-Id: <1415162873-1874-2-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, the mce_severity mechanism can only identify the severity
of UCNA error as MCE_KEEP_SEVERITY. Meanwhile, it is not able to filter
out DEFERRED error for ADM platform.

This patch aims to extend the mce_severity mechanism for handling
UCNA/DEFERRED error. In order to do this, the patch introduces a new
severity level - MCE_UCNA/DEFERRED_SEVERITY.

In addition, mce_severity is specific to machine check exception,
and it will check MCIP/EIPV/RIPV bits. In order to use mce_severity
mechanism in non-exception context, the patch also introduces a new
argument (is_excp) for mce_severity. `is_excp' is used to explicitly
specify the calling context of mce_severity.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/include/asm/mce.h                |    4 ++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    4 +++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   21 ++++++++++++++++-----
 arch/x86/kernel/cpu/mcheck/mce.c          |   14 ++++++++------
 4 files changed, 31 insertions(+), 12 deletions(-)

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
index 09edd0b..10b4690 100644
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
@@ -21,7 +23,7 @@ struct mce_bank {
 	char			attrname[ATTR_LEN];	/* attribute name */
 };
 
-int mce_severity(struct mce *a, int tolerant, char **msg);
+int mce_severity(struct mce *a, int tolerant, char **msg, bool is_excp);
 struct dentry *mce_get_debugfs_dir(void);
 
 extern struct mce_bank *mce_banks;
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index c370e1c..d31618d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -31,6 +31,7 @@
 
 enum context { IN_KERNEL = 1, IN_USER = 2 };
 enum ser { SER_REQUIRED = 1, NO_SER = 2 };
+enum exception { EXCP_CONTEXT = 1, NO_EXCP = 2 };
 
 static struct severity {
 	u64 mask;
@@ -40,6 +41,7 @@ static struct severity {
 	unsigned char mcgres;
 	unsigned char ser;
 	unsigned char context;
+	unsigned char excp;
 	unsigned char covered;
 	char *msg;
 } severities[] = {
@@ -48,6 +50,8 @@ static struct severity {
 #define  USER		.context = IN_USER
 #define  SER		.ser = SER_REQUIRED
 #define  NOSER		.ser = NO_SER
+#define  EXCP		.excp = EXCP_CONTEXT
+#define  ONEXCP	.excp = NO_EXCP
 #define  BITCLR(x)	.mask = x, .result = 0
 #define  BITSET(x)	.mask = x, .result = x
 #define  MCGMASK(x, y)	.mcgmask = x, .mcgres = y
@@ -71,16 +75,20 @@ static struct severity {
 	/* When MCIP is not set something is very confused */
 	MCESEV(
 		PANIC, "MCIP not set in MCA handler",
-		MCGMASK(MCG_STATUS_MCIP, 0)
+		EXCP, MCGMASK(MCG_STATUS_MCIP, 0)
 		),
 	/* Neither return not error IP -- no chance to recover -> PANIC */
 	MCESEV(
 		PANIC, "Neither restart nor error IP",
-		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
+		EXCP, MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
 		),
 	MCESEV(
 		PANIC, "In kernel and no restart IP",
-		KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
+		EXCP, KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
+		),
+	MCESEV(
+		DEFERRED, "Deferred error",
+		NOSER, MASK(MCI_STATUS_UC|MCI_STATUS_DEFERRED|MCI_STATUS_POISON, MCI_STATUS_DEFERRED)
 		),
 	MCESEV(
 		KEEP, "Corrected error",
@@ -89,7 +97,7 @@ static struct severity {
 
 	/* ignore OVER for UCNA */
 	MCESEV(
-		KEEP, "Uncorrected no action required",
+		UCNA, "Uncorrected no action required",
 		SER, MASK(MCI_UC_SAR, MCI_STATUS_UC)
 		),
 	MCESEV(
@@ -178,8 +186,9 @@ static int error_context(struct mce *m)
 	return ((m->cs & 3) == 3) ? IN_USER : IN_KERNEL;
 }
 
-int mce_severity(struct mce *m, int tolerant, char **msg)
+int mce_severity(struct mce *m, int tolerant, char **msg, bool is_excp)
 {
+	enum exception excp = (is_excp ? EXCP_CONTEXT : NO_EXCP);
 	enum context ctx = error_context(m);
 	struct severity *s;
 
@@ -194,6 +203,8 @@ int mce_severity(struct mce *m, int tolerant, char **msg)
 			continue;
 		if (s->context && ctx != s->context)
 			continue;
+		if (s->excp && excp != s->excp)
+			continue;
 		if (msg)
 			*msg = s->msg;
 		s->covered = 1;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 61a9668ce..453e9bf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -668,7 +668,8 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 			if (quirk_no_way_out)
 				quirk_no_way_out(i, m, regs);
 		}
-		if (mce_severity(m, mca_cfg.tolerant, msg) >= MCE_PANIC_SEVERITY)
+		if (mce_severity(m, mca_cfg.tolerant, msg, true) >=
+		    MCE_PANIC_SEVERITY)
 			ret = 1;
 	}
 	return ret;
@@ -754,7 +755,7 @@ static void mce_reign(void)
 	for_each_possible_cpu(cpu) {
 		int severity = mce_severity(&per_cpu(mces_seen, cpu),
 					    mca_cfg.tolerant,
-					    &nmsg);
+					    &nmsg, true);
 		if (severity > global_worst) {
 			msg = nmsg;
 			global_worst = severity;
@@ -1095,13 +1096,14 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 */
 		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
 
-		severity = mce_severity(&m, cfg->tolerant, NULL);
+		severity = mce_severity(&m, cfg->tolerant, NULL, true);
 
 		/*
-		 * When machine check was for corrected handler don't touch,
-		 * unless we're panicing.
+		 * When machine check was for corrected/deferred handler don't
+		 * touch, unless we're panicing.
 		 */
-		if (severity == MCE_KEEP_SEVERITY && !no_way_out)
+		if ((severity == MCE_KEEP_SEVERITY ||
+		     severity == MCE_UCNA_SEVERITY) && !no_way_out)
 			continue;
 		__set_bit(i, toclear);
 		if (severity == MCE_NO_SEVERITY) {
-- 
1.7.10.4

