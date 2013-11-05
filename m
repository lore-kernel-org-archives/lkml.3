Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3KEEiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 23:38:09 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:49998 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3KEEiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 23:38:07 -0500
MIME-Version: 1.0
In-Reply-To: <1383621014-11202-1-git-send-email-rongjun.ying@csr.com>
References: <1383621014-11202-1-git-send-email-rongjun.ying@csr.com>
Date: Tue, 5 Nov 2013 10:08:06 +0530
Message-ID: <CAKohpo=qR5WD=5VjGmeRraQ+_m5NUn8xiP5Z_ZuZWLv1hNx5KA@mail.gmail.com>
Subject: Re: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage instead of voltage-tolerance
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjying <rjying@gmail.com>, Shawn Guo <shawn.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rongjun.ying@gcsr.com, Rongjun Ying <rongjun.ying@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding shawn in cc list..

On 5 November 2013 08:40, rjying <rjying@gmail.com> wrote:
> From: Rongjun Ying <rongjun.ying@csr.com>
>
> Sometime the regulator can't supply appropriate voltages for requestion of cpu.
> All voltage tolerance value can't figure out a good voltage.
>
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index c522a95..0c9e6b9 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -23,7 +23,7 @@
>  #include <linux/slab.h>
>
>  static unsigned int transition_latency;
> -static unsigned int voltage_tolerance; /* in percentage */
> +static unsigned int voltage_max;
>
>  static struct device *cpu_dev;
>  static struct clk *cpu_clk;
> @@ -45,7 +45,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>  {
>         struct cpufreq_freqs freqs;
>         struct opp *opp;
> -       unsigned long volt = 0, volt_old = 0, tol = 0;
> +       unsigned long volt = 0, volt_old = 0;
>         long freq_Hz, freq_exact;
>         unsigned int index;
>         int ret;
> @@ -82,7 +82,6 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>                 }
>                 volt = opp_get_voltage(opp);
>                 rcu_read_unlock();
> -               tol = volt * voltage_tolerance / 100;
>                 volt_old = regulator_get_voltage(cpu_reg);
>         }
>
> @@ -92,7 +91,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>
>         /* scaling up?  scale voltage before frequency */
>         if (!IS_ERR(cpu_reg) && freqs.new > freqs.old) {
> -               ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
> +               ret = regulator_set_voltage(cpu_reg, volt, voltage_max);
>                 if (ret) {
>                         pr_err("failed to scale voltage up: %d\n", ret);
>                         freqs.new = freqs.old;
> @@ -104,14 +103,14 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>         if (ret) {
>                 pr_err("failed to set clock rate: %d\n", ret);
>                 if (!IS_ERR(cpu_reg))
> -                       regulator_set_voltage_tol(cpu_reg, volt_old, tol);
> +                       regulator_set_voltage(cpu_reg, volt_old, voltage_max);
>                 freqs.new = freqs.old;
>                 goto post_notify;
>         }
>
>         /* scaling down?  scale voltage after frequency */
>         if (!IS_ERR(cpu_reg) && freqs.new < freqs.old) {
> -               ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
> +               ret = regulator_set_voltage(cpu_reg, volt, voltage_max);
>                 if (ret) {
>                         pr_err("failed to scale voltage down: %d\n", ret);
>                         clk_set_rate(cpu_clk, freqs.old * 1000);
> @@ -224,7 +223,11 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>                 goto out_put_node;
>         }
>
> -       of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
> +       ret = of_property_read_u32(np, "voltage-max", &voltage_max);
> +       if (ret) {
> +               pr_err("failed to get max voltage: %d\n", ret);
> +               goto out_put_node;
> +       }
>
>         if (of_property_read_u32(np, "clock-latency", &transition_latency))
>                 transition_latency = CPUFREQ_ETERNAL;
> --
> 1.7.5.4
>
