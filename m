Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaKKJFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:05:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaKKJFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:05:08 -0500
Date: Tue, 11 Nov 2014 10:05:05 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141111090505.GA20424@suse.cz>
References: <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107074745.GC22703@infradead.org>
 <20141107131153.GD4071@treble.redhat.com>
 <20141107140458.GA21774@suse.cz>
 <20141107154500.GF4071@treble.redhat.com>
 <20141107212735.GA21409@suse.cz>
 <20141108034553.GA11663@treble.redhat.com>
 <20141108080754.GA28969@suse.cz>
 <20141110170903.GA11119@treble.hsd1.ky.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110170903.GA11119@treble.hsd1.ky.comcast.net>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:09:03AM -0600, Josh Poimboeuf wrote:

> > In fact LEAVE_KERNEL can be approximated by extending the patched
> > set as required to include functions which are not changed per se, but
> > are "contaminated" by propagation of semantic changes in the calling
> > convention, and/or data format.
> > 
> > This applies to cases like this (needs LEAVE_KERNEL or extending patched
> > set beyond changed functions):
> > 
> > -----------------------------------------------------------
> > 
> > 	int bar() {
> > 		[...]
> > -		return x;
> > +		return x + 1;
> > 	}
> > 
> > 	foo() {
> > 		int ret = bar();
> > 		do {
> > 			wait_interruptible();
> > 		} while (ret == bar());
> > 	}
> > 
> > -----------------------------------------------------------
> 
> Agreed.  Though I think this is quite rare anyway.  Do you know of any
> real world examples of this pattern in the kernel?

No, I do not. All of the examples I presented are entirely synthetic
corner cases designed to show the weaknesses of the various models.

> > Or like this (needs SWITCH_KERNEL so won't work with kGraft, but also
> > extending patched set, will not work with kpatch as it stands today):
> > 
> > -----------------------------------------------------------
> > 
> > 	void lock_a()
> > 	{
> > -		spin_lock(&x);
> > +		spin_lock(&y);
> > 	}
> > 	void lock_b()
> > 	{
> > -		spin_lock(&y);
> > +		spin_lock(&x);
> > 	}
> > 	void unlock_a()
> > 	}
> > -		spin_unlock(&x);
> > +		spin_unlock(&y);
> > 	}
> > 	void unlock_b()
> > 	{
> > -		spin_unlock(&y);
> > +		spin_unlock(&x);
> > 	}
> > 
> > 	void foo()
> > 	{
> > 		lock_a();
> > 		lock_b();
> > 		[...]
> > 		unlock_b();
> > 		unlock_a();
> > 	}
> > -----------------------------------------------------------
> 
> Another way to handle this type of locking semantic change for either
> kpatch or kGraft is to use shadow data to add a "v2" shadow field to the
> lock's containing struct, which is set whenever the struct is allocated
> in the new universe.  Then you can use that field to determine which
> version of locking semantics to use.

Agreed, this way of handling the locking changes makes the locking
changes viable even for the SWITCH_THREAD case then.

And if you'd want to convert existing structs, then you also need to
make the shadow operations atomic, but that's possible.

Also, if the lock is not a member of any struct, you'd have to shadow
the lock itself, again, possible.

> > I believe we have to get incremental patching working anyway as it is a
> > valid usecase for many users, just not for major distributions.
> 
> Well, we do already have it "working", but it's not safe enough for
> serious use because we aren't properly dealing with build and runtime
> dependencies between patch modules.  It may be tricky to get right.

Similar for kGraft, incremental also works, and kGraft doesn't have an
issue with build time dependencies for obvious reasons. At runtime it
gets tricky, particularly if you start removing some of the patches.

> But yeah, if you're _very_ careful to analyze any dependencies between
> the patches, an occasional incremental patch might be do-able.

I don't have an issue with not offering incremental patching initially,
as we currently do not have a practical use for it.

> > And we may want to take a look at how to mark parts of a cumulative
> > patch with different consistency models, when we combine eg. the recent
> > futex CVE patch (not working with SWITCH_KERNEL) and anything requiring
> > SWITCH kernel.
> 
> Yeah, interesting idea.  But again I think we'd still need to be very
> careful with the dependencies.

Yes.

> > Now we stop_kernel on baz(). We don't check the stack. We patch bar().
> > We resume, and baz() happily returns into bar(), executing old code.
> > At the same time, another CPU can call bar(), getting new code.
> > 
> > Stack checking at stop_kernel() time is required to keep the
> > SWITCH_KERNEL part of the model.
> 
> Ok, I think I get what you're saying.  In my mind it's kind of a hybrid
> of SWITCH_KERNEL and SWITCH_FUNCTION, since SWITCH_KERNEL would still be
> used for other functions in the patch.  In that case we'd be forfeiting
> consistency just for those skipped functions in the list.

So you would not be skipping the stack checking entirely, just allowing
certain functions from the patched set to be on the stack while you
switch to the new universe.

That indeed would make it a mixed SWITCH_FUNCTION/SWITCH_KERNEL
situation. 

The big caveat in such a situation is that you must not change the
calling convention or semantics of any function called directly from the
function you skipped the stack check for. As doing so would crash the
kernel when an old call calls a new function.

> > But there are a few (probably much less than 10%) cases like the locking
> > one I used above, where SWITCH_THREAD just isn't going to cut it and for
> > those I would need SWITCH_KERNEL or get very creative with refactoring
> > the patch to do things differently.
> 
> I'm not opposed to having both if necessary.  But I think the code would
> be _much_ simpler if we could agree on a single consistency model that
> can be used in all cases.  Plus there wouldn't be such a strong
> requirement to get incremental patching to work safely (which will add
> more complexity).
> 
> I actually agree with you that LEAVE_PATCHED_SET + SWITCH_THREAD is
> pretty nice.

Cool! Do you see it as the next step consistency model we would focus on
implementing in livepatch after the null model is complete and upstream?

(That wouldn't preclude extending it or implementing more models later.)

> So I'd like to hear more about cases where you think we _need_
> SWITCH_KERNEL.  As I mentioned above, I think many of those cases can be
> solved by using data structure versioning with shadow data fields.

I have tried, but so far I can't find a situation whether we would
absolutely need SWITCH_KERNEL, assuming we have LEAVE_PATCHED_SET +
SWITCH_THREAD + TRANSFORM_ON_ACCESS.

> > > Why would LEAVE_PATCHED_SET SWITCH_THREAD finish much quicker than
> > > LEAVE_PATCHED_SET SWITCH_KERNEL?  Wouldn't they be about the same?
> > 
> > Because with LEAVE_PATCHED_SET SWITCH_THREAD you're waiting for each
> > thread to leave the patched set and when they each have done that at
> > least once, you're done. Even if some are already back within the set.
> 
> Ok, so you're talking about the case when you're trying to patch a
> function which is always active.  Agreed :-)

Yes.

> > With LEAVE_PATCHED_SET SWITCH_KERNEL, you have to find the perfect
> > moment when all of the threads are outside of the patched set at the
> > same time. Depending on how often the functions are used and how large
> > the set is, reaching that moment will get harder.
> 
> Yeah, I think this is the biggest drawback of SWITCH_KERNEL.  More
> likely to fail (or never succeed).

If some threads are sleeping in a loop inside the patched set:

With SWITCH_THREAD you can wake (eg. by a signal) the threads from
userspace as a last resort and that will complete your patching.

With SWITCH_KERNEL you'd have somehow to wake them at the same time
hoping they also leave the patched set together. That's unlikely to
happen when many threads are involved.

In addition the "in progress" behavior is nicer for SWITCH_THREAD, as
any new thread will already be running patched code. With SWITCH_KERNEL,
you're waiting with applying the fix until the perfect moment.

-- 
Vojtech Pavlik
Director SUSE Labs
