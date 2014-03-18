Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaCRFoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:44:15 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:57161 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaCRFoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <1394831037-15553-3-git-send-email-dirk.j.brandewie@intel.com>
References: <16035918.jZXKnQ3yiq@vostro.rjw.lan>
	<1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com>
	<1394831037-15553-3-git-send-email-dirk.j.brandewie@intel.com>
Date: Tue, 18 Mar 2014 11:14:12 +0530
X-Google-Sender-Auth: puMRs7izjMRavyxYTqyIrHTS5qs
Message-ID: <CAOh2x=kFC5cwdYVgFCwNgqZAwWaE-CFQoyYizBuv1W6MOnQ9DA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] intel_pstate: Set core to min P state during core offline
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrick Marlier <patrick.marlier@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 2:33 AM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>
> Change to use ->stop() callback to do clean up during CPU
> hotplug. The requested P state for an offline core will be used by the
> hardware coordination function to select the package P state. If the
> core is under load when it is offlined it will fix the package P state
> floor to the requested P state of offline core.
>
> Reported-by: Patrick Marlier <patrick.marlier@gmail.com>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/intel_pstate.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 2cd36b9..e9092fd 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -447,7 +447,7 @@ static void core_set_pstate(struct cpudata *cpudata, int pstate)
>         if (limits.no_turbo)
>                 val |= (u64)1 << 32;
>
> -       wrmsrl(MSR_IA32_PERF_CTL, val);
> +       wrmsrl_on_cpu(cpudata->cpu, MSR_IA32_PERF_CTL, val);
>  }
>
>  static struct cpu_defaults core_params = {
> @@ -773,16 +773,22 @@ static int intel_pstate_verify_policy(struct cpufreq_policy *policy)
>         return 0;
>  }
>
> -static int intel_pstate_cpu_exit(struct cpufreq_policy *policy)
> +static int intel_pstate_cpu_stop(struct cpufreq_policy *policy)
>  {
> -       int cpu = policy->cpu;
> +       int cpu_num = policy->cpu;
> +       struct cpudata *cpu = all_cpu_data[cpu_num];
> +
> +       pr_info("intel_pstate CPU %d exiting\n", cpu_num);
> +
> +       del_timer(&all_cpu_data[cpu_num]->timer);
> +       intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
> +       kfree(all_cpu_data[cpu_num]);
> +       all_cpu_data[cpu_num] = NULL;
>
> -       del_timer(&all_cpu_data[cpu]->timer);
> -       kfree(all_cpu_data[cpu]);
> -       all_cpu_data[cpu] = NULL;
>         return 0;
>  }
>
> +
>  static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
>  {
>         struct cpudata *cpu;
> @@ -818,7 +824,7 @@ static struct cpufreq_driver intel_pstate_driver = {
>         .setpolicy      = intel_pstate_set_policy,
>         .get            = intel_pstate_get,
>         .init           = intel_pstate_cpu_init,
> -       .exit           = intel_pstate_cpu_exit,
> +       .stop           = intel_pstate_cpu_stop,

Probably, keep exit as is and only change P-state in stop(). So that
allocation of resources happen in init() and they are freed in exit()?
