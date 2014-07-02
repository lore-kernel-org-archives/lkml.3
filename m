Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaGBNix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:38:53 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:52750 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaGBNiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:38:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140702133105.GG19379@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
	<20140701093442.GN6758@twins.programming.kicks-ass.net>
	<CABPqkBT9zT6Qejc3hin5yLO4x8bxkZqrXTS-VNana8MhtWC0XA@mail.gmail.com>
	<20140702133105.GG19379@twins.programming.kicks-ass.net>
Date: Wed, 2 Jul 2014 15:38:50 +0200
Message-ID: <CABPqkBSCckKtKUZ0P0FONtiygjmGYzgA1myE9aG+-RcQ9xnLsg@mail.gmail.com>
Subject: Re: [patch] x86, perf: avoid spamming kernel log for bts buffer failure
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 3:31 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jul 02, 2014 at 03:16:40PM +0200, Stephane Eranian wrote:
>> On Tue, Jul 1, 2014 at 11:34 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, Jun 30, 2014 at 04:04:08PM -0700, David Rientjes wrote:
>> >> It's unnecessary to excessively spam the kernel log anytime the BTS buffer
>> >> cannot be allocated, so make this allocation __GFP_NOWARN.
>> >>
>> >> The user probably will want to at least find some artifact that the
>> >> allocation has failed in the past, probably due to fragmentation because
>> >> of its large size, when it's not allocated at bootstrap.  Thus, add a
>> >> WARN_ONCE() so something is left behind for them to understand why perf
>> >> commnads that require PEBS is not working properly.
>> >
>> > Can you elaborate a bit under which conditions this triggered? Typically
>> > we should be doing fairly well allocating such buffers with GFP_KERNEL,
>> > that should allow things like compaction to run and create higher order
>> > pages.
>> >
>> I think this triggers when you have fragmented memory and you have
>> perf_events active and inactive (i.e., 0 users = no nmi watchdog) frequently.
>> Each first user invokes the reserve_ds() function to reserve DS, PEBS, BTS.
>
> Right, that'd suck. I suppose we could also change that to allocate the
> DS resources on first demand and never free them again.
>
Some may argue that if you never use perf_event again, you are wasting
(1 + 1 + 4) pages per CPU. That may not be okay on some systems.

But yes, it would avoid this problem and also take the penalty for the allocs
only once.


> So only allocate the PEBS buffer when we create the first PEBS event,
> and idem for the BTS muck.
>
>> The reason for BTS rather then PEBS is the size of the allocation.
>> PEBS allocates one page, i.e., less likely to get a failure than BTS
>> which allocates 4 pages, I think.
>
> Sure..
>
>> David and I discussed this. He can probably add more background
>> info, if needed.
>
> It would still be good to see why compaction etc is failing.
