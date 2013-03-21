Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3CUXrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:47:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59508 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932882Ab3CUXrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:47:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 linux-next] cpufreq: governors: Calculate iowait time only when necessary
Date: Fri, 22 Mar 2013 00:54:58 +0100
Message-ID: <1776032.T2F0vtOmT3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponkj++4AkW__i7vWykURkAkgiHGLMX973KWMjQw9sTQYg@mail.gmail.com>
References: <512E45E9.5020801@semaphore.gr> <512F8C7C.2020101@semaphore.gr> <CAKohponkj++4AkW__i7vWykURkAkgiHGLMX973KWMjQw9sTQYg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 01, 2013 09:18:08 AM Viresh Kumar wrote:
> On 28 February 2013 22:27, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> > Currently we always calculate the CPU iowait time and add it to idle time.
> > If we are in ondemand and we use io_is_busy, we re-calculate iowait time
> > and we subtract it from idle time.
> >
> > With this patch iowait time is calculated only when necessary avoiding
> > the double call to get_cpu_iowait_time_us. We use a parameter in
> > function get_cpu_idle_time to distinguish when the iowait time will be
> > added to idle time or not, without the need of keeping the prev_io_wait.
> >
> > Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> > ---
> >  drivers/cpufreq/cpufreq_conservative.c |  2 +-
> >  drivers/cpufreq/cpufreq_governor.c     | 46 +++++++++++++---------------------
> >  drivers/cpufreq/cpufreq_governor.h     |  3 +--
> >  drivers/cpufreq/cpufreq_ondemand.c     | 11 +++++++-
> >  4 files changed, 29 insertions(+), 33 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> > index 4fd0006..dfe652c 100644
> > --- a/drivers/cpufreq/cpufreq_conservative.c
> > +++ b/drivers/cpufreq/cpufreq_conservative.c
> > @@ -242,7 +242,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
> >                 struct cs_cpu_dbs_info_s *dbs_info;
> >                 dbs_info = &per_cpu(cs_cpu_dbs_info, j);
> >                 dbs_info->cdbs.prev_cpu_idle = get_cpu_idle_time(j,
> > -                                               &dbs_info->cdbs.prev_cpu_wall);
> > +                                       &dbs_info->cdbs.prev_cpu_wall, 0);
> >                 if (cs_tuners.ignore_nice)
> >                         dbs_info->cdbs.prev_cpu_nice =
> >                                 kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> > diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> > index 5a76086..a322bda 100644
> > --- a/drivers/cpufreq/cpufreq_governor.c
> > +++ b/drivers/cpufreq/cpufreq_governor.c
> > @@ -50,13 +50,13 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
> >         return cputime_to_usecs(idle_time);
> >  }
> >
> > -u64 get_cpu_idle_time(unsigned int cpu, u64 *wall)
> > +u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
> >  {
> >         u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
> >
> >         if (idle_time == -1ULL)
> >                 return get_cpu_idle_time_jiffy(cpu, wall);
> > -       else
> > +       else if (!io_busy)
> >                 idle_time += get_cpu_iowait_time_us(cpu, wall);
> >
> >         return idle_time;
> > @@ -83,13 +83,22 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
> >         /* Get Absolute Load (in terms of freq for ondemand gov) */
> >         for_each_cpu(j, policy->cpus) {
> >                 struct cpu_dbs_common_info *j_cdbs;
> > -               u64 cur_wall_time, cur_idle_time, cur_iowait_time;
> > -               unsigned int idle_time, wall_time, iowait_time;
> > +               u64 cur_wall_time, cur_idle_time;
> > +               unsigned int idle_time, wall_time;
> >                 unsigned int load;
> > +               int io_busy = 0;
> >
> >                 j_cdbs = dbs_data->get_cpu_cdbs(j);
> >
> > -               cur_idle_time = get_cpu_idle_time(j, &cur_wall_time);
> > +               /*
> > +                * For the purpose of ondemand, waiting for disk IO is
> > +                * an indication that you're performance critical, and
> > +                * not that the system is actually idle. So do not add
> > +                * the iowait time to the cpu idle time.
> > +                */
> > +               if (dbs_data->governor == GOV_ONDEMAND)
> > +                       io_busy = od_tuners->io_is_busy;
> > +               cur_idle_time = get_cpu_idle_time(j, &cur_wall_time, io_busy);
> >
> >                 wall_time = (unsigned int)
> >                         (cur_wall_time - j_cdbs->prev_cpu_wall);
> > @@ -117,29 +126,6 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
> >                         idle_time += jiffies_to_usecs(cur_nice_jiffies);
> >                 }
> >
> > -               if (dbs_data->governor == GOV_ONDEMAND) {
> > -                       struct od_cpu_dbs_info_s *od_j_dbs_info =
> > -                               dbs_data->get_cpu_dbs_info_s(cpu);
> > -
> > -                       cur_iowait_time = get_cpu_iowait_time_us(j,
> > -                                       &cur_wall_time);
> > -                       if (cur_iowait_time == -1ULL)
> > -                               cur_iowait_time = 0;
> > -
> > -                       iowait_time = (unsigned int) (cur_iowait_time -
> > -                                       od_j_dbs_info->prev_cpu_iowait);
> > -                       od_j_dbs_info->prev_cpu_iowait = cur_iowait_time;
> > -
> > -                       /*
> > -                        * For the purpose of ondemand, waiting for disk IO is
> > -                        * an indication that you're performance critical, and
> > -                        * not that the system is actually idle. So subtract the
> > -                        * iowait time from the cpu idle time.
> > -                        */
> > -                       if (od_tuners->io_is_busy && idle_time >= iowait_time)
> > -                               idle_time -= iowait_time;
> > -               }
> > -
> >                 if (unlikely(!wall_time || wall_time < idle_time))
> >                         continue;
> >
> > @@ -207,6 +193,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
> >         struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
> >         struct cpu_dbs_common_info *cpu_cdbs;
> >         unsigned int *sampling_rate, latency, ignore_nice, j, cpu = policy->cpu;
> > +       int io_busy = 0;
> >         int rc;
> >
> >         cpu_cdbs = dbs_data->get_cpu_cdbs(cpu);
> > @@ -221,6 +208,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
> >                 sampling_rate = &od_tuners->sampling_rate;
> >                 ignore_nice = od_tuners->ignore_nice;
> >                 od_ops = dbs_data->gov_ops;
> > +               io_busy = od_tuners->io_is_busy;
> >         }
> >
> >         switch (event) {
> > @@ -237,7 +225,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
> >                         j_cdbs->cpu = j;
> >                         j_cdbs->cur_policy = policy;
> >                         j_cdbs->prev_cpu_idle = get_cpu_idle_time(j,
> > -                                       &j_cdbs->prev_cpu_wall);
> > +                                              &j_cdbs->prev_cpu_wall, io_busy);
> >                         if (ignore_nice)
> >                                 j_cdbs->prev_cpu_nice =
> >                                         kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> > diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> > index d2ac911..534dfae 100644
> > --- a/drivers/cpufreq/cpufreq_governor.h
> > +++ b/drivers/cpufreq/cpufreq_governor.h
> > @@ -87,7 +87,6 @@ struct cpu_dbs_common_info {
> >
> >  struct od_cpu_dbs_info_s {
> >         struct cpu_dbs_common_info cdbs;
> > -       u64 prev_cpu_iowait;
> >         struct cpufreq_frequency_table *freq_table;
> >         unsigned int freq_lo;
> >         unsigned int freq_lo_jiffies;
> > @@ -169,7 +168,7 @@ static inline int delay_for_sampling_rate(unsigned int sampling_rate)
> >         return delay;
> >  }
> >
> > -u64 get_cpu_idle_time(unsigned int cpu, u64 *wall);
> > +u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy);
> >  void dbs_check_cpu(struct dbs_data *dbs_data, int cpu);
> >  bool need_load_eval(struct cpu_dbs_common_info *cdbs,
> >                 unsigned int sampling_rate);
> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> > index f3eb26c..74dd3ae 100644
> > --- a/drivers/cpufreq/cpufreq_ondemand.c
> > +++ b/drivers/cpufreq/cpufreq_ondemand.c
> > @@ -339,11 +339,20 @@ static ssize_t store_io_is_busy(struct kobject *a, struct attribute *b,
> >  {
> >         unsigned int input;
> >         int ret;
> > +       unsigned int j;
> >
> >         ret = sscanf(buf, "%u", &input);
> >         if (ret != 1)
> >                 return -EINVAL;
> >         od_tuners.io_is_busy = !!input;
> > +
> > +       /* we need to re-evaluate prev_cpu_idle */
> > +       for_each_online_cpu(j) {
> > +               struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info,
> > +                                                                       j);
> > +               dbs_info->cdbs.prev_cpu_idle = get_cpu_idle_time(j,
> > +                       &dbs_info->cdbs.prev_cpu_wall, od_tuners.io_is_busy);
> > +       }
> >         return count;
> >  }
> >
> > @@ -411,7 +420,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
> >                 struct od_cpu_dbs_info_s *dbs_info;
> >                 dbs_info = &per_cpu(od_cpu_dbs_info, j);
> >                 dbs_info->cdbs.prev_cpu_idle = get_cpu_idle_time(j,
> > -                                               &dbs_info->cdbs.prev_cpu_wall);
> > +                       &dbs_info->cdbs.prev_cpu_wall, od_tuners.io_is_busy);
> >                 if (od_tuners.ignore_nice)
> >                         dbs_info->cdbs.prev_cpu_nice =
> >                                 kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.,org>

Applied to linux-pm.git/bleeding-edge and will be moved to linux-next if there
are no build problems in the bleeding-edge branch.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
