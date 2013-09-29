Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab3I2S02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 14:26:28 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:34871 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab3I2S0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 14:26:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130929181047.GM13318@ZenIV.linux.org.uk>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
	<CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
	<20130929060601.GL13318@ZenIV.linux.org.uk>
	<CA+55aFyGY7hZTDhWiyWBe+oSkxd2GzoYWGhvXtGTyZKL-3PZ1w@mail.gmail.com>
	<20130929181047.GM13318@ZenIV.linux.org.uk>
Date: Sun, 29 Sep 2013 11:26:21 -0700
X-Google-Sender-Auth: 9qyN9Cz5YpyRk8IkszBOzNaJ2Zw
Message-ID: <CA+55aFy3if1_gP2+ck0+08CkiZyAqQNLyufJNTGu7JuckGNntQ@mail.gmail.com>
Subject: Re: [rfc][possible solution] RCU vfsmounts
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 11:10 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, right now I'm reviewing the subset of fs code that can be hit in
> RCU mode.  Not a pretty sight, that... ;-/  First catch: in
> fuse_dentry_revalidate() we have a case (reachable with LOOKUP_RCU) where
> we do this:
>         } else if (inode) {
>                 fc = get_fuse_conn(inode);
>                 if (fc->readdirplus_auto) {
>                         parent = dget_parent(entry);
>                         fuse_advise_use_readdirplus(parent->d_inode);
>                         dput(parent);
>                 }
>         }

Ugh, yes, that dget/dput(parent) looks wrong in RCU mode.

That said, in RCU mode you simply shouldn't _need_ it at all, you
should be able to just use dentry->d_parent without any refcount
games. Put an ACCESS_ONCE there to be safe. You might want to make
sure that you do the same for the inode, and check for NULL, to be
safe against racing with a cross-directory rename/rmdir. I don't know
if there are then any internal fuse races with the whole
get_fuse_conn() etc, so...

It does look bad. In practice, of course, it will never hit anything.

> If my reading of that code is right, the proper fix would be to
> turn that else if (inode) into else if (inode && !(flags & LOOKUP_RCU))

That sounds safer, but then the fuse_advise_use_readdirplus() bit
wouldn't get set. But why _is_ that bit set there in the first place?
It sounds stupid. I think the bit should be set in the lookup path (or
the revalidation slow-path when the timeout is over and the thing gets
properly revalidated), why the hell does it do it in the fast-path
revalidation in the first place? That's just odd. Maybe there is some
odd internal fuse logic.

Miklos, please do give that a look..

            Linus
