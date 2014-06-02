Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaFBN6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:58:31 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:57711 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbaFBN6a convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Mon, 2 Jun 2014 09:58:30 -0400
Message-Id: <538C9F210200007800016DC7@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 02 Jun 2014 14:58:25 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] swiotlb: don't assume PA 0 is invalid
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.29 io_tlb_orig_addr[] got converted from storing virtual addresses
to storing physical ones. While checking virtual addresses against NULL
is a legitimate thing to catch invalid entries, checking physical ones
against zero isn't: There's no guarantee that PFN 0 is reserved on a
particular platform.

Since it is unclear whether the check in swiotlb_tbl_unmap_single() is
actually needed, retain it but check against a guaranteed invalid physical
address. This requires setting up the array in a suitable fashion. And
since the original code failed to invalidate array entries when regions
get unmapped, this is being fixed at once along with adding a similar
check to swiotlb_tbl_sync_single().

Obviously the less intrusive change would be to simply drop the check in
swiotlb_tbl_unmap_single().

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 lib/swiotlb.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- 3.15-rc8/lib/swiotlb.c
+++ 3.15-rc8-swiotlb-unmap-single-phys-check/lib/swiotlb.c
@@ -86,6 +86,7 @@ static unsigned int io_tlb_index;
  * We need to save away the original address corresponding to a mapped entry
  * for the sync operations.
  */
+#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
 static phys_addr_t *io_tlb_orig_addr;
 
 /*
@@ -188,12 +189,14 @@ int __init swiotlb_init_with_tbl(char *t
 	io_tlb_list = memblock_virt_alloc(
 				PAGE_ALIGN(io_tlb_nslabs * sizeof(int)),
 				PAGE_SIZE);
-	for (i = 0; i < io_tlb_nslabs; i++)
- 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
-	io_tlb_index = 0;
 	io_tlb_orig_addr = memblock_virt_alloc(
 				PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)),
 				PAGE_SIZE);
+	for (i = 0; i < io_tlb_nslabs; i++) {
+ 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+ 		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
+	}
+	io_tlb_index = 0;
 
 	if (verbose)
 		swiotlb_print_info();
@@ -313,10 +316,6 @@ swiotlb_late_init_with_tbl(char *tlb, un
 	if (!io_tlb_list)
 		goto cleanup3;
 
-	for (i = 0; i < io_tlb_nslabs; i++)
- 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
-	io_tlb_index = 0;
-
 	io_tlb_orig_addr = (phys_addr_t *)
 		__get_free_pages(GFP_KERNEL,
 				 get_order(io_tlb_nslabs *
@@ -324,7 +323,11 @@ swiotlb_late_init_with_tbl(char *tlb, un
 	if (!io_tlb_orig_addr)
 		goto cleanup4;
 
-	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
+	for (i = 0; i < io_tlb_nslabs; i++) {
+ 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+ 		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
+	}
+	io_tlb_index = 0;
 
 	swiotlb_print_info();
 
@@ -556,7 +559,8 @@ void swiotlb_tbl_unmap_single(struct dev
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
-	if (orig_addr && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
+	if (orig_addr != INVALID_PHYS_ADDR &&
+	    ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
 		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_FROM_DEVICE);
 
 	/*
@@ -573,8 +577,10 @@ void swiotlb_tbl_unmap_single(struct dev
 		 * Step 1: return the slots to the free list, merging the
 		 * slots with superceeding slots
 		 */
-		for (i = index + nslots - 1; i >= index; i--)
+		for (i = index + nslots - 1; i >= index; i--) {
 			io_tlb_list[i] = ++count;
+			io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
+		}
 		/*
 		 * Step 2: merge the returned slots with the preceding slots,
 		 * if available (non zero)
@@ -593,6 +599,8 @@ void swiotlb_tbl_sync_single(struct devi
 	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
+	if (orig_addr == INVALID_PHYS_ADDR)
+		return;
 	orig_addr += (unsigned long)tlb_addr & ((1 << IO_TLB_SHIFT) - 1);
 
 	switch (target) {



