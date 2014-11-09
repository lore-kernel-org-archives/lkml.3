Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaKIV5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 16:57:42 -0500
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:65470 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532AbaKIV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 16:57:40 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2014 16:57:39 EST
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: Guenter Roeck <linux@roeck-us.net>, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 33/48] staging: nvec: Register with kernel power-off handler
Date: Sun, 09 Nov 2014 22:41:26 +0100
Message-Id: <5008744.rVN94atT9b@ax5200p>
User-Agent: KMail/4.13.3 (Linux/3.13.0-39-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1415292213-28652-34-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net> <1415292213-28652-34-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 06 November 2014, 08:43:17 schrieb Guenter Roeck:
> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with default priority since we don't know any better.
> 
> Cc: Julian Andres Klode <jak@jak-linux.org>
> Cc: Marc Dietrich <marvin24@gmx.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net

ok, this version (V5) actually switches the device off in contrast to the 
first implementation. Somehow I have to find out why it works at all without 
irqs.

Acked-by: Marc Dietrich <mavin24@gmx.de>

> ---
> v5:
> - Rebase to v3.18-rc3
> v4:
> - Do not use notifiers but internal functions and data structures to manage
>   the list of power-off handlers. Drop unused parameters from callbacks, and
> make the power-off function type void
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> v2:
> - Use define to specify poweroff handler priority
> - Use dev_warn instead of dev_err
> 
>  drivers/staging/nvec/nvec.c | 21 ++++++++++++---------
>  drivers/staging/nvec/nvec.h |  2 ++
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index a93208a..acf2ea6 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -33,6 +33,7 @@
>  #include <linux/mfd/core.h>
>  #include <linux/mutex.h>
>  #include <linux/notifier.h>
> +#include <linux/pm.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/workqueue.h>
> @@ -80,8 +81,6 @@ enum nvec_sleep_subcmds {
>  #define LID_SWITCH BIT(1)
>  #define PWR_BUTTON BIT(15)
> 
> -static struct nvec_chip *nvec_power_handle;
> -
>  static const struct mfd_cell nvec_devices[] = {
>  	{
>  		.name = "nvec-kbd",
> @@ -759,12 +758,14 @@ static void nvec_disable_i2c_slave(struct nvec_chip
> *nvec) }
>  #endif
> 
> -static void nvec_power_off(void)
> +static void nvec_power_off(struct power_off_handler_block *this)
>  {
> +	struct nvec_chip *nvec = container_of(this, struct nvec_chip,
> +					      power_off_hb);
>  	char ap_pwr_down[] = { NVEC_SLEEP, AP_PWR_DOWN };
> 
> -	nvec_toggle_global_events(nvec_power_handle, false);
> -	nvec_write_async(nvec_power_handle, ap_pwr_down, 2);
> +	nvec_toggle_global_events(nvec, false);
> +	nvec_write_async(nvec, ap_pwr_down, 2);
>  }
> 
>  /*
> @@ -878,8 +879,11 @@ static int tegra_nvec_probe(struct platform_device
> *pdev) nvec->nvec_status_notifier.notifier_call = nvec_status_notifier;
> nvec_register_notifier(nvec, &nvec->nvec_status_notifier, 0);
> 
> -	nvec_power_handle = nvec;
> -	pm_power_off = nvec_power_off;
> +	nvec->power_off_hb.handler = nvec_power_off;
> +	nvec->power_off_hb.priority = POWER_OFF_PRIORITY_DEFAULT;
> +	ret = register_power_off_handler(&nvec->power_off_hb);
> +	if (ret)
> +		dev_warn(nvec->dev, "Failed to register power-off handler\n");
> 
>  	/* Get Firmware Version */
>  	msg = nvec_write_sync(nvec, get_firmware_version, 2);
> @@ -914,13 +918,12 @@ static int tegra_nvec_remove(struct platform_device
> *pdev) {
>  	struct nvec_chip *nvec = platform_get_drvdata(pdev);
> 
> +	unregister_power_off_handler(&nvec->power_off_hb);
>  	nvec_toggle_global_events(nvec, false);
>  	mfd_remove_devices(nvec->dev);
>  	nvec_unregister_notifier(nvec, &nvec->nvec_status_notifier);
>  	cancel_work_sync(&nvec->rx_work);
>  	cancel_work_sync(&nvec->tx_work);
> -	/* FIXME: needs check wether nvec is responsible for power off */
> -	pm_power_off = NULL;
> 
>  	return 0;
>  }
> diff --git a/drivers/staging/nvec/nvec.h b/drivers/staging/nvec/nvec.h
> index e271375..d4145da 100644
> --- a/drivers/staging/nvec/nvec.h
> +++ b/drivers/staging/nvec/nvec.h
> @@ -163,6 +163,8 @@ struct nvec_chip {
>  	struct nvec_msg *last_sync_msg;
> 
>  	int state;
> +
> +	struct power_off_handler_block power_off_hb;
>  };
> 
>  extern int nvec_write_async(struct nvec_chip *nvec, const unsigned char
> *data,

