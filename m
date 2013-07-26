Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab3GZVa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:30:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759985Ab3GZUst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 46/79] fuse: readdirplus: fix instantiate
Date: Fri, 26 Jul 2013 13:47:36 -0700
Message-Id: <20130726204727.307803796@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 2914941e3178d84a216fc4eb85292dfef3b6d628 upstream.

Fuse does instantiation slightly differently from NFS/CIFS which use
d_materialise_unique().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1264,10 +1264,19 @@ static int fuse_direntplus_link(struct f
 	if (!inode)
 		goto out;
 
-	alias = d_materialise_unique(dentry, inode);
-	err = PTR_ERR(alias);
-	if (IS_ERR(alias))
-		goto out;
+	if (S_ISDIR(inode->i_mode)) {
+		mutex_lock(&fc->inst_mutex);
+		alias = fuse_d_add_directory(dentry, inode);
+		mutex_unlock(&fc->inst_mutex);
+		err = PTR_ERR(alias);
+		if (IS_ERR(alias)) {
+			iput(inode);
+			goto out;
+		}
+	} else {
+		alias = d_splice_alias(inode, dentry);
+	}
+
 	if (alias) {
 		dput(dentry);
 		dentry = alias;


