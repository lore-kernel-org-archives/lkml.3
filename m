Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3KDJes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:34:48 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:11517 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3KDJeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:34:46 -0500
Date: Mon, 4 Nov 2013 10:34:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] hwmon: (lm90) add support to handle IRQ
Message-ID: <20131104103434.5a085e27@endymion.delvare>
In-Reply-To: <1375856306-14415-3-git-send-email-wni@nvidia.com>
References: <1375856306-14415-1-git-send-email-wni@nvidia.com>
	<1375856306-14415-3-git-send-email-wni@nvidia.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

I'm hitting a problem with that patch now...

On Wed, 7 Aug 2013 14:18:25 +0800, Wei Ni wrote:
> When the temperature exceed the limit range value,
> the driver can handle the interrupt.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  drivers/hwmon/lm90.c |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index 1da2eff..2e68773 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -89,6 +89,7 @@
>  #include <linux/err.h>
>  #include <linux/mutex.h>
>  #include <linux/sysfs.h>
> +#include <linux/interrupt.h>
>  
>  /*
>   * Addresses to scan
> @@ -1433,6 +1434,16 @@ static bool lm90_is_tripped(struct i2c_client *client)
>  	return true;
>  }
>  
> +static irqreturn_t lm90_irq_thread(int irq, void *dev_id)
> +{
> +	struct i2c_client *client = dev_id;
> +
> +	if (lm90_is_tripped(client))

Did you really send the latest version of the patch? lm90_is_tripped()
takes two arguments now, but here you only pass one.

If you have a more up-to-date version of this patch, please send it
over quickly.

> +		return IRQ_HANDLED;
> +	else
> +		return IRQ_NONE;
> +}
> +
>  static int lm90_probe(struct i2c_client *client,
>  		      const struct i2c_device_id *id)
>  {
> @@ -1509,6 +1520,18 @@ static int lm90_probe(struct i2c_client *client,
>  		goto exit_remove_files;
>  	}
>  
> +	if (client->irq) {
> +		dev_dbg(dev, "IRQ: %d\n", client->irq);
> +		err = devm_request_threaded_irq(dev, client->irq,
> +						NULL, lm90_irq_thread,
> +						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +						"lm90", client);
> +		if (err < 0) {
> +			dev_err(dev, "cannot request IRQ: %d\n", client->irq);
> +			goto exit_remove_files;
> +		}
> +	}
> +
>  	return 0;
>  
>  exit_remove_files:


-- 
Jean Delvare
