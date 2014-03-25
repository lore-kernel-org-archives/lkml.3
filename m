Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaCYVMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:12:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaCYVMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:12:34 -0400
Date: Tue, 25 Mar 2014 22:12:29 +0100
From: Jan Kara <jack@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
Message-ID: <20140325211229.GA27422@quack.suse.cz>
References: <20140305124536.GA32371@quack.suse.cz>
 <53189BF8.1010308@oracle.com>
 <531A7CFD.9030603@oracle.com>
 <20140310104350.GB28797@quack.suse.cz>
 <531DC89A.9010601@oracle.com>
 <53304451.7030800@oracle.com>
 <20140324214851.GB10057@quack.suse.cz>
 <5330D15E.2000702@oracle.com>
 <20140325173340.GB17292@quack.suse.cz>
 <5331C20F.5010109@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <5331C20F.5010109@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 25-03-14 13:51:11, Sasha Levin wrote:
> On 03/25/2014 01:33 PM, Jan Kara wrote:
> >On Mon 24-03-14 20:44:14, Sasha Levin wrote:
> >>On 03/24/2014 05:48 PM, Jan Kara wrote:
> >>>>>[  339.948946] ** 4194304 ffff8805ac03ba38 [eventpoll] ffff8806ec051fe0
> >>>>>[eventpoll] ffffffff84666040 ffff88056c73e7b0           (null)
> >>>   OK, great. So finally we have something useful. We know we have problems
> >>>with [eventpoll] dentry. That is actually a special filesystem not mounted
> >>>anywhere - likely you get to that dentry through/proc/<pid>/fd/. Now
> >>>eventpoll is interesting because it uses single anon inode for all
> >>>eventpoll instances. And that inode should stay in place as long as
> >>>eventpoll filesystem exists. So it's not clear how come that inode is
> >>>freed. The basic check of handling of inode use count didn't find anything
> >>>suspicious. But I can check in more detail and if I fail, we now have a
> >>>pretty narrow area where to look...
> >>
> >>Seems like it's not specific to eventpoll, I saw the same error message with
> >>"eventfd" and "perf_event".
> >   Yup, all these use anon_inode_getfile() so it all points to the fact that
> >for some reason we freed anon_inode_inode. But I don't see where the
> >problem is. Can you maybe make 'anon_inode_inode' external to
> >fs/anon_inodes.c and dump stack for all iput() calls to anon_inode_inode?
> >There must be some suckers which don't belong there...
> 
> Okay, this is straightforward. It happened right after boot so we're lucky.
> 
> I'm also looking into that, but odds you'll spot the issue faster than me.
  Can you try whether the following patch fixes the issue for you?

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--BOKacYhQ+x31HxR3
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-fs-Avoid-userspace-mounting-anon_inodefs-filesystem.patch"

>From 08effd8156660b889af7df31c22695f1469d12ad Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Mar 2014 21:37:09 +0100
Subject: [PATCH] fs: Avoid userspace mounting anon_inodefs filesystem

anon_inodefs filesystem is a kernel internal filesystem userspace
shouldn't mess with. Remove registration of it so userspace cannot
even try to mount it (which would fail anyway because the filesystem is
MS_NOUSER).

This fixes an oops triggered by trinity when it tried mounting
anon_inodefs which overwrote anon_inode_inode pointer while other CPU
has been in anon_inode_getfile() between ihold() and d_instantiate().
Thus effectively creating dentry pointing to an inode without holding a
reference to it.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/anon_inodes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 24084732b1d0..4b4543b8b894 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -177,9 +177,6 @@ static int __init anon_inode_init(void)
 {
 	int error;
 
-	error = register_filesystem(&anon_inode_fs_type);
-	if (error)
-		goto err_exit;
 	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
 	if (IS_ERR(anon_inode_mnt)) {
 		error = PTR_ERR(anon_inode_mnt);
-- 
1.8.1.4


--BOKacYhQ+x31HxR3--
