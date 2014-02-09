Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaBIWuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:50:13 -0500
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:48379 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752250AbaBIWs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:48:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1535:1605:1606:1730:1747:1777:1792:2198:2199:2393:2559:2562:2901:3138:3139:3140:3141:3142:3865:3867:3874:4117:4321:4419:4605:5007:6248:6261:8957:10004:10026:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12679,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ray41_13faaf8f1701d
X-Filterd-Recvd-Size: 6189
From: Joe Perches <joe@perches.com>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ncpfs: Convert PPRINTK to ncp_vdbg
Date: Sun,  9 Feb 2014 14:48:47 -0800
Message-Id: <cc512ed66dac8ca5a9042c7071bc8b361d7a0e8e.1391985629.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1391985629.git.joe@perches.com>
References: <cover.1391985629.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Convert the paranoia debug statement to vdbg.
Remove the embedded function names as dynamic_debug can do that.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ncpfs/dir.c           | 19 +++++++++----------
 fs/ncpfs/file.c          |  4 ++--
 fs/ncpfs/ncp_fs.h        |  9 +++++++--
 fs/ncpfs/ncplib_kernel.c |  6 +++---
 fs/ncpfs/sock.c          |  2 +-
 5 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 8bfd2c4..91441de 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -736,8 +736,8 @@ ncp_do_readdir(struct file *file, struct dir_context *ctx,
 	size_t bufsize;
 
 	ncp_dbg(1, "%pD2, fpos=%ld\n", file, (unsigned long)ctx->pos);
-	PPRINTK("ncp_do_readdir: init %pD, volnum=%d, dirent=%u\n",
-		file, NCP_FINFO(dir)->volNumber, NCP_FINFO(dir)->dirEntNum);
+	ncp_vdbg("init %pD, volnum=%d, dirent=%u\n",
+		 file, NCP_FINFO(dir)->volNumber, NCP_FINFO(dir)->dirEntNum);
 
 	err = ncp_initialize_search(server, dir, &seq);
 	if (err) {
@@ -804,8 +804,7 @@ int ncp_conn_logged_in(struct super_block *sb)
 			goto out;
 		result = -ENOENT;
 		if (ncp_get_volume_root(server, __name, &volNumber, &dirEntNum, &DosDirNum)) {
-			PPRINTK("ncp_conn_logged_in: %s not found\n",
-				server->m.mounted_vol);
+			ncp_vdbg("%s not found\n", server->m.mounted_vol);
 			goto out;
 		}
 		dent = sb->s_root;
@@ -842,7 +841,7 @@ static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, unsig
 	if (!ncp_conn_valid(server))
 		goto finished;
 
-	PPRINTK("ncp_lookup: server lookup for %pd2\n", dentry);
+	ncp_vdbg("server lookup for %pd2\n", dentry);
 
 	len = sizeof(__name);
 	if (ncp_is_server_root(dir)) {
@@ -858,7 +857,7 @@ static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, unsig
 		if (!res)
 			res = ncp_obtain_info(server, dir, __name, &(finfo.i));
 	}
-	PPRINTK("ncp_lookup: looked for %pd2, res=%d\n", dentry, res);
+	ncp_vdbg("looked for %pd2, res=%d\n", dentry, res);
 	/*
 	 * If we didn't find an entry, make a negative dentry.
 	 */
@@ -882,7 +881,7 @@ add_entry:
 	}
 
 finished:
-	PPRINTK("ncp_lookup: result=%d\n", error);
+	ncp_vdbg("result=%d\n", error);
 	return ERR_PTR(error);
 }
 
@@ -905,7 +904,7 @@ out:
 	return error;
 
 out_close:
-	PPRINTK("ncp_instantiate: %pd2 failed, closing file\n", dentry);
+	ncp_vdbg("%pd2 failed, closing file\n", dentry);
 	ncp_close_file(NCP_SERVER(dir), finfo->file_handle);
 	goto out;
 }
@@ -919,7 +918,7 @@ int ncp_create_new(struct inode *dir, struct dentry *dentry, umode_t mode,
 	int opmode;
 	__u8 __name[NCP_MAXPATHLEN + 1];
 	
-	PPRINTK("ncp_create_new: creating %pd2, mode=%hx\n", dentry, mode);
+	ncp_vdbg("creating %pd2, mode=%hx\n", dentry, mode);
 
 	ncp_age_dentry(server, dentry);
 	len = sizeof(__name);
@@ -1069,7 +1068,7 @@ static int ncp_unlink(struct inode *dir, struct dentry *dentry)
 	 * Check whether to close the file ...
 	 */
 	if (inode) {
-		PPRINTK("ncp_unlink: closing file\n");
+		ncp_vdbg("closing file\n");
 		ncp_make_closed(inode);
 	}
 
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 4cb02fd..77640a8 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -73,7 +73,7 @@ int ncp_make_open(struct inode *inode, int right)
 				break;
 		}
 		if (result) {
-			PPRINTK("ncp_make_open: failed, result=%d\n", result);
+			ncp_vdbg("failed, result=%d\n", result);
 			goto out_unlock;
 		}
 		/*
@@ -85,7 +85,7 @@ int ncp_make_open(struct inode *inode, int right)
 	}
 
 	access = NCP_FINFO(inode)->access;
-	PPRINTK("ncp_make_open: file open, access=%x\n", access);
+	ncp_vdbg("file open, access=%x\n", access);
 	if (access == right || access == O_RDWR) {
 		atomic_inc(&NCP_FINFO(inode)->opened);
 		error = 0;
diff --git a/fs/ncpfs/ncp_fs.h b/fs/ncpfs/ncp_fs.h
index ce5239a..f38134e 100644
--- a/fs/ncpfs/ncp_fs.h
+++ b/fs/ncpfs/ncp_fs.h
@@ -7,9 +7,14 @@
 
 #undef NCPFS_PARANOIA
 #ifdef NCPFS_PARANOIA
-#define PPRINTK(format, args...) PRINTK(format , ## args)
+#define ncp_vdbg(fmt, ...)					\
+	pr_debug(fmt, ##__VA_ARGS__)
 #else
-#define PPRINTK(format, args...)
+#define ncp_vdbg(fmt, ...)					\
+do {								\
+	if (0)							\
+		pr_debug(fmt, ##__VA_ARGS__);			\
+} while (0)
 #endif
 
 #ifndef DEBUG_NCP
diff --git a/fs/ncpfs/ncplib_kernel.c b/fs/ncpfs/ncplib_kernel.c
index 2938855..4823875 100644
--- a/fs/ncpfs/ncplib_kernel.c
+++ b/fs/ncpfs/ncplib_kernel.c
@@ -295,9 +295,9 @@ ncp_make_closed(struct inode *inode)
 		err = ncp_close_file(NCP_SERVER(inode), NCP_FINFO(inode)->file_handle);
 
 		if (!err)
-			PPRINTK("ncp_make_closed: volnum=%d, dirent=%u, error=%d\n",
-				NCP_FINFO(inode)->volNumber,
-				NCP_FINFO(inode)->dirEntNum, err);
+			ncp_vdbg("volnum=%d, dirent=%u, error=%d\n",
+				 NCP_FINFO(inode)->volNumber,
+				 NCP_FINFO(inode)->dirEntNum, err);
 	}
 	mutex_unlock(&NCP_FINFO(inode)->open_mutex);
 	return err;
diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index 3dd731b..04a69a4 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -823,7 +823,7 @@ int ncp_request2(struct ncp_server *server, int function,
 	result = reply->completion_code;
 
 	if (result != 0)
-		PPRINTK("ncp_request: completion code=%x\n", result);
+		ncp_vdbg("completion code=%x\n", result);
 out:
 	return result;
 }
-- 
1.8.1.2.459.gbcd45b4.dirty

