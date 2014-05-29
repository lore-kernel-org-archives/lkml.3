Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbaE2MHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:07:41 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40929 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbaE2MHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:07:40 -0400
Date: Thu, 29 May 2014 14:07:34 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@gmail.com, hooanon05@yahoo.co.jp,
        mszeredi@suse.cz
Subject: Re: Kernel errors with overlay filesystem v22
Message-ID: <20140529120734.GM17233@tucsk.piliscsaba.szeredi.hu>
References: <27993.1401360881@warthog.procyon.org.uk>
 <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
 <28313.1401362925@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28313.1401362925@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:28:45PM +0100, David Howells wrote:
> 
> This sequence of commands produces both errors:
> 
>  mount -t tmpfs lower_layer /lower
>  mount -t tmpfs upper_layer /upper
>  mkdir /upper/upper
>  mkdir /upper/work
>  mount -t overlayfs overlayfs /mnt -olowerdir=/lower,upperdir=/upper/upper,workdir=/upper/work
>  # The lockdep error was reported in the above mount command

The lockdep error is due to lazyness on my part and trying to hold
mnt_want_write() on upper for the lifetime of the overlay.  That doesn't work
well with the freeze protection part (sb_start_write()) because then upper can't
be frozen while the overlay is mounted, which is not what we want, I think.

So I'll just have to bite the bullet and add those mnt_want_write/mnt_end_write
to those vfs_* calls that need it.

>  umount /mnt
>  umount /upper
>  # The dentry leak error was reported in the last umount command

Okay, this was just sloppy testing of the workdir thing that was added to this
version.  Below patch fixes it.

Thanks,
Miklos


diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 04879abbbf98..3e2cbbce69e1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -381,6 +381,7 @@ static void ovl_put_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		mnt_drop_write(ufs->upper_mnt);
 
+	dput(ufs->workdir);
 	mntput(ufs->upper_mnt);
 	mntput(ufs->lower_mnt);
 
@@ -706,7 +707,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	mntput(upperpath.mnt);
 	mntput(lowerpath.mnt);
-	mntput(workpath.mnt);
+	path_put(&workpath);
 
 	oe->__upperdentry = dget(upperpath.dentry);
 	oe->lowerdentry = lowerpath.dentry;
