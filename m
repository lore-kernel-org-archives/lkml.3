Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaFEOB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:01:28 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:54908 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaFEOB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:01:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140605134841.GL3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-6-git-send-email-eranian@google.com>
	<20140605134841.GL3213@twins.programming.kicks-ass.net>
Date: Thu, 5 Jun 2014 17:01:25 +0300
Message-ID: <CAHzUATjSd0Cio25RvwNaph0vFZYQB-pKBt=xz7C=_MhZvpFXxQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug workaround
From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you saying it is illegal to call kmalloc() from
this context?

kmalloc is needed because we need to allocate
a new constraint struct since the static constraint
cannot be modified.

Worst case we can statically allocate a second
constraint struct in the event struct.

On Thu, Jun 5, 2014 at 4:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jun 04, 2014 at 11:34:14PM +0200, Stephane Eranian wrote:
>
>> +static struct event_constraint *
>> +intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
>> +                        struct event_constraint *c)
>> +{
>
>> +     if (!(c->flags & PERF_X86_EVENT_DYNAMIC)) {
>> +
>> +             /*
>> +              * in case we fail, we assume no counter
>> +              * is supported to be on the safe side
>> +              */
>> +             cx = kmalloc(sizeof(*cx), GFP_KERNEL);
>> +             if (!cx)
>> +                     return &emptyconstraint;
>> +
>
> Ok, so forgive me if I'm wrong, but the way we get here is through:
>
> x86_schedule_event()
>   ->start_scheduling()
>     spin_lock()
>   ->get_event_constraints()
>     intel_get_excl_constraints()
>       kmalloc(.gfp=GFP_KERNEL)
>
> How can that ever work?
