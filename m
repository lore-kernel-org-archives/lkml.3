Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3KSNcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:32:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57404 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3KSNcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:32:15 -0500
Date: Tue, 19 Nov 2013 14:32:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi
Subject: Re: [PATCH v2 3/3] RX-51: Add platform data for bq24150a charger
Message-ID: <20131119133212.GF14587@amd.pavel.ucw.cz>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-4-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384856285-19593-4-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-11-19 11:18:05, Pali Rohár wrote:
> This patch will register bq24150a charger in RX-51 board data.
> 
> So finally charging battery on Nokia N900 (RX-51) working
> automatically without any proprietary Nokia bits in userspace.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

									Pavel
BTW, current code says:

That seems to limit charging voltage to 3.9V, with comment saying
4.11V... which means battery will not be charged fully. does it make
sense to raise limit to 4.11V here?

Aha, and actually will not 4.2V requested by
rx51_bq24150a_platform_data trigger -EINVAL?

/* set battery regulation voltage in mV */
static int bq2415x_set_battery_regulation_voltage(struct
bq2415x_device *bq,
                                                  int mV)
{
        int val = (mV/10 - 350) / 2;

        if (val < 0)
                val = 0;
        else if (val > 94) /* FIXME: Max is 94 or 122 ? Set max value
                ? */
                return -EINVAL;

        return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE, val,
                        BQ2415X_MASK_VO, BQ2415X_SHIFT_VO);
}

> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -1275,6 +1276,16 @@ static struct aic3x_pdata rx51_aic3x_data2 = {
>  	.gpio_reset = 60,
>  };
>  
> +static struct bq2415x_platform_data rx51_bq24150a_platform_data = {
> +	.current_limit = 100,			/* mA */
> +	.weak_battery_voltage = 3400,		/* mV */
> +	.battery_regulation_voltage = 4200,	/* mV */
> +	.charge_current = 650,			/* mA */
> +	.termination_current = 100,		/* mA */
> +	.resistor_sense = 68,			/* m ohm */
> +	.notify_device = "isp1704",
> +};
> +
>  static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_2[] = {
>  	{
>  		I2C_BOARD_INFO("tlv320aic3x", 0x18),

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
