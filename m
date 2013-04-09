Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937204Ab3DIJrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:47:15 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:45828 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab3DIJrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:47:12 -0400
MIME-Version: 1.0
In-Reply-To: <1365496365-28450-1-git-send-email-Yuantian.Tang@freescale.com>
References: <1365496365-28450-1-git-send-email-Yuantian.Tang@freescale.com>
Date: Tue, 9 Apr 2013 15:17:11 +0530
Message-ID: <CAKohpokVf0hCokDL62WeaUdYEBycf+Kh_cRgWxTR--_12xjEBA@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: powerpc: Add cpufreq driver for Freescale
 e500mc SoCs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Yuantian.Tang@freescale.com
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Li Yang <leoli@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly good now, V5 should be the final one.

On 9 April 2013 14:02,  <Yuantian.Tang@freescale.com> wrote:
> diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c

> +static int corenet_cpufreq_target(struct cpufreq_policy *policy,
> +               unsigned int target_freq, unsigned int relation)
> +{
> +       struct cpufreq_freqs freqs;
> +       unsigned int new;
> +       struct clk *parent;
> +       int ret;
> +       struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
> +
> +       cpufreq_frequency_table_target(policy, data->table,
> +                       target_freq, relation, &new);
> +
> +       if (policy->cur == data->table[new].frequency)
> +               return 0;
> +
> +       freqs.old = policy->cur;
> +       freqs.new = data->table[new].frequency;
> +       freqs.cpu = policy->cpu;

You don't need to set freqs.cpu..

> +       mutex_lock(&cpufreq_lock);
> +       cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +
> +       parent = of_clk_get(data->parent, new);
> +       ret = clk_set_parent(data->clk, parent);
> +       if (ret) {
> +               freqs.new = freqs.old;
> +               cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +               mutex_unlock(&cpufreq_lock);
> +               return ret;
> +       }
> +
> +       cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +       mutex_unlock(&cpufreq_lock);

What about writing it as:

+       ret = clk_set_parent(data->clk, parent);
+       if (ret)
+               freqs.new = freqs.old;
+
+       cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+       mutex_unlock(&cpufreq_lock);

return ret;

> +       return 0;
> +}
