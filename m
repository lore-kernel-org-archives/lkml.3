Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaIQVBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:01:38 -0400
Received: from relay.parallels.com ([195.214.232.42]:44198 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbaIQVBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:01:36 -0400
Date: Thu, 18 Sep 2014 01:01:22 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Jan Kara <jack@suse.cz>
CC: Heinrich Schuchardt <xypron.debian@gmx.de>,
        Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "John McCutchan" <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s
Message-ID: <20140917210122.GA31893@paralelels.com>
References: <1410177716-3965-1-git-send-email-avagin@openvz.org>
 <20140909012712.GV7996@ZenIV.linux.org.uk>
 <20140909085439.GB25034@quack.suse.cz>
 <20140910094318.GA19472@paralelels.com>
 <54146D8D.9090708@gmx.de>
 <20140916211211.GG1205@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <20140916211211.GG1205@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.24.24.254]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ftEhullJWpWg/VHq
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline

On Tue, Sep 16, 2014 at 11:12:11PM +0200, Jan Kara wrote:
> On Sat 13-09-14 18:15:09, Heinrich Schuchardt wrote:
> > On Tue 09-09-14 02:27:12, Al Viro wrote:
> > http://lkml.org/lkml/2014/9/8/762
> > > I agree that it changes user-visible ABI and I agree the behavior
> > > isn't really specified in the manpage.
> > 
> > Shouldn't we start with putting the expected behavior into the
> > manpage before patching the code? I am missing a patch for
> > man7/inotify.7.
>   Good idea. Thanks for bringing this up. And ideally we should write it
> down before settling for a solution to this problem. Because when thinking
> about it again, some details of the behavior are still vague.
> 
> > On Mon, Sep 08, 2014 at 04:01:56PM +0400, Andrey Vagin wrote:
> > http://lkml.org/lkml/2014/9/8/219
> > >
> > > 	fd = inotify_init1(IN_NONBLOCK);
> > > 	deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
> > > 	link(path, path_link);
> > >
> > > 	wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);
> > >
> > > 	unlink(path);
> > > 	unlink(path_link);
> > >
> > > 	printf(" --- unlink\n");
> > > 	read_evetns(fd);
> > >
> > > 	close(deleted);
> > > 	printf(" --- close\n");
> > > 	read_evetns(fd);
> > >
> > > Without this patch:
> > >   --- unlink
> > > 4	(IN_ATTRIB)
> > > 400	(IN_DELETE_SELF)
> > > 8000	(IN_IGNORED)
> > >   --- close
> > > FAIL
> > >
> > > With this patch:
> > >   --- unlink
> > > 4	(IN_ATTRIB)
> > > 400	(IN_DELETE_SELF)
> > >   --- close
> > > 8	(IN_CLOSE_WRITE)
> > > 400	(IN_DELETE_SELF)
> > > 8000	(IN_IGNORED)
> > > PASS
> > 
> > Shouldn't the second IN_DELETE_SELF occur before
> > --- close ?
> > Why is IN_CLOSE_WRITE created?
>   So I would like events to be generated until the watched inode really
> gets deleted. This way simple (non-hardlinked) file behaves and that's what
> seems "natural". In this light generating IN_CLOSE_WRITE is what we want to
> do.
> 
> Generation of IN_DELETE_SELF is less obvious I think. Do we want to
> generate IN_DELETE_SELF for each hardlink to the inode that gets removed? I
> don't think so (this actually would be too visible user API change IMHO).
> To match the single link case I think we want to generate IN_DELETE_SELF
> when the last link to the file is removed. But then generating it twice
> like we would do with the above patch is wrong... Opinions?

I think you are right. Could you look at the attached patch? Pay your
attention to the description. This patch removes differences of
behaviours for two equivalent cases. And the resulting behavior is equal
for one of these case.

If it looks good for you, I will send this patch together with the patch
for the man page.

Thank you and Heinrich for the comments and advices.

Thanks,
Andrey
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

--ftEhullJWpWg/VHq
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: attachment;
	filename="0001-fs-don-t-remove-inotify-watchers-from-alive-inode-s-.patch"

>From c7a79bccca1aac70f5e50fb145942b932eca79ba Mon Sep 17 00:00:00 2001
From: Andrey Vagin <avagin@openvz.org>
Date: Sat, 6 Sep 2014 08:35:24 +0400
Subject: [PATCH] fs: don't remove inotify watchers from alive inode-s (v2)

Currently watchers are removed in dentry_iput(), if n_link is zero.  But
other detries can be linked with this inode.

For example if we create two hard links, open the first one and set an
inotify watcher on one of them.  Then if we remove the opened file and
then another file, the inotify watcher will be removed. But we will have
the alive file descriptor, which allows us to generate more events.

And here is another behaviour, if files are removed in another order.
The watcher will not be removed and we will keep getting inotify events
for that inode.

This patch removes difference of behaviours for these cases. Watchers
are removed, only if nlink is zero and i_dentry list is empty. The
resulting behaviour is the same with what has been described in the
second case.

Look at a following example:

	fd = inotify_init1(IN_NONBLOCK);
	deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
	link(path, path_link);

	wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);

	unlink(path);
	unlink(path_link);

	printf(" --- unlink path, path_link\n");
	read_evetns(fd);

	close(deleted);
	printf(" --- close\n");
	read_evetns(fd);
	printf(" --- end\n");

We expect to get the same set of events for this case and for the
case, when files are deleted in another order. But now we get the
different set of events.

Without this patch:
The first case, when "path" is deleted before "path_link"
 --- unlink path, path_link
4	(IN_ATTRIB)
400	(IN_DELETE_SELF)
8000	(IN_IGNORED)
 --- close
 --- end

and for the case, when "path_link" is deleted before "path"
 --- unlink path_link, path
4	(IN_ATTRIB)
 --- close
8	(IN_CLOSE_WRITE)
400	(IN_DELETE_SELF)
8000	(IN_IGNORED)
 --- end

With this patch we have the same output for both cases:
 --- unlink
4	(IN_ATTRIB)
 --- close
8	(IN_CLOSE_WRITE)
400	(IN_DELETE_SELF)
8000	(IN_IGNORED)
 --- end
PASS

v2: generate IN_DELETE_SELF when the last link to the file is removed

Cc: Jan Kara <jack@suse.cz>
Cc: Heinrich Schuchardt <xypron.debian@gmx.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/dcache.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7a5b514..3a0e3bc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -278,12 +278,15 @@ static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
+	bool last_dentry;
+
 	if (inode) {
 		dentry->d_inode = NULL;
 		hlist_del_init(&dentry->d_alias);
+		last_dentry = hlist_empty(&inode->i_dentry);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&inode->i_lock);
-		if (!inode->i_nlink)
+		if (!inode->i_nlink && last_dentry)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
 			dentry->d_op->d_iput(dentry, inode);
@@ -303,13 +306,16 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
+	bool last_dentry;
+
 	__d_clear_type(dentry);
 	dentry->d_inode = NULL;
 	hlist_del_init(&dentry->d_alias);
 	dentry_rcuwalk_barrier(dentry);
+	last_dentry = hlist_empty(&inode->i_dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
-	if (!inode->i_nlink)
+	if (!inode->i_nlink && last_dentry)
 		fsnotify_inoderemove(inode);
 	if (dentry->d_op && dentry->d_op->d_iput)
 		dentry->d_op->d_iput(dentry, inode);
-- 
1.9.3


--ftEhullJWpWg/VHq--
