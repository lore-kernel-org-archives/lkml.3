Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030261AbaDBUk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:40:58 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:54277 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbaDBUk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:40:57 -0400
Date: Wed, 2 Apr 2014 16:40:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH driver-core-linus] kernfs: protect lazy kernfs_iattrs
 allocation with mutex
Message-ID: <20140402204052.GA18444@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_iattrs is allocated lazily when operations which require it
take place; unfortunately, the lazy allocation and returning weren't
properly synchronized and when there are multiple concurrent
operations, it might end up returning kernfs_iattrs which hasn't
finished initialization yet or different copies to different callers.

Fix it by synchronizing with a mutex.  This can be smarter with memory
barriers but let's go there if it actually turns out to be necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/g/533ABA32.9080602@oracle.com
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: stable@vger.kernel.org # 3.14
---
 fs/kernfs/inode.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index e55126f..553946c 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -48,14 +48,18 @@ void __init kernfs_inode_init(void)
 
 static struct kernfs_iattrs *kernfs_iattrs(struct kernfs_node *kn)
 {
+	static DEFINE_MUTEX(iattr_mutex);
+	struct kernfs_iattrs *ret;
 	struct iattr *iattrs;
 
+	mutex_lock(&iattr_mutex);
+
 	if (kn->iattr)
-		return kn->iattr;
+		goto out_unlock;
 
 	kn->iattr = kzalloc(sizeof(struct kernfs_iattrs), GFP_KERNEL);
 	if (!kn->iattr)
-		return NULL;
+		goto out_unlock;
 	iattrs = &kn->iattr->ia_iattr;
 
 	/* assign default attributes */
@@ -65,8 +69,10 @@ static struct kernfs_iattrs *kernfs_iattrs(struct kernfs_node *kn)
 	iattrs->ia_atime = iattrs->ia_mtime = iattrs->ia_ctime = CURRENT_TIME;
 
 	simple_xattrs_init(&kn->iattr->xattrs);
-
-	return kn->iattr;
+out_unlock:
+	ret = kn->iattr;
+	mutex_unlock(&iattr_mutex);
+	return ret;
 }
 
 static int __kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr)
