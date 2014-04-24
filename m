Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbaDXWgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:36:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaDXVqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:46:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 3.14 11/33] kernfs: protect lazy kernfs_iattrs allocation with mutex
Date: Thu, 24 Apr 2014 14:48:24 -0700
Message-Id: <20140424214451.135716435@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424214449.423169713@linuxfoundation.org>
References: <20140424214449.423169713@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 4afddd60a770560d370d6f85c5aef57c16bf7502 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/kernfs/inode.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

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
@@ -65,8 +69,10 @@ static struct kernfs_iattrs *kernfs_iatt
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


