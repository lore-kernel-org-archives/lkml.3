Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab3BLMZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:25:49 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38227 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185Ab3BLMX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:23:58 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com, mst@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 5/9] scatterlist: introduce sg_unmark_end
Date: Tue, 12 Feb 2013 13:23:31 +0100
Message-Id: <1360671815-2135-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360671815-2135-1-git-send-email-pbonzini@redhat.com>
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful in places that recycle the same scatterlist multiple
times, and do not want to incur the cost of sg_init_table every
time in hot paths.

Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
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
1.7.1


