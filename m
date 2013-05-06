Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3EFUqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:46:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab3EFUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:45:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Minchan Kim <minchan@kernel.org>
Subject: [ 003/115] staging: zsmalloc: Fix link error on ARM
Date: Mon,  6 May 2013 13:43:59 -0700
Message-Id: <20130506203055.940256450@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joro@8bytes.org>

commit d95abbbb291bf5bce078148f53603ce9c0aa1d44 upstream.

Testing the arm chromebook config against the upstream
kernel produces a linker error for the zsmalloc module from
staging. The symbol flush_tlb_kernel_range is not available
there. Fix this by removing the reimplementation of
unmap_kernel_range in the zsmalloc module and using the
function directly. The unmap_kernel_range function is not
usable by modules, so also disallow building the driver as a
module for now.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zsmalloc/Kconfig         |    2 +-
 drivers/staging/zsmalloc/zsmalloc-main.c |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/staging/zsmalloc/Kconfig
+++ b/drivers/staging/zsmalloc/Kconfig
@@ -1,5 +1,5 @@
 config ZSMALLOC
-	tristate "Memory allocator for compressed pages"
+	bool "Memory allocator for compressed pages"
 	default n
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -656,11 +656,8 @@ static inline void __zs_unmap_object(str
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


