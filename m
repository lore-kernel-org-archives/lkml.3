Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab3IHVpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 17:45:36 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:63298 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3IHVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 17:45:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
Date: Sun, 8 Sep 2013 14:45:32 -0700
X-Google-Sender-Auth: HbuJqVgK6BEIUKNXaKlTIf24Y5U
Message-ID: <CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, this is mainly a rambling question for you, but others left on the
Cc just FYI..

On Thu, Aug 29, 2013 at 4:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I fixed the VFS layer instead. With dput() and friends using
> lockrefs, the only thing remaining in the hot RCU dentry lookup path
> was the nasty __d_rcu_to_refcount() thing in complete_walk(). I
> rewrote that to locklessly increment the refcount when it was nonzero,
> and get the lock if it was zero, and that all seems to work fine.

Today I realized that my new simplified d_rcu_to_refcount() was
fundamentally buggy in a really annoying way.

I had worried mainly about the races with the dentry being
invalidated, and how we must not touch the dentry reference count if
it might be dead, because once the dentry has been killed, it cannot
be killed again.

My lockref_get_or_lock() avoided all that by making sure that it
always got the reference on a dentry that was still live, and this
everything was fine. If it turns out that the sequence count says that
the lookup wasn't valid, we could just dput() that dentry, and
everything was fine.

And you know what? That's even true. It's true from a dentry standpoint.

But today I was - for totally unrelated reasons, just as a result of
looking at performance profiles - looking at dput(), and realized that
dput() really *can* sleep. Not for any actual dentry reasons, but
because the inode associated with the dentry is being released. And
the reason I noticed this from the performance profile was that the
dput code did

      if (dentry->d_lockref.count == 1)
            might_sleep();

where reading that lockref count showed up in the profile.

But that test never triggered any of my thinking, and it's racy
anyway, and the condition we care about is another race, which means
that it not only didn't trigger my thinking, it doesn't trigger in any
normal testing either. The fact is, dput() can always sleep,
regardless of count, because of the race (ok, the exception being that
you actually have multiple references to the same dentry _yourself_,
but who does that? Nobody).

Anyway, the reason the new d_rcu_to_refcount() is buggy isn't because
it does bad things to dentries - the dentry reference counts and
lifetimes are perfectly fine. No, the reason it does bad things is
that it does an otherwise perfectly fine dput() in a context where it
definitely is _not_ fine to sleep. We are in RCU lookup, so we are in
a RCU-locked region, we hold the percpu vfsmount_lock spinlock, and in
fact in unlazy_walk() we also potentially hold the "fs->lock"
spinlock.

Ugh, ugh, ugh.

I really like the much simplified d_rcu_to_refcount() conceptually,
though. So my current plan is to keep it, but to just delay the
"dput()" it does until after we've done the "unlock_rcu_walk()".

"complete_walk()" is actually quite simple to fix, because it does the
unlock_rcu_walk() itself - so it's fairly trivial to just move the
dput() to be after it. In preparation for this, I already ended up
committing my "dead lockref" dentry code, because that simplifies
d_rcu_to_refcount() to the degree that splitting the code up into the
callers and then moving the dput() looks like the right thing to do.

The problem I see right now is unlazy_walk(). It does *not* do the
unlock_rcu_walk() itself for the error case (and it's the error case
that needs this), but instead just returns -ECHILD and expects the
caller to do it. Even then it happens fairly obscurely in
"terminate_walk()".

So Al, any ideas? I currently have two:

 - always do that unlock_rcu_walk() in unlazy_walk(), and exit RCU
mode even for the error case (similar to how complete_walk() does it).

   That makes solving this for unlazy_walk() as straightforward as it
is for complete_walk(), and this is, I think, the right thing to do.

 - add a couple of "to be freed" dentry pointers to the 'nd' and let
terminate_walk() do the dput(). This leaves the unlazy_walk()
semantics alone.

The second one is hacky, but it doesn't change the semantics of
unlzay_walk(). I think the current semantics (drop out of RCU mode on
success, but not on failure) are nasty, but I wonder if there is some
really subtle reason for it. So the hacky second solution has got that
whole "no change to odd/subtle semantics" thing going for it..

Comments?

                 Linus
