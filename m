Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3I2SKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 14:10:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52003 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3I2SKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 14:10:49 -0400
Date: Sun, 29 Sep 2013 19:10:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [rfc][possible solution] RCU vfsmounts
Message-ID: <20130929181047.GM13318@ZenIV.linux.org.uk>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
 <CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
 <20130929060601.GL13318@ZenIV.linux.org.uk>
 <CA+55aFyGY7hZTDhWiyWBe+oSkxd2GzoYWGhvXtGTyZKL-3PZ1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyGY7hZTDhWiyWBe+oSkxd2GzoYWGhvXtGTyZKL-3PZ1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 10:19:59AM -0700, Linus Torvalds wrote:
> I have to say, that when I was working with the dcache lockref code, I
> absolutely _detested_ the magical shrink_dcache_for_umount() code that
> violated all the locking rules.

... and duplicated random-half-of-an-arseload of stuff done in other
shrinking paths.  You are not alone at that - it's been a serious
source of annoyances all along.

> So I actually wouldn't mind at all if that was all forced to follow
> all the same rules that the live filesystem code is forced to follow.
> Yes, yes, it's going to slow things down, but it's not like umount()
> is _that_ performance critical. And I think the whole "let's ignore
> locking rules" actually comes from back when we had one global
> dcache_lock: we used to have batching in order to not hold the
> dcache_lock over long periods, and then it got converted to the
> per-dentry locking, and then that got removed entirely with the whole
> RCU lookup etc.
> 
> So I would be *entirely* ok with having
> shrink_dcache_for_umount_subtree() take the d_lock on the dentry as it
> shrinks it etc etc.

I'm not even sure it will slow the things down that much these days; needs
to be tested, obviously...

FWIW, right now I'm reviewing the subset of fs code that can be hit in
RCU mode.  Not a pretty sight, that... ;-/  First catch: in
fuse_dentry_revalidate() we have a case (reachable with LOOKUP_RCU) where
we do this:
        } else if (inode) {
                fc = get_fuse_conn(inode);
                if (fc->readdirplus_auto) {
                        parent = dget_parent(entry);
                        fuse_advise_use_readdirplus(parent->d_inode);
                        dput(parent);
                }
        }
First of all, that'll lead to obvious nastiness if we get here when
->s_fs_info has already been freed in process of fs shutdown; fc will
be pointing to kfreed object and no, freeing it isn't RCU-delayed.
That's not a problem with the current tree, of course, but this
dput(parent) very much is - doing that under rcu_read_lock() is
a Bloody Bad Idea(tm).

If my reading of that code is right, the proper fix would be to
turn that else if (inode) into else if (inode && !(flags & LOOKUP_RCU))

Miklos, could you confirm that?  Or would you prefer to deal with that
in some other way?
