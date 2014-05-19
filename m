Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaESWi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:38:59 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52476 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751719AbaESWi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:38:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/hotplug: Fix STARTING/DYING action in acpi_cpu_soft_notify()
Date: Tue, 20 May 2014 00:55:51 +0200
Message-ID: <2011129.WMiXDPUasW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399557539-7282-1-git-send-email-toshi.kani@hp.com>
References: <1399557539-7282-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 07:58:59 AM Toshi Kani wrote:
> During CPU online/offline testing on a large system, one of the
> processors got stuck after the message "bad: scheduling from the
> idle thread!".  The problem is that acpi_cpu_soft_notify() calls
> acpi_bus_get_device() for all action types.  CPU_STARTING and
> CPU_DYING do not allow the notify handlers to sleep.  However,
> acpi_bus_get_device() can sleep in acpi_ut_acquire_mutex().
> 
> Change acpi_cpu_soft_notify() to return immediately for CPU_STARTING
> and CPU_DYING as they have no action in this handler.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Queued up for 3.16, thanks!

> ---
>  drivers/acpi/processor_driver.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 7f70f31..4fcbd67 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -121,6 +121,13 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
>  	struct acpi_processor *pr = per_cpu(processors, cpu);
>  	struct acpi_device *device;
>  
> +	/*
> +	 * CPU_STARTING and CPU_DYING must not sleep. Return here since
> +	 * acpi_bus_get_device() may sleep.
> +	 */
> +	if (action == CPU_STARTING || action == CPU_DYING)
> +		return NOTIFY_DONE;
> +
>  	if (!pr || acpi_bus_get_device(pr->handle, &device))
>  		return NOTIFY_DONE;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
