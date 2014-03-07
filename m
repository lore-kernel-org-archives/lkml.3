Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaCGKwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:52:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbaCGKwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:52:20 -0500
X-IronPort-AV: E=Sophos;i="4.97,607,1389715200"; 
   d="scan'208";a="9660336"
Message-ID: <5319A2D8.70409@cn.fujitsu.com>
Date: Fri, 07 Mar 2014 18:43:36 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] f2fs: optimize restore_node_summary slightly
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:42,
	Serialize complete at 2014/03/07 18:49:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, we ra_sum_pages to pre-read contiguous pages as more
as possible, and if we fail to alloc more pages, an ENOMEM error
will be reported upstream, even though we have alloced some pages
yet. In fact, we can use the available pages to do the job partly,
and continue the rest in the following circle. Only reporting ENOMEM
upstream if we really can not alloc any available page.

And another fix is ignoring dealing with the following pages if an
EIO occurs when reading page from page_list.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/node.c    |   44 ++++++++++++++++++++------------------------
 fs/f2fs/segment.c |    7 +++++--
 2 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 8787469..4b7861d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1588,15 +1588,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 	for (; page_idx < start + nrpages; page_idx++) {
 		/* alloc temporal page for read node summary info*/
 		page = alloc_page(GFP_F2FS_ZERO);
-		if (!page) {
-			struct page *tmp;
-			list_for_each_entry_safe(page, tmp, pages, lru) {
-				list_del(&page->lru);
-				unlock_page(page);
-				__free_pages(page, 0);
-			}
-			return -ENOMEM;
-		}
+		if (!page)
+			break;
 
 		lock_page(page);
 		page->index = page_idx;
@@ -1607,7 +1600,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
 
 	f2fs_submit_merged_bio(sbi, META, READ);
-	return 0;
+
+	return page_idx - start;
 }
 
 int restore_node_summary(struct f2fs_sb_info *sbi,
@@ -1630,28 +1624,30 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 		nrpages = min(last_offset - i, bio_blocks);
 
 		/* read ahead node pages */
-		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
-		if (err)
-			return err;
+		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
+		if (!nrpages)
+			return -ENOMEM;
 
 		list_for_each_entry_safe(page, tmp, &page_list, lru) {
-
-			lock_page(page);
-			if (unlikely(!PageUptodate(page))) {
-				err = -EIO;
-			} else {
-				rn = F2FS_NODE(page);
-				sum_entry->nid = rn->footer.nid;
-				sum_entry->version = 0;
-				sum_entry->ofs_in_node = 0;
-				sum_entry++;
+			if (!err) {
+				lock_page(page);
+				if (unlikely(!PageUptodate(page))) {
+					err = -EIO;
+				} else {
+					rn = F2FS_NODE(page);
+					sum_entry->nid = rn->footer.nid;
+					sum_entry->version = 0;
+					sum_entry->ofs_in_node = 0;
+					sum_entry++;
+				}
+				unlock_page(page);
 			}
 
 			list_del(&page->lru);
-			unlock_page(page);
 			__free_pages(page, 0);
 		}
 	}
+
 	return err;
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 199c964..b3f8431 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1160,9 +1160,12 @@ static int read_normal_summaries(struct f2fs_sb_info *sbi, int type)
 				ns->ofs_in_node = 0;
 			}
 		} else {
-			if (restore_node_summary(sbi, segno, sum)) {
+			int err;
+
+			err = restore_node_summary(sbi, segno, sum);
+			if (err) {
 				f2fs_put_page(new, 1);
-				return -EINVAL;
+				return err;
 			}
 		}
 	}
-- 
1.7.7

