Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaHTLrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:47:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59037 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbaHTLoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 095/104] bnx2fc: fix memory leak in bnx2fc_allocate_hash_table()
Date: Wed, 20 Aug 2014 13:43:58 +0200
Message-Id: <654ce789f7bc53f4dde3ef44e6177b818bb33a2f.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fdbcbcab0eae6773430546697ace0b3fe48e7fbc upstream.

In case of error, the bnx2fc_allocate_hash_table() didn't free
all the memory it allocated.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Acked-by: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 46a37657307f..f819cd17af75 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -2023,7 +2023,7 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 	dma_segment_array = kzalloc(dma_segment_array_size, GFP_KERNEL);
 	if (!dma_segment_array) {
 		printk(KERN_ERR PFX "hash table pointers (dma) alloc failed\n");
-		return -ENOMEM;
+		goto cleanup_ht;
 	}
 
 	for (i = 0; i < segment_count; ++i) {
@@ -2034,15 +2034,7 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 					   GFP_KERNEL);
 		if (!hba->hash_tbl_segments[i]) {
 			printk(KERN_ERR PFX "hash segment alloc failed\n");
-			while (--i >= 0) {
-				dma_free_coherent(&hba->pcidev->dev,
-						    BNX2FC_HASH_TBL_CHUNK_SIZE,
-						    hba->hash_tbl_segments[i],
-						    dma_segment_array[i]);
-				hba->hash_tbl_segments[i] = NULL;
-			}
-			kfree(dma_segment_array);
-			return -ENOMEM;
+			goto cleanup_dma;
 		}
 		memset(hba->hash_tbl_segments[i], 0,
 		       BNX2FC_HASH_TBL_CHUNK_SIZE);
@@ -2054,8 +2046,7 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 					       GFP_KERNEL);
 	if (!hba->hash_tbl_pbl) {
 		printk(KERN_ERR PFX "hash table pbl alloc failed\n");
-		kfree(dma_segment_array);
-		return -ENOMEM;
+		goto cleanup_dma;
 	}
 	memset(hba->hash_tbl_pbl, 0, PAGE_SIZE);
 
@@ -2080,6 +2071,22 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 	}
 	kfree(dma_segment_array);
 	return 0;
+
+cleanup_dma:
+	for (i = 0; i < segment_count; ++i) {
+		if (hba->hash_tbl_segments[i])
+			dma_free_coherent(&hba->pcidev->dev,
+					    BNX2FC_HASH_TBL_CHUNK_SIZE,
+					    hba->hash_tbl_segments[i],
+					    dma_segment_array[i]);
+	}
+
+	kfree(dma_segment_array);
+
+cleanup_ht:
+	kfree(hba->hash_tbl_segments);
+	hba->hash_tbl_segments = NULL;
+	return -ENOMEM;
 }
 
 /**
-- 
2.0.4

