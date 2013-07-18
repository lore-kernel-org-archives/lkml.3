Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab3GRP6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:58:40 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:22946 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3GRP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:58:38 -0400
Date: Thu, 18 Jul 2013 17:58:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: <linux@roeck-us.net>, <thierry.reding@gmail.com>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] hwmon: (lm90) add support to handle IRQ
Message-ID: <20130718175822.62c358bf@endymion.delvare>
In-Reply-To: <1373615287-18502-4-git-send-email-wni@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
	<1373615287-18502-4-git-send-email-wni@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Fri, 12 Jul 2013 15:48:06 +0800, Wei Ni wrote:
> When the temperature exceed the limit range value,
> the driver can handle the interrupt.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  drivers/hwmon/lm90.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index c90037f..1cc3d19 100644
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
> @@ -1460,6 +1461,17 @@ static bool lm90_is_tripped(struct i2c_client *client)
>  	return true;
>  }
>  
> +static irqreturn_t lm90_irq_thread(int irq, void *dev_id)
> +{
> +	struct lm90_data *data = dev_id;
> +	struct i2c_client *client = to_i2c_client(data->hwmon_dev->parent);

Why are you passing data as the dev_id in the first place, instead of
client? It's easier to get the data when you have the client
(i2c_get_clientdata) than the other way around.

> +
> +	if (lm90_is_tripped(client))
> +		return IRQ_HANDLED;
> +	else
> +		return IRQ_NONE;
> +}
> +
>  static int lm90_probe(struct i2c_client *client,
>  		      const struct i2c_device_id *id)
>  {
> @@ -1536,6 +1548,18 @@ static int lm90_probe(struct i2c_client *client,
>  		goto exit_remove_files;
>  	}
>  
> +	if (client->irq >= 0) {

I though you had agreed to just check for (client->irq)?

> +		dev_dbg(dev, "lm90 IRQ: %d\n", client->irq);

The "lm90" is redundant, dev_dbg will use the chip name as a prefix.

> +		err = devm_request_threaded_irq(dev, client->irq,
> +						NULL, lm90_irq_thread,
> +						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +						"lm90", data);
> +		if (err < 0) {
> +			dev_err(dev, "cannot request interrupt\n");

You should include the IRQ number in the error message, it is useful
for investigating the issue. Not everyone will have the debugging
message above enabled.

> +			goto exit_remove_files;
> +		}
> +	}
> +
>  	return 0;
>  
>  exit_remove_files:

That's it for the code. Now I'm not sure I understand what you are
trying to do and what this is all good for.

First of all, how is the chip wired on your system? You are using an
NCT1008, right? Which output of the chip is connected to your interrupt
line, THERM or ALERT/THERM2? ALERT is normally used for SMBus Alert but
I suppose it could be used for an interrupt too. THERM and THERM2 OTOH
are comparator outputs, they stay low as long as the temperature are
above the therm limits. Reading the status register won't bring them
back up as I understand it, and contrary to the ALERT output, they
can't be masked. Won't this result in an interrupt flood if using
IRQF_TRIGGER_LOW? Have you tested your code already?

Also I don't think just logging an error message is the right thing to
do in the case of overheating. The code to handle SMBus alerts is from
me, and it does indeed just log the problems, but it was really only
meant as a proof of concept when I first added support for SMBus Alert.
Today we could do better than this, starting with issuing sysfs
notifications to the relevant alarm files (several other hwmon drivers
are doing that already.)

For a real system, if the THERM output is connected to an interrupt line
(instead of directly to a fan controller) I would expect the platform
to provide a callback to handle thermal events and take whatever
appropriate measure is needed (e.g. throttling.) Just logging the
problem won't save the system, by the time someone looks at the log it
might be too late.

-- 
Jean Delvare
