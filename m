Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab3LEBzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:55:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31813 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3LEBzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:55:39 -0500
X-AuditID: cbfee61a-b7f796d000004313-f1-529fdd19b699
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 3/3] f2fs: introduce f2fs_cache_node_page() to add
 page into node_inode cache
Date: Thu, 05 Dec 2013 09:54:56 +0800
Message-id: <001701cef15d$169a5a30$43cf0e90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7xW57rkvBulRtcTFywPeFMBA87vA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAV2pu/ODDE43MFlc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxsXpy1gL
	LvBUND3fyN7AOIOri5GTQ0LARKLnxVZGCFtM4sK99WxdjFwcQgKLGCW2dK1hBkkICfxglJjy
	0RrEZhNQkVje8Z8JxBYRUJTY8H4DO0gDs8AMRonDc/+xgiSEBbIkfjYsAytiEVCV2PLnGNgg
	XgFLiVstV6BsQYkfk++xgNjMAhoS/Ys2sEHY8hKb17xlhrhIQWLH2deMEMv0JPbtPcwKUSMu
	sfHILZYJjAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKif
	Se1gXNlgcYhRgINRiYf3ReL8ICHWxLLiytxDjBIczEoivPVXgUK8KYmVValF+fFFpTmpxYcY
	pTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYWbreZ5qm8Boq7V6w8GFndse35QqGVyT/
	rUxqlHBY4rki/O2JUxLf5cqvPAhW1WN2v3N3nfTk5qB1Lx4o2LBe6vm8zlJj+eK/zpuucW59
	K3ns9zsRO/nKE2L127zMgo7/U+BMP1qnZ2vF8/fc57v8mtEbWSUeGfTdXLk0oLVrzXGDpI8L
	rS4dUGIpzkg01GIuKk4EAM1GqPJmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces f2fs_cache_node_page(), in this function, page which is
readed ahead will be copy to node_inode's mapping cache.
It will avoid rereading these node pages.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 099f06f..5e2588f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1600,6 +1600,34 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
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
+	if (npage && PageUptodate(npage)) {
+		f2fs_put_page(npage, 0);
+		return;
+	}
+	f2fs_put_page(npage, 0);
+
+	npage = grab_cache_page(mapping, nid);
+	if (!npage)
+		return;
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
@@ -1633,6 +1661,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
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

