Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaDQCwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 22:52:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14875 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaDQCwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 22:52:05 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-7e-534f41d3ec99
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: introduce raw_nat_from_node_info() to simplfy
 codes
Date: Thu, 17 Apr 2014 10:51:05 +0800
Message-id: <000a01cf59e8$03a910d0$0afb3270$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9Z59iafTcHt3IHSMKJV3LLN3oUXQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd3Ljv7BBpsWCFhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFh/S7GgvtCFbvv
	TmFpYNzC38XIySEhYCLx7PdJdghbTOLCvfVsILaQwHRGiQ9rs7sYuYDsH4wSP+79ZQRJsAmo
	SCzv+M8EYosIKEpseL8BrJlZIFPiXtMMZhBbWCBM4tCv02A1LAKqEicvLQer4RWwlPj6uJ8V
	whaU+DH5HgtEr5bE+p3HmSBseYnNa94yQxykILHj7GtGiF16Eo/ufIKqEZfYeOQWywRGgVlI
	Rs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcyM+kdjCubLA4xCjA
	wajEwztB3T9YiDWxrLgy9xCjBAezkgivuzhQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutA
	IYH0xJLU7NTUgtQimCwTB6dUA+PeG48fnTKu+dR/7m65hhNT2lODQ8c+eB30upB5MXx6WKzg
	bKZMy8anq2auvMJ3vuxLn/TtmS8Mf7YU9sXucP7cJHzC66VZXt2tbxvsfwpOtGGx1C7Iz/oV
	dljWt754t7lJ65XZD7VWeu6QCznB/VzhxWkj9QzrCKf0fw9L5LXzUz24JNtErZVYijMSDbWY
	i4oTATaFbvZgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce raw_nat_from_node_info() to simplfy some codes, and also
use exist function node_info_from_raw_nat() to do the same job.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |   15 +++------------
 fs/f2fs/node.h |    8 ++++++++
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f760793..84f9b7b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -179,9 +179,7 @@ retry:
 			write_unlock(&nm_i->nat_tree_lock);
 			goto retry;
 		}
-		nat_set_blkaddr(e, le32_to_cpu(ne->block_addr));
-		nat_set_ino(e, le32_to_cpu(ne->ino));
-		nat_set_version(e, ne->version);
+		node_info_from_raw_nat(&e->ni, ne);
 	}
 	write_unlock(&nm_i->nat_tree_lock);
 }
@@ -1755,9 +1753,7 @@ retry:
 			write_unlock(&nm_i->nat_tree_lock);
 			goto retry;
 		}
-		nat_set_blkaddr(ne, le32_to_cpu(raw_ne.block_addr));
-		nat_set_ino(ne, le32_to_cpu(raw_ne.ino));
-		nat_set_version(ne, raw_ne.version);
+		node_info_from_raw_nat(&ne->ni, &raw_ne);
 		__set_nat_cache_dirty(nm_i, ne);
 		write_unlock(&nm_i->nat_tree_lock);
 	}
@@ -1790,7 +1786,6 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 		nid_t nid;
 		struct f2fs_nat_entry raw_ne;
 		int offset = -1;
-		block_t new_blkaddr;
 
 		if (nat_get_blkaddr(ne) == NEW_ADDR)
 			continue;
@@ -1826,11 +1821,7 @@ to_nat_page:
 		f2fs_bug_on(!nat_blk);
 		raw_ne = nat_blk->entries[nid - start_nid];
 flush_now:
-		new_blkaddr = nat_get_blkaddr(ne);
-
-		raw_ne.ino = cpu_to_le32(nat_get_ino(ne));
-		raw_ne.block_addr = cpu_to_le32(new_blkaddr);
-		raw_ne.version = nat_get_version(ne);
+		raw_nat_from_node_info(&raw_ne, &ne->ni);
 
 		if (offset < 0) {
 			nat_blk->entries[nid - start_nid] = raw_ne;
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 5decc1a..41bb65b 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -75,6 +75,14 @@ static inline void node_info_from_raw_nat(struct node_info *ni,
 	ni->version = raw_ne->version;
 }
 
+static inline void raw_nat_from_node_info(struct f2fs_nat_entry *raw_ne,
+						struct node_info *ni)
+{
+	raw_ne->ino = cpu_to_le32(ni->ino);
+	raw_ne->block_addr = cpu_to_le32(ni->blk_addr);
+	raw_ne->version = ni->version;
+}
+
 enum nid_type {
 	FREE_NIDS,	/* indicates the free nid list */
 	NAT_ENTRIES	/* indicates the cached nat entry */
-- 
1.7.9.5


