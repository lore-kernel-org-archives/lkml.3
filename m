Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaFDOoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:44:05 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:63634 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaFDOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:44:03 -0400
MIME-Version: 1.0
In-Reply-To: <538F186A.2060801@linaro.org>
References: <cover.1401841482.git.luto@amacapital.net> <c932da32f908d0c0c9ea5b7f7d5fff540eb8fec6.1401841482.git.luto@amacapital.net>
 <538F186A.2060801@linaro.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Jun 2014 07:43:42 -0700
Message-ID: <CALCETrWTPFSdEjNMWYp=4QQjE1C_A6tNqZ3y+wMN0-_8bTr+CQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] sched,trace: Add a tracepoint for remote wakeups via polling
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 6:00 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 06/04/2014 02:29 AM, Andy Lutomirski wrote:
>>
>> Remote wakeups of polling CPUs are a valuable performance
>> improvement; add a tracepoint to make it much easier to verify that
>> they're working.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>
>
> I don't think this trace makes sense. The polling state is x86 only and this
> trace is in the generic code.
>
> Furthermore, you may be not in polling state but in the idle mainloop before
> or after the idle state, so the trace will be wrong for the purpose you are
> aiming.
>
> IMO, the right place would be in 'poll_idle' but why add such trace ?
>
> If, on x86, we exit poll_idle, we have the idle state exit trace. The
> missing information would be the origin of the 'wakeup' (irq or ipi or
> nothing). The missing informations are the IPI traces [1].
>
> And as a sidenote, the polling state could be rare on a system with a
> cpuidle driver, it should be much more easy to restrict the idle states to
> 'poll' only and check there are no IPI_WAKEUP, no ?

While developing and testing this, I found it quite useful to measure
the ratio of IPIs to non-IPIs.  I think most of your objection stems
from the fact that I named this tracepoint rather poorly.  How about
"sched_wake_idle_without_ipi"?  I don't think there's anywhere good to
put it in arch / cpuidle driver code (neither the true polling loop
nor (AFAIK) x86 mwait the sleeping cpu any straightforward indication
of why it woke up.

On archs without TIF_POLLING_NRFLAG, the compiler should optimize this
away completely.  On archs with TIF_POLLING_NRFLAG but not actual
polling, it could be interesting to see if this tracepoint ever hits
and, if not, consider removing TIF_POLLING_NRFLAG.

--Andy
