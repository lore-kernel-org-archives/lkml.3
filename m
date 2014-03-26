Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaCZFeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 01:34:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbaCZFep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 01:34:45 -0400
Date: Wed, 26 Mar 2014 06:34:40 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Sasha Levin <sasha.levin@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: fs: gpf in simple_setattr
Message-ID: <20140326053440.GB1292@quack.suse.cz>
References: <531A7CFD.9030603@oracle.com>
 <20140310104350.GB28797@quack.suse.cz>
 <531DC89A.9010601@oracle.com>
 <53304451.7030800@oracle.com>
 <20140324214851.GB10057@quack.suse.cz>
 <5330D15E.2000702@oracle.com>
 <20140325173340.GB17292@quack.suse.cz>
 <5331C20F.5010109@oracle.com>
 <20140325211229.GA27422@quack.suse.cz>
 <CA+55aFx_ejUs5Qp7_316hF_X2vyz5Csssz7zyEiHQr2TqH_vyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <CA+55aFx_ejUs5Qp7_316hF_X2vyz5Csssz7zyEiHQr2TqH_vyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 25-03-14 17:41:59, Linus Torvalds wrote:
> On Tue, Mar 25, 2014 at 2:12 PM, Jan Kara <jack@suse.cz> wrote:
> >
> >   Can you try whether the following patch fixes the issue for you?
> 
> Good catch, Honza.
> 
> I hate how fragile that code ends up being and would love to see that
> "anon_inode_inode" allocation and assignment just once in
> anon_inode_init(), but considering that it wants the superblock
> pointer, I suspect it's not cleanly doable. Oh well. Your patch looks
> like it should make the issue moot, I just dread this happening again
> due to the layout of the code.
  Well, I think it could be done relatively cleanly... How about the
attached patch (it boots for me)?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--AqsLC8rIMeq19msA
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-vfs-Allocate-anon_inode_inode-in-anon_inode_init.patch"

>From de87b1e6c3613d92f659c632be57461e87828e42 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 26 Mar 2014 06:20:14 +0100
Subject: [PATCH] vfs: Allocate anon_inode_inode in anon_inode_init()

Currently we allocated anon_inode_inode in anon_inodefs_mount. This is
somewhat fragile as if that function ever gets called again, it will
overwrite anon_inode_inode pointer. So move the initialization of
anon_inode_inode to anon_inode_init().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/anon_inodes.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 4b4543b8b894..7f34f7702204 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -41,19 +41,8 @@ static const struct dentry_operations anon_inodefs_dentry_operations = {
 static struct dentry *anon_inodefs_mount(struct file_system_type *fs_type,
 				int flags, const char *dev_name, void *data)
 {
-	struct dentry *root;
-	root = mount_pseudo(fs_type, "anon_inode:", NULL,
+	return mount_pseudo(fs_type, "anon_inode:", NULL,
 			&anon_inodefs_dentry_operations, ANON_INODE_FS_MAGIC);
-	if (!IS_ERR(root)) {
-		struct super_block *s = root->d_sb;
-		anon_inode_inode = alloc_anon_inode(s);
-		if (IS_ERR(anon_inode_inode)) {
-			dput(root);
-			deactivate_locked_super(s);
-			root = ERR_CAST(anon_inode_inode);
-		}
-	}
-	return root;
 }
 
 static struct file_system_type anon_inode_fs_type = {
@@ -180,12 +169,15 @@ static int __init anon_inode_init(void)
 	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
 	if (IS_ERR(anon_inode_mnt)) {
 		error = PTR_ERR(anon_inode_mnt);
-		goto err_unregister_filesystem;
+		goto err_exit;
+	}
+	anon_inode_inode = alloc_anon_inode(anon_inode_mnt->mnt_sb);
+	if (IS_ERR(anon_inode_inode)) {
+		error = PTR_ERR(anon_inode_inode);
+		goto err_exit;
 	}
 	return 0;
 
-err_unregister_filesystem:
-	unregister_filesystem(&anon_inode_fs_type);
 err_exit:
 	panic(KERN_ERR "anon_inode_init() failed (%d)\n", error);
 }
-- 
1.8.1.4


--AqsLC8rIMeq19msA--
