Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104AbaETUvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:51:06 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52039 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaETUvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:51:04 -0400
MIME-Version: 1.0
In-Reply-To: <1400617046.2970.270.camel@schen9-DESK>
References: <1400617046.2970.270.camel@schen9-DESK>
Date: Tue, 20 May 2014 13:51:03 -0700
X-Google-Sender-Auth: OmzyAJcDSlfrpZuz_4r7ZicUtDI
Message-ID: <CAGQ1y=5cwk+-Ztv8kXod+QexwEqQ0U6wPdMDBLL66rcF_cukLA@mail.gmail.com>
Subject: Re: [PATCH] sched: Reduce the rate of needless idle load balancing
From: Jason Low <jason.low2@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Russ Anderson <rja@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 1:17 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 9b4c4f3..97132db 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6764,12 +6764,17 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
>
>                 rq = cpu_rq(balance_cpu);
>
> -               raw_spin_lock_irq(&rq->lock);
> -               update_rq_clock(rq);
> -               update_idle_cpu_load(rq);
> -               raw_spin_unlock_irq(&rq->lock);
> -
> -               rebalance_domains(rq, CPU_IDLE);
> +               /*
> +                * If time for next balance is due,
> +                * do the balance.
> +                */
> +               if (time_after(jiffies + 1, rq->next_balance)) {

Hi Tim,

If we want to do idle load balancing only when it is due for a
balance, shouldn't the above just be "if (time_after(jiffies,
rq->next_balance))"?

> +                       raw_spin_lock_irq(&rq->lock);
> +                       update_rq_clock(rq);
> +                       update_idle_cpu_load(rq);
> +                       raw_spin_unlock_irq(&rq->lock);
> +                       rebalance_domains(rq, CPU_IDLE);
> +               }
>
>                 if (time_after(this_rq->next_balance, rq->next_balance))
>                         this_rq->next_balance = rq->next_balance;
