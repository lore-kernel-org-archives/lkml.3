Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaKGV1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:27:43 -0500
Received: from jablonecka.jablonka.cz ([91.219.244.36]:36744 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaKGV1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:27:41 -0500
Date: Fri, 7 Nov 2014 22:27:35 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141107212735.GA21409@suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107074745.GC22703@infradead.org>
 <20141107131153.GD4071@treble.redhat.com>
 <20141107140458.GA21774@suse.cz>
 <20141107154500.GF4071@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107154500.GF4071@treble.redhat.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 09:45:00AM -0600, Josh Poimboeuf wrote:

> > 	LEAVE_FUNCTION
> > 	LEAVE_PATCHED_SET
> > 	LEAVE_KERNEL
> > 
> > 	SWITCH_FUNCTION
> > 	SWITCH_THREAD
> > 	SWITCH_KERNEL
> > 
> > Now with those definitions:
> > 
> > 	livepatch (null model), as is, is LEAVE_FUNCTION and SWITCH_FUNCTION
> > 
> > 	kpatch, masami-refcounting and Ksplice are LEAVE_PATCHED_SET and SWITCH_KERNEL
> > 
> > 	kGraft is LEAVE_KERNEL and SWITCH_THREAD
> > 
> > 	CRIU/kexec is LEAVE_KERNEL and SWITCH_KERNEL
> 
> Thanks, nice analysis!
> 
> > By blending kGraft and masami-refcounting, we could create a consistency
> > engine capable of almost any combination of these properties and thus
> > all the consistency models.
> 
> Can you elaborate on what this would look like?

There would be the refcounting engine, counting entries/exits of the
area of interest (nothing for LEAVE_FUNCTION, patched functions for
LEAVE_PATCHED_SET - same as Masami's work now, or syscall entry/exit for
LEAVE_KERNEL), and it'd do the counting either per thread, flagging a
thread as 'new universe' when the count goes to zero, or flipping a
'new universe' switch for the whole kernel when the count goes down to zero.

A patch would have flags which specify a combination of the above
properties that are needed for successful patching of that specific
patch.

> The big problem with SWITCH_THREAD is that it adds the possibility that
> old functions can run simultaneously with new ones.  When you change
> data or data semantics, which is roughly 10% of security patches, it
> creates some serious headaches:
> 
> - It makes patch safety analysis much harder by doubling the number of
>   permutations of scenarios you have to consider.  In addition to
>   considering newfunc/olddata and newfunc/newdata, you also have to
>   consider oldfunc/olddata and oldfunc/newdata.
> 
> - It requires two patches instead of one.  The first patch is needed to
>   modify the old functions to be able to deal with new data.  After the
>   first patch has been fully applied, then you apply the second patch
>   which can start creating new versions of data.

For data layout an semantic changes, there are two approaches:

	1) TRANSFORM_WORLD

	Stop the world, transform everything, resume. This is what Ksplice does
	and what could work for kpatch, would be rather interesting (but
	possible) for masami-refcounting and doesn't work at all for the
	per-thread kGraft.

	It allows to deallocate structures, allocate new ones, basically
	rebuild the data structures of the kernel. No shadowing or using
	of padding is needed.

	The nice part is that the patch can stay pretty much the original patch
	that fixes the bug when applied to normal kernel sources.

	The most tricky part with this approach is writing the
	additional transformation code. Finding all instances of a
	changed data structure. It fails if only semantics are changed,
	but that is easily fixed by making sure there is always a layout
	change for any semantic change. All instances of a specific data
	structure can be found, worst case with some compiler help: No
	function can have pointers or instances of the structure on the
	stack, or registers, as that would include it in the patched
	set. So all have to be either global, or referenced by a
	globally-rooted tree, linked list or any other structure.

	This one is also possible to revert, if a reverse-transforming function
	is provided.

	masami-refcounting can be made to work with this by spinning in every
	function entry ftrace/kprobe callback after a universe flip and calling
	stop_kernel from the function exit callback that flipped the switch.

	2) TRANSFORM_ON_ACCESS

	This requires structure versioning and/or shadowing. All 'new' functions
	are written with this in mind and can both handle the old and new data formats
	and transform the data to the new format. When universe transition is
	completed for the whole system, a single flag is flipped for the
	functions to start transforming.

	The advantage is to not have to look up every single instance of the
	structure and not having to make sure you found them all.

	The disadvantages are that the patch now looks very different to what
	goes into the kernel sources, that you never know whether the conversion
	is complete and reverting the patch is tough, although can be helped by
	keeping track of transformed functions at a cost of maintaining another
	data structure for that.

	It works with any of the approaches (except null model) and while it
	needs two steps (patch, then enable conversion), it doesn't require two
	rounds of patching. Also, you don't have to consider oldfunc/newdata as
	that will never happen. oldfunc/olddata obviously works, so you only
	have to look at newfunc/olddata and newfunc/newdata as the
	transformation goes on.

I don't see either of these as really that much simpler. But I do see value
in offering both.

> On the other hand, SWITCH_KERNEL doesn't have those problems.  It does
> have the problem you mentioned, roughly 2% of the time, where it can't
> patch functions which are always in use.  But in that case we can skip
> the backtrace check ~90% of the time.  

An interesting bit is that when you skip the backtrace check you're
actually reverting to LEAVE_FUNCION SWITCH_FUNCTION, forfeiting all
consistency and not LEAVE_FUNCTION SWITCH_KERNEL as one would expect.

Hence for those 2% of cases (going with your number, because it's a
guess anyway) LEAVE_PATCHED_SET SWITCH_THREAD would in fact be a safer
option.

> So it's really maybe something
> like 0.2% of patches which can't be patched with SWITCH_KERNEL.  But
> even then I think we could overcome that by getting creative, e.g. using
> the multiple patch approach.
> 
> So my perspective is that SWITCH_THREAD causes big headaches 10% of the
> time, whereas SWITCH_KERNEL causes small headaches 1.8% of the time, and
> big headaches 0.2% of the time :-)

My preferred way would be to go with SWITCH_THREAD for the simpler stuff
and do a SWITCH_KERNEL for the 10% of complex patches. This because
(LEAVE_PATCHED_SET) SWITCH_THREAD finishes much quicker. But I'm biased
there. ;)

It seems more and more to me that we will actually want the more
powerful engine coping with the various options.

-- 
Vojtech Pavlik
Director SUSE Labs
