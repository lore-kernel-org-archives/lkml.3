Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3C1IyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:54:00 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:58971 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab3C1Ixy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <1364457923-8499-2-git-send-email-amit.daniel@samsung.com>
References: <1364457923-8499-1-git-send-email-amit.daniel@samsung.com>
	<1364457923-8499-2-git-send-email-amit.daniel@samsung.com>
Date: Thu, 28 Mar 2013 14:23:53 +0530
Message-ID: <CAKohpo=uZxCv6wFJFQx_zrPKujukW9d6_2GihwPpN6BkBAFNwA@mail.gmail.com>
Subject: Re: [PATCH V5 1/4] cpufreq: exynos: Add cpufreq driver for exynos5440
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2013 13:35, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> This patch adds dvfs support for exynos5440 SOC. This soc has 4 cores and
> they scale at same frequency. The nature of exynos5440 clock controller is
> different from previous exynos controllers so not using the common exynos
> cpufreq framework. The major difference being interrupt notification for
> frequency change. Also, OPP library is used for device tree parsing to get
> different parameters like frequency, voltage etc. Since the opp library sorts
> the frequency table in ascending order so they are again re-arranged in
> descending order. This will have one-to-one mapping with the clock controller
> state management logic.
>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Mostly okay now, just minor comments:

> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
> +static void exynos_cpufreq_work(struct work_struct *work)
> +{

> +       if (likely(index < dvfs_info->freq_count)) {
> +               freqs.new = freq_table[index].frequency;
> +               for_each_cpu(freqs.cpu, policy->cpus)
> +                       cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
> +               dvfs_info->cur_frequency = freqs.new;
> +       } else {
> +               dev_crit(dvfs_info->dev, "New frequency out of range\n");
> +       }

I believe there is something wrong here. For failure cases too
we need to issue cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
with the old frequency.

> +static int exynos_cpufreq_probe(struct platform_device *pdev)
> +{

> +       ret = cpufreq_register_driver(&exynos_driver);
> +       if (ret) {
> +               dev_err(dvfs_info->dev,
> +                       "%s: failed to register cpufreq driver\n", __func__);
> +               goto err_free_table;
> +       }
> +
> +       of_node_put(np);

Don't we need to put node everytime?

> +       dvfs_info->dvfs_enabled = true;
> +       return 0;
> +
> +err_free_table:
> +       opp_free_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
> +err_put_node:
> +       of_node_put(np);
> +       dev_err(dvfs_info->dev, "%s: failed initialization\n", __func__);
> +       return ret;
> +}

--
viresh
