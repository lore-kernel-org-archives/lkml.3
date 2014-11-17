Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaKQRbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:31:13 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45516 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaKQRbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:31:12 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-1c-546a30dd2f06
Subject: [PATCH RFC] fs: check and toss errors returned by ->sync_fs
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: koct9i@gmail.com
Date: Mon, 17 Nov 2014 20:31:08 +0400
Message-id: <20141117173108.30234.59271.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xa7p3DbJCDH4uErD4sbOX1WJl5wNW
	iz17T7JYXN41h83i/N/jrA6sHjtn3WX36NuyitHj8yY5j01P3jIFsERx2aSk5mSWpRbp2yVw
	ZdzYvY21YCN/xfY5SxkbGCfzdDFyckgImEh8eXObGcIWk7hwbz1bFyMXh5DAUkaJTV+us0I4
	jUwS/w/uYwSpEhZwkTjXc4EJxGYTMJPYtu82UJyDQ0QgW+LQkRAQk1lAROLk7GiQChYBVYnN
	W5+AdfIKGEtMed7NAmKLCshJrLzcwgoRF5T4MfkeC0SrusSUKbkgYWYBeYnNa94yT2Dkm4Wk
	ahZC1SwkVQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihATklx2Mi49ZHWIU4GBU4uEV
	YMkKEWJNLCuuzD3EKMHBrCTCW6IPFOJNSaysSi3Kjy8qzUktPsTIxMEp1cC4wbnGofbhvg1P
	Ff99iNw7+f2cJT8+mqgfLhX5caHl8s2rzrvUfJZxGlot+26aFbg90ILl7RTWqysZ8/+/rg14
	aR3prG2x9fqNjOWy4Z37QiMMxK/x74j4t2LhQpYjc6cXadleVnHpU3mmnbdMKy5wtxjDWo1Z
	QV785o+X75i7S/2g2Xy9BSvblViKMxINtZiLihMBeTnJTyYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->ssync_fs returns int but the result is always ignored silently.
Of course syscall sync is declared as void and it writes multiple
fs thus returning error codes here is impossible and meaningless.
But recently added syscall syncfs writes only one filesystem, it
returns int but only -EBADF is documented for now.

After this patch sync_filesystem() and syscall syncfs returns these
error codes. Also they will skip waiting if somebody returned -EIO,
the same logic is used in filemap_write_and_wait().

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 fs/sync.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index bdc729d..e2c3622 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -29,14 +29,21 @@
  */
 static int __sync_filesystem(struct super_block *sb, int wait)
 {
+	int ret = 0, ret2;
+
 	if (wait)
 		sync_inodes_sb(sb);
 	else
 		writeback_inodes_sb(sb, WB_REASON_SYNC);
 
 	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, wait);
-	return __sync_blockdev(sb->s_bdev, wait);
+		ret = sb->s_op->sync_fs(sb, wait);
+
+	ret2 = __sync_blockdev(sb->s_bdev, wait);
+	if (!ret)
+		ret = ret2;
+
+	return ret;
 }
 
 /*
@@ -46,7 +53,7 @@ static int __sync_filesystem(struct super_block *sb, int wait)
  */
 int sync_filesystem(struct super_block *sb)
 {
-	int ret;
+	int ret, ret2;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -61,9 +68,18 @@ int sync_filesystem(struct super_block *sb)
 		return 0;
 
 	ret = __sync_filesystem(sb, 0);
-	if (ret < 0)
+	/*
+	 * EIO may indicate the worst thing: bug or hardware failure.
+	 * In other cases it's better to wait for partially written data.
+	 */
+	if (ret == -EIO)
 		return ret;
-	return __sync_filesystem(sb, 1);
+
+	ret2 = __sync_filesystem(sb, 1);
+	if (!ret)
+		ret = ret2;
+
+	return ret;
 }
 EXPORT_SYMBOL(sync_filesystem);
 

