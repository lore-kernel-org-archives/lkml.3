Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaFEOPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:15:22 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63053 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaFEOPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140605140400.GM3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-6-git-send-email-eranian@google.com>
	<20140605140400.GM3213@twins.programming.kicks-ass.net>
Date: Thu, 5 Jun 2014 16:15:17 +0200
Message-ID: <CABPqkBQRDpbkF73sWKXiXJOO0Jbeb9tRTWqScbjNdTG50EN3ug@mail.gmail.com>
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

On Thu, Jun 5, 2014 at 4:04 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jun 04, 2014 at 11:34:14PM +0200, Stephane Eranian wrote:
>> +
>> +     /*
>> +      * Modify static constraint with current dynamic
>> +      * state of thread
>> +      *
>> +      * EXCLUSIVE: sibling counter measuring exclusive event
>> +      * SHARED   : sibling counter measuring non-exclusive event
>> +      * UNUSED   : sibling counter unused
>> +      */
>> +     for_each_set_bit(i, cx->idxmsk, X86_PMC_IDX_MAX) {
>> +             /*
>> +              * exclusive event in sibling counter
>> +              * our corresponding counter cannot be used
>> +              * regardless of our event
>> +              */
>> +             if (xl->state[i] == INTEL_EXCL_EXCLUSIVE)
>> +                     __clear_bit(i, cx->idxmsk);
>> +             /*
>> +              * if measuring an exclusive event, sibling
>> +              * measuring non-exclusive, then counter cannot
>> +              * be used
>> +              */
>> +             if (is_excl && xl->state[i] == INTEL_EXCL_SHARED)
>> +                     __clear_bit(i, cx->idxmsk);
>> +     }
>> +
>> +     /*
>> +      * recompute actual bit weight for scheduling algorithm
>> +      */
>> +     cx->weight = hweight64(cx->idxmsk64);
>
> So I think we talked about this a bit; what happens if CPU0 (taking your
> 4 core HSW-client) is first to program its counters and takes all 4 in
> exclusive mode?
>
> Then there's none left for CPU4.
>
> Did I miss where we avoid that problem, or is that an actual issue?

Yes, this patch series does not address this problem yet. It will be
in a second series.
Don't have a good solution yet.
