Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaB1VDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:03:23 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:37641 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbaB1VDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:03:22 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8cAFX5EFNbskx7/2dsb2JhbABZKIJeO4MIpgWYZQICgRQXdIJTExwjGIECJBOHfQHMBY5VhD4EiUiOcQGBMpB5gzov
Date: Fri, 28 Feb 2014 21:04:36 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/affs/dir.c: unlock/brelse dir on failure + code
 clean-up
Message-Id: <20140228210436.87f8d1ee59f02daee600e10e@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0edf977d2ae32b ("[readdir] convert affs")
returns directly -EIO without unlocking dir inode and cleaning dir bh
when second affs_bread sequence fails.
This patch restores initial behaviour.It also fixes pr_debug and
affs_error to fit in 80 columns + removes reference to filldir
(replaced by dir_emit in the commit above).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/dir.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index f1eba8c..cbbda47 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -52,8 +52,10 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 	int			 hash_pos;
 	int			 chain_pos;
 	u32			 ino;
+	int			 error = 0;
 
-	pr_debug("AFFS: readdir(ino=%lu,f_pos=%lx)\n",inode->i_ino,(unsigned long)ctx->pos);
+	pr_debug("AFFS: readdir(ino=%lu,f_pos=%lx)\n",
+		 inode->i_ino, (unsigned long)ctx->pos);
 
 	if (ctx->pos < 2) {
 		file->private_data = (void *)0;
@@ -72,7 +74,7 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 	}
 	dir_bh = affs_bread(sb, inode->i_ino);
 	if (!dir_bh)
-		goto readdir_out;
+		goto out_unlock_dir;
 
 	/* If the directory hasn't changed since the last call to readdir(),
 	 * we can jump directly to where we left off.
@@ -88,7 +90,8 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 		fh_bh = affs_bread(sb, ino);
 		if (!fh_bh) {
 			affs_error(sb, "readdir","Cannot read block %d", i);
-			return -EIO;
+			error = -EIO;
+			goto out_brelse_dir;
 		}
 		ino = be32_to_cpu(AFFS_TAIL(sb, fh_bh)->hash_chain);
 		affs_brelse(fh_bh);
@@ -107,29 +110,34 @@ inside:
 		do {
 			fh_bh = affs_bread(sb, ino);
 			if (!fh_bh) {
-				affs_error(sb, "readdir","Cannot read block %d", ino);
+				affs_error(sb, "readdir",
+					   "Cannot read block %d", ino);
 				break;
 			}
 
 			namelen = min(AFFS_TAIL(sb, fh_bh)->name[0], (u8)30);
 			name = AFFS_TAIL(sb, fh_bh)->name + 1;
-			pr_debug("AFFS: readdir(): filldir(\"%.*s\", ino=%u), hash=%d, f_pos=%x\n",
+			pr_debug("AFFS: readdir(): dir_emit(\"%.*s\", "
+				 "ino=%u), hash=%d, f_pos=%x\n",
 				 namelen, name, ino, hash_pos, (u32)ctx->pos);
+
 			if (!dir_emit(ctx, name, namelen, ino, DT_UNKNOWN))
-				goto readdir_done;
+				goto done;
 			ctx->pos++;
 			ino = be32_to_cpu(AFFS_TAIL(sb, fh_bh)->hash_chain);
 			affs_brelse(fh_bh);
 			fh_bh = NULL;
 		} while (ino);
 	}
-readdir_done:
+done:
 	file->f_version = inode->i_version;
 	file->private_data = (void *)(long)ino;
+	affs_brelse(fh_bh);
 
-readdir_out:
+out_brelse_dir:
 	affs_brelse(dir_bh);
-	affs_brelse(fh_bh);
+
+out_unlock_dir:
 	affs_unlock_dir(inode);
-	return 0;
+	return error;
 }
-- 
1.8.1.4

