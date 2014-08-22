Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaHVRO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:14:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57596 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932696AbaHVROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:14:53 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, bebl@mageta.org, davem@davemloft.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Run fixed button devices' notify callback in the process context
Date: Fri, 22 Aug 2014 19:33:55 +0200
Message-ID: <3313221.quKCYo2xmm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408693091-16268-1-git-send-email-tianyu.lan@intel.com>
References: <1408693091-16268-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 22, 2014 03:37:55 PM Lan Tianyu wrote:
> Currently fixed button devices' notify callbacks are running in the
> interrupt context. It's not necessary and prevent calling functions
> with mutex lock(E,G evaluating ACPI method). Otherwise, it's different
> with non-fixed button device whose notify callback is running in the process
> context. This patch is to make fixed button device's notify
> callback in the process context and this also can avoid dead lock
> when using netlink to report button event to user space.

I guess this is the main reason for the patch?

Is there a bug report regarding this?

> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/scan.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 0a817ad..bfb7fc5 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -922,12 +922,17 @@ static void acpi_device_notify(acpi_handle handle, u32 event, void *data)
>  	device->driver->ops.notify(device, event);
>  }
>  
> -static acpi_status acpi_device_notify_fixed(void *data)
> +static void acpi_device_notify_fixed_run(void *data)
>  {
>  	struct acpi_device *device = data;
>  
> -	/* Fixed hardware devices have no handles */
>  	acpi_device_notify(NULL, ACPI_FIXED_HARDWARE_EVENT, device);
> +}
> +
> +static acpi_status acpi_device_notify_fixed(void *data)
> +{
> +	/* Fixed hardware devices have no handles */
> +	acpi_os_execute(OSL_NOTIFY_HANDLER, acpi_device_notify_fixed_run, data);
>  	return AE_OK;
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
