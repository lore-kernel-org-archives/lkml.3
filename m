Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918Ab3DBRU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:20:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32910 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab3DBRUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:20:41 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
Date: Tue,  2 Apr 2013 10:19:42 -0700
Message-Id: <1364923183-316-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364923183-316-1-git-send-email-yinghai@kernel.org>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek found old kexec-tools does not work new kernel anymore.

So change back crashkernel= back to old behavoir, and add crashkernel_high=
to let user decide if buffer could be above 4G, and also new kexec-tools will
be needed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/kernel-parameters.txt |    8 ++++++--
 arch/x86/kernel/setup.c             |   26 ++++++++++++++++++++------
 include/linux/kexec.h               |    2 ++
 kernel/kexec.c                      |    9 +++++++++
 4 files changed, 37 insertions(+), 8 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -603,9 +603,13 @@ bytes respectively. Such letter suffixes
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for an example.
 
+	crashkernel_high=size[KMG]
+			[KNL, x86_64] range could be above 4G. Allow kernel
+			to allocate physical memory region from top, so could
+			be above 4G if system have more than 4G ram installed.
 	crashkernel_low=size[KMG]
-			[KNL, x86_64] range under 4G. When crashkernel= is
-			passed, kernel allocate physical memory region
+			[KNL, x86_64] range under 4G. When crashkernel_high= is
+			passed, kernel could allocate physical memory region
 			above 4G, that cause second kernel crash on system
 			that need swiotlb later. Kernel would try to allocate
 			some region below 4G automatically. This one let
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -507,11 +507,14 @@ static void __init memblock_x86_reserve_
 /*
  * Keep the crash kernel below this limit.  On 32 bits earlier kernels
  * would limit the kernel to the low 512 MiB due to mapping restrictions.
+ * On 64bit, old kexec-tools need to under 896MiB.
  */
 #ifdef CONFIG_X86_32
-# define CRASH_KERNEL_ADDR_MAX	(512 << 20)
+# define CRASH_KERNEL_ADDR_LOW_MAX	(512 << 20)
+# define CRASH_KERNEL_ADDR_HIGH_MAX	(512 << 20)
 #else
-# define CRASH_KERNEL_ADDR_MAX	MAXMEM
+# define CRASH_KERNEL_ADDR_LOW_MAX	(896UL<<20)
+# define CRASH_KERNEL_ADDR_HIGH_MAX	MAXMEM
 #endif
 
 static void __init reserve_crashkernel_low(void)
@@ -525,6 +528,7 @@ static void __init reserve_crashkernel_l
 	int ret;
 
 	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
+	/* crashkernel_low=YM */
 	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
 						&low_size, &base);
 	if (ret != 0) {
@@ -568,14 +572,22 @@ static void __init reserve_crashkernel(v
 	const unsigned long long alignment = 16<<20;	/* 16M */
 	unsigned long long total_mem;
 	unsigned long long crash_size, crash_base;
+	bool high = true;
 	int ret;
 
 	total_mem = memblock_phys_mem_size();
 
-	ret = parse_crashkernel(boot_command_line, total_mem,
+	/* crashkernel_high=XM */
+	ret = parse_crashkernel_high(boot_command_line, total_mem,
 			&crash_size, &crash_base);
-	if (ret != 0 || crash_size <= 0)
-		return;
+	if (ret != 0 || crash_size <= 0) {
+		/* crashkernel=XM */
+		ret = parse_crashkernel(boot_command_line, total_mem,
+				&crash_size, &crash_base);
+		if (ret != 0 || crash_size <= 0)
+			return;
+		high = false;
+	}
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
@@ -583,7 +595,9 @@ static void __init reserve_crashkernel(v
 		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
 		crash_base = memblock_find_in_range(alignment,
-			       CRASH_KERNEL_ADDR_MAX, crash_size, alignment);
+					high ? CRASH_KERNEL_ADDR_HIGH_MAX :
+					       CRASH_KERNEL_ADDR_LOW_MAX,
+					crash_size, alignment);
 
 		if (!crash_base) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
Index: linux-2.6/include/linux/kexec.h
===================================================================
--- linux-2.6.orig/include/linux/kexec.h
+++ linux-2.6/include/linux/kexec.h
@@ -200,6 +200,8 @@ extern size_t vmcoreinfo_max_size;
 
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
+int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
+		unsigned long long *crash_size, unsigned long long *crash_base);
 int parse_crashkernel_low(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 int crash_shrink_memory(unsigned long new_size);
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -1422,6 +1422,15 @@ int __init parse_crashkernel(char *cmdli
 					"crashkernel=");
 }
 
+int __init parse_crashkernel_high(char *cmdline,
+			     unsigned long long system_ram,
+			     unsigned long long *crash_size,
+			     unsigned long long *crash_base)
+{
+	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
+					"crashkernel_high=");
+}
+
 int __init parse_crashkernel_low(char *cmdline,
 			     unsigned long long system_ram,
 			     unsigned long long *crash_size,
