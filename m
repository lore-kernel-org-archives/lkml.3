Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3L3B34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 20:29:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:17449 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3L3B3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 20:29:54 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-84-52c0cc904f23
From: Chao Yu <chao2.yu@samsung.com>
To: "'???'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <000201cf03cc$30b2ce30$92186a90$@samsung.com>
In-reply-to: <000201cf03cc$30b2ce30$92186a90$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH] f2fs: avoid to left uninitialized data in page
 when read inline data
Date: Mon, 30 Dec 2013 09:29:06 +0800
Message-id: <000301cf04fe$a2fb82b0$e8f28810$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGHwb8RBoK/8vQEnqGquASIcVKYWpr6d7CQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jQd0JZw4EGew9Y2lxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8a+xtXMBSu5K04/
	WczewLiKs4uRk0NCwESifdYndghbTOLCvfVsXYxcHEIC0xklOvZ2s0I4P4CcKRdZQKrYBFQk
	lnf8ZwKxRQSUJVZ1tLOB2MwCmRJzXk9mBbGFBCwl3p7eDGZzClhJLGvZA9YrLJAmsWH3XbBe
	FgFViUen7oH18gLV73l8lQnCFpT4MfkeC8RMLYn1O48zQdjyEpvXvGWGuFRBYsfZ14wQNxhJ
	HOzZxQpRIy6x8cgtlgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10v
	OT93EyM49J9J72Bc1WBxiFGAg1GJh/dlwP4gIdbEsuLK3EOMEhzMSiK8bqcPBAnxpiRWVqUW
	5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgLLEu1Zm3cIrqrGMnuRpd
	75SfeiV29mHWy2fHHDuv1Wz68N2lb9uD0KDZKg+4Tm9xPbWl/5un4Kzzm/giWJfpKf4WWRNZ
	2ScU7vX3nsBhgVktn3c+Laiau6nkss+KBe3xZ+oLD3grrH3UZ7SqWOANj9nUlc+uTGfJsdtV
	UB9vVp63KuXNzi8ub5RYijMSDbWYi4oTAU9OBrF5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o reduce unneeded memset in __f2fs_convert_inline_data

>From 58796be2bd2becbe8d52305210fb2a64e7dd80b6 Mon Sep 17 00:00:00 2001
From: Chao Yu <chao2.yu@samsung.com>
Date: Mon, 30 Dec 2013 09:21:33 +0800
Subject: [PATCH] f2fs: avoid to left uninitialized data in page when read
 inline data

We left uninitialized data in the tail of page when we read an inline data
page. So let's initialize left part of the page excluding inline data region.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/inline.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 0e940ce..33a07e1 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -48,8 +48,7 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 	if (IS_ERR(ipage))
 		return PTR_ERR(ipage);
 
-	zero_user_segment(page, INLINE_DATA_OFFSET,
-				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+	zero_user_segment(page, MAX_INLINE_DATA, PAGE_CACHE_SIZE);
 
 	/* Copy the whole inline data block */
 	src_addr = inline_data_addr(ipage);
@@ -94,7 +93,7 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 		return err;
 	}
 
-	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+	zero_user_segment(page, MAX_INLINE_DATA, PAGE_CACHE_SIZE);
 
 	/* Copy the whole inline data block */
 	src_addr = inline_data_addr(ipage);
-- 
1.7.9.5

