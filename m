Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3ITGPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 02:15:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37825 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3ITGPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 02:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <1379654772-10700-1-git-send-email-yinghai@kernel.org>
References: <1379654772-10700-1-git-send-email-yinghai@kernel.org>
Date: Fri, 20 Sep 2013 11:40:18 +0530
Message-ID: <CAKohpokdyk9hfBreVeXttN23biTVjWiJRm8eYkfAjLz+cbnreQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: skip loading acpi_cpufreq after intel_pstate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2013 10:56, Yinghai Lu <yinghai@kernel.org> wrote:
> If the hw support intel_pstate and acpi_cpufreq, intel_pstate will
> get loaded at first.

s/at //

>
> acpi_cpufreq_init will call acpi_cpufreq_early_init()
> and it allocate perf data and init those perf data in ACPI core, (that

s/it /that will /

> will go over all cpus).

s/go over/cover/

> but late it will free them as cpufreq_register_driver(acpi_cpufreq) will

s/late/later

> return fail as init_pstate already take over before.

write it as: fail as intel_pstate is already registered.

> Use cpufreq_get_current_driver() to check if we can skip the
> acpi_cpufreq loading.

The below material looks to be a separate issue and so we
probably break this patch into two?

> Also there is racing in
>         __acpi_processor_start
>                  ==> acpi_processor_load_module
>                          ==> request_module_nowait/requested = 1

> Index: linux-2.6/drivers/cpufreq/acpi-cpufreq.c
> ===================================================================
> --- linux-2.6.orig/drivers/cpufreq/acpi-cpufreq.c
> +++ linux-2.6/drivers/cpufreq/acpi-cpufreq.c
> @@ -986,6 +986,10 @@ static int __init acpi_cpufreq_init(void
>  {
>         int ret;
>
> +       /* don't keep reloading if cpufreq_driver exists */
> +       if (cpufreq_get_current_driver())
> +               return 0;
> +
>         if (acpi_disabled)
>                 return 0;

This looks fine to me..

> Index: linux-2.6/drivers/acpi/processor_perflib.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_perflib.c
> +++ linux-2.6/drivers/acpi/processor_perflib.c

Can't really review this one.. Rafael will do it..
