Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaC2Hbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 03:31:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48876 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaC2Hbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 03:31:32 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-97-533676d19256
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: fix error path when fail to read inline data
Date: Sat, 29 Mar 2014 15:30:40 +0800
Message-id: <000101cf4b20$e4765270$ad62f750$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9LHoRwP637GPA+RcKKhJHOyzw3yw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQd1LZWbBBjensFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHx1Vy2gnU8Fa37
	vrI2MD7k7GLk5JAQMJHYN382E4QtJnHh3nq2LkYuDiGB6YwSLw+dZIdwfjBK3GpfDFbFJqAi
	sbzjP5gtIqAoseH9BnYQm1kgU+Je0wxmEFtYwE+i6fhHRhCbRUBV4nrDZ7AaXgFLiZuLJ0HZ
	ghI/Jt9jgejVkli/8zgThC0vsXnNW2aIixQkdpx9zQixS0+iY243VI24xMYjt1gmMArMQjJq
	FpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4FB+Jr2DcVWDxSFGAQ5G
	JR5egVbTYCHWxLLiytxDjBIczEoivJmmZsFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcK
	CaQnlqRmp6YWpBbBZJk4OKUaGFecNrl6+sKniCdZe+rWH7pZs39DVcy9xJjDGuuUzO3V3auZ
	L2cqHUq1dgwXlJi3qTx9e6vqYqNVnOt62D95XZLXmWf9TnLlqh75p1MvTHb9ySk9t9SeeV/9
	qtjV3/xsivWN+XaHL9+o8O2QeWf4fadTjpcXRd5V0ZpvufSVrbPssqd9k20yypRYijMSDbWY
	i4oTAcW2XDhhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should unlock page in ->readpage() path and also should unlock & release page
in error path of ->write_begin() to avoid deadlock or memory leak.
So let's add release code to fix the problem when we fail to read inline data.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c   |   14 ++++++++++----
 fs/f2fs/inline.c |    4 +++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 598bfa6..45abd60 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -942,13 +942,19 @@ inline_data:
 	if (dn.data_blkaddr == NEW_ADDR) {
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 	} else {
-		if (f2fs_has_inline_data(inode))
+		if (f2fs_has_inline_data(inode)) {
 			err = f2fs_read_inline_data(inode, page);
-		else
+			if (err) {
+				page_cache_release(page);
+				return err;
+			}
+		} else {
 			err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
 							READ_SYNC);
-		if (err)
-			return err;
+			if (err)
+				return err;
+		}
+
 		lock_page(page);
 		if (unlikely(!PageUptodate(page))) {
 			f2fs_put_page(page, 1);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 31ee5b1..383db1f 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -45,8 +45,10 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 	}
 
 	ipage = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(ipage))
+	if (IS_ERR(ipage)) {
+		unlock_page(page);
 		return PTR_ERR(ipage);
+	}
 
 	zero_user_segment(page, MAX_INLINE_DATA, PAGE_CACHE_SIZE);
 
-- 
1.7.9.5


