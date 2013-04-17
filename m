Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967001Ab3DQWyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:54:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966900Ab3DQWys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:54:48 -0400
Date: Wed, 17 Apr 2013 15:54:34 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-55a20ee7804ab64ac90bcdd4e2868a42829e2784@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        vgoyal@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, vgoyal@redhat.com,
        hpa@linux.intel.com
In-Reply-To: <1366089828-19692-4-git-send-email-yinghai@kernel.org>
References: <1366089828-19692-4-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kdump] x86, kdump: Retore crashkernel=
  to allocate under 896M
Git-Commit-ID: 55a20ee7804ab64ac90bcdd4e2868a42829e2784
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 15:54:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55a20ee7804ab64ac90bcdd4e2868a42829e2784
Gitweb:     http://git.kernel.org/tip/55a20ee7804ab64ac90bcdd4e2868a42829e2784
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 15 Apr 2013 22:23:47 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 17 Apr 2013 12:35:33 -0700

x86, kdump: Retore crashkernel= to allocate under 896M

Vivek found old kexec-tools does not work new kernel anymore.

So change back crashkernel= back to old behavoir, and add crashkernel_high=
to let user decide if buffer could be above 4G, and also new kexec-tools will
be needed.

-v2: let crashkernel=X override crashkernel_high=
    update description about _high will be ignored by crashkernel=X
-v3: update description about kernel-parameters.txt according to Vivek.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1366089828-19692-4-git-send-email-yinghai@kernel.org
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt | 13 +++++++++++--
 arch/x86/kernel/setup.c             | 24 +++++++++++++++++++-----
 include/linux/kexec.h               |  2 ++
 kernel/kexec.c                      |  9 +++++++++
 4 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cff672d..709eb3ed 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -603,9 +603,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for an example.
 
+	crashkernel_high=size[KMG]
+			[KNL, x86_64] range could be above 4G. Allow kernel
+			to allocate physical memory region from top, so could
+			be above 4G if system have more than 4G ram installed.
+			Otherwise memory region will be allocated below 4G, if
+			available.
+			It will be ignored if crashkernel=X is specified.
 	crashkernel_low=size[KMG]
-			[KNL, x86_64] range under 4G. When crashkernel= is
-			passed, kernel allocate physical memory region
+			[KNL, x86_64] range under 4G. When crashkernel_high= is
+			passed, kernel could allocate physical memory region
 			above 4G, that cause second kernel crash on system
 			that require some amount of low memory, e.g. swiotlb
 			requires at least 64M+32K low memory.  Kernel would
@@ -613,6 +620,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			This one let user to specify own low range under 4G
 			for second kernel instead.
 			0: to disable low allocation.
+			It will be ignored when crashkernel_high=X is not used
+			or memory reserved is below 4G.
 
 	cs89x0_dma=	[HW,NET]
 			Format: <dma>
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1234920..a85a144 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -507,11 +507,14 @@ static void __init memblock_x86_reserve_range_setup_data(void)
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
@@ -525,6 +528,7 @@ static void __init reserve_crashkernel_low(void)
 	int ret;
 
 	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
+	/* crashkernel_low=YM */
 	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
 						&low_size, &base);
 	if (ret != 0) {
@@ -569,14 +573,22 @@ static void __init reserve_crashkernel(void)
 	const unsigned long long alignment = 16<<20;	/* 16M */
 	unsigned long long total_mem;
 	unsigned long long crash_size, crash_base;
+	bool high = false;
 	int ret;
 
 	total_mem = memblock_phys_mem_size();
 
+	/* crashkernel=XM */
 	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
-	if (ret != 0 || crash_size <= 0)
-		return;
+	if (ret != 0 || crash_size <= 0) {
+		/* crashkernel_high=XM */
+		ret = parse_crashkernel_high(boot_command_line, total_mem,
+				&crash_size, &crash_base);
+		if (ret != 0 || crash_size <= 0)
+			return;
+		high = true;
+	}
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
@@ -584,7 +596,9 @@ static void __init reserve_crashkernel(void)
 		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
 		crash_base = memblock_find_in_range(alignment,
-			       CRASH_KERNEL_ADDR_MAX, crash_size, alignment);
+					high ? CRASH_KERNEL_ADDR_HIGH_MAX :
+					       CRASH_KERNEL_ADDR_LOW_MAX,
+					crash_size, alignment);
 
 		if (!crash_base) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d2e6927..d78d28a 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -200,6 +200,8 @@ extern size_t vmcoreinfo_max_size;
 
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
+int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
+		unsigned long long *crash_size, unsigned long long *crash_base);
 int parse_crashkernel_low(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 int crash_shrink_memory(unsigned long new_size);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index bddd3d7..1b2f73f 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1422,6 +1422,15 @@ int __init parse_crashkernel(char *cmdline,
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
