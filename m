Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab3CULvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:51:24 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56252 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab3CULvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:51:21 -0400
Date: Thu, 21 Mar 2013 12:51:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH 13/14] x86/UV: Update UV support for external NMI signals
Message-ID: <20130321115116.GB2659@gmail.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
 <20130312193825.244350065@gulag1.americas.sgi.com>
 <20130314072019.GC7869@gmail.com>
 <5149538F.2080402@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5149538F.2080402@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> 
> 
> On 3/14/2013 12:20 AM, Ingo Molnar wrote:
> > 
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >>
> >> There is an exception where the NMI_LOCAL notifier chain is used. When 
> >> the perf tools are in use, it's possible that our NMI was captured by 
> >> some other NMI handler and then ignored.  We set a per_cpu flag for 
> >> those CPUs that ignored the initial NMI, and then send them an IPI NMI 
> >> signal.
> > 
> > "Other" NMI handlers should never lose NMIs - if they do then they should 
> > be fixed I think.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Hi Ingo,
> 
> I suspect that the other NMI handlers would not grab ours if we were
> on the NMI_LOCAL chain to claim them.  The problem though is the UV
> Hub is not designed to have that amount of traffic reading the MMRs.
> This was handled in previous kernel versions by a.) putting us at the
> bottom of the chain; and b.) as soon as a handler claimed an NMI as
> it's own, the search would be stopped.
> 
> Neither of these are true any more as all handlers are called for
> all NMIs.  (I measured anywhere from .5M to 4M NMIs per second on a
> 64 socket, 1024 cpu thread system [not sure why the rate changes]).
> This was the primary motivation for placing the UV NMI handler on the
> NMI_UNKNOWN chain, so it would be called only if all other handlers
> "gave up", and thus not incur the overhead of the MMR reads on every
> NMI event.

That's a fair motivation.

> The good news is that I haven't yet encountered a case where the
> "missing" cpus were not called into the NMI loop.  Even better news
> is that on the previous (3.0 vintage) kernels running two perf tops
> would almost always cause either tons of the infamous "dazed and
> confused" messages, or would lock up the system.  Now it results in
> quite a few messages like:
> 
> [  961.119417] perf_event_intel: clearing PMU state on CPU#652
> 
> followed by a dump of a number of cpu PMC registers.  But the system
> remains responsive.  (This was experienced in our Customer Training
> Lab where multiple system admins were in the class.)

I too can provoke those messages when pushing PMUs hard enough via 
multiple perf users. I suspect there's still some PMU erratum that
seems to have been introduced at around Nehalem CPUs.

Clearing the PMU works it around, at the cost of a loss of a slight 
amount of profiling data.

> The bad news is I'm not sure why the errant NMI interrupts are lost.
> I have noticed that restricting the 'perf tops' to separate and
> distinct cpusets seems to lessen this "stomping on each other's perf
> event handlers" effect, which might be more representative of actual
> customer usage.
> 
> So in total the situation is vastly improved... :)

Okay. My main dislike is the linecount:

 4 files changed, 648 insertions(+), 41 deletions(-)

... for something that should in theory work almost out of box, with 
minimal glue!

As long as it stays in the UV platform code this isn't a NAK from me - 
just wanted to inquire whether most of that complexity could be eliminated 
by figuring out the root cause of the lost NMIs ...

Thanks,

	Ingo
