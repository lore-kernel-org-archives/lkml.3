Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaFJF1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:27:10 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46887 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbaFJF1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <5396207D.7030704@semaphore.gr>
References: <5396207D.7030704@semaphore.gr>
Date: Tue, 10 Jun 2014 10:57:06 +0530
Message-ID: <CAKohpokYB4oKxrEwHH888T5hg=zrpb0PCs_QKTLS0bd-_fqeTA@mail.gmail.com>
Subject: Re: [PATCH 4/7] cpufreq: intel_pstate: Simplify code in intel_pstate_adjust_busy_pstate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2014 02:30, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Simplify the code by removing the inline functions
> pstate_increase and pstate_decrease and use directly the
> intel_pstate_set_pstate.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/intel_pstate.c | 26 +++-----------------------
>  1 file changed, 3 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 3a49269..26a0262 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -588,21 +588,6 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
>         pstate_funcs.set(cpu, pstate);
>  }
>
> -static inline void intel_pstate_pstate_increase(struct cpudata *cpu, int steps)
> -{
> -       int target;
> -       target = cpu->pstate.current_pstate + steps;
> -
> -       intel_pstate_set_pstate(cpu, target);
> -}
> -
> -static inline void intel_pstate_pstate_decrease(struct cpudata *cpu, int steps)
> -{
> -       int target;
> -       target = cpu->pstate.current_pstate - steps;
> -       intel_pstate_set_pstate(cpu, target);
> -}
> -
>  static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
>  {
>         cpu->pstate.min_pstate = pstate_funcs.get_min();
> @@ -695,20 +680,15 @@ static inline void intel_pstate_calc_scaled_busy(struct cpudata *cpu)
>  static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
>  {
>         struct _pid *pid;
> -       signed int ctl = 0;
> -       int steps;
> +       signed int ctl;
>
>         pid = &cpu->pid;
>         intel_pstate_calc_scaled_busy(cpu);
>
>         ctl = pid_calc(pid, cpu->sample.busy_scaled);
>
> -       steps = abs(ctl);
> -
> -       if (ctl < 0)
> -               intel_pstate_pstate_increase(cpu, steps);
> -       else
> -               intel_pstate_pstate_decrease(cpu, steps);
> +       /* Negative values of ctl increase the pstate and vice versa */
> +       intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate - ctl);
>  }

I am not very good at this driver but there is some obvious functional
change here. Earlier we used to pass
'cpu->pstate.current_pstate {-|+} steps' and now you are doing '-ctl' only
