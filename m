Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab3KLUvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:51:31 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:59582
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755192Ab3KLUvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:51:22 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: akpm@linux-foundation.org, alexander.h.duyck@intel.com, joro@8bytes.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] dma-debug: enhance dma_debug_device_change() to check for mapping errors
Date: Tue, 12 Nov 2013 13:51:18 -0700
Message-Id: <1384289478-9899-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma-debug checks to verify if driver validated the address returned by
dma mapping routines when driver does unmap. If a driver doesn't call
unmap, failure to check mapping errors isn't detected and reported.

Enhancing existing bus notifier_call dma_debug_device_change() to check
for mapping errors at the same time it detects leaked dma buffers for
BUS_NOTIFY_UNBOUND_DRIVER event.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 lib/dma-debug.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d87a17a..6c17b90 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -712,6 +712,19 @@ out_err:
 	return -ENOMEM;
 }
 
+static void check_dma_mapping_error(struct dma_debug_entry *ref,
+				    struct dma_debug_entry *entry)
+{
+	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
+		err_printk(ref->dev, entry,
+			   "DMA-API: device driver failed to check map error"
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped as %s]",
+			   ref->dev_addr, ref->size,
+			   type2name[entry->type]);
+	}
+}
+
 static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
 {
 	struct dma_debug_entry *entry;
@@ -724,6 +737,7 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
 		spin_lock(&dma_entry_hash[i].lock);
 		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
 			if (entry->dev == dev) {
+				check_dma_mapping_error(entry, entry);
 				count += 1;
 				*out_entry = entry;
 			}
@@ -928,14 +942,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 			   dir2name[ref->direction]);
 	}
 
-	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
-		err_printk(ref->dev, entry,
-			   "DMA-API: device driver failed to check map error"
-			   "[device address=0x%016llx] [size=%llu bytes] "
-			   "[mapped as %s]",
-			   ref->dev_addr, ref->size,
-			   type2name[entry->type]);
-	}
+	check_dma_mapping_error(ref, entry);
 
 	hash_bucket_del(entry);
 	dma_entry_free(entry);
-- 
1.8.3.2

