Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbaKTWUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:20:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45435 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbaKTWT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:19:59 -0500
Date: Thu, 20 Nov 2014 23:19:53 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [2/5] i2c: davinci: query STP always when NACK is received
Message-ID: <20141120221953.GI27002@pengutronix.de>
References: <1416477788-5544-3-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416477788-5544-3-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 20, 2014 at 12:03:05PM +0200, Grygorii Strashko wrote:
> According to I2C specification the NACK should be handled as folowing:
s/folowing/follows/

> "When SDA remains HIGH during this ninth clock pulse, this is defined as the Not
> Acknowledge signal. The master can then gene rate either a STOP condition to
s/gene rate/generate/

> abort the transfer, or a repeated START condition to start a new transfer."
> [http://www.nxp.com/documents/user_manual/UM10204.pdf]
The link is nice, but pointing out that this is the i2c spec would be
nice.

> The same is recomened by TI I2C wiki:
s/recomened/recommended/

>  http://processors.wiki.ti.com/index.php/I2C_Tips
If the specification tells what to do, there is no need to further
support your claim.

> Currently, the Davinci I2C driver interrupts I2C trunsfer in case of NACK, but
s/trunsfer/transfer/

> It queries Stop condition DAVINCI_I2C_MDR_REG.STP=1 only if NACK has been received
s/It/it/

> during the last message transmitting/recieving.
s/transmitting/transmitted/; s/recieving/received/

I think I don't understand this sentence even with the typos corrected.
Do you want to say:

Currently the Davinci i2c driver interrupts the transfer on receipt of a
NACK but fails to send a STOP in some situations and so makes the bus
stuck.

> This may lead to Bus stuck in "Bus Busy" until I2C IP reset (idle/enable) if
> during SMBus reading transaction the first I2C message is NACKed.
Did you hit this problem, or is this a theoretical issue?

Assuming this is a candidate for stable, adding a Fixes:-footer would be
nice.

> Hence, fix it by querying Stop condition (STP) always when NACK is received.
> 
> This patch fixes Davinci I2C in the same way it was done for OMAP I2C
> commit cda2109a26eb ("i2c: omap: query STP always when NACK is received").
> 
> More info can be found at:
> https://lkml.org/lkml/2013/7/16/159
> http://patchwork.ozlabs.org/patch/249790/
I'd drop this "more info" paragraph.

> CC: Sekhar Nori <nsekhar@ti.com>
> CC: Kevin Hilman <khilman@deeprootsystems.com>
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> CC: Murali Karicheri <m-karicheri2@ti.com>
> Reported-by: Hein Tibosch <hein_tibosch@yahoo.es>
Is this Reported-by tag reused from the omap issue?

> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/i2c/busses/i2c-davinci.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index 9bbfb8f..2cef115 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -411,11 +411,9 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
>  	if (dev->cmd_err & DAVINCI_I2C_STR_NACK) {
>  		if (msg->flags & I2C_M_IGNORE_NAK)
>  			return msg->len;
> -		if (stop) {
> -			w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
> -			w |= DAVINCI_I2C_MDR_STP;
> -			davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
> -		}
> +		w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
> +		w |= DAVINCI_I2C_MDR_STP;
> +		davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
I think this is a good change, but I wonder if the handling of
I2C_M_IGNORE_NAK is correct here. If the controller reports a NACK say
for the 2nd byte of a 5-byte-message, the transfer supposed to
continue, right? (Hmm, maybe the framework handle this and restarts the
transfer with I2C_M_NOSTART but the davinci driver doesn't seem to
handle this flag?)

Best regards
Uwe

>  		return -EREMOTEIO;
>  	}
>  	return -EIO;

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
