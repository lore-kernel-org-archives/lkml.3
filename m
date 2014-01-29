Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaA2NhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:37:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaA2NhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:37:17 -0500
Date: Wed, 29 Jan 2014 14:37:14 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20140129133714.GE8749@quack.suse.cz>
References: <20140127142520.GD10323@ZenIV.linux.org.uk>
 <CA+55aFyuC11WPBh0bWu_K3+CooAVAUbSTfk2aw5sks8eJRAhDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyuC11WPBh0bWu_K3+CooAVAUbSTfk2aw5sks8eJRAhDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28-01-14 19:26:08, Linus Torvalds wrote:
> On Mon, Jan 27, 2014 at 6:25 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >         Assorted stuff; the biggest pile here is Christoph's ACL series.
> > Plus assorted cleanups and fixes all over the place...  There will be
> > another pile later this week.
> 
> The posix_acl_chmod() code looks wrong.
> 
> Not that it looked right before either, but whatever. The code
> basically looks like some variation of this in most setattr()
> implementations:
> 
>         if (ia_valid & ATTR_MODE)
>                 rc = posix_acl_chmod(inode, inode->i_mode);
> 
> but the mode we're changing to (and what ATTR_MODE guards) is actually
> attr->ia_mode, not inode->i_mode.
  Yes, but posix_acl_chmod() is called after setattr_copy() was done so
inode->i_mode should be the same as attr->ia_mode. Whether i_mode or
ia_mode is mode logical depends on whether you view posix_acl_chmod() as
"sync current i_mode into acls" or "reflect this i_mode change in acls".
I agree the function name suggests more the latter semantics.

> And quite frankly, passing in inode->i_mode looks stupid, since we're
> already passing in the inode pointer, so that's just redundant and
> pointless information.
  Yes, it looks stupid. We could almost drop that argument, except that f2fs
tries to play some tricks with i_mode and stores i_mode in a different
place when acls are enabled. Huh? Jaegeuk, can you explain why are you
doing that?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
