Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab3LEB4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:56:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49874 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab3LEB4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:56:19 -0500
X-AuditID: cbfee61a-b7f796d000004313-64-529fdd412f8b
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 2/3] f2fs: avoid unneeded page release for correct
 _count of page
Date: Thu, 05 Dec 2013 09:54:56 +0800
Message-id: <001801cef15d$2e3e4b10$8abae130$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7xWnkObZY7DeOPRb+hr2dnxbxMBQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAV3Hu/ODDM5261hc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxraH/UwF
	bTwV35q+MDYw7uTsYuTkkBAwkfjRvoQRwhaTuHBvPVsXIxeHkMAiRonFn9+CJYQEfjBK3FqY
	A2KzCahILO/4zwRiiwgoSmx4v4EdpIFZYAajxOG5/1hBEsICcRJ3vl0Ca2YRUJXY8ucYM4jN
	K2ApcWsXRJxXQFDix+R7LCA2s4CGRP+iDWwQtrzE5jVvmSEuUpDYcfY1I8QyPYkLPVfYIWrE
	JTYeucUygVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAf1
	M6kdjCsbLA4xCnAwKvHwvkicHyTEmlhWXJl7iFGCg1lJhLf+KlCINyWxsiq1KD++qDQntfgQ
	ozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QD4zqfxD1rI8tnyUzrPGJUoDf1Cp+VYfTy
	VcamP1OZGSz9y/KyLNo4llR5Jef/WPL+k9CnWdau4UIZvnop7du+XQntV5Dk+LFhrd7vTCvz
	3rNnJ30/4PPja2tPbiiD2NHIm0WaEgx/HSY13SvTUi2MX+p+T32j1Jn5+jWntpsuzVGROKJn
	lPRFiaU4I9FQi7moOBEAfhGN7WYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In find_fsync_dnodes() and recover_data(), our flow is like this:

->f2fs_submit_page_bio()
	-> f2fs_put_page()
		-> page_cache_release()	---- page->_count declined to zero.
->__free_pages()
	-> put_page_testzero() ---- page->_count will be declined again.

We will get a segment fault in put_page_testzero when CONFIG_DEBUG_VM
is on, or return MM with a bad page with wrong _count num.

So let's just release this page.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/recovery.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 7dda1f28..d075465 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -145,7 +145,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 
 		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
 		if (err)
-			goto out;
+			return err;
 
 		lock_page(page);
 
@@ -191,9 +191,10 @@ next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
 	}
+
 	unlock_page(page);
-out:
 	__free_pages(page, 0);
+
 	return err;
 }
 
@@ -388,7 +389,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 
 		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
 		if (err)
-			goto out;
+			return err;
 
 		lock_page(page);
 
@@ -412,8 +413,8 @@ next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
 	}
+
 	unlock_page(page);
-out:
 	__free_pages(page, 0);
 
 	if (!err)
-- 
1.7.9.5

