Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998AbaE3ROV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:14:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34567 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810AbaE3ROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:14:15 -0400
Date: Fri, 30 May 2014 18:14:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for
 22s! [systemd-udevd:1667]
Message-ID: <20140530171408.GT18016@ZenIV.linux.org.uk>
References: <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
 <20140529154454.GK18016@ZenIV.linux.org.uk>
 <20140529162307.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
 <20140529165351.GM18016@ZenIV.linux.org.uk>
 <20140529185201.GN18016@ZenIV.linux.org.uk>
 <20140530081238.GA1957@lahna.fi.intel.com>
 <20140530152151.GR18016@ZenIV.linux.org.uk>
 <CA+55aFxLNvBDYtiq92DvuVqUk7byWeYiL1svbNQdXg7MRtbBcQ@mail.gmail.com>
 <20140530164815.GS18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530164815.GS18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 05:48:16PM +0100, Al Viro wrote:
> On Fri, May 30, 2014 at 08:31:30AM -0700, Linus Torvalds wrote:
> > On Fri, May 30, 2014 at 8:21 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Linus, how would you prefer it to be handled?
> > 
> > I'll just have to do an rc8. I really hoped to avoid it, because we're
> > going on our family vacation when school is out in two weeks, and it
> > causes problems for the merge window, but it's not like there is much
> > choice - I can't do a 3.15 release with a known regression like that.
> 
> Sorry about that... ;-/
> 
> > So just send me the pull request, and I'll pull it. I'll probably do
> > the "let's increase the x86-64 stack size to 16kB" too, to close
> > _that_ issue as well.
> 
> OK, here it is:
> 
> Fixes for livelocks in shrink_dentry_list() introduced by fixes to shrink
> list corruption; the root cause was that trylock of parent's ->d_lock could
> be disrupted by d_walk() happening on other CPUs, resulting in
> shrink_dentry_list() making no progress *and* the same d_walk() being called
> again and again for as long as shrink_dentry_list() doesn't get past that
> mess.  Solution is to have shrink_dentry_list() treat that trylock failure not
> as "try to do the same thing again", but "lock them in the right order".
> Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus-2

*GYAH*

Shortlog and diffstat are from the local branch that has two more cleanups
on top what's been pushed to vfs.git (and what had been tested).  Ones
matching what's really in that branch are here:
Shortlog:
Al Viro (6):
      lift the "already marked killed" case into shrink_dentry_list()
      split dentry_kill()
      expand dentry_kill(dentry, 0) in shrink_dentry_list()
      shrink_dentry_list(): take parent's ->d_lock earlier
      dealing with the rest of shrink_dentry_list() livelock
      dentry_kill() doesn't need the second argument now

Diffstat:
 fs/dcache.c |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 107 insertions(+), 46 deletions(-)

My apologies - the script I'm using to generate shortlogs takes branch
name as an argument, defaulting to HEAD, which was two commits past
vfs/for-linus-2.  And no, I'm _not_ planning to push that followup stuff
until the merge window.  Just to make sure: the branch to pull should have
head at 8cbf74da435d1bd13dbb790f94c7ff67b2fb6af4 and have the same tree
as vfs.git#for-linus, which is what got testing.
