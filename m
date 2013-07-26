Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab3GZM0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:26:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41538 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757094Ab3GZM0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:26:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v6 2/8] cpufreq: Add boost frequency support in core
Date: Fri, 26 Jul 2013 14:36:08 +0200
Message-ID: <13618968.iglDI8cQ6h@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130726103321.21238bbb@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com> <20130726103321.21238bbb@amdc308.digital.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 26, 2013 10:33:21 AM Lukasz Majewski wrote:
> On Fri, 26 Jul 2013 12:47:15 +0530 Viresh Kumar wrote,
> > On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > 
> > >  /*********************************************************************
> > > + *
> > > BOOST                                              *
> > > +
> > > *********************************************************************/
> > > +static int cpufreq_boost_set_sw(int state) +{
> > > +       struct cpufreq_frequency_table *freq_table;
> > > +       struct cpufreq_policy *policy;
> > > +       int ret = -EINVAL;
> > > +
> > > +       list_for_each_entry(policy, &cpufreq_policy_list,
> > > policy_list) {
> > > +               freq_table =
> > > cpufreq_frequency_get_table(policy->cpu);
> > > +               if (freq_table) {
> > > +                       ret =
> > > cpufreq_frequency_table_cpuinfo(policy,
> > > +                                                       freq_table);
> > > +                       if (!ret) {
> > > +                               policy->user_policy.max =
> > > policy->max;
> > > +                               __cpufreq_governor(policy,
> > > CPUFREQ_GOV_LIMITS);
> > > +                       }
> > > +               }
> > > +       }
> > > +
> > > +       return ret;
> > > +}
> > > +
> > > +int cpufreq_boost_trigger_state(int state)
> > > +{
> > > +       unsigned long flags;
> > > +       int ret = 0;
> > > +
> > > +       if (cpufreq_driver->boost_enabled == state)
> > > +               return 0;
> > > +
> > > +       write_lock_irqsave(&cpufreq_driver_lock, flags);
> > > +       cpufreq_driver->boost_enabled = state;
> > > +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 	    ^^^^^^^^^^^^^^^^^^^^ [*]
> > 
> > Not sure if we should leave the lock at this point of time, as we
> > haven't enabled boost until now.
> 
> The problem here is with the cpufreq_driver->set_boost() call.
> 
> I tried to avoid acquiring lock at one function and release it at
> another (in this case cpufreq_boost_set_sw), especially since the
> __cpufreq_governor() acquires its own lock - good place for deadlock.
> 
> Is it OK for you to grab lock at one function
> (cpufreq_boost_trigger_state()) and then at other function
> (cpufreq_boost_set_sw) release it before calling __cpufreq_governor()
> and grab it again after its completion?

It generally is better to avoid doing that, although it is not unheard of.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
