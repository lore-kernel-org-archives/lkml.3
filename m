Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3J1FIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:08:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27393 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3J1FIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:08:50 -0400
X-AuditID: cbfee691-b7f866d000001b8c-9e-526df1601695
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: fix a deadlock during init_acl procedure
Date: Mon, 28 Oct 2013 14:08:09 +0900
Message-id: <1382936889-4911-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zY92Ej7lBBpsfm1hc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHjxVS2gr0KFTue
	zWVpYJwm1cXIySEhYCJxb/18FghbTOLCvfVsXYxcHEICyxgl5s/ZwAJTdPhRGztEYhGjxPZj
	W1khnGYmiY33NgO1cHCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwGpERZwlmhvdAGp
	YRFQlbjzYRETiM0r4CbRd2411DJtiW3PJ4L1SgjcZ5N4v+8bK0SDgMS3yYfA5kgIyEpsOsAM
	US8pcXDFDZYJjIILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoSE4MQdjPcPWB9iTAYa
	N5FZSjQ5HxjCeSXxhsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7E
	yMTBKdXAeHp9FENZvNSyHquj/MkbhOIc1/nfDv/97cJ1zWTOr5+Lm45Ou5V065zR43NX+1PC
	tmXNMHQynz3nxFoBY+ElDC+eO97ffvr9Mn6G737/7huuv3dgte1zy3ffjNcWtU8+r3hb8aWO
	3onTQWUnvz9Nvfkg9OQL7flrAy3j8vqV9v1OC2gUSYjPTVNiKc5INNRiLipOBADWrW8JVwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd2Ej7lBBt9PGFhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx48VUtoK9ChU7ns1laWCcJtXFyMkhIWAicfhRGzuELSZx4d56ti5GLg4h
	gUWMEtuPbWWFcJqZJDbe2wyU4eBgE9CW2LzfAKRBRIBZYsHU84wgNcwCExgl/i96zwJSIyzg
	LNHe6AJSwyKgKnHnwyImEJtXwE2i79xqFohl2hLbnk9knMDIvYCRYRWjaGpBckFxUnquoV5x
	Ym5xaV66XnJ+7iZGcIA/k9rBuLLB4hCjAAejEg/vhrW5QUKsiWXFlbmHGCU4mJVEePtuAYV4
	UxIrq1KL8uOLSnNSiw8xJgNtn8gsJZqcD4y+vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJ
	pCeWpGanphakFsFsYeLglGpgFJ30/1Yb38svpWrnn8/jNPh6JS35xonFGTfslaPvJieyve3t
	tD9neNf83p2H8xaIJCfcr795R04r/JBF2tQntjI9S3cycgjf379Qr8kq+4TkEp0/Sx4L/b37
	ecMRnqUr60omt6mFyZrHK3pXu8lNX3Cx5tbBcK64cP20/Akp808miZvwzDEsVmIpzkg01GIu
	Kk4EAIA3wxO0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The deadlock is found through the following scenario.

sys_mkdir()
 -> f2fs_add_link()
  -> __f2fs_add_link()
   -> init_inode_metadata()
     : lock_page(inode);
    -> f2fs_init_acl()
     -> f2fs_set_acl()
      -> f2fs_setxattr(..., NULL)
       : This NULL page incurs a deadlock at update_inode_page().

So, likewise f2fs_init_security(), this patch adds a parameter to transfer the
locked inode page to f2fs_setxattr().

Found by Linux File System Verification project (linuxtesting.org).

Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/acl.c | 15 ++++++++-------
 fs/f2fs/acl.h |  5 +++--
 fs/f2fs/dir.c |  2 +-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index f1a6975..d0fc287 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -205,7 +205,8 @@ struct posix_acl *f2fs_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static int f2fs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+static int f2fs_set_acl(struct inode *inode, int type,
+			struct posix_acl *acl, struct page *ipage)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
@@ -250,7 +251,7 @@ static int f2fs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 		}
 	}
 
-	error = f2fs_setxattr(inode, name_index, "", value, size, NULL);
+	error = f2fs_setxattr(inode, name_index, "", value, size, ipage);
 
 	kfree(value);
 	if (!error)
@@ -260,7 +261,7 @@ static int f2fs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 	return error;
 }
 
-int f2fs_init_acl(struct inode *inode, struct inode *dir)
+int f2fs_init_acl(struct inode *inode, struct inode *dir, struct page *ipage)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 	struct posix_acl *acl = NULL;
@@ -280,7 +281,7 @@ int f2fs_init_acl(struct inode *inode, struct inode *dir)
 		goto cleanup;
 
 	if (S_ISDIR(inode->i_mode)) {
-		error = f2fs_set_acl(inode, ACL_TYPE_DEFAULT, acl);
+		error = f2fs_set_acl(inode, ACL_TYPE_DEFAULT, acl, ipage);
 		if (error)
 			goto cleanup;
 	}
@@ -288,7 +289,7 @@ int f2fs_init_acl(struct inode *inode, struct inode *dir)
 	if (error < 0)
 		return error;
 	if (error > 0)
-		error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl);
+		error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl, ipage);
 cleanup:
 	posix_acl_release(acl);
 	return error;
@@ -314,7 +315,7 @@ int f2fs_acl_chmod(struct inode *inode)
 	if (error)
 		return error;
 
-	error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl);
+	error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl, NULL);
 	posix_acl_release(acl);
 	return error;
 }
@@ -389,7 +390,7 @@ static int f2fs_xattr_set_acl(struct dentry *dentry, const char *name,
 		acl = NULL;
 	}
 
-	error = f2fs_set_acl(inode, type, acl);
+	error = f2fs_set_acl(inode, type, acl, NULL);
 
 release_and_out:
 	posix_acl_release(acl);
diff --git a/fs/f2fs/acl.h b/fs/f2fs/acl.h
index 3839048..4963313 100644
--- a/fs/f2fs/acl.h
+++ b/fs/f2fs/acl.h
@@ -38,7 +38,7 @@ struct f2fs_acl_header {
 
 extern struct posix_acl *f2fs_get_acl(struct inode *, int);
 extern int f2fs_acl_chmod(struct inode *);
-extern int f2fs_init_acl(struct inode *, struct inode *);
+extern int f2fs_init_acl(struct inode *, struct inode *, struct page *);
 #else
 #define f2fs_check_acl	NULL
 #define f2fs_get_acl	NULL
@@ -49,7 +49,8 @@ static inline int f2fs_acl_chmod(struct inode *inode)
 	return 0;
 }
 
-static inline int f2fs_init_acl(struct inode *inode, struct inode *dir)
+static inline int f2fs_init_acl(struct inode *inode, struct inode *dir,
+							struct page *page)
 {
 	return 0;
 }
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 384c6da..c9d53fc 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -346,7 +346,7 @@ static struct page *init_inode_metadata(struct inode *inode,
 				goto error;
 		}
 
-		err = f2fs_init_acl(inode, dir);
+		err = f2fs_init_acl(inode, dir, page);
 		if (err)
 			goto error;
 
-- 
1.8.4.474.g128a96c

