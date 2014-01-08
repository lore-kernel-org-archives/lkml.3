Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaAHAAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 19:00:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56337 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754829AbaAHAAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 19:00:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH Resend 1/4] cpufreq: stats: handle cpufreq_unregister_driver() and suspend/resume properly
Date: Wed, 08 Jan 2014 01:14:11 +0100
Message-ID: <2641423.LeSa8tdYgZ@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <b4c2b7c1f5e480e6ae6fcbc737ae52c1e0a88549.1389058746.git.viresh.kumar@linaro.org>
References: <b4c2b7c1f5e480e6ae6fcbc737ae52c1e0a88549.1389058746.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 07, 2014 07:10:10 AM Viresh Kumar wrote:
> There are several problems cpufreq stats in the way it handles
> cpufreq_unregister_driver() and suspend/resume..
> 
> - We must not loose data collected so far when suspend/resume happens and so
>   stats directories must not be removed/allocated during these operations, Which
>   is done currently.
> 
> - cpufreq_stat has registered notifiers with both cpufreq and hotplug. It adds
>   sysfs stats directory with a cpufreq notifier: CPUFREQ_NOTIFY and removes this
>   directory with a notifier from hotplug core.
> 
>   In case cpufreq_unregister_driver() is called (on rmmod cpufreq driver), stats
>   directories per cpu aren't removed as CPUs are still online. The only call
>   cpufreq_stats gets is cpufreq_stats_update_policy_cpu for all CPUs except the
>   last of each policy. And pointer to stat information is stored in the entry
>   for last cpu in per-cpu cpufreq_stats_table. But policy structure would be
>   freed inside cpufreq core and so that will result in memory leak inside
>   cpufreq stats (as we are never freeing memory for stats).
> 
>   Now if we again insert the module cpufreq_register_driver() will be called and
>   we will again allocate stats data and put it on for first cpu of every policy.
>   In case we only have a single cpu per policy we will return with a error from
>   cpufreq_stats_create_table() due to below code:
> 
> 	if (per_cpu(cpufreq_stats_table, cpu))
> 		return -EBUSY;
> 
>   And so probably cpufreq stats directory would show up anymore (as it was added
>   inside last policies->kobj which doesn't exist anymore). I haven't tested it
>   though. Also the values in stats files wouldn't be refreshed as we are using
>   the earlier stats structure.
> 
> - CPUFREQ_NOTIFY is called from cpufreq_set_policy() which is called for
>   scenarios where we don't really want cpufreq_stat_notifier_policy() to get
>   called. For example whenever we are changing anything related to a policy:
>   min/max/current freq, etc.. cpufreq_set_policy() is called and so cpufreq
>   stats is notified. Where we don't do any useful stuff other than simply
>   returning with -EBUSY from cpufreq_stats_create_table(). And so this isn't the
>   right notifier that cpufreq stats..
> 
> Due to all above reasons this patch does following changes:
> - Add new notifiers CPUFREQ_CREATE_POLICY and CPUFREQ_REMOVE_POLICY, which are
>   only called when policy is created/destroyed. They aren't called for
>   suspend/resume paths..
> - Use these notifiers in cpufreq_stat_notifier_policy() to create/destory stats
>   sysfs entries. And so cpufreq_unregister_driver() or suspend/resume shouldn't
>   be a problem for cpufreq_stats.
> - Return early from cpufreq_stat_cpu_callback() for suspend/resume sequence, so
>   that we don't free stats structure.
> 
> Acked-and-tested-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

The entire series applied to bleeding-edge, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
