Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaE0BIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:08:02 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56010 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaE0BHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:07:48 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-ed-5383e562b9cf
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: avoid overflow when large directory feathure
 is enabled
Date: Tue, 27 May 2014 09:06:52 +0800
Message-id: <00f601cf7948$1263a480$372aed80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac95RH35p6IB48fqTU+sdKZgScEU4w==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAd2kp83BBo/u2lhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFtRRt7wRaeiq6Z
	HewNjA1cXYycHBICJhLzO/4zQ9hiEhfurWfrYuTiEBJYxCjR0tvFAuH8YJS4PXsuC0gVm4CK
	xPKO/0wgtoiApsTj5ZvBupkFMiXuNc0As4UFoiTut85mA7FZBFQlLpy7C2bzClhKfP2ygwXC
	FpT4MfkeC0SvlsT6nceZIGx5ic1r3kJdpCCx4+xrRohdehKHn2xkhKgRl9h45BbLBEaBWUhG
	zUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzKz6R3MK5qsDjEKMDB
	qMTDO8G3OViINbGsuDL3EKMEB7OSCO+Gk0Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOF
	BNITS1KzU1MLUotgskwcnFINjMbr7D2MpjBdOH5OfHmDZYXosSs2rke+vLIQT49jKD3WtG3d
	ojIG+8WCzLzWVVnn2huX/vV5171ye63BvznLT+bp3ruzy+9m1Dr7R2+qDK6dlJAwUDyyM2y2
	/d/HTffEH77IfmS58JjAfzuW2dzRN7ZO+ed0gmVKm8DJSxclpljN7Ag/IpAvbKrEUpyRaKjF
	XFScCAAGWNleYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When large directory feathure is enable, We have one case which could cause
overflow in dir_buckets() as following:
special case: level + dir_level >= 32 and level < MAX_DIR_HASH_DEPTH / 2.

Here we define MAX_DIR_BUCKETS to limit the return value when the condition
could trigger potential overflow.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c           |    4 ++--
 include/linux/f2fs_fs.h |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index c3f1485..966acb0 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -23,10 +23,10 @@ static unsigned long dir_blocks(struct inode *inode)
 
 static unsigned int dir_buckets(unsigned int level, int dir_level)
 {
-	if (level < MAX_DIR_HASH_DEPTH / 2)
+	if (level + dir_level < MAX_DIR_HASH_DEPTH / 2)
 		return 1 << (level + dir_level);
 	else
-		return 1 << ((MAX_DIR_HASH_DEPTH / 2 + dir_level) - 1);
+		return MAX_DIR_BUCKETS;
 }
 
 static unsigned int bucket_blocks(unsigned int level)
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 8c03f71..ba6f312 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -394,6 +394,9 @@ typedef __le32	f2fs_hash_t;
 /* MAX level for dir lookup */
 #define MAX_DIR_HASH_DEPTH	63
 
+/* MAX buckets in one level of dir */
+#define MAX_DIR_BUCKETS		(1 << ((MAX_DIR_HASH_DEPTH / 2) - 1))
+
 #define SIZE_OF_DIR_ENTRY	11	/* by byte */
 #define SIZE_OF_DENTRY_BITMAP	((NR_DENTRY_IN_BLOCK + BITS_PER_BYTE - 1) / \
 					BITS_PER_BYTE)
-- 
1.7.10.4


