Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3DTR31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 13:29:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3DTR30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 13:29:26 -0400
Date: Sat, 20 Apr 2013 10:29:06 -0700
Message-Id: <201304201729.r3KHT6k2010609@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/kdump fixes for 3.9
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
        WANG Chao <chaowang@redhat.com>, Yinghai Lu <yinghai@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 20 Apr 2013 10:29:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I am sending this particular patchset under its own cover because I
consider it to be a judgement call.

The kexec/kdump people have found several problems with the support
for loading over 4 GiB that was introduced in this merge cycle.  This
is partly due to a number of design problems inherent in the way the
various pieces of kdump fit together (it is pretty horrifically manual
in many places.)

After a *lot* of iterations this is the patchset that was agreed upon,
but of course it is now very late in the cycle.  However, because it
changes both the syntax and semantics of the crashkernel option, it
would be desirable to avoid a stable release with the broken
interfaces.

	-hpa

The following changes since commit 41ef2d5678d83af030125550329b6ae8b74618fa:

  Linux 3.9-rc7 (2013-04-14 17:45:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-kdump-for-linus

for you to fetch changes up to 157752d84f5df47e01577970f9c5f61a0b9f4546:

  kexec: use Crash kernel for Crash kernel low (2013-04-17 12:35:34 -0700)

----------------------------------------------------------------
Yinghai Lu (4):
      x86, kdump: Set crashkernel_low automatically
      x86, kdump: Retore crashkernel= to allocate under 896M
      x86, kdump: Change crashkernel_high/low= to crashkernel=,high/low
      kexec: use Crash kernel for Crash kernel low

 Documentation/kernel-parameters.txt |  23 ++++++-
 arch/x86/kernel/setup.c             |  45 +++++++++++---
 include/linux/kexec.h               |   2 +
 include/linux/swiotlb.h             |   1 +
 kernel/kexec.c                      | 118 ++++++++++++++++++++++++++++++++----
 lib/swiotlb.c                       |  19 ++++--
 6 files changed, 180 insertions(+), 28 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..a1ac1f1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -596,9 +596,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			is selected automatically. Check
 			Documentation/kdump/kdump.txt for further details.
 
-	crashkernel_low=size[KMG]
-			[KNL, x86] parts under 4G.
-
 	crashkernel=range1:size1[,range2:size2,...][@offset]
 			[KNL] Same as above, but depends on the memory
 			in the running system. The syntax of range is
@@ -606,6 +603,26 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for an example.
 
+	crashkernel=size[KMG],high
+			[KNL, x86_64] range could be above 4G. Allow kernel
+			to allocate physical memory region from top, so could
+			be above 4G if system have more than 4G ram installed.
+			Otherwise memory region will be allocated below 4G, if
+			available.
+			It will be ignored if crashkernel=X is specified.
+	crashkernel=size[KMG],low
+			[KNL, x86_64] range under 4G. When crashkernel=X,high
+			is passed, kernel could allocate physical memory region
+			above 4G, that cause second kernel crash on system
+			that require some amount of low memory, e.g. swiotlb
+			requires at least 64M+32K low memory.  Kernel would
+			try to allocate 72M below 4G automatically.
+			This one let user to specify own low range under 4G
+			for second kernel instead.
+			0: to disable low allocation.
+			It will be ignored when crashkernel=X,high is not used
+			or memory reserved is below 4G.
+
 	cs89x0_dma=	[HW,NET]
 			Format: <dma>
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..fae9134 100644
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
@@ -521,19 +524,35 @@ static void __init reserve_crashkernel_low(void)
 	unsigned long long low_base = 0, low_size = 0;
 	unsigned long total_low_mem;
 	unsigned long long base;
+	bool auto_set = false;
 	int ret;
 
 	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
+	/* crashkernel=Y,low */
 	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
 						&low_size, &base);
-	if (ret != 0 || low_size <= 0)
-		return;
+	if (ret != 0) {
+		/*
+		 * two parts from lib/swiotlb.c:
+		 *	swiotlb size: user specified with swiotlb= or default.
+		 *	swiotlb overflow buffer: now is hardcoded to 32k.
+		 *		We round it to 8M for other buffers that
+		 *		may need to stay low too.
+		 */
+		low_size = swiotlb_size_or_default() + (8UL<<20);
+		auto_set = true;
+	} else {
+		/* passed with crashkernel=0,low ? */
+		if (!low_size)
+			return;
+	}
 
 	low_base = memblock_find_in_range(low_size, (1ULL<<32),
 					low_size, alignment);
 
 	if (!low_base) {
-		pr_info("crashkernel low reservation failed - No suitable area found.\n");
+		if (!auto_set)
+			pr_info("crashkernel low reservation failed - No suitable area found.\n");
 
 		return;
 	}
@@ -554,14 +573,22 @@ static void __init reserve_crashkernel(void)
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
+		/* crashkernel=X,high */
+		ret = parse_crashkernel_high(boot_command_line, total_mem,
+				&crash_size, &crash_base);
+		if (ret != 0 || crash_size <= 0)
+			return;
+		high = true;
+	}
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
@@ -569,7 +596,9 @@ static void __init reserve_crashkernel(void)
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
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 2de42f9..a5ffd32 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -25,6 +25,7 @@ extern int swiotlb_force;
 extern void swiotlb_init(int verbose);
 int swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
 extern unsigned long swiotlb_nr_tbl(void);
+unsigned long swiotlb_size_or_default(void);
 extern int swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs);
 
 /*
diff --git a/kernel/kexec.c b/kernel/kexec.c
index bddd3d7..ffd4e11 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -55,7 +55,7 @@ struct resource crashk_res = {
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
 };
 struct resource crashk_low_res = {
-	.name  = "Crash kernel low",
+	.name  = "Crash kernel",
 	.start = 0,
 	.end   = 0,
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
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
@@ -1413,13 +1492,26 @@ static int __init __parse_crashkernel(char *cmdline,
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
+}
+
+int __init parse_crashkernel_high(char *cmdline,
+			     unsigned long long system_ram,
+			     unsigned long long *crash_size,
+			     unsigned long long *crash_base)
+{
+	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
+				"crashkernel=", suffix_tbl[SUFFIX_HIGH]);
 }
 
 int __init parse_crashkernel_low(char *cmdline,
@@ -1428,7 +1520,7 @@ int __init parse_crashkernel_low(char *cmdline,
 			     unsigned long long *crash_base)
 {
 	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-					"crashkernel_low=");
+				"crashkernel=", suffix_tbl[SUFFIX_LOW]);
 }
 
 static void update_vmcoreinfo_note(void)
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index bfe02b8..d23762e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -105,9 +105,9 @@ setup_io_tlb_npages(char *str)
 	if (!strcmp(str, "force"))
 		swiotlb_force = 1;
 
-	return 1;
+	return 0;
 }
-__setup("swiotlb=", setup_io_tlb_npages);
+early_param("swiotlb", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
 unsigned long swiotlb_nr_tbl(void)
@@ -115,6 +115,18 @@ unsigned long swiotlb_nr_tbl(void)
 	return io_tlb_nslabs;
 }
 EXPORT_SYMBOL_GPL(swiotlb_nr_tbl);
+
+/* default to 64MB */
+#define IO_TLB_DEFAULT_SIZE (64UL<<20)
+unsigned long swiotlb_size_or_default(void)
+{
+	unsigned long size;
+
+	size = io_tlb_nslabs << IO_TLB_SHIFT;
+
+	return size ? size : (IO_TLB_DEFAULT_SIZE);
+}
+
 /* Note that this doesn't work with highmem page */
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
@@ -188,8 +200,7 @@ int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 void  __init
 swiotlb_init(int verbose)
 {
-	/* default to 64MB */
-	size_t default_size = 64UL<<20;
+	size_t default_size = IO_TLB_DEFAULT_SIZE;
 	unsigned char *vstart;
 	unsigned long bytes;
 
