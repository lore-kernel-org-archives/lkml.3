Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaDRJtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:49:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45879 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 10/72] NFSv3: Fix return value of nfs3_proc_setacls
Date: Fri, 18 Apr 2014 11:21:43 +0200
Message-Id: <173d76aa5fd78eebd9893e201879d3a2df600c4c.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8f493b9cfcd8941c6b27d6ce8e3b4a78c094b3c1 upstream.

nfs3_proc_setacls is used internally by the NFSv3 create operations
to set the acl after the file has been created. If the operation
fails because the server doesn't support acls, then it must return '0',
not -EOPNOTSUPP.

Reported-by: Russell King <linux@arm.linux.org.uk>
Link: http://lkml.kernel.org/r/20140201010328.GI15937@n2100.arm.linux.org.uk
Cc: Christoph Hellwig <hch@lst.de>
Tested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs3acl.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index 4a1aafba6a20..4612291e7cc0 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -289,8 +289,8 @@ getout:
 	return acl;
 }
 
-static int nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
-		  struct posix_acl *dfacl)
+static int __nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
+			       struct posix_acl *dfacl)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs_fattr *fattr;
@@ -373,6 +373,15 @@ out:
 	return status;
 }
 
+int nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
+		struct posix_acl *dfacl)
+{
+	int ret;
+	ret = __nfs3_proc_setacls(inode, acl, dfacl);
+	return (ret == -EOPNOTSUPP) ? 0 : ret;
+
+}
+
 int nfs3_proc_setacl(struct inode *inode, int type, struct posix_acl *acl)
 {
 	struct posix_acl *alloc = NULL, *dfacl = NULL;
@@ -406,7 +415,7 @@ int nfs3_proc_setacl(struct inode *inode, int type, struct posix_acl *acl)
 		if (IS_ERR(alloc))
 			goto fail;
 	}
-	status = nfs3_proc_setacls(inode, acl, dfacl);
+	status = __nfs3_proc_setacls(inode, acl, dfacl);
 	posix_acl_release(alloc);
 	return status;
 
-- 
1.9.2

