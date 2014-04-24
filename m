Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaDXLRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:17:36 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:48203 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbaDXLRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:17:33 -0400
Date: Thu, 24 Apr 2014 14:17:29 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc2: longhaul cpufreq stalls tasks for 120s+
In-Reply-To: <CAKohpo=Lzzj5eki3644-ESB+P39+Q-ARFqN-S+_HM5UB802W3g@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1404241417120.13595@math.ut.ee>
References: <alpine.SOC.1.00.1404241249480.13595@math.ut.ee> <CAKohpoktwh=SgHTfEgT7vYRVWHssXw7==+a9qAdtmJXepjT2Tw@mail.gmail.com> <alpine.SOC.1.00.1404241316290.13595@math.ut.ee> <CAKohpo=Lzzj5eki3644-ESB+P39+Q-ARFqN-S+_HM5UB802W3g@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 24 April 2014 15:46, Meelis Roos <mroos@linux.ee> wrote:
> > I can add debug to where needed and try it.
> 
> I am quite sure below wouldn't fix it, but just wanted to check
> for the corner case :(
> 
> Can you please try attached patch (mail's content would be
> broken):

Did not help. Will try lock debugging now.

> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index abda660..7198e23 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -355,10 +355,12 @@ void cpufreq_freq_transition_begin(struct
> cpufreq_policy *policy,
>                 struct cpufreq_freqs *freqs)
>  {
>  wait:
> +       smp_mb();
>         wait_event(policy->transition_wait, !policy->transition_ongoing);
> 
>         spin_lock(&policy->transition_lock);
> 
> +       smp_mb();
>         if (unlikely(policy->transition_ongoing)) {
>                 spin_unlock(&policy->transition_lock);
>                 goto wait;
> @@ -380,8 +382,11 @@ void cpufreq_freq_transition_end(struct
> cpufreq_policy *policy,
> 
>         cpufreq_notify_post_transition(policy, freqs, transition_failed);
> 
> +       smp_mb();
> +
>         policy->transition_ongoing = false;
> 
> +       smp_mb();
>         wake_up(&policy->transition_wait);
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_freq_transition_end);
> 

-- 
Meelis Roos (mroos@linux.ee)
