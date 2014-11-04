Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaKDNUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:20:40 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:46206 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaKDNUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:20:38 -0500
Message-ID: <5458D29E.50908@compulab.co.il>
Date: Tue, 04 Nov 2014 15:20:30 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
References: <20141102180756.GH31454@atomide.com>
In-Reply-To: <20141102180756.GH31454@atomide.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 11/02/14 20:07, Tony Lindgren wrote:
> Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
> configuration") enabled configuring the PM features for twl4030.
> 
> This caused poweroff command to fail on devices that have the
> BCI charger on twl4030 wired, or have power wired for VBUS.
> Instead of powering off, the device reboots. This is because
> voltage is detected on charger or VBUS with the default bits
> enabled for the power transition registers.
> 
> To fix the issue, let's just clear VBUS and CHG bits as we want
> poweroff command to keep the system powered off.

What about devices that really need to start once VBUS or CHG is connected?
It seems to me that forcing these bits on power off can break that kind of
devices and these settings should really be board specific.
What do you think?

> 
> Fixes: e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset configuration")
> Cc: stable@vger.kernel.org # v3.16+
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -44,6 +44,15 @@ static u8 twl4030_start_script_address = 0x2b;
>  #define PWR_DEVSLP		BIT(1)
>  #define PWR_DEVOFF		BIT(0)
>  
> +/* Register bits for CFG_P1_TRANSITION (also for P2 and P3) */
> +#define STARTON_SWBUG		BIT(7)	/* Start on watchdog */
> +#define STARTON_VBUS		BIT(5)	/* Start on VBUS */
> +#define STARTON_VBAT		BIT(4)	/* Start on battery insert */
> +#define STARTON_RTC		BIT(3)	/* Start on RTC */
> +#define STARTON_USB		BIT(2)	/* Start on USB host */
> +#define STARTON_CHG		BIT(1)	/* Start on charger */
> +#define STARTON_PWON		BIT(0)	/* Start on PWRON button */
> +
>  #define SEQ_OFFSYNC		(1 << 0)
>  
>  #define PHY_TO_OFF_PM_MASTER(p)		(p - 0x36)
> @@ -606,6 +615,44 @@ twl4030_power_configure_resources(const struct twl4030_power_data *pdata)
>  	return 0;
>  }
>  
> +static int twl4030_starton_mask_and_set(u8 bitmask, u8 bitvalues)
> +{
> +	u8 regs[3] = { TWL4030_PM_MASTER_CFG_P1_TRANSITION,
> +		       TWL4030_PM_MASTER_CFG_P2_TRANSITION,
> +		       TWL4030_PM_MASTER_CFG_P3_TRANSITION, };
> +	u8 val;
> +	int i, err;
> +
> +	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG1,
> +			       TWL4030_PM_MASTER_PROTECT_KEY);
> +	if (err)
> +		goto relock;
> +	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER,
> +			       TWL4030_PM_MASTER_KEY_CFG2,
> +			       TWL4030_PM_MASTER_PROTECT_KEY);
> +	if (err)
> +		goto relock;
> +
> +	for (i = 0; i < sizeof(regs); i++) {
> +		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER,
> +				      &val, regs[i]);
> +		if (err)
> +			break;
> +		val = (~bitmask & val) | (bitmask & bitvalues);
> +		err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER,
> +				       val, regs[i]);
> +		if (err)
> +			break;
> +	}
> +
> +	if (err)
> +		pr_err("TWL4030 Register access failed: %i\n", err);
> +
> +relock:
> +	return twl_i2c_write_u8(TWL_MODULE_PM_MASTER, 0,
> +				TWL4030_PM_MASTER_PROTECT_KEY);
> +}
> +
>  /*
>   * In master mode, start the power off sequence.
>   * After a successful execution, TWL shuts down the power to the SoC
> @@ -615,6 +662,11 @@ void twl4030_power_off(void)
>  {
>  	int err;
>  
> +	/* Disable start on charger or VBUS as it can break poweroff */
> +	err = twl4030_starton_mask_and_set(STARTON_VBUS | STARTON_CHG, 0);
> +	if (err)
> +		pr_err("TWL4030 Unable to configure start-up\n");
> +
>  	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, PWR_DEVOFF,
>  			       TWL4030_PM_MASTER_P1_SW_EVENTS);
>  	if (err)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Regards,
Igor.
