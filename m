Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab3HMGee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:34:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab3HMGeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 11/12] vfs: d_obtain_alias() needs to use "/" as default name.
Date: Mon, 12 Aug 2013 23:35:46 -0700
Message-Id: <20130813063521.161729261@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063520.285638946@linuxfoundation.org>
References: <20130813063520.285638946@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: use named initialisers instead of QSTR_INIT()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1563,7 +1563,7 @@ static struct dentry * d_find_any_alias(
  */
 struct dentry *d_obtain_alias(struct inode *inode)
 {
-	static const struct qstr anonstring = { .name = "" };
+	static const struct qstr anonstring = { .name = "/", .len = 1 };
 	struct dentry *tmp;
 	struct dentry *res;
 


