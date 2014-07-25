Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbaGYTeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:34:21 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55444 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaGYTeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140725180632.GA6230@linux.vnet.ibm.com>
References: <1406248652-17416-1-git-send-email-bobby.prani@gmail.com>
 <1406248652-17416-2-git-send-email-bobby.prani@gmail.com> <20140725152551.GC11241@linux.vnet.ibm.com>
 <20140725180632.GA6230@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 25 Jul 2014 15:33:48 -0400
Message-ID: <CAJhHMCDVwn52YoZaGWpJ0X6N-2c63EJw9H6Br3dzts9cQUPo0w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] rcu: Check the return value of rcu_nocb_mask
 cpumask allocation
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 2:06 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Jul 25, 2014 at 08:25:51AM -0700, Paul E. McKenney wrote:
>> On Thu, Jul 24, 2014 at 08:37:32PM -0400, Pranith Kumar wrote:
>> > This commit checks the return value of the zalloc_cpumask_var() used for
>> > allocating cpumask for rcu_nocb_mask.
>> >
>> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>
>> Hmmm...  I saw the check in the previous patch, but didn't see removal
>> of the later have_rcu_nocb_mask check.  Please see below.
>
> And events overtook this one.  Turns out that commit b58cc46c5f6b
> (rcu: Don't offload callbacks unless specifically requested) was not
> one of my best efforts.
>
> I will adapt your patch 2/2 in this series and apply it with your
> Signed-off-by.  Patch 1/2 is obsoleted by the current fix for
> commit b58cc46c5f6b.
>

OK. I am curious to see what problem you found in that commit.
I look forward to see your updated patch.

>> > ---
>> > v2: no change from v1
>> >
>> >  kernel/rcu/tree_plugin.h | 23 ++++++++++++-----------
>> >  1 file changed, 12 insertions(+), 11 deletions(-)
>> >
>> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
>> > index 520538a..9c9a01c 100644
>> > --- a/kernel/rcu/tree_plugin.h
>> > +++ b/kernel/rcu/tree_plugin.h
>> > @@ -54,7 +54,10 @@ static void __init rcu_bootup_announce_oddness_nocb(void)
>> >  {
>> >  #ifndef CONFIG_RCU_NOCB_CPU_NONE
>> >     if (!have_rcu_nocb_mask) {
>> > -           zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
>> > +           if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
>> > +                   pr_info("rcu_nocb_mask allocation failed\n");
>> > +                   return;
>> > +           }
>> >             have_rcu_nocb_mask = true;
>> >     }
>> >  #ifdef CONFIG_RCU_NOCB_CPU_ZERO
>> > @@ -66,17 +69,15 @@ static void __init rcu_bootup_announce_oddness_nocb(void)
>> >     cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
>> >  #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
>> >  #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
>> > -   if (have_rcu_nocb_mask) {
>> > -           if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
>> > -                   pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
>> > -                   cpumask_and(rcu_nocb_mask, cpu_possible_mask,
>> > -                               rcu_nocb_mask);
>> > -           }
>> > -           cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
>> > -           pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
>> > -           if (rcu_nocb_poll)
>> > -                   pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
>> > +   if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
>>
>> What happens if CONFIG_RCU_NOCB_CPU_NONE=y and the rcu_nocbs= boot
>> parameter is not specified and we get here?
>>
>> In order to get visible failures when testing, build with
>> CONFIG_CPUMASK_OFFSTACK=y.
>>
>> > +           pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
>> > +           cpumask_and(rcu_nocb_mask, cpu_possible_mask,
>> > +                           rcu_nocb_mask);
>> >     }
>> > +   cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
>> > +   pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
>> > +   if (rcu_nocb_poll)
>> > +           pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
>> >  }
>> >
>> >  /*
>> > --
>> > 2.0.1
>> >
>



-- 
Pranith
