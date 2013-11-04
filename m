Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3KDCaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 21:30:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:58454 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3KDCaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 21:30:09 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-3b-527706afe6c9
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: remove unnecessary TestClearPageError when
 wait pages writeback
Date: Mon, 04 Nov 2013 10:28:33 +0800
Message-id: <000001ced905$c49eac00$4ddc0400$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7XlEwB9Xz7GigZRU+F4tz+grChWQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd0NbOVBBofTLK7v+stkcWmRu8We
	vSdZLC7vmsNm0brwPLMDq8fuBZ+ZPPq2rGL0+LxJLoA5issmJTUnsyy1SN8ugStjdsdL5oIv
	bBVNN76wNDBuZe1i5OSQEDCRWHD0DDOELSZx4d56ti5GLg4hgUWMEqubJ7FDOD8YJX6c+csC
	UsUmoCKxvOM/E4gtIqAt8XNuK1gRs8AMRonDc/+BjRUWSJZYdnMZmM0ioCrxe80PdhCbV8BS
	4vHNOywQtqDEj8n3wGxmAQ2J/kUb2CBseYnNa95CnaQgsePsa8YuRg6gZXoS55dIQJSIS2w8
	cotlAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7pZ9I7
	GFc1WBxiFOBgVOLhlbhcFiTEmlhWXJl7iFGCg1lJhNf5HFCINyWxsiq1KD++qDQntfgQozQH
	i5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QDY1PctG0nMvIkfxbOPVKY96zwy4SjSk8PyvhN
	2VLn/PHP14Ldlq8af6y/9d159yu5jFDXjw/bp3HJcb6f+TXZReSjAXdFpLvmrpMqjOUR85Xn
	Tgn/evVc9+Ug0Vdf1lv63og+aaxhypcU9oJlyyO+uydfrT/UPu1Ytxz7+5MzSuoOz1hblb68
	iVeJpTgj0VCLuag4EQBnYzf5ZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In wait_on_node_pages_writeback we will test and clear error flag for all pages in radix tree, but not necessary.
So we only do this for pages belong to the specified inode.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b527ed4..4ac4150 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1170,10 +1170,11 @@ int wait_on_node_pages_writeback(struct f2fs_sb_info *sbi, nid_t ino)
 			if (page->index > end)
 				continue;
 
-			if (ino && ino_of_node(page) == ino)
+			if (ino && ino_of_node(page) == ino) {
 				wait_on_page_writeback(page);
-			if (TestClearPageError(page))
-				ret = -EIO;
+				if (TestClearPageError(page))
+					ret = -EIO;
+			}
 		}
 		pagevec_release(&pvec);
 		cond_resched();
-- 
1.7.9.5

