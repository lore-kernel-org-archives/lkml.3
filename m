Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaFEO0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:26:40 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65033 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaFEO0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:26:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140605142135.GM6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-6-git-send-email-eranian@google.com>
	<20140605140400.GM3213@twins.programming.kicks-ass.net>
	<CABPqkBQRDpbkF73sWKXiXJOO0Jbeb9tRTWqScbjNdTG50EN3ug@mail.gmail.com>
	<20140605142135.GM6758@twins.programming.kicks-ass.net>
Date: Thu, 5 Jun 2014 16:26:38 +0200
Message-ID: <CABPqkBQ9_HWN-LbwoxqDY52gHjevA_8fSoYbcv=wp04Rtp2ESg@mail.gmail.com>
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug workaround
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 4:21 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jun 05, 2014 at 04:15:17PM +0200, Stephane Eranian wrote:
>> On Thu, Jun 5, 2014 at 4:04 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, Jun 04, 2014 at 11:34:14PM +0200, Stephane Eranian wrote:
>> >> +
>> >> +     /*
>> >> +      * Modify static constraint with current dynamic
>> >> +      * state of thread
>> >> +      *
>> >> +      * EXCLUSIVE: sibling counter measuring exclusive event
>> >> +      * SHARED   : sibling counter measuring non-exclusive event
>> >> +      * UNUSED   : sibling counter unused
>> >> +      */
>> >> +     for_each_set_bit(i, cx->idxmsk, X86_PMC_IDX_MAX) {
>> >> +             /*
>> >> +              * exclusive event in sibling counter
>> >> +              * our corresponding counter cannot be used
>> >> +              * regardless of our event
>> >> +              */
>> >> +             if (xl->state[i] == INTEL_EXCL_EXCLUSIVE)
>> >> +                     __clear_bit(i, cx->idxmsk);
>> >> +             /*
>> >> +              * if measuring an exclusive event, sibling
>> >> +              * measuring non-exclusive, then counter cannot
>> >> +              * be used
>> >> +              */
>> >> +             if (is_excl && xl->state[i] == INTEL_EXCL_SHARED)
>> >> +                     __clear_bit(i, cx->idxmsk);
>> >> +     }
>> >> +
>> >> +     /*
>> >> +      * recompute actual bit weight for scheduling algorithm
>> >> +      */
>> >> +     cx->weight = hweight64(cx->idxmsk64);
>> >
>> > So I think we talked about this a bit; what happens if CPU0 (taking your
>> > 4 core HSW-client) is first to program its counters and takes all 4 in
>> > exclusive mode?
>> >
>> > Then there's none left for CPU4.
>> >
>> > Did I miss where we avoid that problem, or is that an actual issue?
>>
>> Yes, this patch series does not address this problem yet. It will be
>> in a second series.
>> Don't have a good solution yet.
>
> We could limit each cpu to num_counters/2 exclusive slots. That'll still
> be painful with some constrained events I imagine, but in general that
> should 'work' I suppose.

That is probably the easiest solution, just modify the dynamic constraint
mask some more. Have not yet tried it.

The repatriation of the leaked count is not so easy either. Need to IPI
the other HT. There may be some restrictions as to when we can
safely do this.
