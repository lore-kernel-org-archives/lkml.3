Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967021Ab3DQW4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:56:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966945Ab3DQW4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:56:07 -0400
Date: Wed, 17 Apr 2013 15:55:48 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-adbc742bf78695bb98c79d18c558b61571748b99@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, vgoyal@redhat.com, d.hatayama@jp.fujitsu.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, d.hatayama@jp.fujitsu.com, vgoyal@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1366089828-19692-5-git-send-email-yinghai@kernel.org>
References: <1366089828-19692-5-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kdump] x86, kdump: Change crashkernel_high/low=
  to crashkernel=,high/low
Git-Commit-ID: adbc742bf78695bb98c79d18c558b61571748b99
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 15:55:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  adbc742bf78695bb98c79d18c558b61571748b99
Gitweb:     http://git.kernel.org/tip/adbc742bf78695bb98c79d18c558b61571748b99
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 15 Apr 2013 22:23:48 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 17 Apr 2013 12:35:33 -0700

x86, kdump: Change crashkernel_high/low= to crashkernel=,high/low

Per hpa, use crashkernel=X,high crashkernel=Y,low instead of
crashkernel_hign=X crashkernel_low=Y. As that could be extensible.

-v2: according to Vivek, change delimiter to ;
-v3: let hign and low only handle simple form and it conforms to
	description in kernel-parameters.txt
     still keep crashkernel=X override any crashkernel=X,high
        crashkernel=Y,low
-v4: update get_last_crashkernel returning and add more strict
     checking in parse_crashkernel_simple() found by HATAYAMA.
-v5: Change delimiter back to , according to HPA.
     also separate parse_suffix from parse_simper according to vivek.
	so we can avoid @pos in that path.
-v6: Tight the checking about crashkernel=X,highblahblah,high
     found by HTYAYAMA.

Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1366089828-19692-5-git-send-email-yinghai@kernel.org
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt |  10 ++--
 arch/x86/kernel/setup.c             |   6 +-
 kernel/kexec.c                      | 109 +++++++++++++++++++++++++++++++-----
 3 files changed, 104 insertions(+), 21 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 709eb3ed..a1ac1f1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -603,16 +603,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for an example.
 
-	crashkernel_high=size[KMG]
+	crashkernel=size[KMG],high
 			[KNL, x86_64] range could be above 4G. Allow kernel
 			to allocate physical memory region from top, so could
 			be above 4G if system have more than 4G ram installed.
 			Otherwise memory region will be allocated below 4G, if
 			available.
 			It will be ignored if crashkernel=X is specified.
-	crashkernel_low=size[KMG]
-			[KNL, x86_64] range under 4G. When crashkernel_high= is
-			passed, kernel could allocate physical memory region
+	crashkernel=size[KMG],low
+			[KNL, x86_64] range under 4G. When crashkernel=X,high
+			is passed, kernel could allocate physical memory region
 			above 4G, that cause second kernel crash on system
 			that require some amount of low memory, e.g. swiotlb
 			requires at least 64M+32K low memory.  Kernel would
@@ -620,7 +620,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			This one let user to specify own low range under 4G
 			for second kernel instead.
 			0: to disable low allocation.
-			It will be ignored when crashkernel_high=X is not used
+			It will be ignored when crashkernel=X,high is not used
 			or memory reserved is below 4G.
 
 	cs89x0_dma=	[HW,NET]
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a85a144..fae9134 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -528,7 +528,7 @@ static void __init reserve_crashkernel_low(void)
 	int ret;
 
 	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
-	/* crashkernel_low=YM */
+	/* crashkernel=Y,low */
 	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
 						&low_size, &base);
 	if (ret != 0) {
@@ -542,7 +542,7 @@ static void __init reserve_crashkernel_low(void)
 		low_size = swiotlb_size_or_default() + (8UL<<20);
 		auto_set = true;
 	} else {
-		/* passed with crashkernel_low=0 ? */
+		/* passed with crashkernel=0,low ? */
 		if (!low_size)
 			return;
 	}
@@ -582,7 +582,7 @@ static void __init reserve_crashkernel(void)
 	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
 	if (ret != 0 || crash_size <= 0) {
-		/* crashkernel_high=XM */
+		/* crashkernel=X,high */
 		ret = parse_crashkernel_high(boot_command_line, total_mem,
 				&crash_size, &crash_base);
 		if (ret != 0 || crash_size <= 0)
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 1b2f73f..401fdb0 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1368,35 +1368,114 @@ static int __init parse_crashkernel_simple(char 		*cmdline,
 	return 0;
 }
 
+#define SUFFIX_HIGH 0
+#define SUFFIX_LOW  1
+#define SUFFIX_NULL 2
+static __initdata char *suffix_tbl[] = {
+	[SUFFIX_HIGH] = ",high",
+	[SUFFIX_LOW]  = ",low",
+	[SUFFIX_NULL] = NULL,
+};
+
 /*
- * That function is the entry point for command line parsing and should be
- * called from the arch-specific code.
+ * That function parses "suffix"  crashkernel command lines like
+ *
+ *	crashkernel=size,[high|low]
+ *
+ * It returns 0 on success and -EINVAL on failure.
  */
+static int __init parse_crashkernel_suffix(char *cmdline,
+					   unsigned long long	*crash_size,
+					   unsigned long long	*crash_base,
+					   const char *suffix)
+{
+	char *cur = cmdline;
+
+	*crash_size = memparse(cmdline, &cur);
+	if (cmdline == cur) {
+		pr_warn("crashkernel: memory value expected\n");
+		return -EINVAL;
+	}
+
+	/* check with suffix */
+	if (strncmp(cur, suffix, strlen(suffix))) {
+		pr_warn("crashkernel: unrecognized char\n");
+		return -EINVAL;
+	}
+	cur += strlen(suffix);
+	if (*cur != ' ' && *cur != '\0') {
+		pr_warn("crashkernel: unrecognized char\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
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
+	return ck_cmdline;
+}
+
 static int __init __parse_crashkernel(char *cmdline,
 			     unsigned long long system_ram,
 			     unsigned long long *crash_size,
 			     unsigned long long *crash_base,
-				const char *name)
+			     const char *name,
+			     const char *suffix)
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
 
 	ck_cmdline += strlen(name);
 
+	if (suffix)
+		return parse_crashkernel_suffix(ck_cmdline, crash_size,
+				crash_base, suffix);
 	/*
 	 * if the commandline contains a ':', then that's the extended
 	 * syntax -- if not, it must be the classic syntax
@@ -1413,13 +1492,17 @@ static int __init __parse_crashkernel(char *cmdline,
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
+					"crashkernel=", NULL);
 }
 
 int __init parse_crashkernel_high(char *cmdline,
@@ -1428,7 +1511,7 @@ int __init parse_crashkernel_high(char *cmdline,
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel_high=");
+				"crashkernel=", suffix_tbl[SUFFIX_HIGH]);
 }
 
 int __init parse_crashkernel_low(char *cmdline,
@@ -1437,7 +1520,7 @@ int __init parse_crashkernel_low(char *cmdline,
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel_low=");
+				"crashkernel=", suffix_tbl[SUFFIX_LOW]);
 }
 
 static void update_vmcoreinfo_note(void)
