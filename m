Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab3DXWzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:55:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42537 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757971Ab3DXWza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:55:30 -0400
Date: Wed, 24 Apr 2013 23:55:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Message-ID: <20130424225525.GA2619@decadent.org.uk>
References: <20130423215456.307216898@linuxfoundation.org>
 <20130423215456.648272535@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423215456.648272535@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 03/23] can: sja1000: fix handling on dt properties on little
 endian systems
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 02:56:10PM -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Christoph Fritz <chf.fritz@googlemail.com>
> 
> commit 0443de5fbf224abf41f688d8487b0c307dc5a4b4 upstream.
> 
> To get correct endianes on little endian cpus (like arm) while reading device
> tree properties, this patch replaces of_get_property() with
> of_property_read_u32(). While there use of_property_read_bool() for the
> handling of the boolean "nxp,no-comparator-bypass" property.
> 
> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 
This depends on commit fa4d34ccd091 'of: introduce helper to manage
boolean'.  (I noticed this when looking at it for 3.2.y, but I haven't
compiled the driver to check that that's the *only* thing it requires.)

Ben.

> ---
>  drivers/net/can/sja1000/sja1000_of_platform.c |   31 ++++++++++++--------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> --- a/drivers/net/can/sja1000/sja1000_of_platform.c
> +++ b/drivers/net/can/sja1000/sja1000_of_platform.c
> @@ -93,8 +93,8 @@ static int __devinit sja1000_ofp_probe(s
>  	struct net_device *dev;
>  	struct sja1000_priv *priv;
>  	struct resource res;
> -	const u32 *prop;
> -	int err, irq, res_size, prop_size;
> +	u32 prop;
> +	int err, irq, res_size;
>  	void __iomem *base;
>  
>  	err = of_address_to_resource(np, 0, &res);
> @@ -135,27 +135,27 @@ static int __devinit sja1000_ofp_probe(s
>  	priv->read_reg = sja1000_ofp_read_reg;
>  	priv->write_reg = sja1000_ofp_write_reg;
>  
> -	prop = of_get_property(np, "nxp,external-clock-frequency", &prop_size);
> -	if (prop && (prop_size ==  sizeof(u32)))
> -		priv->can.clock.freq = *prop / 2;
> +	err = of_property_read_u32(np, "nxp,external-clock-frequency", &prop);
> +	if (!err)
> +		priv->can.clock.freq = prop / 2;
>  	else
>  		priv->can.clock.freq = SJA1000_OFP_CAN_CLOCK; /* default */
>  
> -	prop = of_get_property(np, "nxp,tx-output-mode", &prop_size);
> -	if (prop && (prop_size == sizeof(u32)))
> -		priv->ocr |= *prop & OCR_MODE_MASK;
> +	err = of_property_read_u32(np, "nxp,tx-output-mode", &prop);
> +	if (!err)
> +		priv->ocr |= prop & OCR_MODE_MASK;
>  	else
>  		priv->ocr |= OCR_MODE_NORMAL; /* default */
>  
> -	prop = of_get_property(np, "nxp,tx-output-config", &prop_size);
> -	if (prop && (prop_size == sizeof(u32)))
> -		priv->ocr |= (*prop << OCR_TX_SHIFT) & OCR_TX_MASK;
> +	err = of_property_read_u32(np, "nxp,tx-output-config", &prop);
> +	if (!err)
> +		priv->ocr |= (prop << OCR_TX_SHIFT) & OCR_TX_MASK;
>  	else
>  		priv->ocr |= OCR_TX0_PULLDOWN; /* default */
>  
> -	prop = of_get_property(np, "nxp,clock-out-frequency", &prop_size);
> -	if (prop && (prop_size == sizeof(u32)) && *prop) {
> -		u32 divider = priv->can.clock.freq * 2 / *prop;
> +	err = of_property_read_u32(np, "nxp,clock-out-frequency", &prop);
> +	if (!err && prop) {
> +		u32 divider = priv->can.clock.freq * 2 / prop;
>  
>  		if (divider > 1)
>  			priv->cdr |= divider / 2 - 1;
> @@ -165,8 +165,7 @@ static int __devinit sja1000_ofp_probe(s
>  		priv->cdr |= CDR_CLK_OFF; /* default */
>  	}
>  
> -	prop = of_get_property(np, "nxp,no-comparator-bypass", NULL);
> -	if (!prop)
> +	if (!of_property_read_bool(np, "nxp,no-comparator-bypass"))
>  		priv->cdr |= CDR_CBP; /* default */
>  
>  	priv->irq_flags = IRQF_SHARED;

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
