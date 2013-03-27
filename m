Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab3C0AnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:43:18 -0400
Received: from 8bytes.org ([85.214.48.195]:46783 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab3C0AnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:43:17 -0400
Date: Wed, 27 Mar 2013 01:43:14 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Minchan Kim <minchan.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] staging: zsmalloc: Fix link error on ARM
Message-ID: <20130327004314.GH30540@8bytes.org>
References: <1364337232-3513-1-git-send-email-joro@8bytes.org>
 <20130327000552.GA13283@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327000552.GA13283@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar 27 01:43:15 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515240a323671730920668
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 09:05:52AM +0900, Minchan Kim wrote:
> And please Cc stable.

Okay, here it is. The result is compile-tested.

Changes since v1:

* Remove the module-export for unmap_kernel_range and make zsmalloc
  built-in instead

Here is the patch:

>From 2b70502720b36909f9f39bdf27be21321a219c31 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joro@8bytes.org>
Date: Tue, 26 Mar 2013 23:24:22 +0100
Subject: [PATCH v2] staging: zsmalloc: Fix link error on ARM

Testing the arm chromebook config against the upstream
kernel produces a linker error for the zsmalloc module from
staging. The symbol flush_tlb_kernel_range is not available
there. Fix this by removing the reimplementation of
unmap_kernel_range in the zsmalloc module and using the
function directly. The unmap_kernel_range function is not
usable by modules, so also disallow building the driver as a
module for now.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/staging/zsmalloc/Kconfig         |    2 +-
 drivers/staging/zsmalloc/zsmalloc-main.c |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
index 9084565..7fab032 100644
--- a/drivers/staging/zsmalloc/Kconfig
+++ b/drivers/staging/zsmalloc/Kconfig
@@ -1,5 +1,5 @@
 config ZSMALLOC
-	tristate "Memory allocator for compressed pages"
+	bool "Memory allocator for compressed pages"
 	default n
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index e78d262..324e123 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -656,11 +656,8 @@ static inline void __zs_unmap_object(struct mapping_area *area,
 				struct page *pages[2], int off, int size)
 {
 	unsigned long addr = (unsigned long)area->vm_addr;
-	unsigned long end = addr + (PAGE_SIZE * 2);
 
-	flush_cache_vunmap(addr, end);
-	unmap_kernel_range_noflush(addr, PAGE_SIZE * 2);
-	flush_tlb_kernel_range(addr, end);
+	unmap_kernel_range(addr, PAGE_SIZE * 2);
 }
 
 #else /* USE_PGTABLE_MAPPING */
-- 
1.7.9.5


