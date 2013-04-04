Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab3DDAj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:39:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23799 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761971Ab3DDAjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:39:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 4/4] x86, kdump: Change crashkernel_high/low= to crashkernel=;high/low
Date: Wed,  3 Apr 2013 17:38:26 -0700
Message-Id: <1365035906-3208-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
References: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per hpa, use crashkernel=XM;high crashkernel=YM;low instead of
crashkernel_hign=XM crashkernel_low=YM. As that could be extensible.

-v2: according to Vivek, change delimiter to ;
-v3: let hign and low only handle simple form and it conforms to
	description in kernel-parameters.txt
     still keep crashkernel=X override any crashkernel=X,high
        crashkernel=Y,low

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/kernel-parameters.txt |   10 +--
 arch/x86/kernel/setup.c             |    6 +-
 kernel/kexec.c                      |   94 +++++++++++++++++++++++++++---------
 3 files changed, 80 insertions(+), 30 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -603,14 +603,14 @@ bytes respectively. Such letter suffixes
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for an example.
 
-	crashkernel_high=size[KMG]
+	crashkernel=size[KMG];high
 			[KNL, x86_64] range could be above 4G. Allow kernel
 			to allocate physical memory region from top, so could
 			be above 4G if system have more than 4G ram installed.
 			It will be ignored if crashkernel=X is specified.
-	crashkernel_low=size[KMG]
-			[KNL, x86_64] range under 4G. When crashkernel_high= is
-			passed, kernel could allocate physical memory region
+	crashkernel=size[KMG];low
+			[KNL, x86_64] range under 4G. When crashkernel=X;high
+			is passed, kernel could allocate physical memory region
 			above 4G, that cause second kernel crash on system
 			that need swiotlb later. Kernel would try to allocate
 			some region below 4G automatically. This one let
@@ -619,7 +619,7 @@ bytes respectively. Such letter suffixes
 			0: to disable low allocation on systems that do not
 			need swiotlb, that will save 72M low ram in first
 			kernel.
-			It will be ignored when crashkernel_high=X is not used
+			It will be ignored when crashkernel=X;high is not used
 			or return from that is below 4G.
 
 	cs89x0_dma=	[HW,NET]
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -526,7 +526,7 @@ static void __init reserve_crashkernel_l
 	int ret;
 
 	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
-	/* crashkernel_low=YM */
+	/* crashkernel=YM;low */
 	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
 						&low_size, &base);
 	if (ret != 0) {
@@ -539,7 +539,7 @@ static void __init reserve_crashkernel_l
 		low_size = swiotlb_size_or_default() + (8UL<<20);
 		auto_set = true;
 	} else {
-		/* passed with crashkernel_low=0 ? */
+		/* passed with crashkernel=0;low ? */
 		if (!low_size)
 			return;
 	}
@@ -579,7 +579,7 @@ static void __init reserve_crashkernel(v
 	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
 	if (ret != 0 || crash_size <= 0) {
-		/* crashkernel_high=XM */
+		/* crashkernel=XM;high */
 		ret = parse_crashkernel_high(boot_command_line, total_mem,
 				&crash_size, &crash_base);
 		if (ret != 0 || crash_size <= 0)
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -1360,7 +1360,7 @@ static int __init parse_crashkernel_simp
 
 	if (*cur == '@')
 		*crash_base = memparse(cur+1, &cur);
-	else if (*cur != ' ' && *cur != '\0') {
+	else if (*cur != ' ' && *cur != ';' && *cur != '\0') {
 		pr_warning("crashkernel: unrecognized char\n");
 		return -EINVAL;
 	}
@@ -1368,58 +1368,108 @@ static int __init parse_crashkernel_simp
 	return 0;
 }
 
-/*
- * That function is the entry point for command line parsing and should be
- * called from the arch-specific code.
- */
+#define SUFFIX_HIGH 0
+#define SUFFIX_LOW  1
+#define SUFFIX_NULL 2
+static __initdata char *suffix_tbl[] = {
+	[SUFFIX_HIGH] = ";high",
+	[SUFFIX_LOW]  = ";low",
+	[SUFFIX_NULL] = NULL,
+};
+
+static __init char *get_last_crashkernel(char *cmdline,
+			     const char *name,
+			     const char *suffix)
+{
+	char *p = cmdline, *ck_cmdline = NULL;
+
+	/* find crashkernel and use the last one if there are more */
+	p = strstr(p, name);
+	while (p) {
+		char *end_p = strchr(p, ' ');
+		char *q;
+
+		if (!end_p)
+			end_p = p + strlen(p);
+
+		if (!suffix) {
+			int i;
+
+			/* skip the one with any known suffix */
+			for (i = 0; suffix_tbl[i]; i++) {
+				q = end_p - strlen(suffix_tbl[i]);
+				if (!strncmp(q, suffix_tbl[i],
+					     strlen(suffix_tbl[i])))
+					goto next;
+			}
+			ck_cmdline = p;
+		} else {
+			q = end_p - strlen(suffix);
+			if (!strncmp(q, suffix, strlen(suffix)))
+				ck_cmdline = p;
+		}
+next:
+		p = strstr(p+1, name);
+	}
+
+	if (!ck_cmdline)
+		return NULL;
+
+	ck_cmdline += strlen(name);
+
+	return ck_cmdline;
+}
+
 static int __init __parse_crashkernel(char *cmdline,
 			     unsigned long long system_ram,
 			     unsigned long long *crash_size,
 			     unsigned long long *crash_base,
-				const char *name)
+			     const char *name,
+			     const char *suffix,
+			     bool simple_only)
 {
-	char 	*p = cmdline, *ck_cmdline = NULL;
 	char	*first_colon, *first_space;
+	char	*ck_cmdline;
 
 	BUG_ON(!crash_size || !crash_base);
 	*crash_size = 0;
 	*crash_base = 0;
 
-	/* find crashkernel and use the last one if there are more */
-	p = strstr(p, name);
-	while (p) {
-		ck_cmdline = p;
-		p = strstr(p+1, name);
-	}
+	ck_cmdline = get_last_crashkernel(cmdline, name, suffix);
 
 	if (!ck_cmdline)
 		return -EINVAL;
 
-	ck_cmdline += strlen(name);
-
 	/*
 	 * if the commandline contains a ':', then that's the extended
 	 * syntax -- if not, it must be the classic syntax
 	 */
 	first_colon = strchr(ck_cmdline, ':');
 	first_space = strchr(ck_cmdline, ' ');
-	if (first_colon && (!first_space || first_colon < first_space))
-		return parse_crashkernel_mem(ck_cmdline, system_ram,
-				crash_size, crash_base);
-	else
+	if (first_colon && (!first_space || first_colon < first_space)) {
+		if (simple_only)
+			return -EINVAL;
+		else
+			return parse_crashkernel_mem(ck_cmdline, system_ram,
+					crash_size, crash_base);
+	} else
 		return parse_crashkernel_simple(ck_cmdline, crash_size,
 				crash_base);
 
 	return 0;
 }
 
+/*
+ * That function is the entry point for command line parsing and should be
+ * called from the arch-specific code.
+ */
 int __init parse_crashkernel(char *cmdline,
 			     unsigned long long system_ram,
 			     unsigned long long *crash_size,
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel=");
+					"crashkernel=", NULL, false);
 }
 
 int __init parse_crashkernel_high(char *cmdline,
@@ -1428,7 +1478,7 @@ int __init parse_crashkernel_high(char *
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel_high=");
+				"crashkernel=", suffix_tbl[SUFFIX_HIGH], true);
 }
 
 int __init parse_crashkernel_low(char *cmdline,
@@ -1437,7 +1487,7 @@ int __init parse_crashkernel_low(char *c
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel_low=");
+				"crashkernel=", suffix_tbl[SUFFIX_LOW], true);
 }
 
 static void update_vmcoreinfo_note(void)
