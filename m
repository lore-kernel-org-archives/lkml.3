Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3L3Khe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:37:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50687 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3L3Khd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:37:33 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-9f-52c14cdf9dd5
From: Chao Yu <chao2.yu@samsung.com>
To: "'???'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH V2] f2fs: avoid to read inline data except first page
Date: Mon, 30 Dec 2013 18:36:23 +0800
Message-id: <000701cf054b$1db23ca0$5916b5e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8FSuMYYcVs8UGpTyuxuhFnE9iKew==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd37PgeDDH72yFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXGr4yp7wRyuiuZ3
	p1kaGCdwdDFycEgImEi0H3XqYuQEMsUkLtxbz9bFyMUhJLCIUeLb9w3sEM4PRom7Ox4wgVSx
	CahILO/4D2aLCChLrOpoZwOxmQUyJea8nswKYgsLBEgsO3SUHcRmEVCVODNhAQuIzStgKbF4
	+m12CFtQ4sfkeywQvVoS63ceZ4Kw5SU2r3nLDHGRgsSOs68ZIXbpSZzYuJ8VokZcYuORWywT
	GAVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCA/k97BuKrB
	4hCjAAejEg9vwI0DQUKsiWXFlbmHGCU4mJVEeHncDwYJ8aYkVlalFuXHF5XmpBYfYpTmYFES
	5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYGQtCC5qFTHueFS9vWOdH3vU7Rm1NxT8/h4TvW46
	7ee6B/uXJr895Ruz9WyxUuIOuwt1M8pP+AZusJSc+51DYBLH1q5ut4u7r14qP/i48Ma6GdJZ
	hWYLnyXypd99EFR57tr03x7ivRqll77WXS/8JCj1aqXg1Pepkza3c8xg7GLRMLX+sGWjYbYS
	S3FGoqEWc1FxIgDhbJRJYAIAAA==
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

Change log from v1:
 o fix a deadlock bug

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/inline.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 5d121d7..69a923e 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -39,6 +39,11 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 	struct page *ipage;
 	void *src_addr, *dst_addr;
 
+	if (page->index) {
+		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+		goto out;
+	}
+
 	ipage = get_node_page(sbi, inode->i_ino);
 	if (IS_ERR(ipage))
 		return PTR_ERR(ipage);
@@ -52,6 +57,7 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 	kunmap(page);
 	f2fs_put_page(ipage, 1);
 
+out:
 	SetPageUptodate(page);
 	unlock_page(page);
 
-- 
1.7.9.5

