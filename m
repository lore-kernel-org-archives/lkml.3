Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaK1L30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:29:26 -0500
Received: from 8bytes.org ([81.169.241.247]:40161 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaK1L3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:29:22 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/3] swiotlb: Warn on allocation failure in swiotlb_alloc_coherent
Date: Fri, 28 Nov 2014 12:29:07 +0100
Message-Id: <1417174149-31210-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417174149-31210-1-git-send-email-joro@8bytes.org>
References: <1417174149-31210-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Print a warning when all allocation tries have been failed
and the function is about to return NULL. This prepares for
calling the function with __GFP_NOWARN to suppress
allocation failure warnings before all fall-backs have
failed.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 lib/swiotlb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 4abda07..e0e9212 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -655,7 +655,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 */
 		phys_addr_t paddr = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
 		if (paddr == SWIOTLB_MAP_ERROR)
-			return NULL;
+			goto err_warn;
 
 		ret = phys_to_virt(paddr);
 		dev_addr = phys_to_dma(hwdev, paddr);
@@ -669,7 +669,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
 			swiotlb_tbl_unmap_single(hwdev, paddr,
 						 size, DMA_TO_DEVICE);
-			return NULL;
+			goto err_warn;
 		}
 	}
 
@@ -677,6 +677,13 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	memset(ret, 0, size);
 
 	return ret;
+
+err_warn:
+	pr_warn("swiotlb: coherent allocation failed for device %s size=%zu\n",
+		dev_name(hwdev), size);
+	dump_stack();
+
+	return NULL;
 }
 EXPORT_SYMBOL(swiotlb_alloc_coherent);
 
-- 
1.9.1

