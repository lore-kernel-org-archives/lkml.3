Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3K0B3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:29:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60984 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754813Ab3K0B3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:29:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH V3 1/6] cpufreq: suspend governors on system suspend/hibernate
Date: Wed, 27 Nov 2013 02:42:27 +0100
Message-ID: <4787675.sJF8mqYyxv@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <4253729.doK7ubnxKx@vostro.rjw.lan>
References: <cover.1385374819.git.viresh.kumar@linaro.org> <CAKohpok0E=m=63KXM22usiW7Rsu59cD7Q=+k3tRcW=8269tZnQ@mail.gmail.com> <4253729.doK7ubnxKx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 09:23:15 PM Rafael J. Wysocki wrote:
> On Tuesday, November 26, 2013 07:56:19 AM Viresh Kumar wrote:
> > On 26 November 2013 04:59, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > >> @@ -1259,6 +1262,8 @@ int dpm_suspend(pm_message_t state)
> > >>
> > >>       might_sleep();
> > >>
> > >> +     cpufreq_suspend();
> > >> +
> > >>
> > >>       mutex_lock(&dpm_list_mtx);
> > >>       pm_transition = state;
> > >>       async_error = 0;
> > >
> > > Shouldn't it do cpufreq_resume() on errors?
> > 
> > Yes and this is already done I believe. In case dpm_suspend() fails,
> > dpm_resume() gets called. Isn't it?
> 
> OK
> 
> > >> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > >> +void cpufreq_suspend(void)
> > >> +{
> > >> +     struct cpufreq_policy *policy;
> > >> +
> > >> +     if (!has_target())
> > >> +             return;
> > >> +
> > >> +     pr_debug("%s: Suspending Governors\n", __func__);
> > >> +
> > >> +     list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
> > >> +             if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
> > >> +                     pr_err("%s: Failed to stop governor for policy: %p\n",
> > >> +                                     __func__, policy);
> > >
> > > This appears to be racy.  Is it really racy, or just seemingly?
> > 
> > Why does it look racy to you? Userspace should be frozen by now,
> > policy_list should be stable as well as nobody would touch it.
> 
> You're stopping governors while they may be in use in principle.  Do we have
> suitable synchronization in place for that?

Anyway, if you did what I asked you to do and put the cpufreq suspend/resume
into dpm_suspend/resume_noirq(), I'd probably take this for 3.13.  However,
since you've decided to put those things somewhere else thus making the
change much more intrusive, I can only queue it up for 3.14.

This means I'm going to take the Tianyu's patch as a stop gap for 3.13.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
