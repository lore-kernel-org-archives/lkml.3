Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab3KZUF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:05:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50130 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758049Ab3KZUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:05:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianyu.lan@intel.com, nm@ti.com,
        jinchoi@broadcom.com, sebastian.capella@linaro.org
Subject: Re: [PATCH V2 1/2] cpufreq: suspend governors on system suspend/hibernate
Date: Tue, 26 Nov 2013 21:18:42 +0100
Message-ID: <9179214.Tbesu8t5px@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131126193902.GA2481@amd.pavel.ucw.cz>
References: <cover.1385118255.git.viresh.kumar@linaro.org> <e4bc55fac6bc68694e9905cc3cc6844173b64925.1385118256.git.viresh.kumar@linaro.org> <20131126193902.GA2481@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 08:39:02 PM Pavel Machek wrote:
> Hi!
> 
> > This patch adds cpufreq callbacks to dpm_{suspend|resume}_noirq() for handling
> > suspend/resume of cpufreq governors. This is required for early suspend and late
> > resume of governors.
> > 
> > There are multiple problems that are fixed by this patch:
> > - Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
> >   wasn't working well with suspend/resume as calls for removing non-boot CPUs
> >   was turning out into a call to drivers ->target() which then tries to play
> >   with regulators. But regulators and their I2C bus were already suspended and
> >   this resulted in a failure. This is why we need a PM notifier here.
> > - Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found another issue where
> >   tunables configuration for clusters/sockets with non-boot CPUs was getting
> >   lost after suspend/resume, as we were notifying governors with
> >   CPUFREQ_GOV_POLICY_EXIT on removal of the last cpu for that policy and so
> >   deallocating memory for tunables.
> > 
> > +/*
> > + * Callbacks for suspending/resuming governors as some platforms can't change
> > + * frequency after this point in suspend cycle. Because some of the devices
> > + * (like: i2c, regulators, etc) they use for changing frequency are suspended
> > + * quickly after this point.
> > + */
> > +void cpufreq_suspend(void)
> > +{
> > +	struct cpufreq_policy *policy;
> > +	unsigned long flags;
> > +
> > +	if (!has_target())
> > +		return;
> > +
> > +	pr_debug("%s: Suspending Governors\n", __func__);
> > +
> > +	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
> > +		if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
> > +			pr_err("%s: Failed to stop governor for policy: %p\n",
> > +					__func__, policy);
> 
> So... we freeze frequencies in whatever state they are, yes?

Yes.  The idea was to do that after suspending devices in which case it wouldn't
matter so much.  But Viresh always has to complicate things.

> Should we go to some specific frequency?

If that is done where it is done, yes, we should.

Thanks,
Rafael

