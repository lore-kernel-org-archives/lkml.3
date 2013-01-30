Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3A3Qqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:46:34 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:52788 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab3A3Qqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:46:31 -0500
Date: Wed, 30 Jan 2013 17:46:14 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/4] cpufreq: ondemand: call dbs_check_cpu only when
 necessary
Message-ID: <20130130164614.GC30559@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
 <1359550803-18577-3-git-send-email-fabio.baltieri@linaro.org>
 <CAKohpok0iDffNM31W2r97Wtq4DR+TdPwYWTAdJH7AyLqHm0UPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpok0iDffNM31W2r97Wtq4DR+TdPwYWTAdJH7AyLqHm0UPA@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 09:21:41PM +0530, Viresh Kumar wrote:
> On 30 January 2013 18:30, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > Modify ondemand timer to not resample CPU utilization if recently
> > sampled from another SW coordinated core.
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> 
> I might be wrong but i have some real concerns over this patch.
> 
> This is what i believe is your idea:
> - because a cpu can sleep, create timer per cpu
> - then check load again only when no other cpu in policy->cpus has
>   checked load within sampling time interval.
> 
> Correct?

Yes.

> > ---
> >  drivers/cpufreq/cpufreq_governor.c |  3 ++
> >  drivers/cpufreq/cpufreq_governor.h |  1 +
> >  drivers/cpufreq/cpufreq_ondemand.c | 58 +++++++++++++++++++++++++++++++-------
> >  3 files changed, 52 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> > index 8393d6e..46f96a4 100644
> > --- a/drivers/cpufreq/cpufreq_governor.c
> > +++ b/drivers/cpufreq/cpufreq_governor.c
> > @@ -289,6 +289,9 @@ second_time:
> >                 }
> >                 mutex_unlock(&dbs_data->mutex);
> >
> > +               /* Initiate timer time stamp */
> > +               cpu_cdbs->time_stamp = ktime_get();
> 
> We have updated time_stamp only for policy->cpu's cdbs.

Yes, see below.

> >                 for_each_cpu(j, policy->cpus)
> >                         dbs_timer_init(dbs_data, j, *sampling_rate);
> >                 break;
> 
> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> > index 93bb56d..13ceb3c 100644
> > --- a/drivers/cpufreq/cpufreq_ondemand.c
> > +++ b/drivers/cpufreq/cpufreq_ondemand.c
> > @@ -216,23 +216,23 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
> >         }
> >  }
> >
> > -static void od_dbs_timer(struct work_struct *work)
> > +static void od_timer_update(struct od_cpu_dbs_info_s *dbs_info, bool sample,
> > +                           struct delayed_work *dw)
> >  {
> > -       struct od_cpu_dbs_info_s *dbs_info =
> > -               container_of(work, struct od_cpu_dbs_info_s, cdbs.work.work);
> >         unsigned int cpu = dbs_info->cdbs.cpu;
> >         int delay, sample_type = dbs_info->sample_type;
> >
> > -       mutex_lock(&dbs_info->cdbs.timer_mutex);
> > -
> >         /* Common NORMAL_SAMPLE setup */
> >         dbs_info->sample_type = OD_NORMAL_SAMPLE;
> >         if (sample_type == OD_SUB_SAMPLE) {
> >                 delay = dbs_info->freq_lo_jiffies;
> > -               __cpufreq_driver_target(dbs_info->cdbs.cur_policy,
> > -                       dbs_info->freq_lo, CPUFREQ_RELATION_H);
> > +               if (sample)
> > +                       __cpufreq_driver_target(dbs_info->cdbs.cur_policy,
> > +                                               dbs_info->freq_lo,
> > +                                               CPUFREQ_RELATION_H);
> >         } else {
> > -               dbs_check_cpu(&od_dbs_data, cpu);
> > +               if (sample)
> > +                       dbs_check_cpu(&od_dbs_data, cpu);
> >                 if (dbs_info->freq_lo) {
> >                         /* Setup timer for SUB_SAMPLE */
> >                         dbs_info->sample_type = OD_SUB_SAMPLE;
> > @@ -243,11 +243,49 @@ static void od_dbs_timer(struct work_struct *work)
> >                 }
> >         }
> >
> > -       schedule_delayed_work_on(smp_processor_id(), &dbs_info->cdbs.work,
> > -                       delay);
> > +       schedule_delayed_work_on(smp_processor_id(), dw, delay);
> > +}
> 
> All good until now.
> 
> > +
> > +static void od_timer_coordinated(struct od_cpu_dbs_info_s *dbs_info_local,
> > +                                struct delayed_work *dw)
> > +{
> > +       struct od_cpu_dbs_info_s *dbs_info;
> > +       ktime_t time_now;
> > +       s64 delta_us;
> > +       bool sample = true;
> > +
> 
> --start--
> 
> > +       /* use leader CPU's dbs_info */
> > +       dbs_info = &per_cpu(od_cpu_dbs_info, dbs_info_local->cdbs.cpu);
> > +       mutex_lock(&dbs_info->cdbs.timer_mutex);
> > +
> > +       time_now = ktime_get();
> > +       delta_us = ktime_us_delta(time_now, dbs_info->cdbs.time_stamp);
> > +
> > +       /* Do nothing if we recently have sampled */
> > +       if (delta_us < (s64)(od_tuners.sampling_rate / 2))
> > +               sample = false;
> > +       else
> > +               dbs_info->cdbs.time_stamp = time_now;
> > +
> 
> --end--
> 
> Instead of two routines (this and the one below), we can have one and can
> put the above code in the if (coordinated cpus case). That will save some
> redundant code.

Ok but then you have two dbs_infos mixing up in the same code and it
start to become harder to read (first version was with a single function
I think).

> Another issue that i see is: Current routine will be called from timer handler
> of every cpu and so above calculations will happen for every cpu. Here, you
> are taking the diff of last timestamp of cpu "x" with cpu "x" current timestamp,
> but what you should have really done is the diff b/w current timestamp with
> the timestamp of last change on any cpu in policy->cpus.

Isn't that how it works now?  The current cpu ktime is not checked
against its own, but against the "leader" cpu (dbs_info_local->cdbs.cpu),
that's why it's initialized only for the first.

Maybe I should have used dbs_info_leader/dbs_info instead of
dbs_info_local/dbs_info.

> Over that, timestamp for all cpu's isn't initialized early in the code
> at GOV_START.
> 
> Am i correct?

As above.

Fabio

> > +       od_timer_update(dbs_info, sample, dw);
> >         mutex_unlock(&dbs_info->cdbs.timer_mutex);
> >  }
> >
> > +static void od_dbs_timer(struct work_struct *work)
> > +{
> > +       struct delayed_work *dw = to_delayed_work(work);
> > +       struct od_cpu_dbs_info_s *dbs_info =
> > +               container_of(work, struct od_cpu_dbs_info_s, cdbs.work.work);
> > +
> > +       if (dbs_sw_coordinated_cpus(&dbs_info->cdbs)) {
> > +               od_timer_coordinated(dbs_info, dw);
> > +       } else {
> > +               mutex_lock(&dbs_info->cdbs.timer_mutex);
> > +               od_timer_update(dbs_info, true, dw);
> > +               mutex_unlock(&dbs_info->cdbs.timer_mutex);
> > +       }
> > +}
> > +

-- 
Fabio Baltieri
