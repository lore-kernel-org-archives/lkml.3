Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbbA0I0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:26:17 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40396 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbbA0I0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:26:15 -0500
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Cc: linaro-kernel@lists.linaro.org, robdclark@gmail.com, daniel@ffwll.ch,
        m.szyprowski@samsung.com, stanislawski.tomasz@googlemail.com,
        robin.murphy@arm.com, Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFCv3 1/2] device: add dma_params->max_segment_count
Date: Tue, 27 Jan 2015 13:55:53 +0530
Message-Id: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Clark <robdclark@gmail.com>

For devices which have constraints about maximum number of segments in
an sglist.  For example, a device which could only deal with contiguous
buffers would set max_segment_count to 1.

The initial motivation is for devices sharing buffers via dma-buf,
to allow the buffer exporter to know the constraints of other
devices which have attached to the buffer.  The dma_mask and fields
in 'struct device_dma_parameters' tell the exporter everything else
that is needed, except whether the importer has constraints about
maximum number of segments.

Signed-off-by: Rob Clark <robdclark@gmail.com>
 [sumits: Minor updates wrt comments]
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---

v3: include Robin Murphy's fix[1] for handling '0' as a value for
     max_segment_count
v2: minor updates wrt comments on the first version

[1]: http://article.gmane.org/gmane.linux.kernel.iommu/8175/

 include/linux/device.h      |  1 +
 include/linux/dma-mapping.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index fb506738f7b7..a32f9b67315c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -647,6 +647,7 @@ struct device_dma_parameters {
 	 * sg limitations.
 	 */
 	unsigned int max_segment_size;
+	unsigned int max_segment_count;    /* INT_MAX for unlimited */
 	unsigned long segment_boundary_mask;
 };
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index c3007cb4bfa6..d3351a36d5ec 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -154,6 +154,25 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
 		return -EIO;
 }
 
+#define DMA_SEGMENTS_MAX_SEG_COUNT ((unsigned int) INT_MAX)
+
+static inline unsigned int dma_get_max_seg_count(struct device *dev)
+{
+	if (dev->dma_parms && dev->dma_parms->max_segment_count)
+		return dev->dma_parms->max_segment_count;
+	return DMA_SEGMENTS_MAX_SEG_COUNT;
+}
+
+static inline int dma_set_max_seg_count(struct device *dev,
+						unsigned int count)
+{
+	if (dev->dma_parms) {
+		dev->dma_parms->max_segment_count = count;
+		return 0;
+	}
+	return -EIO;
+}
+
 static inline unsigned long dma_get_seg_boundary(struct device *dev)
 {
 	return dev->dma_parms ?
-- 
1.9.1

