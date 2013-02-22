Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3BVMeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:34:22 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:59453 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3BVMeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:34:21 -0500
Date: Fri, 22 Feb 2013 13:34:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Lists LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] cpustat: use accessor functions for get/set/add
Message-ID: <20130222123412.GB17948@somewhere.redhat.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
 <1361512604-2720-2-git-send-email-khilman@linaro.org>
 <CAOh2x=kFL5_H=LqLf14yxYQEs7zSTT8Ue8mjUEVN4_a0c53Rdg@mail.gmail.com>
 <CAP245DVYsjgvww-3qBnbZ4T7SsJ=whbVvhf06fArxcspyX9bwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP245DVYsjgvww-3qBnbZ4T7SsJ=whbVvhf06fArxcspyX9bwQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 12:47:33PM +0530, Amit Kucheria wrote:
> On Fri, Feb 22, 2013 at 11:51 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On Fri, Feb 22, 2013 at 11:26 AM, Kevin Hilman <khilman@linaro.org> wrote:
> >> Add some accessor functions in order to facilitate the conversion to
> >> atomic reads/writes of cpustat values.
> >>
> >> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> >> ---
> >>  drivers/cpufreq/cpufreq_governor.c | 18 ++++++++---------
> >>  drivers/cpufreq/cpufreq_ondemand.c |  2 +-
> >
> >> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> >> index 6c5f1d3..ec6c315 100644
> >> --- a/drivers/cpufreq/cpufreq_governor.c
> >> +++ b/drivers/cpufreq/cpufreq_governor.c
> >> @@ -36,12 +36,12 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
> >>
> >>         cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
> >>
> >> -       busy_time = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
> >> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
> >> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
> >> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
> >> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
> >> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
> >> +       busy_time = kcpustat_cpu_get(cpu, CPUTIME_USER);
> >> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_SYSTEM);
> >> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_IRQ);
> >> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_SOFTIRQ);
> >> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_STEAL);
> >> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_NICE);
> >>
> >>         idle_time = cur_wall_time - busy_time;
> >>         if (wall)
> >> @@ -103,7 +103,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
> >>                         u64 cur_nice;
> >>                         unsigned long cur_nice_jiffies;
> >>
> >> -                       cur_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE] -
> >> +                       cur_nice = kcpustat_cpu_get(j, CPUTIME_NICE) -
> >>                                          cdbs->prev_cpu_nice;
> >>                         /*
> >>                          * Assumption: nice time between sampling periods will
> >> @@ -113,7 +113,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
> >>                                         cputime64_to_jiffies64(cur_nice);
> >>
> >>                         cdbs->prev_cpu_nice =
> >> -                               kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> >> +                               kcpustat_cpu_get(j, CPUTIME_NICE);
> >>                         idle_time += jiffies_to_usecs(cur_nice_jiffies);
> >>                 }
> >>
> >> @@ -216,7 +216,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
> >>                                         &j_cdbs->prev_cpu_wall);
> >>                         if (ignore_nice)
> >>                                 j_cdbs->prev_cpu_nice =
> >> -                                       kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> >> +                                       kcpustat_cpu_get(j, CPUTIME_NICE);
> >>                 }
> >>
> >>                 /*
> >> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> >> index 7731f7c..ac5d49f 100644
> >> --- a/drivers/cpufreq/cpufreq_ondemand.c
> >> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> >> @@ -403,7 +403,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
> >>                                                 &dbs_info->cdbs.prev_cpu_wall);
> >>                 if (od_tuners.ignore_nice)
> >>                         dbs_info->cdbs.prev_cpu_nice =
> >> -                               kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> >> +                               kcpustat_cpu_get(j, CPUTIME_NICE);
> >>
> >>         }
> >>         return count;
> >
> > For cpufreq:
> >
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> >
> > Though i believe you also need this:
> >
> > diff --git a/drivers/cpufreq/cpufreq_conservative.c
> > b/drivers/cpufreq/cpufreq_conservative.c
> > index 64ef737..38e3ad7 100644
> > --- a/drivers/cpufreq/cpufreq_conservative.c
> > +++ b/drivers/cpufreq/cpufreq_conservative.c
> > @@ -242,7 +242,7 @@ static ssize_t store_ignore_nice_load(struct
> > kobject *a, struct attribute *b,
> >                                                 &dbs_info->cdbs.prev_cpu_wall);
> >                 if (cs_tuners.ignore_nice)
> >                         dbs_info->cdbs.prev_cpu_nice =
> > -                               kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> > +                               kcpustat_cpu_get(j, CPUTIME_NICE);
> >         }
> >         return count;
> >  }
> >
> > BTW, i don't see kcpustat_cpu() used in
> >
> >  kernel/sched/core.c                | 12 +++++-------
> >  kernel/sched/cputime.c             | 29 +++++++++++++--------------
> >
> > I searched tip/master as well as lnext/master.
> 
> Added by Frederic's Adaptive NOHZ patchset?

No, Kevin has been using kcpustat_this_cpu_set() from kernel/sched/cputime.c. That's
because it's always written locally.
