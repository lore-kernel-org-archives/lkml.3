Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3F0MGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:06:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53179 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3F0MGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:06:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Subject: Re: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
Date: Thu, 27 Jun 2013 14:15:35 +0200
Message-ID: <6169955.66kyyKnUeH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomGNSA4Pyg6Pn2SiawXPe=wMU7hx0Y7phjfNDV8J+JrLw@mail.gmail.com>
References: <cover.1371630975.git.viresh.kumar@linaro.org> <2081161.dnl1xTqcUT@vostro.rjw.lan> <CAKohpomGNSA4Pyg6Pn2SiawXPe=wMU7hx0Y7phjfNDV8J+JrLw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 27, 2013 10:26:27 AM Viresh Kumar wrote:
> On 27 June 2013 03:27, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Well, now, seeing that the locking around this seems to be kind of haphazard,
> > I'm wondering what prevents two different threads from doing CPUFREQ_PRECHANGE
> > concurrently in such a way that thread A will check transition_ongoing
> > and thread B will check transition_ongoing and then both will set it if it
> > was 'false' before.  And then one of them will trigger the WARN() in
> > CPUFREQ_POSTCHANGE.
> >
> > Is there any protection in place and if so then how does it work?
> 
> cpufreq_notify_transition() is called from driver->target() which is
> called from __cpufreq_driver_target(). __cpufreq_driver_target()
> is called directly by governors and cpufreq_driver_target() otherwise.
> 
> cpufreq_driver_target() implements proper locking and so it is fine.
> __cpufreq_driver_target() is called from governors. From governors
> it is is serialized in the sense two threads wouldn't call it at the same
> time.
> 
> And so I thought this will work. But I just found a mistake in my code.
> For multi-socket platforms with clock domains for sockets/clusters,
> a single instance of transition_ongoing isn't enough and so this must
> be embedded in struct cpufreq_policy.
> 
> Below patch must get this fixed (Attached).
> 
> -------------x---------------------x-----------------
> 
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Wed, 19 Jun 2013 10:16:55 +0530
> Subject: [PATCH] cpufreq: make sure frequency transitions are serialized
> 
> Whenever we are changing frequency of a cpu, we are calling PRECHANGE and
> POSTCHANGE notifiers. They must be serialized. i.e. PRECHANGE or POSTCHANGE
> shouldn't be called twice contiguously.
> 
> This can happen due to bugs in users of __cpufreq_driver_target() or actual
> cpufreq drivers who are sending these notifiers.
> 
> This patch adds some protection against this. Now, we keep track of the last
> transaction and see if something went wrong.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

OK, queued up for 3.11.

Thanks,
Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 14 ++++++++++++++
>  include/linux/cpufreq.h   |  1 +
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2d53f47..75715f1 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -264,6 +264,12 @@ void __cpufreq_notify_transition(struct
> cpufreq_policy *policy,
>  	switch (state) {
> 
>  	case CPUFREQ_PRECHANGE:
> +		if (WARN(policy->transition_ongoing,
> +				"In middle of another frequency transition\n"))
> +			return;
> +
> +		policy->transition_ongoing = true;
> +
>  		/* detect if the driver reported a value as "old frequency"
>  		 * which is not equal to what the cpufreq core thinks is
>  		 * "old frequency".
> @@ -283,6 +289,12 @@ void __cpufreq_notify_transition(struct
> cpufreq_policy *policy,
>  		break;
> 
>  	case CPUFREQ_POSTCHANGE:
> +		if (WARN(!policy->transition_ongoing,
> +				"No frequency transition in progress\n"))
> +			return;
> +
> +		policy->transition_ongoing = false;
> +
>  		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
>  		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
>  			(unsigned long)freqs->cpu);
> @@ -1458,6 +1470,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
> 
>  	if (cpufreq_disabled())
>  		return -ENODEV;
> +	if (policy->transition_ongoing)
> +		return -EBUSY;
> 
>  	/* Make sure that target_freq is within supported range */
>  	if (target_freq > policy->max)
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 037d36a..8c13a45 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -115,6 +115,7 @@ struct cpufreq_policy {
> 
>  	struct kobject		kobj;
>  	struct completion	kobj_unregister;
> +	bool			transition_ongoing; /* Tracks transition status */
>  };
> 
>  #define CPUFREQ_ADJUST			(0)
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
