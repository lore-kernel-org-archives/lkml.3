Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3FSRtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:49:00 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64722 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3FSRs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:48:58 -0400
Message-ID: <51C1EF05.90402@gmail.com>
Date: Wed, 19 Jun 2013 10:48:53 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>,
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
        Eduardo Valentin <eduardo.valentin@ti.com>, dirk.brandewie@gmail.com
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <1371661969-7660-1-git-send-email-l.majewski@samsung.com> <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 10:12 AM, Lukasz Majewski wrote:
> This commit adds boost frequency support in cpufreq core (Hardware &

> +/*********************************************************************
>    *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
>    *********************************************************************/
>
> @@ -1936,6 +2019,16 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>   	cpufreq_driver = driver_data;
>   	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> +	if (!cpufreq_driver->boost_supported)
> +		boost.attr.mode = 0444;
> +
> +	ret = cpufreq_sysfs_create_file(&(boost.attr));
> +	if (ret) {
> +		pr_err("%s: cannot register global boost sysfs file\n",
> +		       __func__);
> +		goto err_null_driver;
> +	}
> +

I do not think the boost sysfs should be created at all if boost is not
supported.

For intel_pstate the read-only boost would be there for no reason and would
cause confusion on the part of the user IMHO

>   	ret = subsys_interface_register(&cpufreq_interface);
>   	if (ret)
>   		goto err_null_driver;
> @@ -1992,6 +2085,8 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
>   	pr_debug("unregistering driver %s\n", driver->name);
>
>   	subsys_interface_unregister(&cpufreq_interface);
> +
> +	cpufreq_sysfs_remove_file(&(boost.attr));
>   	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
>

