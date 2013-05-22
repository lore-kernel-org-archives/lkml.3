Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3EVP5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:57:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52415 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3EVP5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:57:03 -0400
Date: Wed, 22 May 2013 16:56:58 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH 11/14] sched: filter task pull request
Message-ID: <20130522155658.GB4935@e103034-lin>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
 <1366910611-20048-12-git-send-email-vincent.guittot@linaro.org>
 <CAKfTPtCUvKmTHzyVRCkGyM-nWOSWP8OUzMgyCyzPEXf1NoxsQQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKfTPtCUvKmTHzyVRCkGyM-nWOSWP8OUzMgyCyzPEXf1NoxsQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 22 May 2013 15:56:58.0205 (UTC) FILETIME=[FD5588D0:01CE5704]
X-MC-Unique: 113052216570105301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:00:58AM +0100, Vincent Guittot wrote:
> Part of this patch is missing, the fix below is needed
> 
> @@ -3497,7 +3497,9 @@ static bool is_buddy_full(int cpu)
>  static bool is_my_buddy(int cpu, int buddy)
>  {
>   int my_buddy = per_cpu(sd_pack_buddy, cpu);
> - return (my_buddy == -1) || (buddy == my_buddy);
> +
> + return ((sysctl_sched_packing_mode == SCHED_PACKING_FULL) &&
> +               ((my_buddy == -1) || (buddy == my_buddy)));
>  }
> 
>  static bool is_light_task(struct task_struct *p)
> 
> 
> On 25 April 2013 19:23, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> > Only CPUs that participates to the packing effort can pull tasks on a busiest
> > group.
> >
> > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > ---
> >  kernel/sched/fair.c |   14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 28f8ea7..6f63fb9 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -3494,6 +3494,12 @@ static bool is_buddy_full(int cpu)
> >         return (sum * 1024 >= period * 1000);
> >  }
> >
> > +static bool is_my_buddy(int cpu, int buddy)
> > +{
> > +       int my_buddy = per_cpu(sd_pack_buddy, cpu);
> > +       return (my_buddy == -1) || (buddy == my_buddy);
> > +}

Would it make sense to change the function name to something like
is_packing_target() and only have one argument?

is_my_buddy() is only used with the same variable for both arguments
like below.

> > +
> >  static bool is_light_task(struct task_struct *p)
> >  {
> >         /* A light task runs less than 20% in average */
> > @@ -4688,8 +4694,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
> >
> >                 /* Bias balancing toward cpus of our domain */
> >                 if (local_group) {
> > -                       if (idle_cpu(i) && !first_idle_cpu &&
> > -                                       cpumask_test_cpu(i, sched_group_mask(group))) {
> > +                       if (is_my_buddy(i, i) && idle_cpu(i) && !first_idle_cpu
> > +                        && cpumask_test_cpu(i, sched_group_mask(group))) {
> >                                 first_idle_cpu = 1;
> >                                 balance_cpu = i;
> >                         }
> > @@ -4817,6 +4823,10 @@ static void update_plb_buddy(int cpu, int *balance, struct sd_lb_stats *sds,
> >
> >         /* Get my new buddy */
> >         buddy = per_cpu(sd_pack_buddy, cpu);
> > +
> > +       /* This CPU doesn't act for agressive packing */
> > +       if (buddy != cpu)
> > +               sds->busiest = 0;

sds->busiest is a pointer, so I think it should be assigned to NULL
instead of 0.

Morten

> >  }
> >
> >  /**
> > --
> > 1.7.9.5
> >
> 

