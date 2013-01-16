Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab3APQeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:34:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab3APQGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 137/222] vfs: d_obtain_alias() needs to use "/" as default name.
Date: Wed, 16 Jan 2013 13:55:37 -0200
Message-Id: <1358351822-7675-138-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit b911a6bdeef5848c468597d040e3407e0aee04ce upstream.

NFS appears to use d_obtain_alias() to create the root dentry rather than
d_make_root.  This can cause 'prepend_path()' to complain that the root
has a weird name if an NFS filesystem is lazily unmounted.  e.g.  if
"/mnt" is an NFS mount then

 { cd /mnt; umount -l /mnt ; ls -l /proc/self/cwd; }

will cause a WARN message like
   WARNING: at /home/git/linux/fs/dcache.c:2624 prepend_path+0x1d7/0x1e0()
   ...
   Root dentry has weird name <>

to appear in kernel logs.

So change d_obtain_alias() to use "/" rather than "" as the anonymous
name.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9560257..1845c46 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1580,7 +1580,7 @@ EXPORT_SYMBOL(d_find_any_alias);
  */
 struct dentry *d_obtain_alias(struct inode *inode)
 {
-	static const struct qstr anonstring = { .name = "" };
+	static const struct qstr anonstring = QSTR_INIT("/", 1);
 	struct dentry *tmp;
 	struct dentry *res;
 
-- 
1.7.9.5

