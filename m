Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaJNO6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:58:25 -0400
Received: from relay2.sgi.com ([192.48.180.65]:43263 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755286AbaJNO6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:58:24 -0400
Date: Tue, 14 Oct 2014 09:58:29 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alex Thorlton <athorlton@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [BUG] mm, thp: khugepaged can't allocate on requested node when
 confined to a cpuset
Message-ID: <20141014145829.GC3745@sgi.com>
References: <20141008191050.GK3778@sgi.com>
 <20141010092052.GU4750@worktop.programming.kicks-ass.net>
 <20141010185620.GA3745@sgi.com>
 <54385635.5020709@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54385635.5020709@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:57:09PM +0200, Vlastimil Babka wrote:
> On 10.10.2014 20:56, Alex Thorlton wrote:
> >On Fri, Oct 10, 2014 at 11:20:52AM +0200, Peter Zijlstra wrote:
> >>So for the numa thing we do everything from the affected tasks context.
> >>There was a lot of arguments early on that that could never really work,
> >>but here we are.
> >>
> >>Should we convert khugepaged to the same? Drive the whole thing from
> >>task_work? That would make this issue naturally go away.
> 
> Mel was suggesting to me few weeks ago that this would be desirable
> and I was
> planning to look at this soonish. But if you volunteer, great :)

Good to know that somebody else has already suggested this- and yes, I'll
volunteer to do the initial footwork. Hoping to have something here in a
few days.

> >If we move the compaction scan over to a task_work style function, we'll
> >only be able to scan the one task's mm at a time.  While the underlying
> >compaction infrastructure can function more or less the same, the timing
> >of when these scans occur, and exactly what the scans cover, will have
> >to change.  If we go for the most rudimentary approach, the scans will
> >occur each time a thread is about to return to userland after faulting
> >in a THP (we'll just replace the khugepaged_enter call with a
> 
> I don't understand the motivation of doing this after "faulting in a
> THP"? If you already
> have a THP then maybe it's useful to scan for more candidates for a
> THP, but why
> would a THP fault be the trigger?

I might be playing it a bit fast and loose with my terminology here.
The curent bit of code that would add an mm to the scan list is in the
THP fault path - see the call to khugepaged_enter in
do_huge_pmd_anonymous_page.  That call doesn't have much to do with a
THP fault, but it does add the faulting mm onto the khugepaged scan
list.  I was just suggesting that this is an appropriate place (at
least initially), to put the code that will add our new scan function to
the numa_work list.

> >task_work_add), and will cover the mm for the current task.  A slightly
> >more advanced approach would involve a timer to ensure that scans don't
> >occur too often, as is currently handled by
> 
> Maybe not a timer, but just a timestamp of last scan and the "wait
> time" to compare
> against current timestamp. The wait time could be extended and
> reduced based on
> how successful the scanner was in the recent past (somewhat similar to the
> deferred compaction mechanism).

That's what I meant :)  Again, I'm probably abusing some terminology
here.

> >khugepaged_scan_sleep_millisecs. In any case, I don't see a way around
> >the fact that we'll lose the multi-mm scanning functionality our
> >khugepaged_scan list provides, but maybe that's not a huge issue.
> 
> It should be actually a benefit, as you can tune the scanning
> frequency per mm,
> to avoid useless scaning (see above) and also you don't scan tasks
> that are sleeping
> at all.

I didn't think about the fact that we avoid scanning sleeping tasks.
The per-mm granularity could definitely be plus as well.

> 
> >Before I run off and start writing patches, here's a brief summary of
> >what I think we could do here:
> >
> >1) Dissolve the khugepaged thread and related structs/timers (I'm
> >    expecting some backlash on this one).
> >2) Replace khugepged_enter calls with calls to task_work_add(work,
> >    our_new_scan_function) - new scan function will look almost exactly
> >    like khugepaged_scan_mm_slot.
> >3) Set up a timer similar to khugepaged_scan_sleep_millisecs that gets
> >    checked during/before our_new_scan_function to ensure that we're not
> >    scanning more often than necessary.  Also, set up progress markers to
> >    limit the number of pages scanned in a single pass.
> 
> Hm tuning the "number of pages in single pass" could be another way
> to change
> the scanning frequency based on recent history.
> 
> >By doing this, scans will get triggered each time a thread that has
> >faulted THPs is about to return to userland execution, throttled by our
> >new timer/progress indicators.  The major benefit here is that scans
> >will now occur in the desired task's context.
> >
> >Let me know if you anybody sees any major flaws in this approach.
> 
> Hm I haven't seen the code yet, but is perhaps the NUMA scanning working
> similarly enough that a single scanner could handle both the NUMA and THP
> bits to save time?

That's a good point, but I wonder if that might make things a bit
unclear when it comes to what task work is being done when.  I like the
idea of the numa_work list because we can just tack individual functions
on there and have things get done sequentially, whenever necessary,
before a task returns to userland.  If we start trying to combine
everything into one task work function we run the risk of trying to
handle too much in one place, since we'd be doing both checks before
returning to userland, even if only one is needed.  I also think this
sort of goes against the idea of having a list of work functions to
perform - if we're going to merge everytng into one location, why not
just have a big task_work() function that gets called every time a task
is returning to userland?  I'm not saying I hate the idea - if we really
save a lot of time by combining stuff into one scan, then I'm not opposed
to it, but I'd like to discuss it thoroughly before we go that route.

Thanks, Vlastimil!

- Alex
