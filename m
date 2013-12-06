Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab3LFJLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:11:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42294 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab3LFJLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:11:14 -0500
X-AuditID: cbfee61a-b7f796d000004313-84-52a194b02dfd
From: Chao Yu <chao2.yu@samsung.com>
To: "'???'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH 3/3 V2] f2fs: introduce f2fs_cache_node_page() to
 add page into node_inode cache
Date: Fri, 06 Dec 2013 17:10:00 +0800
Message-id: <000501cef263$1c57e710$5507b530$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7yYhkuSGXUx+39SR6MpXPzUAYfbA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd0NUxYGGexpNrW4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PUrbPMBYf5Khbf
	6WVvYHzE3cXIySEhYCLx9PBBJghbTOLCvfVsXYxcHEICixglnhzfwA6SEBL4wShxbEEJiM0m
	oCKxvOM/WIOIgLLEqo52NhCbWSBTYs7ryawgtrBArsTkhy/AalgEVCUmTTkFNodXwFLiza31
	bBC2oMSPyfdYIHrVJSbNW8QMYctLbF7zlhniIAWJHWdfM0Ls0pNYdewGVL24xMYjt1gmMArM
	QjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4EB+JrWDcWWDxSFG
	AQ5GJR5ejlULgoRYE8uKK3MPMUpwMCuJ8PaILwwS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug
	1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwGifk3D8bFRG+/H5HE/L41N9p2/Z5uo8z+dcwvy5uo+F
	y3Ysl/bnX8KszTddI+vtOoFjTyQ3TG2+m3RjmTHfV/kbidd/Nvi/m5uj3hI4Z1f+bZUtR6d2
	aczztl39VY717jvDkDKGBb//K/gJHciWv2H3Z1vtN8/en+tmSxWc8Wuten/EfiU7F6MSS3FG
	oqEWc1FxIgCRWISQYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces f2fs_cache_node_page(), in this function, page which is
readed ahead will be copy to node_inode's mapping cache.
It will avoid rereading these node pages.

change log:
 o check validity of grabbed page suggested by Jaegeuk Kim.

Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 099f06f..3ff98fa 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1600,6 +1600,39 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 	return 0;
 }
 
+/*
+ * f2fs_cache_node_page() copy updated page data to node_inode cache page.
+ */
+void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
+						nid_t nid)
+{
+	struct address_space *mapping = sbi->node_inode->i_mapping;
+	struct page *npage;
+
+	npage = find_get_page(mapping, nid);
+	if (unlikely(npage && PageUptodate(npage))) {
+		f2fs_put_page(npage, 0);
+		return;
+	}
+	f2fs_put_page(npage, 0);
+
+	npage = grab_cache_page(mapping, nid);
+	if (unlikely(!npage))
+		return;
+
+	if (unlikely(PageUptodate(npage))) {
+		f2fs_put_page(npage, 1);
+		return;
+	}
+
+	memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);
+
+	SetPageUptodate(npage);
+	f2fs_put_page(npage, 1);
+
+	return;
+}
+
 int restore_node_summary(struct f2fs_sb_info *sbi,
 			unsigned int segno, struct f2fs_summary_block *sum)
 {
@@ -1633,6 +1666,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 				sum_entry->version = 0;
 				sum_entry->ofs_in_node = 0;
 				sum_entry++;
+				f2fs_cache_node_page(sbi, page,
+					le32_to_cpu(rn->footer.nid));
 			} else {
 				err = -EIO;
 			}
-- 
1.7.9.5

