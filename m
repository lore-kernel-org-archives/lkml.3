Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaJWIBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:01:11 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:52846 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaJWIBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:01:09 -0400
MIME-Version: 1.0
In-Reply-To: <20141023071944.GA5184@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
	<1412872486-2930-7-git-send-email-eranian@google.com>
	<20141022123151.GA15126@krava.brq.redhat.com>
	<20141023071944.GA5184@krava.brq.redhat.com>
Date: Thu, 23 Oct 2014 10:01:08 +0200
Message-ID: <CABPqkBT7y0CjozJ9VtkK6KrTGEwYaTzX+Qt6UD-Y9jHXNzu86g@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] perf/x86: implement cross-HT corruption bug workaround
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Liang, Kan" <kan.liang@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 9:19 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Oct 22, 2014 at 02:31:51PM +0200, Jiri Olsa wrote:
>> On Thu, Oct 09, 2014 at 06:34:40PM +0200, Stephane Eranian wrote:
>> > From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>>
>> SNIP
>>
>> > +static struct event_constraint *
>> > +intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
>> > +                      int idx, struct event_constraint *c)
>> > +{
>> > +   struct event_constraint *cx;
>> > +   struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
>> > +   struct intel_excl_states *xl, *xlo;
>> > +   int is_excl, i;
>>
>> SNIP
>>
>> > +   /*
>> > +    * Modify static constraint with current dynamic
>> > +    * state of thread
>> > +    *
>> > +    * EXCLUSIVE: sibling counter measuring exclusive event
>> > +    * SHARED   : sibling counter measuring non-exclusive event
>> > +    * UNUSED   : sibling counter unused
>> > +    */
>> > +   for_each_set_bit(i, cx->idxmsk, X86_PMC_IDX_MAX) {
>> > +           /*
>> > +            * exclusive event in sibling counter
>> > +            * our corresponding counter cannot be used
>> > +            * regardless of our event
>> > +            */
>> > +           if (xl->state[i] == INTEL_EXCL_EXCLUSIVE)
>> > +                   __clear_bit(i, cx->idxmsk);
>>
>> if we want to check sibling counter, shouldn't we check xlo->state[i] instead? like
>>
>>               if (xlo->state[i] == INTEL_EXCL_EXCLUSIVE)
>>                       __clear_bit(i, cx->idxmsk);
>>
>>
>> and also in condition below?
>
> any comment on this? I'm curious, because it'd enlighten me
> on how this is supposed to work ;-)
>
> I dont understand why you update the sibling's counter state instead
> of the current cpuc->excl_thread_id HT, like in intel_commit_scheduling
> while you hold lock for the current HT state
>
> could you please comment, I must be missing something
>
Yes, it is a bit confusing. It comes down that what the state represents.
Let me explain.

In get_constraints(), you compute the bitmask of possible counters by looking
at your own state in states[tid] (xl).

In commit_constraint(), the scheduler has picked counters and you need to commit
the changes. But you don't update your state, you update your
sibling's state. Why?
Because of the bug, what you use influences what the sibling can measure. So you
update the sibling's state to reflect its new constraint. When the
sibling calls get_constraint()
it will harvest the new constraints automatically.

Example:

HT0 wants to program a MEM (corrupting) event, it gathers its
constraints from get_constraints().
The mask is, let's say, 0x3. The scheduler picks counter0. Then, in
commit_constraints(), you need
to mark *HT1*'s counter0 in exclusive mode, i.e., it cannot be used
anymore on that thread.

Hope this helps.
