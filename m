Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556Ab3B0A6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:58:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303Ab3BZX6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matt Sealey <matt@genesi-usa.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [ 092/150] staging: zsmalloc: Fix TLB coherency and build problem
Date: Tue, 26 Feb 2013 15:55:49 -0800
Message-Id: <20130226235533.631064507@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minchan Kim <minchan@kernel.org>

commit 9915518887e83764269d5b617d01782893877ed3 upstream.

Recently, Matt Sealey reported he fail to build zsmalloc caused by
using of local_flush_tlb_kernel_range which are architecture dependent
function so !CONFIG_SMP in ARM couldn't implement it so it ends up
build error following as.

  MODPOST 216 modules
  LZMA    arch/arm/boot/compressed/piggy.lzma
  AS      arch/arm/boot/compressed/lib1funcs.o
ERROR: "v7wbi_flush_kern_tlb_range"
[drivers/staging/zsmalloc/zsmalloc.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....

The reason we used that function is copy method by [1]
was really slow in ARM but at that time.

More severe problem is ARM can prefetch speculatively on other CPUs
so under us, other TLBs can have an entry only if we do flush local
CPU. Russell King pointed that. Thanks!
We don't have many choices except using flush_tlb_kernel_range.

My experiment in ARMv7 processor 4 core didn't make any difference with
zsmapbench[2] between local_flush_tlb_kernel_range and flush_tlb_kernel_range
but still page-table based is much better than copy-based.

* bigger is better.

1. local_flush_tlb_kernel_range: 3918795 mappings
2. flush_tlb_kernel_range : 3989538 mappings
3. copy-based: 635158 mappings

This patch replace local_flush_tlb_kernel_range with
flush_tlb_kernel_range which are avaialbe in all architectures
because we already have used it in vmalloc allocator which are
generic one so build problem should go away and performane loss
shoud be void.

[1] f553646, zsmalloc: add page table mapping method
[2] https://github.com/spartacus06/zsmapbench

Reported-by: Matt Sealey <matt@genesi-usa.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zsmalloc/zsmalloc-main.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -222,11 +222,9 @@ struct zs_pool {
 /*
  * By default, zsmalloc uses a copy-based object mapping method to access
  * allocations that span two pages. However, if a particular architecture
- * 1) Implements local_flush_tlb_kernel_range() and 2) Performs VM mapping
- * faster than copying, then it should be added here so that
- * USE_PGTABLE_MAPPING is defined. This causes zsmalloc to use page table
- * mapping rather than copying
- * for object mapping.
+ * performs VM mapping faster than copying, then it should be added here
+ * so that USE_PGTABLE_MAPPING is defined. This causes zsmalloc to use
+ * page table mapping rather than copying for object mapping.
 */
 #if defined(CONFIG_ARM)
 #define USE_PGTABLE_MAPPING
@@ -663,7 +661,7 @@ static inline void __zs_unmap_object(str
 
 	flush_cache_vunmap(addr, end);
 	unmap_kernel_range_noflush(addr, PAGE_SIZE * 2);
-	local_flush_tlb_kernel_range(addr, end);
+	flush_tlb_kernel_range(addr, end);
 }
 
 #else /* USE_PGTABLE_MAPPING */


