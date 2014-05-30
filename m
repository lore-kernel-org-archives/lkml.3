Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaE3EvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:51:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60196 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbaE3EvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:51:03 -0400
Date: Fri, 30 May 2014 05:50:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140530045059.GP18016@ZenIV.linux.org.uk>
References: <20140529105107.GB1938@lahna.fi.intel.com>
 <20140529110439.GA2006@lahna.fi.intel.com>
 <20140529133036.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
 <20140529154454.GK18016@ZenIV.linux.org.uk>
 <20140529162307.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
 <20140529165351.GM18016@ZenIV.linux.org.uk>
 <20140529185201.GN18016@ZenIV.linux.org.uk>
 <CA+55aFwNv2-9=uXxzYH9UpN_x209Cv_BBu-9j2prSh2xVmmsAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwNv2-9=uXxzYH9UpN_x209Cv_BBu-9j2prSh2xVmmsAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:14:51PM -0700, Linus Torvalds wrote:
> Yeah, I don't think you can reproduce that, but I guess renaming
> directories into each other (two renames needed) could trigger an ABBA
> deadlock by changing the topological order of dentry/parent.
> 
> I suspect there's no way in hell that tiny race will ever happen in
> practice, but let's not risk it.
> 
> And your solution (to re-check after just taking the parent lock)
> seems sufficient and sane, since dentry_lock_for_move() will always
> take the parent lock(s) before we move a dentry.
> 
> So that looks good to me.

BTW, how serious is the problem with __lockref_is_dead(&dentry->d_lockref)
with only ->d_parent->d_lock held?  From my reading of lib/lockref.c it
should be safe - we only do lockref_mark_dead() with ->d_parent->d_lock
held, and it'll provide all the serialization and barriers we need.

If I'm right, we could get rid of DCACHE_DENTRY_KILLED completely and replace
checking for it with checking for negative ->d_lockref.count.  There are two
places where we check for it; in shrink_dentry_list() we definitely can go
that way (we are holding ->d_lock there) and it simplifies the code nicely.
In d_walk(), though (in the bit that used to be try_to_ascend() we only hold
->d_parent->d_lock.  It looks like that ought to be safe to replace
                if (this_parent != child->d_parent ||  
                         (child->d_flags & DCACHE_DENTRY_KILLED) ||
                         need_seqretry(&rename_lock, seq)) {
with
                if (this_parent != child->d_parent ||  
                         __lockref_is_dead(&child->d_lockref) ||
                         need_seqretry(&rename_lock, seq)) {
and remove DCACHE_DENTRY_KILLED completely...

The other user (in shrink_dentry_list()) simplifies to
                if (dentry->d_lockref.count != 0) {
                        bool can_free = dentry->d_flags & DCACHE_MAY_FREE;
                        spin_unlock(&dentry->d_lock);
                        if (parent)
                                spin_unlock(&parent->d_lock);
                        if (can_free)
                                dentry_free(dentry);
                        continue;
                }
taking care of both the DCACHE_DENTRY_KILLED case and simple "lazy dget"
one, and that one's definitely safe and worth doing.

Would be nice if we could switch d_walk() one as well and kill that flag off,
though...

Basically, we have
spin_lock(&A);
spin_lock(&R.lock);
V = 1;
lockref_mark_dead(&R);
...
as the only place where R goes dead and we want to replace
spin_lock(&A);
if (V)
	...
with
spin_lock(&A);
if (__lockref_is_dead(&R))
	...
Unless I'm missing something subtle in lockref.c, that should be safe...
Comments?
