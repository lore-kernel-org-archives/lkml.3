Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab3CRV0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:26:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27532 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3CRV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:26:25 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3] x86, kdump: Set crashkernel_low automatically
Date: Mon, 18 Mar 2013 14:25:57 -0700
Message-Id: <1363641957-5247-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <514783B4.2030401@zytor.com>
References: <514783B4.2030401@zytor.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does not set low range for crashkernel if the user
does not specify that.

That cause regressions on system that does not support intel_iommu
properly.

Chao said that his system does work well on 3.8 without extra parameter.
even iommu does not work with kdump.

Set crashkernel_low automatically if the user does not specify that.

For system that does support IOMMU with kdump properly, user could
specify crashkernel_low=0 to save that 72M low ram.

-v3: add swiotlb_size() according to Konrad.

Reported-by: WANG Chao <chaowang@redhat.com>
Tested-by: WANG Chao <chaowang@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   15 ++++++++++++---
 include/linux/swiotlb.h |    1 +
 lib/swiotlb.c           |   19 +++++++++++++++----
 3 files changed, 28 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -522,19 +522,28 @@ static void __init reserve_crashkernel_l
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
+		/* swiotlb size and etc 8M */
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
 
