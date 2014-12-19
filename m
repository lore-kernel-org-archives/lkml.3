Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaLSRji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:39:38 -0500
Received: from service87.mimecast.com ([91.220.42.44]:60502 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaLSRjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:39:37 -0500
From: Robin Murphy <robin.murphy@arm.com>
To: vinod.koul@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
        lars@metafoo.de, liviu.dudau@arm.com, andrew.jackson@arm.com
Subject: [PATCH] dma-mapping: tidy up dma_parms default handling
Date: Fri, 19 Dec 2014 17:39:09 +0000
Message-Id: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 19 Dec 2014 17:39:33.0652 (UTC) FILETIME=[C0343540:01D01BB2]
X-MC-Unique: 114121917393502701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sBJHdkw5022880

Many DMA controllers and other devices set max_segment_size to
indicate their scatter-gather capability, but have no interest in
segment_boundary_mask. However, the existence of a dma_parms structure
precludes the use of any default value, leaving them as zeros (assuming
a properly kzalloc'ed structure). If a well-behaved IOMMU (or SWIOTLB)
then tries to respect this by ensuring a mapped segment does not cross
a zero-byte boundary, hilarity ensues.

Since zero is a nonsensical value for either parameter, treat it as an
indicator for "default", as might be expected. In the process, clean up
a bit by replacing the bare constants with slightly more meaningful
macros and removing the superfluous "else" statements.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---

Hi Vinod, dmaengine folks,

This isn't strictly a dmaengine patch, but get_maintainer.pl pointed at you,
and there do happen to be more dmaengine drivers potentially affected by this
than anything else - the current PL330 driver blows up arm64's SWIOTLB when
running dmatest on the Juno platform, which is what brought the underlying
problem to light.

 include/linux/dma-mapping.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index c3007cb..99ba736 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -141,7 +141,9 @@ static inline void arch_teardown_dma_ops(struct device *dev) { }
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
 {
-	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
+	if (dev->dma_parms && dev->dma_parms->max_segment_size)
+		return dev->dma_parms->max_segment_size;
+	return SZ_64K;
 }
 
 static inline unsigned int dma_set_max_seg_size(struct device *dev,
@@ -150,14 +152,15 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
 	if (dev->dma_parms) {
 		dev->dma_parms->max_segment_size = size;
 		return 0;
-	} else
-		return -EIO;
+	}
+	return -EIO;
 }
 
 static inline unsigned long dma_get_seg_boundary(struct device *dev)
 {
-	return dev->dma_parms ?
-		dev->dma_parms->segment_boundary_mask : 0xffffffff;
+	if (dev->dma_parms && dev->dma_parms->segment_boundary_mask)
+		return dev->dma_parms->segment_boundary_mask;
+	return DMA_BIT_MASK(32);
 }
 
 static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
@@ -165,8 +168,8 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
 	if (dev->dma_parms) {
 		dev->dma_parms->segment_boundary_mask = mask;
 		return 0;
-	} else
-		return -EIO;
+	}
+	return -EIO;
 }
 
 #ifndef dma_max_pfn
-- 
1.9.1


