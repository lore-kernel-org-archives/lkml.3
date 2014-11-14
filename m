Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934981AbaKNKBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:01:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbaKNKBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:01:40 -0500
Date: Fri, 14 Nov 2014 11:01:35 +0100
From: Jan Kara <jack@suse.cz>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Eric Paris <eparis@parisplace.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ftruncate, truncate: create fanotify events
Message-ID: <20141114100135.GB17262@quack.suse.cz>
References: <20141007192330.GE30038@quack.suse.cz>
 <1414100107-3750-1-git-send-email-xypron.glpk@gmx.de>
 <20141110203029.GA8125@quack.suse.cz>
 <20141111073415.GA21776@infradead.org>
 <20141111110943.GD10456@quack.suse.cz>
 <546269AE.4050200@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546269AE.4050200@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-11-14 20:55:26, Heinrich Schuchardt wrote:
> On 11.11.2014 12:09, Jan Kara wrote:
> >On Mon 10-11-14 23:34:15, Christoph Hellwig wrote:
> >>On Mon, Nov 10, 2014 at 09:30:29PM +0100, Jan Kara wrote:
> >>>   So what I somewhat dislike about this patch is that notify_change() is
> >>>sometimes called with dentry and sometimes with path. That way it's not
> >>>completely clear when fanotify events will be generated and when not.
> 
> No. With my patch notify_change is still only called with dentry.
> It is only new function notify_change_path which will be called with a path.
> And this function will only be called from do_truncate up to now.
> 
> >>>Sadly it isn't easy to provide struct path in all the places where we are
> >>>calling notify_change() so I'm not sure what would a better solution look
> >>>like either :(
> 
> We only want to create FAN_MODIFY events for ATTR_SIZE. So only for
> these events we need a path.
> 
> To my knowledge notify_change is called with ATTR_SIZE from
> do_truncate(), ecryptfs_truncate() and will be called with ATTR_SIZE
> from ovl_setattr() for a truncation.
  There's also a call in fs/cachefiles/interface.c: cachefiles_attr_changed()
and fs/hpfs/namei.c: hpfs_unlink() and nfs plays with ATTR_SIZE although I
wasn't able to track down whether it actually passes it to notify_change().

So I agree you have covered almost all the cases. But it's just prone to
errors (as you can see when you missed some cases) because it isn't clear
to callers of notify_change() whether and why they should provide the path
via notify_change_path() or not. But see below.

> ecryptfs_dentry_to_lower_path() could be used in ecryptfs_truncate()
> to obtain a path.
> ovl_path_upper() could be used in ovl_setattr() to obtain a path.
  Agreed, this can and should be done.

> >>I suspect the right thing to do is to split out the truncate path
> >>from notify_change, as it's fairly different anyway.
> >   Yeah, that would make sense. I wanted to say it's quite a lot of work to
> >change all the filesystems (where the separation of truncate path makes
> >sense as well IMHO) but actually it's possible to just do the separation at
> >the VFS level and still call ->setattr() fs callback for now. Heinrich will
> >you look into this?
> 
> You seem to agree that struct path has to passed to do_truncate()
> and further to the notification layer.
  Yes.

> Currently do_truncate() calls notify_change() which does not accept
> a path argument.
> 
> Here the size change is implemented as an attribute change.
> Furthermore time attributes are changed.
> 
> What do you exactly mean by
> > just do the separation at the virtual file system level
> > and still call ->setattr() fs callback for now.
> 
> Do you want to duplicate the logic of notify_change() to a
> new function notify_truncate() which will at least have to handle
> ATTR_SIZE, ATTR_FORCE, ATTR_KILL_SUID, ATTR_KILL_SGID, ATTR_FILE and
> time attributes?
> 
> And from notify_truncate() call new function fsnotify_truncate()
> with a logic like fsnotify_modify() but accepting a path?
> 
> This would result in a lot of code duplication.
  Yes, I forgot about other changes coupled with truncate and you're right
that duplicating them would do more bad than good. But what we could do
is to just have __notify_change() which takes both path & dentry as you did
it. notify_change() which takes just dentry and verifies ATTR_SIZE is not
set (WARN_ON_ONCE if it is). notify_change_truncate() which takes path.
This still isn't pretty but at least makes errors harder to do.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
