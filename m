Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab3CSPGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:06:02 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20351 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3CSPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:06:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5] x86, kdump: Set crashkernel_low automatically
Date: Tue, 19 Mar 2013 08:05:26 -0700
Message-Id: <1363705526-3197-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130319133326.GB3872@redhat.com>
References: <20130319133326.GB3872@redhat.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Reported-by: WANG Chao <chaowang@redhat.com>
Tested-by: WANG Chao <chaowang@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/kernel-parameters.txt |   15 ++++++++++++---
 arch/x86/kernel/setup.c             |   20 +++++++++++++++++---
 include/linux/swiotlb.h             |    1 +
 lib/swiotlb.c                       |   19 +++++++++++++++----
 4 files changed, 45 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -521,19 +521,33 @@ static void __init reserve_crashkernel_l
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
+		 *	swiotlb overflow buffer: now is hardcoded to 32k,
+		 *		round to 8M to cover more others.
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
Index: linux-2.6/include/linux/swiotlb.h
===================================================================
--- linux-2.6.orig/include/linux/swiotlb.h
+++ linux-2.6/include/linux/swiotlb.h
@@ -25,6 +25,7 @@ extern int swiotlb_force;
 extern void swiotlb_init(int verbose);
 int swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
 extern unsigned long swiotlb_nr_tbl(void);
+unsigned long swiotlb_size_or_default(void);
 extern int swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs);
 
 /*
Index: linux-2.6/lib/swiotlb.c
===================================================================
--- linux-2.6.orig/lib/swiotlb.c
+++ linux-2.6/lib/swiotlb.c
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
@@ -188,8 +200,7 @@ int __init swiotlb_init_with_tbl(char *t
 void  __init
 swiotlb_init(int verbose)
 {
-	/* default to 64MB */
-	size_t default_size = 64UL<<20;
+	size_t default_size = IO_TLB_DEFAULT_SIZE;
 	unsigned char *vstart;
 	unsigned long bytes;
 
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -596,9 +596,6 @@ bytes respectively. Such letter suffixes
 			is selected automatically. Check
 			Documentation/kdump/kdump.txt for further details.
 
-	crashkernel_low=size[KMG]
-			[KNL, x86] parts under 4G.
-
 	crashkernel=range1:size1[,range2:size2,...][@offset]
 			[KNL] Same as above, but depends on the memory
 			in the running system. The syntax of range is
@@ -606,6 +603,18 @@ bytes respectively. Such letter suffixes
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for an example.
 
+	crashkernel_low=size[KMG]
+			[KNL, x86_64] range under 4G. When crashkernel= is
+			passed, kernel allocate physical memory region
+			above 4G, that cause second kernel crash on system
+			that need swiotlb later. Kernel would try to allocate
+			some region below 4G automatically. This one let
+			user to specify own low range under 4G for second
+			kernel instead.
+			0: to disable low allocation on systems that do not
+			need swiotlb, that will save 72M low ram in first
+			kernel.
+
 	cs89x0_dma=	[HW,NET]
 			Format: <dma>
 
