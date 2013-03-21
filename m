Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3CUDUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:20:12 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:62388 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3CUDUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <1363796244-6658-1-git-send-email-dirk.brandewie@gmail.com>
References: <1363796244-6658-1-git-send-email-dirk.brandewie@gmail.com>
Date: Thu, 21 Mar 2013 08:50:09 +0530
X-Google-Sender-Auth: MJSxYRM4NLj88Lyc-4_ST6KHtxk
Message-ID: <CAOh2x=nb8GgUoSLnepo5R9Q+MR81QFe3zH+cmdg5kO87dkGnAg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Add function to check that all
 MSR's are valid
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 9:47 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Some VMs seem to try to implement some MSRs but not all the registers
> the driver needs.  Check to make sure all the MSR that we need are
> available. If any of the required MSRs are not available refuse to
> load.
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/intel_pstate.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index f6dd1e7..cd9c5f4 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -752,6 +752,29 @@ static struct cpufreq_driver intel_pstate_driver = {
>
>  static int __initdata no_load;
>
> +static int intel_pstate_msrs_not_valid(void)
> +{
> +       /* Check that all the msr's we are using are valid. */
> +       u64 aperf, mperf, tmp;
> +
> +       rdmsrl(MSR_IA32_APERF, aperf);
> +       rdmsrl(MSR_IA32_MPERF, mperf);
> +
> +       if (!intel_pstate_min_pstate() ||
> +               !intel_pstate_max_pstate() ||
> +               !intel_pstate_turbo_pstate())
> +               return -ENODEV;
> +
> +       rdmsrl(MSR_IA32_APERF, tmp);
> +       if (!(tmp - aperf))
> +               return -ENODEV;
> +
> +       rdmsrl(MSR_IA32_MPERF, tmp);
> +       if (!(tmp - mperf))
> +               return -ENODEV;
> +
> +       return 0;
> +}

Add blank line here.

>  static int __init intel_pstate_init(void)
>  {
>         int cpu, rc = 0;
> @@ -764,6 +787,9 @@ static int __init intel_pstate_init(void)
>         if (!id)
>                 return -ENODEV;
>
> +       if (intel_pstate_msrs_not_valid())
> +               return -ENODEV;
> +
>         pr_info("Intel P-state driver initializing.\n");
>
>         all_cpu_data = vmalloc(sizeof(void *) * num_possible_cpus());

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
