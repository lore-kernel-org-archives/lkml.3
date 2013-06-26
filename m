Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3FZJW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:22:58 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59027 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3FZJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:22:53 -0400
Date: Wed, 26 Jun 2013 11:22:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Nathan Zimmer <nzimmer@sgi.com>,
        holt@sgi.com, rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC] Transparent on-demand memory setup initialization embedded in
 the (GFP) buddy allocator
Message-ID: <20130626092248.GB27025@gmail.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
 <1371831934-156971-3-git-send-email-nzimmer@sgi.com>
 <20130623092840.GB13445@gmail.com>
 <20130624203657.GA107621@asylum.americas.sgi.com>
 <20130625073819.GC11420@gmail.com>
 <51C9D1D6.20405@sgi.com>
 <51C9E4B7.2000007@zytor.com>
 <51C9E6CD.5080508@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C9E6CD.5080508@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Changed the subject, to make it more apparent what we are talking about.)

* Mike Travis <travis@sgi.com> wrote:

> On 6/25/2013 11:43 AM, H. Peter Anvin wrote:
> > On 06/25/2013 10:22 AM, Mike Travis wrote:
> >>
> >> On 6/25/2013 12:38 AM, Ingo Molnar wrote:
> >>>
> >>> * Nathan Zimmer <nzimmer@sgi.com> wrote:
> >>>
> >>>> On Sun, Jun 23, 2013 at 11:28:40AM +0200, Ingo Molnar wrote:
> >>>>>
> >>>>> That's 4.5 GB/sec initialization speed - that feels a bit slow and the 
> >>>>> boot time effect should be felt on smaller 'a couple of gigabytes' 
> >>>>> desktop boxes as well. Do we know exactly where the 2 hours of boot 
> >>>>> time on a 32 TB system is spent?
> >>>>
> >>>> There are other several spots that could be improved on a large system 
> >>>> but memory initialization is by far the biggest.
> >>>
> >>> My feeling is that deferred/on-demand initialization triggered from the 
> >>> buddy allocator is the better long term solution.
> >>
> >> I haven't caught up with all of Nathan's changes yet (just
> >> got back from vacation), but there was an option to either
> >> start the memory insertion on boot, or trigger it later
> >> using the /sys/.../memory interface.  There is also a monitor
> >> program that calculates the memory insertion rate.  This was
> >> extremely useful to determine how changes in the kernel
> >> affected the rate.
> >>
> > 
> > Sorry, I *totally* did not follow that comment.  It seemed like a
> > complete non-sequitur?
> > 
> > 	-hpa
> 
> It was I who was not following the question.  I'm still reverting
> back to "work mode".
> 
> [There is more code in a separate patch that Nate has not sent
> yet that instructs the kernel to start adding memory as early
> as possible, or not.  That way you can start the insertion process
> later and monitor it's progress to determine how changes in the
> kernel affect that process.  It is controlled by a separate
> CONFIG option.]

So, just to repeat (and expand upon) the solution hpa and me suggests: 
it's not based on /sys, delayed initialization lists or any similar 
(essentially memory hot plug based) approach.

It's a transparent on-demand initialization scheme based on only 
initializing the very early memory setup in 1GB (2MB) steps (not in 4K 
steps like we do it today).

Any subsequent split-up initialization is done on-demand, in alloc_pages() 
et al, initilizing a batch of 512 (or 1024) struct page head's when an 
uninitialized portion is first encountered.

This leaves the principle logic of early init largely untouched, we still 
have the same amount of RAM during and after bootup, except that on 32 TB 
systems we don't spend ~2 hours initializing 8,589,934,592 page heads.

This scheme could be implemented by introducing a new PG_initialized flag, 
which is seen by an unlikely() branch in alloc_pages() and which triggers 
the on-demand initialization of pages.

[ It could probably be made zero-cost for the post-initialization state:
  we already check a bunch of rare PG_ flags, one more flag would not 
  introduce any new branch in the page allocation hot path. ]

It's a technically different solution from what was submitted in this 
thread.

Cons:

 - it works after bootup, via GFP. If done in a simple fashion it adds one 
   more branch to the GFP fastpath. [ If done a bit more cleverly it can 
   merge into an existing unlikely() branch and become essentially 
   zero-cost for the fastpath. ]

 - it adds an initialization non-determinism to GFP, to the tune of
   initializing ~512 page heads when RAM is utilized first.

 - initialization is done when memory is needed - not during or shortly 
   after bootup. This (slightly) increases first-use overhead. [I don't 
   think this factor is significant - and I think we'll quickly see 
   speedups to initialization, once the overhead becomes more easily 
   measurable.]

Pros:

 - it's transparent to the boot process. ('free' shows the same full
   amount of RAM all the time, there's no weird effects of RAM coming
   online asynchronously. You see all the RAM you have - etc.)

 - it helps the boot time of every single Linux system, not just large RAM
   ones. On a smallish, 4GB system memory init can take up precious
   hundreds of milliseconds, so this is a practical issue.

 - it spreads initialization overhead to later portions of the system's 
   life time: when there's typically more idle time and more paralellism
   available.

 - initialization overhead, because it's a natural part of first-time 
   memory allocation with this scheme, becomes more measurable (and thus 
   more prominently optimized) than any deferred lists processed in the 
   background.

 - as an added bonus it probably speeds up your usecase even more than the
   patches you are providing: on a 32 TB system the primary initialization
   would only have to enumerate memory, allocate page heads and buddy
   bitmaps, and initialize the 1GB granular page heads: there's only 32768
   of them.

So unless I overlooked some factor this scheme would be unconditional 
goodness for everyone.

Thanks,

	Ingo
