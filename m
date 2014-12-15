Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbaLOUu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:50:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47497 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaLOUu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:50:26 -0500
Message-ID: <548F498F.7050202@ti.com>
Date: Mon, 15 Dec 2014 14:50:23 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <linus.walleij@linaro.org>,
        <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: Re: [PATCH] gpio: pcf857x: restore the initial line state of all
 pcf lines
References: <1418371601-22658-1-git-send-email-kishon@ti.com>
In-Reply-To: <1418371601-22658-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 02:06 AM, Kishon Vijay Abraham I wrote:
> The reset values for all the PCF lines are high and hence on shutdown
> we should drive all the lines high in order to bring it to the reset state.
> 
> This is actually required since pcf doesn't have a reset line and even after
> warm reset (by invoking "reboot" in prompt) the pcf lines maintains it's
> previous programmed state. This becomes a problem if the boards are designed
> to work with the default initial state.
> 
> DRA7XX_evm uses PCF8575 and one of the PCF output lines feeds to MMC/SD and
> this line should be driven high in order for the MMC/SD to be detected.
> This line is modelled as regulator and the hsmmc driver takes care of enabling
> and disabling it. In the case of 'reboot', during shutdown path as part of it's
> cleanup process the hsmmc driver disables this regulator. This makes MMC boot
> not functional.
> 
> Fixed it by driving high all the pcf lines.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/gpio/gpio-pcf857x.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
> index 236708a..00b15b2 100644
> --- a/drivers/gpio/gpio-pcf857x.c
> +++ b/drivers/gpio/gpio-pcf857x.c
> @@ -448,6 +448,14 @@ static int pcf857x_remove(struct i2c_client *client)
>  	return status;
>  }
>  
> +static void pcf857x_shutdown(struct i2c_client *client)
> +{
> +	struct pcf857x *gpio = i2c_get_clientdata(client);
> +
> +	/* Drive all the I/O lines high */
> +	gpio->write(gpio->client, BIT(gpio->chip.ngpio) - 1);

you might force a contention here - depending on System configuration.
example:
+-------+
|       |
|  U1   |         +------+      +-----------+
|       +--------->      |      |           |
+-------+         |      |      |           |
                  | Switch<-----+    SoC    |
+-------+         |      |      |           |
|       |         |      |      |           |
| U2    <---------+--^---+      +-----------+
|       |            |
|       |            |
+-------+            |
                  +--+--+
                  |     |
                  | PCF |
                  |     |
                  +-----+

At low, SoC pin is connected to U2 as drive. when reset to high, you
now have U1 driving to the same pin that SoC has, potentially
resulting in contention.


Unfortunately, at this level, you do not know what the state of the
system is, blindly forcing a pin level will potentially cause
contention risk depending on pin configuration.


> +}
> +
>  static struct i2c_driver pcf857x_driver = {
>  	.driver = {
>  		.name	= "pcf857x",
> @@ -456,6 +464,7 @@ static struct i2c_driver pcf857x_driver = {
>  	},
>  	.probe	= pcf857x_probe,
>  	.remove	= pcf857x_remove,
> +	.shutdown = pcf857x_shutdown,
>  	.id_table = pcf857x_id,
>  };
>  
> 


-- 
Regards,
Nishanth Menon
