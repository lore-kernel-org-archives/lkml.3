Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3IAUQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 16:16:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50598 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab3IAUQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:16:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
Date: Sun, 01 Sep 2013 22:27:08 +0200
Message-ID: <2163175.MrORytQUnh@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpon1VsoUnw=t0c9wQ2Zfva5nnXoKjNNNxLXV7Frto1BFug@mail.gmail.com>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <11222156.oKTjYXFZjG@vostro.rjw.lan> <CAKohpon1VsoUnw=t0c9wQ2Zfva5nnXoKjNNNxLXV7Frto1BFug@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 01, 2013 09:30:49 PM Viresh Kumar wrote:
> On 1 September 2013 18:58, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, September 01, 2013 10:56:02 AM Viresh Kumar wrote:
> >> We can't take a big lock around __cpufreq_governor() as this causes recursive
> >> locking for some cases. But calls to this routine must be serialized for every
> >> policy.
> >
> > Care to explain here why it must be serialized?
> 
> Yes, added that to the attached patches (Added reported-by too):
> 
> commit dc51771506b113b998c49c3be2db0fb88bb92153
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Sat Aug 31 17:48:23 2013 +0530
> 
>     cpufreq: serialize calls to __cpufreq_governor()
> 
>     We can't take a big lock around __cpufreq_governor() as this
> causes recursive
>     locking for some cases. But calls to this routine must be
> serialized for every
>     policy. Otherwise we can see some unpredictable events.
> 
>     For example, consider following scenario:
> 
>     __cpufreq_remove_dev()
>      __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>        policy->governor->governor(policy, CPUFREQ_GOV_STOP);
>         cpufreq_governor_dbs()
>          case CPUFREQ_GOV_STOP:
>           mutex_destroy(&cpu_cdbs->timer_mutex)
>           cpu_cdbs->cur_policy = NULL;
>       <PREEMPT>
>     store()
>      __cpufreq_set_policy()
>       __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>         policy->governor->governor(policy, CPUFREQ_GOV_LIMITS);
>          case CPUFREQ_GOV_LIMITS:
>           mutex_lock(&cpu_cdbs->timer_mutex); <-- Warning (destroyed mutex)
>            if (policy->max < cpu_cdbs->cur_policy->cur) <- cur_policy == NULL
> 
>     And so store() will eventually result in a crash cur_policy is already NULL;
> 
>     Lets introduce another variable which would guarantee serialization here.
> 
>    Reported-by: Stephen Boyd <sboyd@codeaurora.org>
>    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> >> Lets introduce another variable which would guarantee serialization here.
> >>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >> ---
> >>  drivers/cpufreq/cpufreq.c | 7 ++++++-
> >>  include/linux/cpufreq.h   | 1 +
> >>  2 files changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> >> index f320a20..4d5723db 100644
> >> --- a/drivers/cpufreq/cpufreq.c
> >> +++ b/drivers/cpufreq/cpufreq.c
> >> @@ -1692,13 +1692,15 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
> >>                                               policy->cpu, event);
> >>
> >>       mutex_lock(&cpufreq_governor_lock);
> >> -     if ((policy->governor_enabled && (event == CPUFREQ_GOV_START)) ||
> >> +     if (policy->governor_busy ||
> >> +             (policy->governor_enabled && (event == CPUFREQ_GOV_START)) ||
> >
> > Again, broken white space, but I can fix it up.
> 
> Sorry, what exactly.. Sorry couldn't understand it :(

The second tab is one too many, I usually write such things like this:

	if (policy->governor_busy
	    || (policy->governor_enabled && event == CPUFREQ_GOV_START)
	    || ...

Then it is much easier to distinguish the conditional code from the condition
itself.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
