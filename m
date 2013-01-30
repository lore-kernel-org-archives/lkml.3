Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3A3QXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:23:32 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:52896 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3A3QX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:23:28 -0500
Date: Wed, 30 Jan 2013 17:23:12 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>
Subject: Re: [PATCH v7 1/4] cpufreq: handle SW coordinated CPUs
Message-ID: <20130130162225.GB30559@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
 <1359550803-18577-2-git-send-email-fabio.baltieri@linaro.org>
 <CAKohponwQFFtC3MKh72Z0bqYksV_P6D07VivQUYjai1qPB_J9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponwQFFtC3MKh72Z0bqYksV_P6D07VivQUYjai1qPB_J9g@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Wed, Jan 30, 2013 at 08:32:38PM +0530, Viresh Kumar wrote:
> Hi Fabio,
> 
> I know Rafael has asked you to send only the incremental patch, but i
> am interested in reviewing whole series again, as i haven't reviewed
> earlier stuff :)

Sure, take your chance.

[internal note]
> I believe you are required to send patches to patches@linaro.org too :)

I already have patches@linaro.org in BCC, all my patches are there.
[/internal note]

> On 30 January 2013 18:30, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > From: Rickard Andersson <rickard.andersson@stericsson.com>
> >
> > This patch fixes a bug that occurred when we had load on a secondary CPU
> > and the primary CPU was sleeping. Only one sampling timer was spawned
> > and it was spawned as a deferred timer on the primary CPU, so when a
> > secondary CPU had a change in load this was not detected by the cpufreq
> > governor (both ondemand and conservative).
> >
> > This patch make sure that deferred timers are run on all CPUs in the
> > case of software controlled CPUs that run on the same frequency.
> 
> Its really a good point. I wondered earlier why does interactive governor
> has per-cpu timer. BTW, you can check how interactive governor is handling
> this requirement. That might improve these drivers too.
> 
> > diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> > +bool dbs_sw_coordinated_cpus(struct cpu_dbs_common_info *cdbs)
> > +{
> > +       struct cpufreq_policy *policy = cdbs->cur_policy;
> > +
> > +       return cpumask_weight(policy->cpus) > 1;
> > +}
> > +EXPORT_SYMBOL_GPL(dbs_sw_coordinated_cpus);
> 
> I believe this routine should be rather present in cpufreq core code,
> as their might
> be other users of it. Its really not related to dbs or governors.
> 
> My ideas about the name of routine then:
> - policy_is_shared()
> - or something better you have :)

So you are suggesting to rethink this function to be related to policy
rather than dbs... this may as well become an inline in cpufreq.h, as:

static inline bool policy_is_shared(struct cpufreq_policy *policy)
{
        return cpumask_weight(policy->cpus) > 1;
}

I'm not sure about the name through, I like mentioning sw coordination in it
because that's the comment in the declaration:

        cpumask_var_t           cpus;   /* CPUs requiring sw coordination */
        cpumask_var_t           related_cpus; /* CPUs with any coordination */

And those two are already confusing as a starting point.

Anyway, this sounds fine to me.  If you think this is useful I can send
a patch, or feel free to include it in your patches if you plan to do
further cleanup work on this code.

/me tries to also keep that ->cpu field in mind.

> > @@ -217,6 +227,10 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
> >                         if (ignore_nice)
> >                                 j_cdbs->prev_cpu_nice =
> >                                         kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> > +
> > +                       mutex_init(&j_cdbs->timer_mutex);
> > +                       INIT_DEFERRABLE_WORK(&j_cdbs->work,
> > +                                            dbs_data->gov_dbs_timer);
> 
> That doesn't look the right place for doing it. With this change we
> will initialize
> mutex and work for all cpus whenever cpufreq_governor_dbs(GOV_START) is
> called. We really want to do it just before second_time: label, which will do
> it only when this is called for the very first time or cpu.
> 
> That's what i thought initially :)
> 
> Then i looked at my own work and realized something else :).. Now, because
> we stop/start governors on every cpu movement, this routine is called only once.
> 
> What you can do:
> - Create a single for_each_cpu() in GOV_START path
> - Get rid of dbs_data->enable routine as we don't need to store the
> number of calls
>   for GOV_START.
> 
> >                 }
> >
> >                 /*
> > @@ -275,15 +289,16 @@ second_time:
> >                 }
> >                 mutex_unlock(&dbs_data->mutex);
> >
> > -               mutex_init(&cpu_cdbs->timer_mutex);
> > -               dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate);
> > +               for_each_cpu(j, policy->cpus)
> > +                       dbs_timer_init(dbs_data, j, *sampling_rate);
> 
> Keep this too in the same for_each_cpu() loop and hence get to older
> param types of dbs_timer_init(), i.e. don't pass cpu as we already have
> j_cdbs in our loop.

Ok, I can try to implement this if you help testing the patch on your bL
system. :-)

Fabio

> >                 break;
> >
> >         case CPUFREQ_GOV_STOP:
> >                 if (dbs_data->governor == GOV_CONSERVATIVE)
> >                         cs_dbs_info->enable = 0;
> >
> > -               dbs_timer_exit(cpu_cdbs);
> > +               for_each_cpu(j, policy->cpus)
> > +                       dbs_timer_exit(dbs_data, j);
> >
> >                 mutex_lock(&dbs_data->mutex);
> >                 mutex_destroy(&cpu_cdbs->timer_mutex);

-- 
Fabio Baltieri
