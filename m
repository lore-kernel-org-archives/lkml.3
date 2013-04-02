Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab3DBRUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:20:43 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37905 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab3DBRUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:20:40 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, kdump: Change crashkernel_high/low= to crashkernel=;high/low
Date: Tue,  2 Apr 2013 10:19:43 -0700
Message-Id: <1364923183-316-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364923183-316-1-git-send-email-yinghai@kernel.org>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per hpa, use crashkernel=XM;high crashkernel=YM;low instead of
crashkernel_hign=XM crashkernel_low=YM. As that could be extensible.

-v2: according to Vivek, change delimiter to ;

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/kernel-parameters.txt |    8 ++++----
 arch/x86/kernel/setup.c             |    6 +++---
 kernel/kexec.c                      |   23 +++++++++++++++++------
 3 files changed, 24 insertions(+), 13 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -603,13 +603,13 @@ bytes respectively. Such letter suffixes
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for an example.
 
-	crashkernel_high=size[KMG]
+	crashkernel=size[KMG];high
 			[KNL, x86_64] range could be above 4G. Allow kernel
 			to allocate physical memory region from top, so could
 			be above 4G if system have more than 4G ram installed.
-	crashkernel_low=size[KMG]
-			[KNL, x86_64] range under 4G. When crashkernel_high= is
-			passed, kernel could allocate physical memory region
+	crashkernel=size[KMG];low
+			[KNL, x86_64] range under 4G. When crashkernel=X;high
+			is passed, kernel could allocate physical memory region
 			above 4G, that cause second kernel crash on system
 			that need swiotlb later. Kernel would try to allocate
 			some region below 4G automatically. This one let
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -528,7 +528,7 @@ static void __init reserve_crashkernel_l
 	int ret;
 
 	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
-	/* crashkernel_low=YM */
+	/* crashkernel=YM;low */
 	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
 						&low_size, &base);
 	if (ret != 0) {
@@ -541,7 +541,7 @@ static void __init reserve_crashkernel_l
 		low_size = swiotlb_size_or_default() + (8UL<<20);
 		auto_set = true;
 	} else {
-		/* passed with crashkernel_low=0 ? */
+		/* passed with crashkernel=0;low ? */
 		if (!low_size)
 			return;
 	}
@@ -577,7 +577,7 @@ static void __init reserve_crashkernel(v
 
 	total_mem = memblock_phys_mem_size();
 
-	/* crashkernel_high=XM */
+	/* crashkernel=XM;high */
 	ret = parse_crashkernel_high(boot_command_line, total_mem,
 			&crash_size, &crash_base);
 	if (ret != 0 || crash_size <= 0) {
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
@@ -1376,7 +1376,8 @@ static int __init __parse_crashkernel(ch
 			     unsigned long long system_ram,
 			     unsigned long long *crash_size,
 			     unsigned long long *crash_base,
-				const char *name)
+			     const char *name,
+			     const char *suffix)
 {
 	char 	*p = cmdline, *ck_cmdline = NULL;
 	char	*first_colon, *first_space;
@@ -1388,7 +1389,17 @@ static int __init __parse_crashkernel(ch
 	/* find crashkernel and use the last one if there are more */
 	p = strstr(p, name);
 	while (p) {
-		ck_cmdline = p;
+		if (!suffix)
+			ck_cmdline = p;
+		else {
+			char *end_p = strchr(p, ' ');
+
+			if (!end_p)
+				end_p = p + strlen(p);
+			end_p -= strlen(suffix);
+			if (!strncmp(end_p, suffix, strlen(suffix)))
+				ck_cmdline = p;
+		}
 		p = strstr(p+1, name);
 	}
 
@@ -1419,7 +1430,7 @@ int __init parse_crashkernel(char *cmdli
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel=");
+					"crashkernel=", NULL);
 }
 
 int __init parse_crashkernel_high(char *cmdline,
@@ -1428,7 +1439,7 @@ int __init parse_crashkernel_high(char *
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel_high=");
+					"crashkernel=", ";high");
 }
 
 int __init parse_crashkernel_low(char *cmdline,
@@ -1437,7 +1448,7 @@ int __init parse_crashkernel_low(char *c
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel_low=");
+					"crashkernel=", ";low");
 }
 
 static void update_vmcoreinfo_note(void)
