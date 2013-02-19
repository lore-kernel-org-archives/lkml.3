Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab3BSIHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:07:54 -0500
Received: from ozlabs.org ([203.10.76.45]:48451 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758182Ab3BSICp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 01/16] scatterlist: introduce sg_unmark_end
Date: Tue, 19 Feb 2013 18:26:19 +1030
Message-Id: <1361260594-601-2-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

This is useful in places that recycle the same scatterlist multiple
times, and do not want to incur the cost of sg_init_table every
time in hot paths.

Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 block/blk-integrity.c       |    2 +-
 block/blk-merge.c           |    2 +-
 include/linux/scatterlist.h |   16 ++++++++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index da2a818..0f5004f 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -110,7 +110,7 @@ new_segment:
 			if (!sg)
 				sg = sglist;
 			else {
-				sg->page_link &= ~0x02;
+				sg_unmark_end(sg);
 				sg = sg_next(sg);
 			}
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 936a110..5f24482 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -143,7 +143,7 @@ new_segment:
 			 * termination bit to avoid doing a full
 			 * sg_init_table() in drivers for each command.
 			 */
-			(*sg)->page_link &= ~0x02;
+			sg_unmark_end(*sg);
 			*sg = sg_next(*sg);
 		}
 
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4bd6c06..9b83784 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -172,6 +172,22 @@ static inline void sg_mark_end(struct scatterlist *sg)
 }
 
 /**
+ * sg_unmark_end - Undo setting the end of the scatterlist
+ * @sg:		 SG entryScatterlist
+ *
+ * Description:
+ *   Removes the termination marker from the given entry of the scatterlist.
+ *
+ **/
+static inline void sg_unmark_end(struct scatterlist *sg)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	sg->page_link &= ~0x02;
+}
+
+/**
  * sg_phys - Return physical address of an sg entry
  * @sg:	     SG entry
  *
-- 
1.7.10.4

