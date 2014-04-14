Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaDNGFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 02:05:47 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38273 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaDNGFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:05:45 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Cc: fabf@skynet.be, rakesh@tuxera.com, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Subject: [PATCH] befs: replace goto with while
Date: Mon, 14 Apr 2014 15:05:40 +0900
Message-ID: <1621522.xn25S7ZxMj@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The goto in befs_readdir() can be replaced with while.

And also fix smatch warnings:
 fs/befs/linuxvfs.c:283 befs_readdir() info:
ignoring unreachable code.
 fs/befs/linuxvfs.c:283 befs_readdir() info:
ignoring unreachable code.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/befs/linuxvfs.c |   86 +++++++++++++++++++++++++++-------------------------
 1 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index d626756..640f8775 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -227,6 +227,7 @@ befs_readdir(struct file *file, struct dir_context *ctx)
 	befs_data_stream *ds = &BEFS_I(inode)->i_data.ds;
 	befs_off_t value;
 	int result;
+	int ret = 0;
 	size_t keysize;
 	unsigned char d_type;
 	char keybuf[BEFS_NAME_LEN + 1];
@@ -235,54 +236,57 @@ befs_readdir(struct file *file, struct dir_context *ctx)
 	befs_debug(sb, "---> %s name %s, inode %ld, ctx->pos %lld",
 		  __func__, dirname, inode->i_ino, ctx->pos);
 
-more:
-	result = befs_btree_read(sb, ds, ctx->pos, BEFS_NAME_LEN + 1,
-				 keybuf, &keysize, &value);
+	while (1) {
+		result = befs_btree_read(sb, ds, ctx->pos, BEFS_NAME_LEN + 1,
+					 keybuf, &keysize, &value);
 
-	if (result == BEFS_ERR) {
-		befs_debug(sb, "<--- %s ERROR", __func__);
-		befs_error(sb, "IO error reading %s (inode %lu)",
-			   dirname, inode->i_ino);
-		return -EIO;
+		if (result == BEFS_ERR) {
+			befs_debug(sb, "<--- %s ERROR", __func__);
+			befs_error(sb, "IO error reading %s (inode %lu)",
+				   dirname, inode->i_ino);
+			ret = -EIO;
+			break;
 
-	} else if (result == BEFS_BT_END) {
-		befs_debug(sb, "<--- %s END", __func__);
-		return 0;
+		} else if (result == BEFS_BT_END) {
+			befs_debug(sb, "<--- %s END", __func__);
+			break;
 
-	} else if (result == BEFS_BT_EMPTY) {
-		befs_debug(sb, "<--- %s Empty directory", __func__);
-		return 0;
-	}
+		} else if (result == BEFS_BT_EMPTY) {
+			befs_debug(sb, "<--- %s Empty directory", __func__);
+			break;
+		}
 
-	d_type = DT_UNKNOWN;
+		d_type = DT_UNKNOWN;
 
-	/* Convert to NLS */
-	if (BEFS_SB(sb)->nls) {
-		char *nlsname;
-		int nlsnamelen;
-		result =
-		    befs_utf2nls(sb, keybuf, keysize, &nlsname, &nlsnamelen);
-		if (result < 0) {
-			befs_debug(sb, "<--- %s ERROR", __func__);
-			return result;
-		}
-		if (!dir_emit(ctx, nlsname, nlsnamelen,
-				 (ino_t) value, d_type)) {
+		/* Convert to NLS */
+		if (BEFS_SB(sb)->nls) {
+			char *nlsname;
+			int nlsnamelen;
+
+			result = befs_utf2nls(sb, keybuf, keysize, &nlsname,
+					      &nlsnamelen);
+
+			if (result < 0) {
+				befs_debug(sb, "<--- %s ERROR", __func__);
+				ret = result;
+				break;
+			}
+			if (!dir_emit(ctx, nlsname, nlsnamelen,
+				      (ino_t) value, d_type)) {
+				kfree(nlsname);
+				break;
+			}
 			kfree(nlsname);
-			return 0;
+		} else {
+			if (!dir_emit(ctx, keybuf, keysize,
+				      (ino_t) value, d_type))
+				break;
 		}
-		kfree(nlsname);
-	} else {
-		if (!dir_emit(ctx, keybuf, keysize,
-				 (ino_t) value, d_type))
-			return 0;
+		ctx->pos++;
+		befs_debug(sb, "<--- %s pos %lld", __func__, ctx->pos);
 	}
-	ctx->pos++;
-	goto more;
 
-	befs_debug(sb, "<--- %s pos %lld", __func__, ctx->pos);
-
-	return 0;
+	return ret;
 }
 
 static struct inode *
-- 
1.7.4.4


