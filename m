Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaKHIIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 03:08:00 -0500
Received: from jablonecka.jablonka.cz ([91.219.244.36]:60034 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaKHIH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 03:07:58 -0500
Date: Sat, 8 Nov 2014 09:07:54 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141108080754.GA28969@suse.cz>
References: <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107074745.GC22703@infradead.org>
 <20141107131153.GD4071@treble.redhat.com>
 <20141107140458.GA21774@suse.cz>
 <20141107154500.GF4071@treble.redhat.com>
 <20141107212735.GA21409@suse.cz>
 <20141108034553.GA11663@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141108034553.GA11663@treble.redhat.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 09:45:53PM -0600, Josh Poimboeuf wrote:

> On Fri, Nov 07, 2014 at 10:27:35PM +0100, Vojtech Pavlik wrote:
> > On Fri, Nov 07, 2014 at 09:45:00AM -0600, Josh Poimboeuf wrote:
> > 
> > > > 	LEAVE_FUNCTION
> > > > 	LEAVE_PATCHED_SET
> > > > 	LEAVE_KERNEL
> > > > 
> > > > 	SWITCH_FUNCTION
> > > > 	SWITCH_THREAD
> > > > 	SWITCH_KERNEL
> > > > 
> > 
> > There would be the refcounting engine, counting entries/exits of the
> > area of interest (nothing for LEAVE_FUNCTION, patched functions for
> > LEAVE_PATCHED_SET - same as Masami's work now, or syscall entry/exit
> > for LEAVE_KERNEL), and it'd do the counting either per thread,
> > flagging a thread as 'new universe' when the count goes to zero, or
> > flipping a 'new universe' switch for the whole kernel when the count
> > goes down to zero.
> > 
> > A patch would have flags which specify a combination of the above
> > properties that are needed for successful patching of that specific
> > patch.
> 
> Would it really be necessary to support all possible permutations?  I
> think that would add a lot of complexity to the code.  Especially if we
> have to support LEAVE_KERNEL, which adds a lot of interdependencies with
> the rest of the kernel (kthreads, syscall, irq, etc).
> 
> It seems to me that the two most interesting options are:
> - LEAVE_PATCHED_SET + SWITCH_THREAD (Masami-kGraft)
> - LEAVE_PATCHED_SET + SWITCH_KERNEL (kpatch and/or Masami-kpatch)

I agree here.

In fact LEAVE_KERNEL can be approximated by extending the patched
set as required to include functions which are not changed per se, but
are "contaminated" by propagation of semantic changes in the calling
convention, and/or data format.

This applies to cases like this (needs LEAVE_KERNEL or extending patched
set beyond changed functions):

-----------------------------------------------------------

	int bar() {
		[...]
-		return x;
+		return x + 1;
	}

	foo() {
		int ret = bar();
		do {
			wait_interruptible();
		} while (ret == bar());
	}

-----------------------------------------------------------

Or like this (needs SWITCH_KERNEL so won't work with kGraft, but also
extending patched set, will not work with kpatch as it stands today):

-----------------------------------------------------------

	void lock_a()
	{
-		spin_lock(&x);
+		spin_lock(&y);
	}
	void lock_b()
	{
-		spin_lock(&y);
+		spin_lock(&x);
	}
	void unlock_a()
	}
-		spin_unlock(&x);
+		spin_unlock(&y);
	}
	void unlock_b()
	{
-		spin_unlock(&y);
+		spin_unlock(&x);
	}

	void foo()
	{
		lock_a();
		lock_b();
		[...]
		unlock_b();
		unlock_a();
	}
-----------------------------------------------------------
	

So once we can extend the patched set as needed (manually, after
review), we can handle all the cases that LEAVE_KERNEL offers, making
LEAVE_KERNEL unnecessary.

It'd be nice if we wouldn't require actually patching those functions,
only include them in the set we have to leave to proceed.

The remaining question is the performance impact of using a large set
with refcounting. LEAVE_KERNEL's impact as implemented in kGraft is
beyond being measurable, it's about 16 added instructions for each
thread that get executed.

> I do see some appeal for the choose-your-own-consistency-model idea.
> But it wouldn't be practical for cumulative patch upgrades, which I
> think we both agreed at LPC seems to be safer than incremental
> patching.  If you only ever have one patch module loaded at any given
> time, you only get one consistency model anyway.

> In order for multiple consistency models to be practical, I think we'd
> need to figure out how to make incremental patching safe.

I believe we have to get incremental patching working anyway as it is a
valid usecase for many users, just not for major distributions.

And we may want to take a look at how to mark parts of a cumulative
patch with different consistency models, when we combine eg. the recent
futex CVE patch (not working with SWITCH_KERNEL) and anything requiring
SWITCH kernel.

> > For data layout an semantic changes, there are two approaches:
> > 
> > 	1) TRANSFORM_WORLD
 
> I'm kind of surprised to hear that Ksplice does this.  I had
> considered this approach, but it sounds really tricky, if not
> impossible in many cases.

By the way, the ability to do this is basically the only advantage of
actually stopping the kernel.
 
> Ahem, this would be an opportune time for a Ksplice person to chime in
> with their experiences...

Indeed. :)

> > 	2) TRANSFORM_ON_ACCESS
 
> This is a variation on what we've been doing with kpatch, using shadow
> data fields to add data and/or version metadata to structures, with a
> few differences:
> 
> First, we haven't been transforming existing data.  All existing data
> structures stay at v1.  Only new data structures are created as v2.  I
> suppose it depends on the nature of the patch as to whether it's safe
> to convert existing data.

Also it depends on whether existing data do contain enough information
to actually avoid the security issue the patch is fixing. You may want
to transform the data structures as soon as possible.

> Second, we don't need to flip a flag, because with SWITCH_KERNEL the
> system universe transition happens instantly.

Indeed. I wanted to point out that it works even with the SWITCH_THREAD
and using the patching_complete flag that already is used in kGraft for
other purposes.

> > 	The advantage is to not have to look up every single instance of
> > 	the structure and not having to make sure you found them all.
> >
> > 	The disadvantages are that the patch now looks very different to
> > 	what goes into the kernel sources,
 
> In my experience, s/very different/slightly different/.

Not the same, anyway. :)

> >	that you never know whether the conversion is complete and
> >	reverting the patch is tough, although can be helped by keeping
> >	track of transformed functions at a cost of maintaining another
> >	data structure for that.
> 
> True, and we might even want to prevent or discourage such patches
> from being disabled somehow.

Yes.

> > An interesting bit is that when you skip the backtrace check you're
> > actually reverting to LEAVE_FUNCION SWITCH_FUNCTION, forfeiting all
> > consistency and not LEAVE_FUNCTION SWITCH_KERNEL as one would expect.
> 
> Hm, if we used stop machine (or ref counting), but without the backtrace
> check, wouldn't it be LEAVE_FUNCTION SWITCH_KERNEL?

No; if you don't check the backtrace, any of the patched functions can
be on the stack and old code can still be executed after you resume the
kernel again. Look at this:

--------------------------------------------------------------

	baz() {
	}
	bar() {
-		[...]
+		[...]
		baz();
-		[...]
+		[...]
	}
	foo() {
		bar();
	}

--------------------------------------------------------------

Now we stop_kernel on baz(). We don't check the stack. We patch bar().
We resume, and baz() happily returns into bar(), executing old code.
At the same time, another CPU can call bar(), getting new code.

Stack checking at stop_kernel() time is required to keep the
SWITCH_KERNEL part of the model.

> > > So my perspective is that SWITCH_THREAD causes big headaches 10%
> > > of the time, whereas SWITCH_KERNEL causes small headaches 1.8% of
> > > the time, and big headaches 0.2% of the time :-)
> > 
> > My preferred way would be to go with SWITCH_THREAD for the simpler
> > stuff and do a SWITCH_KERNEL for the 10% of complex patches.
> 
> You said above that neither SWITCH_KERNEL nor SWITCH_THREAD is much
> simpler than the other for the 10% case.  So why would you use
> SWITCH_KERNEL here?

I think I was referring to the two data transformation methods and one
not being simpler than the other.

And since we're both looking at the TRANSFORM_ON_ACCESS model, there
isn't much of a difference using SWITCH_THREAD or SWITCH_KERNEL for the
data format modification cases indeed. It works the same.

But there are a few (probably much less than 10%) cases like the locking
one I used above, where SWITCH_THREAD just isn't going to cut it and for
those I would need SWITCH_KERNEL or get very creative with refactoring
the patch to do things differently.

> > This because (LEAVE_PATCHED_SET) SWITCH_THREAD finishes much quicker.
> > But I'm biased there. ;)
> 
> Why would LEAVE_PATCHED_SET SWITCH_THREAD finish much quicker than
> LEAVE_PATCHED_SET SWITCH_KERNEL?  Wouldn't they be about the same?

Because with LEAVE_PATCHED_SET SWITCH_THREAD you're waiting for each
thread to leave the patched set and when they each have done that at
least once, you're done. Even if some are already back within the set.

With LEAVE_PATCHED_SET SWITCH_KERNEL, you have to find the perfect
moment when all of the threads are outside of the patched set at the
same time. Depending on how often the functions are used and how large
the set is, reaching that moment will get harder.

-- 
Vojtech Pavlik
Director SUSE Labs
