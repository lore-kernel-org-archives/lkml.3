Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab3IIADV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 20:03:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49060 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3IIADT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 20:03:19 -0400
Date: Mon, 9 Sep 2013 01:03:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130909000300.GH13318@ZenIV.linux.org.uk>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
 <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
 <1377751465.4028.20.camel@pasglop>
 <20130829070012.GC27322@gmail.com>
 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
 <CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 02:45:32PM -0700, Linus Torvalds wrote:

> But that test never triggered any of my thinking, and it's racy
> anyway, and the condition we care about is another race, which means
> that it not only didn't trigger my thinking, it doesn't trigger in any
> normal testing either. The fact is, dput() can always sleep,
> regardless of count, because of the race (ok, the exception being that
> you actually have multiple references to the same dentry _yourself_,
> but who does that? Nobody).

There's one exception - basically, we decide to put duplicates of
reference(s) we hold into (a bunch of) structures being created.  If
we decide that we'd failed and need to roll back, the structures
need to be taken out of whatever lists, etc. they'd been already
put on and references held in them - dropped.  That removal gets done
under a spinlock.  Sure, we can string those structures on some kind
of temp list, drop the spinlock and do dput() on everything in there,
but it's much more convenient to just free them as we are evicting
them, doing dput() as we go.  Which is safe, since we are still have
the references used to create these buggers pinned down.

> Anyway, the reason the new d_rcu_to_refcount() is buggy isn't because
> it does bad things to dentries - the dentry reference counts and
> lifetimes are perfectly fine. No, the reason it does bad things is
> that it does an otherwise perfectly fine dput() in a context where it
> definitely is _not_ fine to sleep. We are in RCU lookup, so we are in
> a RCU-locked region, we hold the percpu vfsmount_lock spinlock, and in
> fact in unlazy_walk() we also potentially hold the "fs->lock"
> spinlock.
> 
> Ugh, ugh, ugh.
> 
> I really like the much simplified d_rcu_to_refcount() conceptually,
> though. So my current plan is to keep it, but to just delay the
> "dput()" it does until after we've done the "unlock_rcu_walk()".

> "complete_walk()" is actually quite simple to fix, because it does the
> unlock_rcu_walk() itself - so it's fairly trivial to just move the
> dput() to be after it. In preparation for this, I already ended up
> committing my "dead lockref" dentry code, because that simplifies
> d_rcu_to_refcount() to the degree that splitting the code up into the
> callers and then moving the dput() looks like the right thing to do.
> 
> The problem I see right now is unlazy_walk(). It does *not* do the
> unlock_rcu_walk() itself for the error case (and it's the error case
> that needs this), but instead just returns -ECHILD and expects the
> caller to do it. Even then it happens fairly obscurely in
> "terminate_walk()".
> 
> So Al, any ideas? I currently have two:
> 
>  - always do that unlock_rcu_walk() in unlazy_walk(), and exit RCU
> mode even for the error case (similar to how complete_walk() does it).
> 
>    That makes solving this for unlazy_walk() as straightforward as it
> is for complete_walk(), and this is, I think, the right thing to do.
> 
>  - add a couple of "to be freed" dentry pointers to the 'nd' and let
> terminate_walk() do the dput(). This leaves the unlazy_walk()
> semantics alone.
> 
> The second one is hacky, but it doesn't change the semantics of
> unlzay_walk(). I think the current semantics (drop out of RCU mode on
> success, but not on failure) are nasty, but I wonder if there is some
> really subtle reason for it. So the hacky second solution has got that
> whole "no change to odd/subtle semantics" thing going for it..

Well...  unlazy_walk() is always followed by terminate_walk() very shortly,
but there's a minor problem - terminate_walk() uses "are we in RCU
mode?" for two things:
	a) do we need to do path_put() here?
	b) do we need to unlock?
If you introduce the third case ("no need to do unlock and no need to
do path_put()"), we'd better decide how to check for that case...

I suspect that minimal variant would be along the lines of
	* have unlazy_walk() slap NULL into ->path.mnt on error, clear
LOOKUP_RCU and unlock
	* have terminate_walk() check ->path.mnt before doing path_put()
in !RCU case
	* in do_last() replace bool got_write with struct vfsmount *got_write,
storing the reference to vfsmount we'd fed to mnt_want_write().
And use its value when we call mnt_put_write() in there...

I'll put together a commit like that on top of what I was going to push
into public queues tonight; give me about half an hour, OK?
