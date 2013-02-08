Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab3BHCw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:52:57 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:58096 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab3BHCwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:52:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130207193944.GA4016@thinkpad.lan>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
	<20130207193944.GA4016@thinkpad.lan>
Date: Fri, 8 Feb 2013 08:22:54 +0530
Message-ID: <CAKohponxYknVgZQpubaCQ0d4fw_TJzxqavY0ssjR8Kyu988Y7g@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: rjw@sisk.pl, valdis.kletnieks@vt.edu, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 February 2013 01:09, Artem Savkov <artem.savkov@gmail.com> wrote:
> Tested out linux-pm.git/linux-next with this patches pulled. It seems
> that my systemd-sleep issue is fixed, however there is a new 'sleeping
> in invalid context' bug during boot:
>
> [   12.736484] BUG: sleeping function called from invalid context at mm/slub.c:925
> [   12.739727] in_atomic(): 1, irqs_disabled(): 1, pid: 1799, name: systemd-modules
> [   12.742961] 2 locks held by systemd-modules/1799:
> [   12.746153]  #0:  (subsys mutex#3){......}, at: [<c13f4056>] subsys_interface_register+0x36/0xb0
> [   12.749499]  #1:  (cpufreq_driver_lock){......}, at: [<c14ba53b>] cpufreq_add_dev+0x22b/0x3d0
> [   12.752865] Pid: 1799, comm: systemd-modules Not tainted 3.8.0-rc6+ #1
> [   12.756175] Call Trace:
> [   12.759538]  [<c1068150>] __might_sleep+0xe0/0x100
> [   12.762156]  [<c112a481>] kmem_cache_alloc_trace+0xb1/0x150
> [   12.765432]  [<f804e653>] ? acpi_cpufreq_cpu_init+0x73/0x5c0 [acpi_cpufreq]
> [   12.768780]  [<f804e653>] acpi_cpufreq_cpu_init+0x73/0x5c0 [acpi_cpufreq]
> [   12.772161]  [<c14ba53b>] ? cpufreq_add_dev+0x22b/0x3d0
> [   12.775549]  [<c1695af7>] ? _raw_spin_lock_irqsave+0x77/0x90
> [   12.778932]  [<c14ba53b>] ? cpufreq_add_dev+0x22b/0x3d0
> [   12.782307]  [<c14ba548>] cpufreq_add_dev+0x238/0x3d0

Can you please try out this:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 819aa33..a77d0bc 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -919,17 +919,14 @@ static int cpufreq_add_dev(struct device *dev,
struct subsys_interface *sif)
        init_completion(&policy->kobj_unregister);
        INIT_WORK(&policy->update, handle_update);

-       spin_lock_irqsave(&cpufreq_driver_lock, flags);
        /* call driver. From then on the cpufreq must be able
         * to accept all calls to ->verify and ->setpolicy for this CPU
         */
        ret = driver->init(policy);
        if (ret) {
                pr_debug("initialization failed\n");
-               spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
                goto err_set_policy_cpu;
        }
-       spin_unlock_irqrestore(&cpufreq_driver_lock, flags);

        /* related cpus should atleast have policy->cpus */
        cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
