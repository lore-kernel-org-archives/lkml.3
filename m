Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030889Ab3HITZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:25:51 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34222 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030856Ab3HITZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:25:48 -0400
Date: Fri, 9 Aug 2013 12:21:11 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bq24190_charger: Add support for TI BQ24190 Battery
 Charger
Message-ID: <20130809192111.GD979@lizard.mcd26095.sjc.wayport.net>
References: <1375912608-17312-1-git-send-email-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1375912608-17312-1-git-send-email-mgreer@animalcreek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:56:48PM -0700, Mark A. Greer wrote:
> Add driver support for the Texas Instruments BQ24190
> battery charger.  Some of the information provided by
> the device is about the charger and other information
> is about the battery so create two power_supply objects
> (one for each) and provide the appropriate information
> for each one.
> 
> The device has many fields that go beyond what is
> reasonable to report or modify using the existing
> 'POWER_SUPPLY_PROP_*' properties so the driver exports
> the register fields via sysfs.  They are prefixed by
> 'f_' (for 'field') to make it easier to distinguish
> between a register field and a "normal" sysfs file
> exported by the power_supply infrastructure.
> 
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
...
> +static irqreturn_t bq24190_irq_handler_thread(int irq, void *data)
> +{
> +	struct bq24190_dev_info *bdi = data;
> +	bool alert_userspace = false;
> +	u8 ss_reg, f_reg;
> +	int ret;
> +	static bool first_time = true;
...
> +	/*
> +	 * Sometimes bq24190 gives a steady trickle of interrupts even
> +	 * though the watchdog timer is turned off and neither the STATUS
> +	 * nor FAULT registers have changed.  Weed out these sprurious
> +	 * interrupts so userspace isn't alerted for no reason.
> +	 * In addition, the chip always generates an interrupt after
> +	 * register reset so we should ignore that one (the very first
> +	 * interrupt received).
> +	 */
> +	if (alert_userspace && !first_time) {

Hm, global static... I would guess that per-device flag would be more
appropriate, just in case if there are multiple chargers?

> +		power_supply_changed(&bdi->charger);
> +		power_supply_changed(&bdi->battery);
> +		first_time = false;
> +	}
...
> +	do {
> +		ret = bq24190_read_mask(bdi, BQ24190_REG_POC,
> +				BQ24190_REG_POC_RESET_MASK,
> +				BQ24190_REG_POC_RESET_SHIFT,
> +				&v);
> +		if ((ret <= 0) || !v)
> +			break;
> +
> +		udelay(10);
> +	} while (--limit);
> +
> +	if (!ret && limit)
> +		ret = bq24190_set_mode_host(bdi);
> +out:
> +	pm_runtime_put_sync(bdi->dev);
> +	return ret;
> +}
> +
> +#define irq_to_gpio(irq)	((irq) - gpio_to_irq(0))

Ugh... this does not seem right. On a particular platform it might work,
but not in general...

Thanks,

Anton

p.s. I am also not a big fan of unnecessary 'out:' goto labels... most of
them might be changed to just 'return ...;'
