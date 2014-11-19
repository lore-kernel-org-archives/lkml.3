Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbaKSS6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:58:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:18160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbaKSS6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:58:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,418,1413270000"; 
   d="scan'208";a="639884035"
Date: Wed, 19 Nov 2014 10:58:31 -0800
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: <dirk.j.brandewie@intel.com>, <viresh.kumar@linaro.org>,
        <rjw@rjwysocki.net>, <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <ethan.kernel@gmail.com>, <joe.jin@oracle.com>,
        <brian.maly@oracle.com>
Subject: Re: [PATCH 2/3] intel_pstate: allow driver to be built as a module
Message-ID: <20141119105831.0428235f@kcaccard-desk.amr.corp.intel.com>
In-Reply-To: <1416299826-15813-7-git-send-email-ethan.zhao@oracle.com>
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com>
	<1416299826-15813-7-git-send-email-ethan.zhao@oracle.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 17:37:05 +0900
Ethan Zhao <ethan.zhao@oracle.com> wrote:

> From: Brian Maly <brian.maly@oracle.com>
> 
> To provide the flexibility of module, allow this driver to
> be configured and built as a module.
> 
> Signed-off-by: Brian Maly <brian.maly@oracle.com>
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>

I believe the entire concept of being able to use intel_pstate as a
module just isn't going to work.  There are load order issues - and
additionally the driver doesn't clean up after itself in any way.


> ---
>  drivers/cpufreq/Kconfig.x86    | 2 +-
>  drivers/cpufreq/intel_pstate.c | 6 ++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
> index 89ae88f..94c9e6b 100644
> --- a/drivers/cpufreq/Kconfig.x86
> +++ b/drivers/cpufreq/Kconfig.x86
> @@ -3,7 +3,7 @@
>  #
>  
>  config X86_INTEL_PSTATE
> -       bool "Intel P state control"
> +       tristate "Intel P state control"
>         depends on X86
>         help
>            This driver provides a P state for Intel core processors.
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 5498eb0..7c5faea 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -590,7 +590,9 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
>  	if (pstate == cpu->pstate.current_pstate)
>  		return;
>  
> +#ifndef MODULE
>  	trace_cpu_frequency(pstate * cpu->pstate.scaling, cpu->cpu);
> +#endif
>  
>  	cpu->pstate.current_pstate = pstate;
>  
> @@ -705,12 +707,14 @@ static void intel_pstate_timer_func(unsigned long __data)
>  
>  	intel_pstate_adjust_busy_pstate(cpu);
>  
> +#ifndef MODULE
>  	trace_pstate_sample(fp_toint(sample->core_pct_busy),
>  			fp_toint(intel_pstate_get_scaled_busy(cpu)),
>  			cpu->pstate.current_pstate,
>  			sample->mperf,
>  			sample->aperf,
>  			sample->freq);
> +#endif
>  
>  	intel_pstate_set_sample_time(cpu);
>  }
> @@ -1054,6 +1058,7 @@ out:
>  }
>  device_initcall(intel_pstate_init);
>  
> +#ifndef MODULE
>  static int __init intel_pstate_setup(char *str)
>  {
>  	if (!str)
> @@ -1064,6 +1069,7 @@ static int __init intel_pstate_setup(char *str)
>  	return 0;
>  }
>  early_param("intel_pstate", intel_pstate_setup);
> +#endif
>  
>  MODULE_AUTHOR("Dirk Brandewie <dirk.j.brandewie@intel.com>");
>  MODULE_DESCRIPTION("'intel_pstate' - P state driver Intel Core processors");

