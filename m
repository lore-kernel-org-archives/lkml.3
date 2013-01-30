Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3A3JPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:15:10 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48900 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3A3JPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:15:04 -0500
Date: Wed, 30 Jan 2013 10:14:53 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/5] cpufreq: handle SW coordinated CPUs
Message-ID: <20130130091453.GA32315@balto.lan>
References: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
 <1356620142-8680-2-git-send-email-fabio.baltieri@linaro.org>
 <CAOh2x==SG32h-BbrnLN8gwiYNz7bS-REVcmXN67fdYPqFVmCiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x==SG32h-BbrnLN8gwiYNz7bS-REVcmXN67fdYPqFVmCiA@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Viresh,

On Wed, Jan 30, 2013 at 12:33:40PM +0530, Viresh Kumar wrote:
> I am starting to follow cpufreq patches religiously now and so have to come
> back to this old thread due to some crash we got :)
> 
> Its still not pushed upstream, so better to get it resolved before 3.9.

Definitely, that's what we have -next for!

> On Thu, Dec 27, 2012 at 8:25 PM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> 
> > diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> 
> >  static inline void dbs_timer_init(struct dbs_data *dbs_data,
> > -               struct cpu_dbs_common_info *cdbs, unsigned int sampling_rate)
> > +                                 struct cpu_dbs_common_info *cdbs,
> > +                                 unsigned int sampling_rate,
> > +                                 int cpu)
> >  {
> >         int delay = delay_for_sampling_rate(sampling_rate);
> > +       struct cpu_dbs_common_info *cdbs_local = dbs_data->get_cpu_cdbs(cpu);
> 
> I couldn't understand the real need for this, as it should really give
> back the same
> pointer pointed out by: cdbs and hence no need of cpu in params too..
> 
> I may be wrong here :)

You are actually right.  This comes from the first version of the patch
(I basically rewrote it after the common code rafactoring), and cdbs was
meant to be always the one for the master CPU while cpu should indicate
the one being initialized.  Then the thing turned out as:

A - I dropped the code specific for master cdbs here as it was already
there on another code path following the rafactoring.
B - I passed j_cdbs = dbs_data->get_cpu_cdbs(j) in the init cycle while
it was really meant to be get_cpu_cdbs(cpu).

> >
> > -       INIT_DEFERRABLE_WORK(&cdbs->work, dbs_data->gov_dbs_timer);
> > -       schedule_delayed_work_on(cdbs->cpu, &cdbs->work, delay);
> > +       schedule_delayed_work_on(cpu, &cdbs_local->work, delay);
> >  }
> >
> >  static inline void dbs_timer_exit(struct cpu_dbs_common_info *cdbs)
> > @@ -217,6 +227,10 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
> >                         if (ignore_nice)
> >                                 j_cdbs->prev_cpu_nice =
> >                                         kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> > +
> > +                       mutex_init(&j_cdbs->timer_mutex);
> > +                       INIT_DEFERRABLE_WORK(&j_cdbs->work,
> > +                                            dbs_data->gov_dbs_timer);
> >                 }
> >
> >                 /*
> > @@ -275,15 +289,33 @@ second_time:
> >                 }
> >                 mutex_unlock(&dbs_data->mutex);
> >
> > -               mutex_init(&cpu_cdbs->timer_mutex);
> > -               dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate);
> > +               if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
> > +                       for_each_cpu(j, policy->cpus) {
> > +                               struct cpu_dbs_common_info *j_cdbs;
> > +
> > +                               j_cdbs = dbs_data->get_cpu_cdbs(j);
> > +                               dbs_timer_init(dbs_data, j_cdbs,
> > +                                              *sampling_rate, j);
> > +                       }
> > +               } else {
> > +                       dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate, cpu);
> > +               }
> 
> do you really need this else part? In case of uniprocessor systems also, the if
> block should be enough. Isn't it?

Same reason, get_cpu_cdbs(j) was meant to be get_cpu_cdbs(cpu) but
that's not used anymore in the last version of the patch, and the same
for the last hunk.

I'll send a patch to clean this up, thanks for spotting it!

Fabio

> >                 break;
> >
> >         case CPUFREQ_GOV_STOP:
> >                 if (dbs_data->governor == GOV_CONSERVATIVE)
> >                         cs_dbs_info->enable = 0;
> >
> > -               dbs_timer_exit(cpu_cdbs);
> > +               if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
> > +                       for_each_cpu(j, policy->cpus) {
> > +                               struct cpu_dbs_common_info *j_cdbs;
> > +
> > +                               j_cdbs = dbs_data->get_cpu_cdbs(j);
> > +                               dbs_timer_exit(j_cdbs);
> > +                       }
> > +               } else {
> > +                       dbs_timer_exit(cpu_cdbs);
> > +               }
> 
> ditto.

-- 
Fabio Baltieri
