Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3KRQ6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 11:58:55 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64577 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3KRQ6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 11:58:46 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1311181142380.18020@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311131739560.5706@vincent-weaver-1.um.maine.edu>
	<20131115145944.GA3694@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1311151223040.11932@vincent-weaver-1.um.maine.edu>
	<20131118085439.GD3866@twins.programming.kicks-ass.net>
	<CABPqkBRe0xK_mf4JE+0e-UDs92Os_3dreHfh-wnG78fquTCRHQ@mail.gmail.com>
	<20131118153219.GH3866@twins.programming.kicks-ass.net>
	<CABPqkBQqa_foaozcHkHBU+VFTcVKrkgVcidUQNzWayB53yBa8g@mail.gmail.com>
	<alpine.DEB.2.10.1311181142380.18020@vincent-weaver-1.um.maine.edu>
Date: Mon, 18 Nov 2013 17:58:45 +0100
Message-ID: <CABPqkBSLZAFeJ8t_57eJe8Yuxi-jSJSVF60BPjZwS_gj3zS7VA@mail.gmail.com>
Subject: Re: perf sw_event related lockup
From: Stephane Eranian <eranian@google.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 5:44 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
> On Mon, 18 Nov 2013, Stephane Eranian wrote:
>
>> What's the config for this test?
>> Need to host CPU type and the event config.
>> Otherwise there is not much I can do with the crash dump.
>
> It's 3.12, on a core2 machine.
>
On core2, there is no offcore-response event, therefore you should not
get to the shared_reg_*() code OR it should return immediately. Looks
like here, it calls into it and finds some pointers NULL:
cpuc->shared_regs, I bet.

Now, I am trying to understand how we got there:

        xreg = &event->hw.extra_reg;
        if (xreg->idx != EXTRA_REG_NONE) {
                c = __intel_shared_reg_get_constraints(cpuc, event, xreg);

        }

        breg = &event->hw.branch_reg;
        if (breg->idx != EXTRA_REG_NONE) {
                d = __intel_shared_reg_get_constraints(cpuc, event, breg);
        }

So one of those tests is true.

That means breg->idx is pointing to a LBR_SELECT MSR but that does
not exist on Core2, or xreg->idx is pointing to a shared resource
which does not exist either.
For the former, it would mean it thinks there is hw LBR filtering, but
that's wrong. For the latter, it means it thinks that Core 2 has a
x86_pmu.extra_regs. I would check those two cases. Don't know
how this could happen.

I could debug this but I don't have a Core 2 machine that I can
easily crash. But maybe I can fake this on a IVB laptop. Just
would need the perf_event_attr struct.


ly I don't have the event config.  To reproduce I start my perf_fuzzer
> running and typically it will hit the error/lockup within an hour or so
> of fuzzing assuming it doesn't hit one of the other outstanding bugs
> first.
>
> I can probably narrow it down but that involves a lot of luck as well as a
> lot of time and I might not get a chance to do so until next month at the
> earliest.
>
> Vince
