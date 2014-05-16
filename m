Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbaEPLtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:49:06 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41931 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbaEPLtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:49:03 -0400
Message-ID: <5375FAE7.1080700@linux.vnet.ibm.com>
Date: Fri, 16 May 2014 17:17:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Juri Lelli <juri.lelli@gmail.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
References: <20140509160455.GA4486@htj.dyndns.org> <20140514140034.GM30445@twins.programming.kicks-ass.net> <20140514170238.GB15690@htj.dyndns.org> <20140514171051.GX30445@twins.programming.kicks-ass.net> <20140514223648.GH15690@htj.dyndns.org> <20140515144113.GA2886@cmpxchg.org>
In-Reply-To: <20140515144113.GA2886@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051611-3864-0000-0000-00000E3CFD8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 08:11 PM, Johannes Weiner wrote:
> On Wed, May 14, 2014 at 06:36:48PM -0400, Tejun Heo wrote:
>> On Wed, May 14, 2014 at 07:10:51PM +0200, Peter Zijlstra wrote:
>>> On Wed, May 14, 2014 at 01:02:38PM -0400, Tejun Heo wrote:
>>>> On Wed, May 14, 2014 at 04:00:34PM +0200, Peter Zijlstra wrote:
>>>>> Does something like the below help any? I noticed those things (cpudl
>>>>> and cpupri) had [NR_CPUS] arrays, which is always 'fun'.
>>>>>
>>>>> The below is a mostly no thought involved conversion of cpudl which
>>>>> boots, I'll also do cpupri and then actually stare at the algorithms to
>>>>> see if I didn't make any obvious fails.
>>>>
>>>> Yeah, should avoid large allocation on reasonably sized machines and I
>>>> don't think 2k CPU machines suspend regularly.  Prolly good / safe
>>>> enough for -stable port?  
>>>
>>> Yeah, its certainly -stable material. Esp. if this cures the immediate
>>> problem.
>>
>> The patches are URL encoded.  Tried to reproduce the problem but
>> haven't succeeded but I'm quite confident about the analysis, so
>> verifying that the high order allocation goes away should be enough.
>>
>> I instrumented the allocator and it looks like we also have other
>> sources of high order allocation during resume before GFP_IOFS is
>> cleared.  Some kthread creations (order 2, probably okay) and on my
>> test setup a series of order 3 allocations from e1000.
>>
>> Cc'ing Bruce for e1000.  Is it necessary to free and re-allocate
>> buffers across suspend/resume?  The driver ends up allocating multiple
>> order-3 regions during resume where mm doesn't have access to backing
>> devices and thus can't compact or reclaim and it's not too unlikely
>> for those allocations to fail.
>>
>> I wonder whether we need some generic solution to address the issue.
>> Unfortunately, I don't think it'd be possible to order device
>> initialization to bring up backing devices earlier.  We don't really
>> have that kind of knowledge easily accessible.  Also, I don't think
>> it's realistic to require drivers to avoid high order allocations
>> during resume.
>>
>> Maybe we should pre-reclaim and set aside some amount of memory to be
>> used during resume?  It's a mushy solution but could be good enough.
>> Rafael, Johannes, what do you guys think?
> 
> Is it necessary that resume paths allocate at all?  Freeing at suspend
> what you have to reallocate at resume is asking for trouble.  It's not
> just higher order allocations, either, even order-0 allocations are
> less reliable without GFP_IOFS.  So I think this should be avoided as
> much as possible.
>

>From the discussion on this thread, what I understand is that certain
drivers and some subsystems like the scheduler free memory during suspend
and allocate them back during resume. But why does that pose a problem
to the MM subsystem? I mean, the memory freed and the memory requested
later is not substantially different either in terms of quantity or the
order of the allocation, right?

If that's the case, then what happened to the freed memory? Did the
page-cache or other caching mechanism launder most of that so soon, that
we are forced to rely on reclaim to allocate memory during resume? Isn't
that somewhat suspicious?

I might be missing something obvious here, but given the fact that tasks
are frozen during suspend and not a whole lot of things (allocations etc)
happen in the suspend path, I would expect that whatever memory was freed
during suspend would naturally remain available during resume as well.

Thoughts?

Regards,
Srivatsa S. Bhat

> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] mm: page_alloc: warn about higher-order allocations during
>  suspend
> 
> Higher-order allocations require compaction to work reliably, and
> compaction requires the ability to do IO.  Unfortunately, backing
> storage infrastructure is disabled during suspend & resume, and so
> higher-order allocations can not be supported during that time.
> 
> Drivers should refrain from freeing and allocating data structures
> during suspend and resume entirely, and fall back to order-0 pages if
> strictly necessary.
> 
> Add an extra line of warning to the allocation failure dump when a
> higher-order allocation fails while backing storage is suspended.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/page_alloc.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5dba2933c9c0..3acc12c0e093 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2122,6 +2122,16 @@ void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
>  	pr_warn("%s: page allocation failure: order:%d, mode:0x%x\n",
>  		current->comm, order, gfp_mask);
> 
> +	/*
> +	 * Compaction doesn't work while backing storage is suspended
> +	 * in the resume path.  Drivers should refrain from managing
> +	 * kernel objects during suspend/resume, and leave this task
> +	 * to init/exit as much as possible.
> +	 */
> +	if (order && pm_suspended_storage())
> +		pr_warn("Higher-order allocations during resume "
> +			"are unsupported\n");
> +
>  	dump_stack();
>  	if (!should_suppress_show_mem())
>  		show_mem(filter);
> 


