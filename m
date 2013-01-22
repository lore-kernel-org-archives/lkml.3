Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3AVIDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:03:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50937 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3AVIDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:03:21 -0500
Message-ID: <1358841795.5782.255.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Tue, 22 Jan 2013 09:03:15 +0100
In-Reply-To: <50FE0ADC.6060701@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:co6VLa1yv8cszRrJ9nQo0lAA3KlcgYzjAckh9b67VOV
 vaFhQxtU4wyy+g5C1+DhUXeUfXco4xmJVCZZHDW//0TLnTAefv
 xJtAYNyFL9j/KrcyHgplNObNeXO0zFXM4O61SIh+dU8bQVrjKg
 l/nEgI6+VHRUZa+fsReeBv0RErPR36YFnRZX9cRDdk+JDihLM4
 b+Emlhu2JK4KnKCUz4SbDRZEAnisGM8Hsvbd4pVIJDAzScAmoR
 4J7b4EwZkvpAx3Twhp1YAey2DoAXKPEJhf9ciPulAAUU690dS1
 YW3ISpj5qqn5kd8d4xrnbH5q9K0FjeUf53zsykBsDZkAZbWvDO
 QelLvvAKAbPFZ14eKtad3Jm9vne2mFVRoN2yDwLX4SsKz4ImOZ
 gJOWJa0iPwVKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 11:43 +0800, Michael Wang wrote: 
> On 01/21/2013 05:44 PM, Mike Galbraith wrote:
> > On Mon, 2013-01-21 at 17:22 +0800, Michael Wang wrote: 
> >> On 01/21/2013 05:09 PM, Mike Galbraith wrote:
> >>> On Mon, 2013-01-21 at 15:45 +0800, Michael Wang wrote: 
> >>>> On 01/21/2013 03:09 PM, Mike Galbraith wrote:
> >>>>> On Mon, 2013-01-21 at 07:42 +0100, Mike Galbraith wrote: 
> >>>>>> On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:
> >>>>>
> >>>>>>> May be we could try change this back to the old way later, after the aim
> >>>>>>> 7 test on my server.
> >>>>>>
> >>>>>> Yeah, something funny is going on.
> >>>>>
> >>>>> Never entering balance path kills the collapse.  Asking wake_affine()
> >>>>> wrt the pull as before, but allowing us to continue should no idle cpu
> >>>>> be found, still collapsed.  So the source of funny behavior is indeed in
> >>>>> balance_path.
> >>>>
> >>>> Below patch based on the patch set could help to avoid enter balance path
> >>>> if affine_sd could be found, just like the old logical, would you like to
> >>>> take a try and see whether it could help fix the collapse?
> >>>
> >>> No, it does not.
> >>
> >> Hmm...what have changed now compared to the old logical?
> > 
> > What I did earlier to confirm the collapse originates in balance_path is
> > below.  I just retested to confirm.
> > 
> > Tasks    jobs/min  jti  jobs/min/task      real       cpu
> >     1      435.34  100       435.3448     13.92      3.76   Mon Jan 21 10:24:00 2013
> >     1      440.09  100       440.0871     13.77      3.76   Mon Jan 21 10:24:22 2013
> >     1      440.41  100       440.4070     13.76      3.75   Mon Jan 21 10:24:45 2013
... 
> > 
> > That was with your change backed out, and the q/d below applied.
> 
> So that change will help to solve the issue? good to know :)
> 
> But it will invoke wake_affine() with out any delay, the benefit
> of the patch set will be reduced a lot...

Yeah, I used size large hammer.

> I think this change help to solve the issue because it avoid jump
> into balance path when wakeup for any cases, I think we can do
> some change like below to achieve this and meanwhile gain benefit
> from delay wake_affine().

Yup, I killed it all the way dead.  I'll see what below does.

I don't really see the point of the wake_affine() change in this set
though.  Its purpose is to decide if a pull is ok or not.  If we don't
need its opinion when we look for an (momentarily?) idle core in
this_domain, we shouldn't need it at all, and could just delete it.  If
we ever enter balance_path, we can't possibly induce imbalance without
there being something broken in that path, no?

BTW, it could well be that an unpatched kernel will collapse as well if
WAKE_BALANCE is turned on.  I've never tried that on a largish box, as
doing any of the wakeup time optional stuff used to make tbench scream.

> Since the issue could not been reproduced on my side, I don't know
> whether the patch benefit or not, so if you are willing to send out
> a formal patch, I would be glad to include it in my patch set ;-)

Just changing to scan prev_cpu before considering pulling would put a
big dent in the bouncing cow problem, but that's the intriguing thing
about this set.. can we have the tbench and pgbench big box gain without
a lot of pain to go with it?  Small boxen will surely benefit, pretty
much can't be hurt, but what about all those fast/light tasks that won't
hop across nodes to red hot data?

No formal patch is likely to result from any testing I do atm at least.
I'm testing your patches because I see potential, I really want it to
work out, but have to see it do that with my own two beady eyeballs ;-)

> And another patch below below is a debug one, which will print out
> all the sbm info, so we could check whether it was initialized
> correctly, just use command "dmesg | grep WYT" to show the map.
> 
> Regards,
> Michael Wang
> 
> ---
>  kernel/sched/fair.c |   42 +++++++++++++++++++++++++-----------------
>  1 files changed, 25 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2aa26c1..4361333 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3250,7 +3250,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>  }
> 
>  /*
> - * Try and locate an idle CPU in the sched_domain.
> + * Try and locate an idle CPU in the sched_domain, return -1 if failed.
>   */
>  static int select_idle_sibling(struct task_struct *p, int target)
>  {
> @@ -3292,13 +3292,13 @@ static int select_idle_sibling(struct task_struct *p, int target)
> 
>                         target = cpumask_first_and(sched_group_cpus(sg),
>                                         tsk_cpus_allowed(p));
> -                       goto done;
> +                       return target;
>  next:
>                         sg = sg->next;
>                 } while (sg != sd->groups);
>         }
> -done:
> -       return target;
> +
> +       return -1;
>  }
> 
>  /*
> @@ -3342,40 +3342,48 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>                  * may has already been cached on prev_cpu, and usually
>                  * they require low latency.
>                  *
> -                * So firstly try to locate an idle cpu shared the cache
> +                * Therefor, balance path in such case will cause damage
> +                * and bring benefit synchronously, wakeup on prev_cpu
> +                * may better than wakeup on a new lower load cpu for the
> +                * cached memory, and we never know.
> +                *
> +                * So the principle is, try to find an idle cpu as close to
> +                * prev_cpu as possible, if failed, just take prev_cpu.
> +                *
> +                * Firstly try to locate an idle cpu shared the cache
>                  * with prev_cpu, it has the chance to break the load
>                  * balance, fortunately, select_idle_sibling() will search
>                  * from top to bottom, which help to reduce the chance in
>                  * some cases.
>                  */
>                 new_cpu = select_idle_sibling(p, prev_cpu);
> -               if (idle_cpu(new_cpu))
> +               if (new_cpu != -1)
>                         goto unlock;
> 
>                 /*
>                  * No idle cpu could be found in the topology of prev_cpu,
> -                * before jump into the slow balance_path, try search again
> -                * in the topology of current cpu if it is the affine of
> -                * prev_cpu.
> +                * before take the prev_cpu, try search again in the
> +                * topology of current cpu if it is the affine of prev_cpu.
>                  */
> -               if (cpu == prev_cpu ||
> -                               !sbm->affine_map[prev_cpu] ||
> +               if (cpu == prev_cpu || !sbm->affine_map[prev_cpu] ||
>                                 !cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
> -                       goto balance_path;
> +                       goto take_prev;
> 
>                 new_cpu = select_idle_sibling(p, cpu);
> -               if (!idle_cpu(new_cpu))
> -                       goto balance_path;
> -
>                 /*
>                  * Invoke wake_affine() finally since it is no doubt a
>                  * performance killer.
>                  */
> -               if (wake_affine(sbm->affine_map[prev_cpu], p, sync))
> +               if ((new_cpu != -1) &&
> +                       wake_affine(sbm->affine_map[prev_cpu], p, sync))
>                         goto unlock;
> +
> +take_prev:
> +               new_cpu = prev_cpu;
> +               goto unlock;
>         }
> 
> -balance_path:
> +       /* Balance path. */
>         new_cpu = (sd_flag & SD_BALANCE_WAKE) ? prev_cpu : cpu;
>         sd = sbm->sd[type][sbm->top_level[type]];
> 
> -- 
> 1.7.4.1
> 
> DEBUG PATCH:
> 
> ---
>  kernel/sched/core.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0c63303..f251f29 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5578,6 +5578,35 @@ static void update_top_cache_domain(int cpu)
>  static int sbm_max_level;
>  DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);
> 
> +static void debug_sched_balance_map(int cpu)
> +{
> +       int i, type, level = 0;
> +       struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
> +
> +       printk("WYT: sbm of cpu %d\n", cpu);
> +
> +       for (type = 0; type < SBM_MAX_TYPE; type++) {
> +               if (type == SBM_EXEC_TYPE)
> +                       printk("WYT: \t exec map\n");
> +               else if (type == SBM_FORK_TYPE)
> +                       printk("WYT: \t fork map\n");
> +               else if (type == SBM_WAKE_TYPE)
> +                       printk("WYT: \t wake map\n");
> +
> +               for (level = 0; level < sbm_max_level; level++) {
> +                       if (sbm->sd[type][level])
> +                               printk("WYT: \t\t sd %x, idx %d, level %d, weight %d\n", sbm->sd[type][level], level, sbm->sd[type][level]->level, sbm->sd[type][level]->span_weight);
> +               }
> +       }
> +
> +       printk("WYT: \t affine map\n");
> +
> +       for_each_possible_cpu(i) {
> +               if (sbm->affine_map[i])
> +                       printk("WYT: \t\t affine with cpu %x in sd %x, weight %d\n", i, sbm->affine_map[i], sbm->affine_map[i]->span_weight);
> +       }
> +}
> +
>  static void build_sched_balance_map(int cpu)
>  {
>         struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
> @@ -5688,6 +5717,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
>          * destroy_sched_domains() already do the work.
>          */
>         build_sched_balance_map(cpu);
> +       debug_sched_balance_map(cpu);
>         rcu_assign_pointer(rq->sbm, sbm);
>  }
> 


