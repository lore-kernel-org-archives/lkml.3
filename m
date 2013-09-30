Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3I3KsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:48:19 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39602 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3I3KsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:48:14 -0400
Date: Mon, 30 Sep 2013 12:48:54 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][possible solution] RCU vfsmounts
Message-ID: <20130930104854.GC17299@tucsk.piliscsaba.szeredi.hu>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
 <CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
 <20130929060601.GL13318@ZenIV.linux.org.uk>
 <CA+55aFyGY7hZTDhWiyWBe+oSkxd2GzoYWGhvXtGTyZKL-3PZ1w@mail.gmail.com>
 <20130929181047.GM13318@ZenIV.linux.org.uk>
 <CA+55aFy3if1_gP2+ck0+08CkiZyAqQNLyufJNTGu7JuckGNntQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy3if1_gP2+ck0+08CkiZyAqQNLyufJNTGu7JuckGNntQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 11:26:21AM -0700, Linus Torvalds wrote:

> > If my reading of that code is right, the proper fix would be to
> > turn that else if (inode) into else if (inode && !(flags & LOOKUP_RCU))
> 
> That sounds safer, but then the fuse_advise_use_readdirplus() bit
> wouldn't get set. But why _is_ that bit set there in the first place?
> It sounds stupid. I think the bit should be set in the lookup path (or
> the revalidation slow-path when the timeout is over and the thing gets
> properly revalidated), why the hell does it do it in the fast-path
> revalidation in the first place? That's just odd. Maybe there is some
> odd internal fuse logic.

The logic advises future use of READDIRPLUS on either

 - lookup slowpath (READDIR used, but READDIRPLUS may have been useful)
 - revalidate fastpath (READDIRPLUS used and was found to be useful)

Revalidate slowpath possibly means we have the icache primed by READDIRPLUS, but
something went wrong and the lookup needed to be redone.  Advising use of
READDIRPLUS does not make much sense in that case, since the result of the
"PLUS" part wasn't actually used.

But...  this will always slow down the lookup, even if revalidating something
that was not recently read with READDIRPLUS.  How about something like this:
when setting up inodes with READDIRPLUS set a flag FUSE_I_INIT_RDPLUS.  On
revalidate only advise readdirplus on parent if this flag is set (and clear it
once used).  I think it would be okay to dereference d_parent and even
d_parent->d_inode in rcu mode.  But, to be safe, just drop out of rcu mode
instead in this case, since it won't be the common cached case.

The patch also fixes the invalid path to not call check_submounts_and_drop() in
rcu mode, which is definitely not safe to do.

Untested...

Thanks,
Miklos


----
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 62b43b5..a751598 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -182,6 +182,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	struct inode *inode;
 	struct dentry *parent;
 	struct fuse_conn *fc;
+	struct fuse_inode *fi;
 	int ret;
 
 	inode = ACCESS_ONCE(entry->d_inode);
@@ -228,7 +229,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 		if (!err && !outarg.nodeid)
 			err = -ENOENT;
 		if (!err) {
-			struct fuse_inode *fi = get_fuse_inode(inode);
+			fi = get_fuse_inode(inode);
 			if (outarg.nodeid != get_node_id(inode)) {
 				fuse_queue_forget(fc, forget, outarg.nodeid, 1);
 				goto invalid;
@@ -246,8 +247,11 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 				       attr_version);
 		fuse_change_entry_timeout(entry, &outarg);
 	} else if (inode) {
-		fc = get_fuse_conn(inode);
-		if (fc->readdirplus_auto) {
+		fi = get_fuse_inode(inode);
+		if (flags & LOOKUP_RCU) {
+			if (test_bit(FUSE_I_INIT_RDPLUS, &fi->state))
+				return -ECHILD;
+		} else if (test_and_clear_bit(FUSE_I_INIT_RDPLUS, &fi->state)) {
 			parent = dget_parent(entry);
 			fuse_advise_use_readdirplus(parent->d_inode);
 			dput(parent);
@@ -259,7 +263,8 @@ out:
 
 invalid:
 	ret = 0;
-	if (check_submounts_and_drop(entry) != 0)
+
+	if (!(flags & LOOKUP_RCU) && check_submounts_and_drop(entry) != 0)
 		ret = 1;
 	goto out;
 }
@@ -1291,6 +1296,8 @@ static int fuse_direntplus_link(struct file *file,
 	}
 
 found:
+	if (fc->readdirplus_auto)
+		set_bit(FUSE_I_INIT_RDPLUS, &get_fuse_inode(inode)->state);
 	fuse_change_entry_timeout(dentry, o);
 
 	err = 0;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 5ced199..5b9e6f3 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -115,6 +115,8 @@ struct fuse_inode {
 enum {
 	/** Advise readdirplus  */
 	FUSE_I_ADVISE_RDPLUS,
+	/** Initialized with readdirplus */
+	FUSE_I_INIT_RDPLUS,
 	/** An operation changing file size is in progress  */
 	FUSE_I_SIZE_UNSTABLE,
 };

