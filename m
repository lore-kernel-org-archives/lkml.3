Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3L3CBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 21:01:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45440 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3L3CBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 21:01:31 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-17-52c0d3f9c18c
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH] f2fs: avoid to read inline data except first page
Date: Mon, 30 Dec 2013 10:00:43 +0800
Message-id: <000401cf0503$0d122f10$27368d30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8E/6Zj1+O8q1iISKiAEAK/RLM23A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd2flw8EGUw7LG5xfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8aRS5NZCk5xVPR/
	vsvWwPiWrYuRk0NCwETiauNEJghbTOLCvfVgcSGB6YwSz24adTFyAdk/GCXONi1mBEmwCahI
	LO/4D9YgIqAoseH9BnYQm1kgU2LO68msILawgK/E8j8tYHEWAVWJSU/XAtVzcPAKWErs/gc2
	n1dAUOLH5HssEK1aEut3HmeCsOUlNq95ywxxj4LEjrOvGSFW6UnMuDcfqkZcYuORWywTGAVm
	IRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcBg/k97BuKrB4hCj
	AAejEg/vy4D9QUKsiWXFlbmHGCU4mJVEeN1OHwgS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw
	1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwJjccXFSoXPV0gl3hGX8T4vOyf63W1It/FGyoKb5hsR1
	25/NWm+v+Lw7ar5677t1Vy/N8sx7dVzx81vu8jWMD0QM7F1LPwd5bP81dTFf/ovdLQGbVk+f
	LH5+2sNN1VrCT/I/y8i1NVoeSuZxVZdc9eLqVftE2ZDed68diwNn7hCsZf446fC20JtKLMUZ
	iYZazEXFiQBkELucXwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a case which could read inline page data not from first page.

1. write inline data
2. lseek to offset 4096
3. read 4096 bytes from offset 4096
	(read_inline_data read inline data page to non-first page,
	And previously VFS has add this page to page cache)
4. ftruncate offset 8192
5. read 4096 bytes from offset 4096
	(we meet this updated page with inline data in cache)

So we should leave this page with inited data and uptodate flag
for this case.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/inline.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 33a07e1..4796037 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -44,6 +44,12 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 	struct page *ipage;
 	void *src_addr, *dst_addr;
 
+	if (page->index) {
+		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+		SetPageUptodate(page);
+		return 0;
+	}
+
 	ipage = get_node_page(sbi, inode->i_ino);
 	if (IS_ERR(ipage))
 		return PTR_ERR(ipage);
-- 
1.7.9.5

