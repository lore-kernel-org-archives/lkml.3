Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966980Ab3DQWxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:53:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966883Ab3DQWxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:53:38 -0400
Date: Wed, 17 Apr 2013 15:53:22 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-c729de8fcea37a1c444e81857eace12494c804a9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, vgoyal@redhat.com, tglx@linutronix.de,
        chaowang@redhat.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, vgoyal@redhat.com, tglx@linutronix.de,
        chaowang@redhat.com, hpa@linux.intel.com
In-Reply-To: <1366089828-19692-2-git-send-email-yinghai@kernel.org>
References: <1366089828-19692-2-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kdump] x86, kdump: Set crashkernel_low automatically
Git-Commit-ID: c729de8fcea37a1c444e81857eace12494c804a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 15:53:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c729de8fcea37a1c444e81857eace12494c804a9
Gitweb:     http://git.kernel.org/tip/c729de8fcea37a1c444e81857eace12494c804a9
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 15 Apr 2013 22:23:45 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 17 Apr 2013 12:35:32 -0700

x86, kdump: Set crashkernel_low automatically

Chao said that kdump does does work well on his system on 3.8
without extra parameter, even iommu does not work with kdump.
And now have to append crashkernel_low=Y in first kernel to make
kdump work.

We have now modified crashkernel=X to allocate memory beyong 4G (if
available) and do not allocate low range for crashkernel if the user
does not specify that with crashkernel_low=Y.  This causes regression
if iommu is not enabled.  Without iommu, swiotlb needs to be setup in
first 4G and there is no low memory available to second kernel.

Set crashkernel_low automatically if the user does not specify that.

For system that does support IOMMU with kdump properly, user could
specify crashkernel_low=0 to save that 72M low ram.

-v3: add swiotlb_size() according to Konrad.
-v4: add comments what 8M is for according to hpa.
     also update more crashkernel_low= in kernel-parameters.txt
-v5: update changelog according to Vivek.
-v6: Change description about swiotlb referring according to HATAYAMA.

Reported-by: WANG Chao <chaowang@redhat.com>
Tested-by: WANG Chao <chaowang@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1366089828-19692-2-git-send-email-yinghai@kernel.org
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt | 14 +++++++++++---
 arch/x86/kernel/setup.c             | 21 ++++++++++++++++++---
 include/linux/swiotlb.h             |  1 +
 lib/swiotlb.c                       | 19 +++++++++++++++----
 4 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..cff672d 100644
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
@@ -606,6 +603,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for an example.
 
+	crashkernel_low=size[KMG]
+			[KNL, x86_64] range under 4G. When crashkernel= is
+			passed, kernel allocate physical memory region
+			above 4G, that cause second kernel crash on system
+			that require some amount of low memory, e.g. swiotlb
+			requires at least 64M+32K low memory.  Kernel would
+			try to allocate 72M below 4G automatically.
+			This one let user to specify own low range under 4G
+			for second kernel instead.
+			0: to disable low allocation.
+
 	cs89x0_dma=	[HW,NET]
 			Format: <dma>
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..1234920 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -521,19 +521,34 @@ static void __init reserve_crashkernel_low(void)
 	unsigned long long low_base = 0, low_size = 0;
 	unsigned long total_low_mem;
 	unsigned long long base;
+	bool auto_set = false;
 	int ret;
 
 	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
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
+		/* passed with crashkernel_low=0 ? */
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
 
