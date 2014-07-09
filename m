Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaGIEAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:00:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:56258 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaGIEAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:00:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140709000701.GJ4603@linux.vnet.ibm.com>
References: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com> <20140709000701.GJ4603@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 9 Jul 2014 00:00:10 -0400
Message-ID: <CAJhHMCBS2y_f28UO6SOp7LjnX3owm+C5_qCjzYANEaU__8jxng@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of
 atomic_add_return(0, v)
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 8:07 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Jul 08, 2014 at 06:55:45PM -0400, Pranith Kumar wrote:
>> atomic_add_return() invalidates the cache line in other processors where-as
>> atomic_read does not. I don't see why we would need invalidation in this case.
>> If indeed it was need a comment would be helpful for readers. Otherwise doesn't
>> using atomic_read() make more sense here? RFC!
>>
>> replace atomic_add_return(0, v) with atomic_read(v) as the latter is better.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>
> This will break RCU -- the full memory barriers implied both before
> and after atomic_add_return() are needed in order for RCU to be able to
> avoid death due to memory reordering.
>
> That said, I have considered replacing the atomic_add_return() with:
>
>         smp_mb();
>         ... = atomic_read(...);
>         smp_mb();
>
> However, this is a very ticklish change, and would need serious thought
> and even more serious testing.
>

Thank you for looking at the RFC. I tried understanding the code
deeper and found that the ordering which is needed here is actually on
dynticks_snap.
The ordering currently (by way of atomic_add_return) is on
rdp->dynticks->dynticks which I think is not right.

Looking at the history of the code led me to rev. 23b5c8fa01b723 which
makes me think that the above statement is true. I think providing
ordering guarantees on dynticks_snap should be enough.

I have added an updated patch below. However, it is really hard(and
error prone) to convince oneself that this is right. So I will not
pursue this further if you think this is wrong. You definitely know
better than me :)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1b70cb6..bbccd0a 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -891,7 +891,7 @@ static int rcu_is_cpu_rrupt_from_idle(void)
 static int dyntick_save_progress_counter(struct rcu_data *rdp,
                                         bool *isidle, unsigned long *maxj)
 {
-       rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
+       smp_store_release(&rdp->dynticks_snap,
atomic_read(&rdp->dynticks->dynticks));
        rcu_sysidle_check_cpu(rdp, isidle, maxj);
        if ((rdp->dynticks_snap & 0x1) == 0) {
                trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, TPS("dti"));
@@ -920,8 +920,8 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
        int *rcrmp;
        unsigned int snap;

-       curr = (unsigned int)atomic_add_return(0, &rdp->dynticks->dynticks);
-       snap = (unsigned int)rdp->dynticks_snap;
+       curr = (unsigned int)atomic_read(&rdp->dynticks->dynticks);
+       snap = (unsigned int)smp_load_acquire(&rdp->dynticks_snap);

        /*
         * If the CPU passed through or entered a dynticks idle phase with


-- 
Pranith
