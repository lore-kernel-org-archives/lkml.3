Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaFCJjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:39:21 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:61896 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaFCJjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <538D9631.9090500@linux.vnet.ibm.com>
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
	<CAKohpokdnHag=79cXuwgNjX-k+JJU9GE3KUBhixcj3PZ6y78GQ@mail.gmail.com>
	<538D9631.9090500@linux.vnet.ibm.com>
Date: Tue, 3 Jun 2014 15:09:19 +0530
Message-ID: <CAKohpomynD9m-Cq4zsVSp3Xbw5Tx2cSe_Fcp5y0U8uAKSpQ1Tw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2014 15:02, Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index e1c6433..3e8588f 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -36,14 +36,29 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>         struct od_dbs_tuners *od_tuners = dbs_data->tuners;
>         struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
>         struct cpufreq_policy *policy;
> +       unsigned int sampling_rate;
>         unsigned int max_load = 0;
>         unsigned int ignore_nice;
>         unsigned int j;
>
> -       if (dbs_data->cdata->governor == GOV_ONDEMAND)
> +       if (dbs_data->cdata->governor == GOV_ONDEMAND) {
> +               struct od_cpu_dbs_info_s *od_dbs_info;
> +
> +               /*
> +                * Sometimes, the ondemand governor uses an additional
> +                * multiplier to give long delays. So apply this multiplier to
> +                * the 'sampling_rate', so as to keep the wake-up-from-idle
> +                * detection logic a bit conservative.
> +                */
> +               sampling_rate = od_tuners->sampling_rate;
> +               od_dbs_info = dbs_data->cdata->get_cpu_dbs_info_s(cpu);

Probably do both above right after definition of od_dbs_info or merge
above with it. and just keep below after the comment ?

> +               sampling_rate *= od_dbs_info->rate_mult;
