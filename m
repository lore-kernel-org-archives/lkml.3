Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3IIFoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:44:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49594 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3IIFoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:44:23 -0400
Date: Mon, 9 Sep 2013 06:44:05 +0100
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
Message-ID: <20130909054405.GM13318@ZenIV.linux.org.uk>
References: <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
 <1377751465.4028.20.camel@pasglop>
 <20130829070012.GC27322@gmail.com>
 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
 <CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
 <20130909000300.GH13318@ZenIV.linux.org.uk>
 <CA+55aFyFt+8DY3Umw_YjytdUC8AVoPOWLFdvDP2EWVHue9Mi9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyFt+8DY3Umw_YjytdUC8AVoPOWLFdvDP2EWVHue9Mi9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 08:32:03PM -0700, Linus Torvalds wrote:
> On Sun, Sep 8, 2013 at 5:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > There's one exception - basically, we decide to put duplicates of
> > reference(s) we hold into (a bunch of) structures being created.  If
> > we decide that we'd failed and need to roll back, the structures
> > need to be taken out of whatever lists, etc. they'd been already
> > put on and references held in them - dropped.  That removal gets done
> > under a spinlock.  Sure, we can string those structures on some kind
> > of temp list, drop the spinlock and do dput() on everything in there,
> > but it's much more convenient to just free them as we are evicting
> > them, doing dput() as we go.  Which is safe, since we are still have
> > the references used to create these buggers pinned down.
> 
> Hmm. Which codepath does this? Because I got curious and added back
> the __might_sleep() unconditionally to dput() just to see (now that I
> think that the dput() bugs are gone), and at least under normal load
> it doesn't trigger. I even wrote a thing that just constantly creates
> and renames the target file concurrently with looking it up, so that
> I've stress-tested the RCU sequence number failure path (and verified
> with a profile that yes, it does trigger the "oops, need to retry"
> case). I didn't test anything odd at all (just my dentry stress tests
> and a regular graphical desktop), though.

Not sure if we have anything of that sort in the current tree; I remember
that kind of stuff in shared subtree code (basically, if we decided that
operation should fail halfway through the process, we could just evict
all created vfsmounts from the lists and mntput them, spinlocks or no
spinlocks - they all had been copied from existing ones protected by
the system-wide serialization on namespace modifications, so resulting
dput() calls wouldn't have d_count on anything reach zero).  But I'm not
sure if it had been about vfsmount_lock or namespace_sem (we really don't
want any IO under the latter, since one stuck fs can make _any_ umount
impossible afterwards) and all remnants of that got killed off by
reorganizations of locking in there - all pending dput()/mntput() calls are
delayed until namespace_unlock() now.

Anyway, that wouldn't break even now - I'm not saying that it's a good
pattern to use, but it's legitimate.  If you are holding a reference
already, something like
	p = alloc_foo();
	spin_lock(&lock);
	...
	p->dentry = dget(dentry);
	...
	if (error) {
		...
		free_foo(p);
		...
		spin_unlock(&lock);
	}
with free_foo(p) including dput(p->dentry) is safe.  The whole thing was just
a comment on your "who does that? Nobody" - that kind of stuff has uses and
it did happen at least once.  And yes, it is safe *and* anybody writing
anything of that sort needs to look hard if it can be reorganized into
something less subtle...

> And I have too much memory to sanely stress any out-of-memory situations.

KVM image with -m <size> or mem=<size> in kernel command line ;-)
