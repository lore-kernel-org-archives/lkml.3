Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3FDLsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:48:52 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55622 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3FDLsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130604111900.GB14973@somewhere>
References: <1369927385-7801-1-git-send-email-vincent.guittot@linaro.org>
	<20130603224836.GA9388@somewhere>
	<CAKfTPtCB_ftNWjgAM9s79dX_tuS4yevjdD0YxvKfKS4dxz=LLQ@mail.gmail.com>
	<20130604093611.GJ8923@twins.programming.kicks-ass.net>
	<20130604102620.GB14012@somewhere>
	<CAKfTPtCLYnhQH3Mcx5dhRi9+9_679fdrhm8iZBSpgyu8VmevYw@mail.gmail.com>
	<20130604111900.GB14973@somewhere>
Date: Tue, 4 Jun 2013 13:48:47 +0200
Message-ID: <CAKfTPtCSr-M3ZLNF0NoHuSQTC1sP8wWo-m+hRttL3nZ1iCOHgA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix clear NOHZ_BALANCE_KICK
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2013 13:19, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Jun 04, 2013 at 01:11:47PM +0200, Vincent Guittot wrote:
>> On 4 June 2013 12:26, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > On Tue, Jun 04, 2013 at 11:36:11AM +0200, Peter Zijlstra wrote:
>> >>
>> >> The best I can seem to come up with is something like the below; but I think
>> >> its ghastly. Surely we can do something saner with that bit.
>> >>
>> >> Having to clear it at 3 different places is just wrong.
>> >
>> > We could clear the flag early in scheduler_ipi() and set some
>> > specific value in rq->idle_balance that tells we want nohz idle
>> > balancing from the softirq, something like this untested:
>>
>> I'm not sure that we can have less than 2 places to clear it: cancel
>> place or acknowledge place otherwise we can face a situation where
>> idle load balance will be triggered 2 consecutive times because
>> NOHZ_BALANCE_KICK will be cleared before the idle load balance has
>> been done and had a chance to migrate tasks.
>
> I guess it depends what is the minimum value of rq->next_balance, it seems
> to be large enough to avoid this kind of incident. Although I don't
> know well the whole logic with rq->next_balance and ilb trigger so I must
> defer to you.

In the trace that was showing the issue, i can see that both CPU0 and
CPU1 were trying to trig ILB almost simultaneously and the
test_and_set NOHZ_BALANCE_KICK filters one request so i would say that
clearing the bit before the end of the idle load balance sequence can
generate such sequence

In the sequence below, i have minimized the clear of NOHZ_BALANCE_KICK
in 2 places : acknowledge and cancel. I have reused part of the
proposal from peter which clears the bit if the condition doesn't
match but i have reordered the tests to done that only if all other
condition are matching

 static inline bool got_nohz_idle_kick(void)
 {
- int cpu = smp_processor_id();
- return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+ bool nohz_kick = test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+
+       if (!nohz_kick)
+               return false;
+
+       if (idle_cpu(cpu) && !need_resched())
+               return true;
+
+       clear_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+       return false;
 }

 #else /* CONFIG_NO_HZ_COMMON */
@@ -1393,8 +1401,9 @@ static void sched_ttwu_pending(void)

 void scheduler_ipi(void)
 {
- if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
-    && !tick_nohz_full_cpu(smp_processor_id()))
+ if (llist_empty(&this_rq()->wake_list)
+ && !tick_nohz_full_cpu(smp_processor_id())
+ && !got_nohz_idle_kick())
  return;

  /*
@@ -1417,7 +1426,7 @@ void scheduler_ipi(void)
  /*
  * Check if someone kicked us for doing the nohz idle load balance.
  */
- if (unlikely(got_nohz_idle_kick() && !need_resched())) {
+ if (unlikely(got_nohz_idle_kick())) {
  this_rq()->idle_balance = 1;
  raise_softirq_irqoff(SCHED_SOFTIRQ);
  }
