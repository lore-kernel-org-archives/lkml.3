Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab3CVLwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:52:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33370 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab3CVLwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:52:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Robin Randhawa <robin.randhawa@arm.com>, linux-pm@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Steve Bannister <Steve.Bannister@arm.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Subject: Re: [PATCH] cpufreq: stats: do cpufreq_cpu_put() corresponding to cpufreq_cpu_get
Date: Fri, 22 Mar 2013 12:59:42 +0100
Message-ID: <38998218.UX7TkEXzYs@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAP245DWx_C0wcW-9SCfR0ViqyyqNbAeZnWfeMiXSgRGupo9jWQ@mail.gmail.com>
References: <234906745c34fb72b0c450d897f261a22ed18d40.1363947023.git.viresh.kumar@linaro.org> <CAP245DWx_C0wcW-9SCfR0ViqyyqNbAeZnWfeMiXSgRGupo9jWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 04:42:57 PM Amit Kucheria wrote:
> On Fri, Mar 22, 2013 at 3:43 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > In cpufreq_stats_free_sysfs() we aren't balancing calls to cpufreq_cpu_get()
> > with cpufreq_cpu_put(). This will never let us have ref count to policy->kobj as
> > zero.
> 
> Rafael,
> 
> Since this prevents booting on our hardware (we unregister and
> re-register the cpufreq driver to account for virtual cores), will
> this be considered as a hotfix for 3.9?

Sure.  Can you please remind me what hardware is that, though?

Rafael


> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Acked-by: Amit Kucheria <amit.kucheria@linaro.org>
> 
> > ---
> >  drivers/cpufreq/cpufreq_stats.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> > index 2fd779e..bfd6273 100644
> > --- a/drivers/cpufreq/cpufreq_stats.c
> > +++ b/drivers/cpufreq/cpufreq_stats.c
> > @@ -180,15 +180,19 @@ static void cpufreq_stats_free_sysfs(unsigned int cpu)
> >  {
> >         struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> >
> > -       if (!cpufreq_frequency_get_table(cpu))
> > +       if (!policy)
> >                 return;
> >
> > -       if (policy && !policy_is_shared(policy)) {
> > +       if (!cpufreq_frequency_get_table(cpu))
> > +               goto put_ref;
> > +
> > +       if (!policy_is_shared(policy)) {
> >                 pr_debug("%s: Free sysfs stat\n", __func__);
> >                 sysfs_remove_group(&policy->kobj, &stats_attr_group);
> >         }
> > -       if (policy)
> > -               cpufreq_cpu_put(policy);
> > +
> > +put_ref:
> > +       cpufreq_cpu_put(policy);
> >  }
> >
> >  static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
> > --
> > 1.7.12.rc2.18.g61b472e
> >
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
