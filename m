Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab3B0Qp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:45:57 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48252 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651Ab3B0Qp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:45:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130227161326.GA25559@somewhere>
References: <1361435356-28466-1-git-send-email-vincent.guittot@linaro.org>
	<20130222123213.GA17948@somewhere.redhat.com>
	<CAKfTPtBgEsEJUD+C55Tad8xi3areARQ4GV8WjTaCjncj8hONEA@mail.gmail.com>
	<CAFTL4hz5OzFGfhsj2bNR+76VrpXCxyDtN6fqC1cYF3zpJpjOTg@mail.gmail.com>
	<CAKfTPtAq4GWoc8oOaUt17ZePfa4PMq7NvPEZYrqo2cvDpGwsWQ@mail.gmail.com>
	<CAFTL4hx6BGEotYH4yBH8UYDJYyxLAa56KT0ahAtke97rMKaw=A@mail.gmail.com>
	<CAKfTPtBsk9s-w0A-uMMJuHY=_1y8WhdkArRxN=Jk0qtQwPZyDQ@mail.gmail.com>
	<20130227161326.GA25559@somewhere>
Date: Wed, 27 Feb 2013 17:45:54 +0100
Message-ID: <CAKfTPtAvffA+PucnHFga1o0uVaX=9Eqedrfks08ha0LAmTNWLg@mail.gmail.com>
Subject: Re: [PATCH v4] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org,
        efault@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2013 17:13, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Feb 27, 2013 at 09:28:26AM +0100, Vincent Guittot wrote:
>> > Ok I don't like having a per cpu state in struct sched domain but for
>> > now I can't find anything better. So my suggestion is that we do this
>> > and describe well the race, define the issue in the changelog and code
>> > comments and explain how we are solving it. This way at least the
>> > issue is identified and known. Then later, on review or after the
>> > patch is upstream, if somebody with some good taste comes with a
>> > better idea, we consider it.
>> >
>> > What do you think?
>>
>> I don't have better solution than adding this state in the
>> sched_domain if we want to keep the exact same behavior. This will be
>> a bit of waste of mem because we don't need to update all sched_domain
>> level (1st level is enough).
>
> Or you can try something like the below. Both flags and sched_domain share the same
> object here so the same RCU lifecycle. And there shouldn't be more overhead there
> since accessing rq->sd_rq.sd is the same than rq->sd_rq in the ASM level: only
> one pointer to dereference.

your proposal solves the waste of memory and keeps the sync between
flag and nr_busy. I'm going to try it

Thanks

>
> Also rq_idle becomes a separate value from rq->nohz_flags. It's a simple boolean
> (just making it an int here because boolean size are a bit opaque, although they
> are supposed to be char, let's just avoid surprises in structures).
>
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index cc03cfd..16c0d55 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -417,7 +417,10 @@ struct rq {
>
>  #ifdef CONFIG_SMP
>         struct root_domain *rd;
> -       struct sched_domain *sd;
> +       struct sched_domain_rq {
> +               struct sched_domain sd;
> +               int rq_idle;
> +       } __rcu *sd_rq;
>
>         unsigned long cpu_power;
>
> @@ -505,9 +508,14 @@ DECLARE_PER_CPU(struct rq, runqueues);
>
>  #ifdef CONFIG_SMP
>
> -#define rcu_dereference_check_sched_domain(p) \
> -       rcu_dereference_check((p), \
> -                             lockdep_is_held(&sched_domains_mutex))
> +#define rcu_dereference_check_sched_domain(p) ({\
> +       struct sched_domain_rq *__sd_rq = rcu_dereference_check((p),    \
> +                               lockdep_is_held(&sched_domains_mutex)); \
> +       if (!__sd_rq)                                                   \
> +               NULL;                                                   \
> +       else                                                            \
> +               &__sd_rq->sd;                                           \
> +})
>
>  /*
>   * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
> @@ -517,7 +525,7 @@ DECLARE_PER_CPU(struct rq, runqueues);
>   * preempt-disabled sections.
>   */
>  #define for_each_domain(cpu, __sd) \
> -       for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); \
> +       for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd_rq); \
>                         __sd; __sd = __sd->parent)
>
>  #define for_each_lower_domain(sd) for (; sd; sd = sd->child)
>
