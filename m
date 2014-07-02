Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaGBNHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:07:32 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65111 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaGBNHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:07:31 -0400
MIME-Version: 1.0
In-Reply-To: <1403910612-8754-3-git-send-email-andi@firstfloor.org>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
	<1403910612-8754-3-git-send-email-andi@firstfloor.org>
Date: Wed, 2 Jul 2014 15:07:30 +0200
Message-ID: <CABPqkBSemE1bAnWANO4fnejV8iGXkF5f3+orgBvoN5jqd_jueA@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86, ivb: Allow leaking events with ANY bit set
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Sat, Jun 28, 2014 at 1:10 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Currently the leaking IVB events cannot be scheduled at all,
> to avoid leaking information about other process.
> When the ANY bit is set this does not matter: the process
> already has all the needed priviledges and "leaking" is expected.
> So allow these events with any bit set.
>
Does not make any sense.
This is not the problem.

It is not about leaking information to another hyper-thread, i.e.,
leaking private info.

It is about corrupting the other thread's counter regardless of what
it measures.

The events black-listed here could as well be black-listed on SNB
and HSW. Yet, they are useful events. The patch series we posted
with Maria address the corruption aspect. I will post a V2 next week.


> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index adb02aa..db5cec3 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -116,6 +116,8 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
>         EVENT_CONSTRAINT_END
>  };
>
> +#define FLAGS_NOT_ANY (X86_ALL_EVENT_FLAGS & ~ARCH_PERFMON_EVENTSEL_ANY)
> +
>  static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
>  {
>         FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> @@ -135,11 +137,12 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
>          * Errata BV98 -- MEM_*_RETIRED events can leak between counters of SMT
>          * siblings; disable these events because they can corrupt unrelated
>          * counters.
> +        * But allow them with the ANY bit set.
>          */
>         INTEL_EVENT_CONSTRAINT(0xd0, 0x0), /* MEM_UOPS_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xd1, 0x0), /* MEM_LOAD_UOPS_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xd2, 0x0), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xd3, 0x0), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(FLAGS_NOT_ANY|0xd1, 0x0), /* MEM_LOAD_UOPS_RETIRED.* */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(FLAGS_NOT_ANY|0xd2, 0x0), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(FLAGS_NOT_ANY|0xd3, 0x0), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
>         EVENT_CONSTRAINT_END
>  };
>
> --
> 1.9.3
>
