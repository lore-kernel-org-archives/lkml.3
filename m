Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab3KHVgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 16:36:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36283 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab3KHVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 16:36:02 -0500
Date: Fri, 8 Nov 2013 21:35:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthias Schniedermeyer <ms@citd.de>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [REVIEW][PATCH 1/4] vfs: Don't allow overwriting mounts in the
 current mount namespace
Message-ID: <20131108213551.GR13318@ZenIV.linux.org.uk>
References: <87li23trll.fsf@tw-ebiederman.twitter.com>
 <CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
 <87vc15mjuw.fsf@xmission.com>
 <CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
 <87iox38fkv.fsf@xmission.com>
 <87d2nb8dxy.fsf@xmission.com>
 <87iowyxpci.fsf_-_@xmission.com>
 <87d2n6xpan.fsf_-_@xmission.com>
 <20131103035406.GA8537@ZenIV.linux.org.uk>
 <87bo1u8vmf.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo1u8vmf.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:51:52PM -0800, Eric W. Biederman wrote:

> The return value of d_mountpoint can be obsolete as soon as it returns
> as well, so I don't see this as being significantly different.

Not if the ->i_mutex of that sucker is held.  And it *is* held in
vfs_unlink/vfs_rmdir/vfs_rename.  Note that we only care about a mountpoint
being falsely assumed to be a non-mountpoint - in the other direction we
can just shrug and say that we'd won the race and got EBUSY for that.

> In 3.12 vfs_rmdir checks d_mountpoint with the
> dentry->d_inode->i_mutex and
> dentry->d_parent->d_inode->i_mutex held.
> 
> In 3.12 vfs_unlink checks d_mountpoint with the
> dentry->d_inode->i_mutex and
> dentry->d_parent->d_inode->i_mutex hel.d
> 
> In 3.12 vfs_rename_dir and vfs_rename_other checks d_mountpint with the
> target->i_mutex, new_dir->i_mutex, and old_dir->i_mutex held.
> 
> 
> Therefore the guarantees in 3.12 are:
> - unlink versus mount races are prevented by the
>   dentry->d_inode->i_mutex of the dentry being removed.
> - unlink versus umount races are uninteresting.
> - mount versus rename races in testing of d_mountpoint are ignored.

Read what you've written a few lines above.  The part about target->i_mutex
being held.

> So comparing this to how I have implemented covered the test is at a
> slightly different location in the call path so there may be a slightly
> larger race in rename.

You've got a race in unlink.  You've got a race in rename.  You've got a race
in rmdir.  And none of those had that race in 3.12 (including rename()).

BTW, could you describe the races with umount in a bit more details?  Races
with mount are simple - rmdir() sees that victim isn't a mountpoint and
proceeds, mount() sees that victim is still alive and proceeds, despite
the fact that victim is irretrievably on the way to removal.  And that's
what ->i_mutex on victim prevents, making "check for d_mountpoint / remove /
call dont_mount()" atomic wrt mount().  What is the problem you are seeing
with umount()?  rmdir() getting EBUSY because it hasn't noticed umount()
happening in parallel with it?  Legitimate behaviour, as far I can see...
Or is it about something different?
