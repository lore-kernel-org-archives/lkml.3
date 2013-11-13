Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab3KMU43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:56:29 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:33964
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab3KMU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:56:20 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: akpm@linux-foundation.org, alexander.h.duyck@intel.com, joro@8bytes.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH v2] dma-debug: enhance dma_debug_device_change() to check for mapping errors
Date: Wed, 13 Nov 2013 13:56:08 -0700
Message-Id: <1384376168-2148-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma-debug checks to verify if driver validated the address returned by
dma mapping routines when driver does unmap. If a driver doesn't call
unmap, failure to check mapping errors isn't detected and reported.

Enhancing existing bus notifier_call dma_debug_device_change() to check
for mapping errors at the same time it detects leaked dma buffers for
BUS_NOTIFY_UNBOUND_DRIVER event. It scans for mapping errors and if any
found, prints one warning message that includes mapping error count.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 lib/dma-debug.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d87a17a..e34865e 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -717,6 +717,7 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
 	struct dma_debug_entry *entry;
 	unsigned long flags;
 	int count = 0, i;
+	int map_err_cnt = 0;
 
 	local_irq_save(flags);
 
@@ -724,6 +725,8 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
 		spin_lock(&dma_entry_hash[i].lock);
 		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
 			if (entry->dev == dev) {
+				if (entry->map_err_type == MAP_ERR_NOT_CHECKED)
+					map_err_cnt += 1;
 				count += 1;
 				*out_entry = entry;
 			}
@@ -733,6 +736,10 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
 
 	local_irq_restore(flags);
 
+	if (map_err_cnt)
+		dev_warn(entry->dev,
+			"DMA-API: device driver failed to check map errors: "
+			"[count] = %d\n", map_err_cnt);
 	return count;
 }
 
-- 
1.8.3.2

