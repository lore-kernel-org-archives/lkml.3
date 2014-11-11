Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaKKEXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:23:48 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:49002 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbaKKEXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:23:47 -0500
MIME-Version: 1.0
In-Reply-To: <1415199239-19019-6-git-send-email-prarit@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
	<1415199239-19019-6-git-send-email-prarit@redhat.com>
Date: Tue, 11 Nov 2014 09:53:46 +0530
Message-ID: <CAKohpon3ybK1YhemeZ_kxFCLowsJSZSO3P7=CTZaWpAMwNh7Dg@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpufreq, add BUG() messages in critical paths to aid
 debugging failures
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 November 2014 20:23, Prarit Bhargava <prarit@redhat.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index b1ee597..f158882 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -161,9 +161,18 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
>
>  static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
> -               unsigned int delay)
> +                                   unsigned int delay,
> +                                   struct cpufreq_policy *policy)
>  {
> -       struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);

I will let it crash right here instead of additional code :)

> @@ -258,7 +268,13 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
> -       WARN_ON(!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT));
> +       if (!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT)) {
> +               pr_emerg("governor_data is NULL but governor %s is initialized = %d [governor_enabled = %d event = %u]\n",
> +                        policy->governor->name,
> +                        atomic_read(&policy->governor->initialized),
> +                        policy->governor_enabled, event);
> +               BUG();

How is the BUG better than the WARN here ?

>         switch (event) {
>         case CPUFREQ_GOV_POLICY_INIT:
> @@ -329,6 +345,12 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>         case CPUFREQ_GOV_POLICY_EXIT:
>                 mutex_lock(&dbs_data->usage_count_mutex);
>                 if (atomic_dec_and_test(&dbs_data->usage_count)) {
> +                       if (atomic_read(&policy->governor->initialized) > 1) {

Isn't this wrong? Consider 4 CPUs with separate clock line and have set
governor-per-policy to true. EXIT will be called for every CPU hotplug and
initialized will be 4 initially..

Or I am still vacation lag'd ? :)

> +                               pr_emerg("Removing governor %s but initialized = %d, dbs_data->usage_count = 0\n",
> +                                        policy->governor->name,
> +                                  atomic_read(&policy->governor->initialized));
> +                               BUG();
> +                       }
>                         sysfs_remove_group(get_governor_parent_kobj(policy),
>                                         get_sysfs_attr(dbs_data));
>
> --
> 1.7.9.3
>
