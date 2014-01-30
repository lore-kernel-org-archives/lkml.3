Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaA3P0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:26:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbaA3P0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:26:39 -0500
Date: Thu, 30 Jan 2014 16:26:36 +0100
From: Jan Kara <jack@suse.cz>
To: Kim Jaegeuk <jaegeuk.kim@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20140130152636.GB12687@quack.suse.cz>
References: <20140127142520.GD10323@ZenIV.linux.org.uk>
 <CA+55aFyuC11WPBh0bWu_K3+CooAVAUbSTfk2aw5sks8eJRAhDQ@mail.gmail.com>
 <20140129133714.GE8749@quack.suse.cz>
 <CAOtxgyd_T8eXpQ89KhMCLRhy6ebO55dXscVikhuX2a9HCdGTQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtxgyd_T8eXpQ89KhMCLRhy6ebO55dXscVikhuX2a9HCdGTQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-01-14 11:02:49, Kim Jaegeuk wrote:
> 2014-01-29 Jan Kara <jack@suse.cz>:
> > On Tue 28-01-14 19:26:08, Linus Torvalds wrote:
> >> On Mon, Jan 27, 2014 at 6:25 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> >         Assorted stuff; the biggest pile here is Christoph's ACL series.
> >> > Plus assorted cleanups and fixes all over the place...  There will be
> >> > another pile later this week.
> >>
> >> The posix_acl_chmod() code looks wrong.
> >>
> >> Not that it looked right before either, but whatever. The code
> >> basically looks like some variation of this in most setattr()
> >> implementations:
> >>
> >>         if (ia_valid & ATTR_MODE)
> >>                 rc = posix_acl_chmod(inode, inode->i_mode);
> >>
> >> but the mode we're changing to (and what ATTR_MODE guards) is actually
> >> attr->ia_mode, not inode->i_mode.
> >   Yes, but posix_acl_chmod() is called after setattr_copy() was done so
> > inode->i_mode should be the same as attr->ia_mode. Whether i_mode or
> > ia_mode is mode logical depends on whether you view posix_acl_chmod() as
> > "sync current i_mode into acls" or "reflect this i_mode change in acls".
> > I agree the function name suggests more the latter semantics.
> >
> >> And quite frankly, passing in inode->i_mode looks stupid, since we're
> >> already passing in the inode pointer, so that's just redundant and
> >> pointless information.
> >   Yes, it looks stupid. We could almost drop that argument, except that f2fs
> > tries to play some tricks with i_mode and stores i_mode in a different
> > place when acls are enabled. Huh? Jaegeuk, can you explain why are you
> > doing that?
> 
> As described to Christoph before, the reason is for acl consistency
> between on-disk xattr->mode and on-disk inode->mode.
> 
> Previously, there are three i_modes managed by:
>                        inode->mode   on-disk xattr->mode  on-disk->i_mode
> f2fs_setattr            [x]                       y                       y
> [update_inode]       x                        y                      [x]
> [checkpoint]            x                       [y]                      x
> __f2fs_setxattr        x                       [x]                      x
> 
> In this flow, f2fs is able to break the consistency between on-disk
> xattr->mode and on-disk->i_mode after checkpoint followed by
> sudden-power-off.
> 
> So, fi->i_mode was introduced to address the problem.
> The new f2fs_setattr triggers:
>                 inode->mode   fi->i_mode  on-disk xattr->mode  on-disk->i_mode
> f2fs_setattr             y                [x]                     y
>                       y
> [update_inode]       y                 x                      y
>                   y
> [checkpoint]            y                 x                      y
>                      y
> __f2fs_setxattr       [x]                x                     [x]
>                    [x]
> 
> Finally, __f2fs_setxattr synchronizes inode->mode, on-disk xattr->mode,
> and on-disk inode->i_mode all together.
> 
> Am I missing something?
  OK, I see. Thanks for explanation.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
