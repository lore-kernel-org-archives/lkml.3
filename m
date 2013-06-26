Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3FZKf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:35:28 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45374 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3FZKfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:35:13 -0400
MIME-Version: 1.0
In-Reply-To: <1371661969-7660-2-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-2-git-send-email-l.majewski@samsung.com>
Date: Wed, 26 Jun 2013 16:05:12 +0530
Message-ID: <CAKohpomStuSGyQHnk9jNLpije=SAkb4zHg40zHDgLRCUQeZC1A@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] cpufreq: Store cpufreq policies in a list
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com> wrote:
> Policies available in a cpufreq framework are now linked together. They are
> accessible via cpufreq_policy_list defined at cpufreq core.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>
> Changes for v4:
> - New patch

You need to write changelog after ---, so that it doesn't get commited.

> ---
>  drivers/cpufreq/cpufreq.c |    3 +++
>  include/linux/cpufreq.h   |    1 +
>  2 files changed, 4 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2ce86ed..665e641 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -46,6 +46,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
>  static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  #endif
>  static DEFINE_RWLOCK(cpufreq_driver_lock);
> +static LIST_HEAD(cpufreq_policy_list);
>
>  /*
>   * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
> @@ -989,6 +990,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>         }
>  #endif
>
> +       list_add(&policy->policy_list, &cpufreq_policy_list);
>         ret = cpufreq_add_dev_interface(cpu, policy, dev);
>         if (ret)
>                 goto err_out_unregister;

what about handling error cases?

> @@ -1992,6 +1994,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
>         subsys_interface_unregister(&cpufreq_interface);
>         unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
>
> +       list_del(&cpufreq_policy_list);
>         write_lock_irqsave(&cpufreq_driver_lock, flags);
>         cpufreq_driver = NULL;
>         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index ab1932c..5348981 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -117,6 +117,7 @@ struct cpufreq_policy {
>
>         struct cpufreq_real_policy      user_policy;
>
> +       struct list_head        policy_list;
>         struct kobject          kobj;
>         struct completion       kobj_unregister;

--
viresh
