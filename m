Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3KSPbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:31:47 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39659 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3KSPbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:31:46 -0500
Date: Tue, 19 Nov 2013 16:31:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131119153142.GA10913@gmail.com>
References: <528AB229.6030603@gmail.com>
 <87wqk5t9yd.fsf@sejong.aot.lge.com>
 <528ACA41.4030202@gmail.com>
 <87ob5ht962.fsf@sejong.aot.lge.com>
 <528ACDE7.3050107@gmail.com>
 <20131119065835.GB32367@gmail.com>
 <20131119114810.GK3866@twins.programming.kicks-ass.net>
 <20131119114959.GE3694@twins.programming.kicks-ass.net>
 <20131119131304.GC7263@gmail.com>
 <20131119134508.GN3866@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119134508.GN3866@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Nov 19, 2013 at 02:13:04PM +0100, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Tue, Nov 19, 2013 at 12:48:10PM +0100, Peter Zijlstra wrote:
> > > > And that does indeed seem to side-step the perf sw pagefault event, but
> > > > that is arguably a perf bug.
> > > 
> > > To clarify; mm/memory.c:handle_mm_fault() is where the VM counts its 
> > > generic PGFAULT event, but our perf sw event is in the arch fault 
> > > handler.
> > > 
> > > So they count different but related things.
> > 
> > I think that assymetry was intended: we didn't want to count 
> > 'synchronous' pagefaults like get_user_pages() or mlock() bringing 
> > in pages, only asynchronous/real ones, or so.
> 
> OK, I couldn't remember.
> 
> Anyway, I don't want to hold up this patch set, and the speedup in 
> the 'normal' case is nice.
> 
> The only reason I reacted was because the changelog mentioned 
> avoiding a feedback loop -- so I obviously had to point out that it 
> didn't do such a thing, it only changed the details of the loop.

So with MAP_POPULATE the 'feedback window' is moved entirely into the 
kernel (to within a single syscall) and is also reduced significantly, 
compared to a write() loop.

While you are right that it is not an elimination of the problem - yet 
it is still a significant reduction of its cross section surface in 
practice.

> I'm fairly certain this particular problem is unavoidable, no matter 
> what the mechanism used, you can always create feedback.

Well, we could exclude the profiling task itself from profiling events 
(just like ftrace and core bits of perf does it out of necessity), but 
I intentionally wanted to avoid that, to make sure we are honest and 
to make sure people don't tolerate profiling overhead that disturbs 
other workloads.

Thanks,

	Ingo
