Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab3CTGNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 02:13:41 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51340 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750902Ab3CTGNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 02:13:39 -0400
Message-ID: <5149538F.2080402@sgi.com>
Date: Tue, 19 Mar 2013 23:13:35 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Jason Wessel <jason.wessel@windriver.com>,
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
References: <20130312193823.212544181@gulag1.americas.sgi.com> <20130312193825.244350065@gulag1.americas.sgi.com> <20130314072019.GC7869@gmail.com>
In-Reply-To: <20130314072019.GC7869@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/14/2013 12:20 AM, Ingo Molnar wrote:
> 
> * Mike Travis <travis@sgi.com> wrote:
> 
>>
>> There is an exception where the NMI_LOCAL notifier chain is used. When 
>> the perf tools are in use, it's possible that our NMI was captured by 
>> some other NMI handler and then ignored.  We set a per_cpu flag for 
>> those CPUs that ignored the initial NMI, and then send them an IPI NMI 
>> signal.
> 
> "Other" NMI handlers should never lose NMIs - if they do then they should 
> be fixed I think.
> 
> Thanks,
> 
> 	Ingo

Hi Ingo,

I suspect that the other NMI handlers would not grab ours if we were
on the NMI_LOCAL chain to claim them.  The problem though is the UV
Hub is not designed to have that amount of traffic reading the MMRs.
This was handled in previous kernel versions by a.) putting us at the
bottom of the chain; and b.) as soon as a handler claimed an NMI as
it's own, the search would be stopped.

Neither of these are true any more as all handlers are called for
all NMIs.  (I measured anywhere from .5M to 4M NMIs per second on a
64 socket, 1024 cpu thread system [not sure why the rate changes]).
This was the primary motivation for placing the UV NMI handler on the
NMI_UNKNOWN chain, so it would be called only if all other handlers
"gave up", and thus not incur the overhead of the MMR reads on every
NMI event.

The good news is that I haven't yet encountered a case where the
"missing" cpus were not called into the NMI loop.  Even better news
is that on the previous (3.0 vintage) kernels running two perf tops
would almost always cause either tons of the infamous "dazed and
confused" messages, or would lock up the system.  Now it results in
quite a few messages like:

[  961.119417] perf_event_intel: clearing PMU state on CPU#652

followed by a dump of a number of cpu PMC registers.  But the system
remains responsive.  (This was experienced in our Customer Training
Lab where multiple system admins were in the class.)

The bad news is I'm not sure why the errant NMI interrupts are lost.
I have noticed that restricting the 'perf tops' to separate and
distinct cpusets seems to lessen this "stomping on each other's perf
event handlers" effect, which might be more representative of actual
customer usage.

So in total the situation is vastly improved... :)

Thanks,
Mike
