Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaKUTHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:07:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33905 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaKUTHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:07:48 -0500
Date: Fri, 21 Nov 2014 20:07:44 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [4/5] i2c: davinci: use bus recovery infrastructure
Message-ID: <20141121190744.GB4431@pengutronix.de>
References: <1416477788-5544-5-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416477788-5544-5-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 12:03:07PM +0200, Grygorii Strashko wrote:
> This patch converts Davinci I2C driver to use I2C bus recovery
> infrastructure, introduced by commit 5f9296ba21b3 ("i2c: Add
> bus recovery infrastructure").
> 
> The i2c_bus_recovery_info is configured for Davinci I2C adapter
> only in case if scl_pin is provided in Platform data at least.
s/Platform/platform/

> 
> Because the controller must be held in reset while doing so, the
s/Because/As/

> recovery routine must re-init the controller. Since this was already
> being done after each call to i2c_recover_bus, move those calls into
> the recovery_prepare/unprepare routines and as well.
> 
> CC: Sekhar Nori <nsekhar@ti.com>
> CC: Kevin Hilman <khilman@deeprootsystems.com>
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> CC: Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/i2c/busses/i2c-davinci.c | 76 ++++++++++++++++++----------------------
>  1 file changed, 35 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index 2cef115..db2a2cd 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -133,43 +133,6 @@ static inline u16 davinci_i2c_read_reg(struct davinci_i2c_dev *i2c_dev, int reg)
>  	return readw_relaxed(i2c_dev->base + reg);
>  }
>  
> -/* Generate a pulse on the i2c clock pin. */
> -static void davinci_i2c_clock_pulse(unsigned int scl_pin)
> -{
> -	u16 i;
> -
> -	if (scl_pin) {
> -		/* Send high and low on the SCL line */
> -		for (i = 0; i < 9; i++) {
> -			gpio_set_value(scl_pin, 0);
> -			udelay(20);
> -			gpio_set_value(scl_pin, 1);
> -			udelay(20);
> -		}
> -	}
> -}
> -
> -/* This routine does i2c bus recovery as specified in the
> - * i2c protocol Rev. 03 section 3.16 titled "Bus clear"
> - */
> -static void davinci_i2c_recover_bus(struct davinci_i2c_dev *dev)
> -{
> -	u32 flag = 0;
> -	struct davinci_i2c_platform_data *pdata = dev->pdata;
> -
> -	dev_err(dev->dev, "initiating i2c bus recovery\n");
> -	/* Send NACK to the slave */
> -	flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
> -	flag |=  DAVINCI_I2C_MDR_NACK;
> -	/* write the data into mode register */
> -	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, flag);
> -	davinci_i2c_clock_pulse(pdata->scl_pin);
> -	/* Send STOP */
> -	flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
> -	flag |= DAVINCI_I2C_MDR_STP;
> -	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, flag);
> -}
> -
>  static inline void davinci_i2c_reset_ctrl(struct davinci_i2c_dev *i2c_dev,
>  								int val)
>  {
> @@ -266,6 +229,33 @@ static int i2c_davinci_init(struct davinci_i2c_dev *dev)
>  	return 0;
>  }
>  
> +/* This routine does i2c bus recovery as specified in the
> + * i2c protocol Rev. 03 section 3.16 titled "Bus clear"
> + */
This comment is wrong. The actual bus clear is implemented by
i2c_generic_gpio_recovery. Also while touching this comment, convert it
to the usual format with /* on its own line. (The file in question has
already both types of comment, so consistency is not a reason to keep it
as is.)

Even though I remember that I reviewed this bus recovery patch (that
resulted in 5f9296ba21b3) back then, I don't remember why it was split
in prepare + recover + unprepare. But that is unrelated to this patch.

> +static void davinci_i2c_prepare_recovery(struct i2c_adapter *adap)
> +{
> +	struct davinci_i2c_dev *dev = i2c_get_adapdata(adap);
> +
> +	dev_err(dev->dev, "initiating i2c bus recovery\n");
> +	/* Disable interrupts */
> +	davinci_i2c_write_reg(dev, DAVINCI_I2C_IMR_REG, 0);
> +
> +	/* put I2C into reset */
> +	davinci_i2c_reset_ctrl(dev, 0);
> +}
> +
> +static void davinci_i2c_unprepare_recovery(struct i2c_adapter *adap)
> +{
> +	struct davinci_i2c_dev *dev = i2c_get_adapdata(adap);
> +
> +	i2c_davinci_init(dev);
> +}
> +
> +static struct i2c_bus_recovery_info davinci_i2c_gpio_recovery_info = {
I'd call this only davinci_i2c_recovery_info.

> +	.recover_bus = i2c_generic_gpio_recovery,
> +	.prepare_recovery = davinci_i2c_prepare_recovery,
> +	.unprepare_recovery = davinci_i2c_unprepare_recovery,
> +};
new line here please

>  /*
>   * Waiting for bus not busy
>   */
> @@ -286,8 +276,7 @@ static int i2c_davinci_wait_bus_not_busy(struct davinci_i2c_dev *dev,
>  				return -ETIMEDOUT;
>  			} else {
>  				to_cnt = 0;
> -				davinci_i2c_recover_bus(dev);
> -				i2c_davinci_init(dev);
> +				i2c_recover_bus(&dev->adapter);
>  			}
>  		}
>  		if (allow_sleep)
> @@ -376,8 +365,7 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
>  						      dev->adapter.timeout);
>  	if (r == 0) {
>  		dev_err(dev->dev, "controller timed out\n");
> -		davinci_i2c_recover_bus(dev);
> -		i2c_davinci_init(dev);
> +		i2c_recover_bus(adap);
>  		dev->buf_len = 0;
>  		return -ETIMEDOUT;
>  	}
> @@ -717,6 +705,12 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  	adap->timeout = DAVINCI_I2C_TIMEOUT;
>  	adap->dev.of_node = pdev->dev.of_node;
>  
> +	if (dev->pdata->scl_pin) {
> +		adap->bus_recovery_info = &davinci_i2c_gpio_recovery_info;
> +		adap->bus_recovery_info->scl_gpio = dev->pdata->scl_pin;
> +		adap->bus_recovery_info->sda_gpio = dev->pdata->sda_pin;
> +	}
> +
>  	adap->nr = pdev->id;
>  	r = i2c_add_numbered_adapter(adap);
>  	if (r) {
Just another general comment about the driver that doesn't influence the
correctness of this patch: The i2c-davinci driver is quite quick to
reset the bus. I wonder how often this reset triggers. Is the bus in
question less "stable" than others?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
