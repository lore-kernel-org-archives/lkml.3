Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaAFBCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:02:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56816 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752411AbaAFBCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:02:17 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/5] cpufreq: Introduce cpufreq_notify_post_transition()
Date: Mon, 06 Jan 2014 02:16:03 +0100
Message-ID: <3190393.X74mkhqobq@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <a6668c7fa63d67ca33b9e59d0189cd99a2ddcd05.1385962178.git.viresh.kumar@linaro.org>
References: <a6668c7fa63d67ca33b9e59d0189cd99a2ddcd05.1385962178.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 02, 2013 11:04:12 AM Viresh Kumar wrote:
> This introduces another routine cpufreq_notify_post_transition() which can be
> used to send POSTCHANGE notification for new freq with or without both
> {PRE|POST}CHANGE notifications for last freq. This is useful at multiple places,
> specially for sending transition failure notifications.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

I've queued this series up for 3.14, but I folded patches [3-5/5] into [2/5]
(and needed to rebase the unicore2 changes).

Every time you want to copy-paste the changelog from one patch to another
(please don't do that any more) you should rather think about sending a
combination of the two as one patch.

Thanks!

> ---
> 
> V1->V2:
> - Not required to push it for 3.13 anymore and can go in 3.14.
> - Rebased over following patchset as there were conflicts in unicore2 driver if
>   following patchset is applied first (which should be the case):
>   https://lkml.org/lkml/2013/10/30/553 (create cpufreq_generic_get() routine)
> 
>  drivers/cpufreq/cpufreq.c | 14 ++++++++++++++
>  include/linux/cpufreq.h   |  2 ++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 5e27def..3b877d4 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -338,6 +338,20 @@ void cpufreq_notify_transition(struct cpufreq_policy *policy,
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
>  
> +/* Do post notifications when there are chances that transition has failed */
> +void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
> +		struct cpufreq_freqs *freqs, int transition_failed)
> +{
> +	cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
> +	if (!transition_failed)
> +		return;
> +
> +	swap(freqs->old, freqs->new);
> +	cpufreq_notify_transition(policy, freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
> +
>  
>  /*********************************************************************
>   *                          SYSFS INTERFACE                          *
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 276e646..b26bfab 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -316,6 +316,8 @@ int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
>  
>  void cpufreq_notify_transition(struct cpufreq_policy *policy,
>  		struct cpufreq_freqs *freqs, unsigned int state);
> +void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
> +		struct cpufreq_freqs *freqs, int transition_failed);
>  
>  #else /* CONFIG_CPU_FREQ */
>  static inline int cpufreq_register_notifier(struct notifier_block *nb,
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
