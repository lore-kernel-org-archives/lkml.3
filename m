Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaBBQVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:21:12 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55265 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751751AbaBBQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:21:11 -0500
Date: Sun, 2 Feb 2014 16:20:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v5 02/23] drm/i2c: tda998x: check more I/O errors
Message-ID: <20140202162057.GE26684@n2100.arm.linux.org.uk>
References: <cover.1390986082.git.moinejf@free.fr> <9ebf1fdd613b5747aefb3ee21c9c246d102f1a47.1390986082.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ebf1fdd613b5747aefb3ee21c9c246d102f1a47.1390986082.git.moinejf@free.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 06:14:45PM +0100, Jean-Francois Moine wrote:
> This patch adds more error checking inn I2C I/O functions.
> In case of I/O error, this permits to avoid writing in bad controller
> pages, a bad chipset detection or looping when getting the EDID.

I've just looked at this again, and spotted something:

> -static uint8_t
> +static int
>  reg_read(struct tda998x_priv *priv, uint16_t reg)
>  {
>  	uint8_t val = 0;
> -	reg_read_range(priv, reg, &val, sizeof(val));
> +	int ret;
> +
> +	ret = reg_read_range(priv, reg, &val, sizeof(val));
> +	if (ret < 0)
> +		return ret;

So yes, this can return negative numbers.

> @@ -1158,8 +1184,11 @@ tda998x_encoder_init(struct i2c_client *client,
>  	tda998x_reset(priv);
>  
>  	/* read version: */
> -	priv->rev = reg_read(priv, REG_VERSION_LSB) |
> -			reg_read(priv, REG_VERSION_MSB) << 8;
> +	ret = reg_read(priv, REG_VERSION_LSB) |
> +		(reg_read(priv, REG_VERSION_MSB) << 8);
> +	if (ret < 0)
> +		goto fail;
> +	priv->rev = ret;

Two issues here:

1. The additional parens are /really/ not required.
2. What if reg_read(priv, REG_VERSION_MSB) returns a negative number?

If we're going to the extent of attempting to make the read/write
functions return errors, we should at least handle errors generated
by them properly, otherwise it's pointless making them return errors.

	ret = reg_read(priv, REG_VERSION_LSB);
	if (ret < 0)
		goto fail;

	priv->rev = ret;

	ret = reg_read(priv, REG_VERSION_MSB);
	if (ret < 0)
		goto fail;

	priv->rev |= ret << 8;

If you want it to look slightly nicer:

	int rev_lo, rev_hi;

	rev_lo = reg_read(priv, REG_VERSION_LSB);
	rev_hi = reg_read(priv, REG_VERSION_MSB);
	if (rev_lo < 0 || rev_hi < 0) {
		ret = rev_lo < 0 ? rev_lo : rev_hi;
		goto fail;
	}

	priv->rev = rev_lo | rev_hi << 8;

I'm happy to commit such a change after this patch to clean it up, or if
you want to regenerate your patch 2 and post /just/ that incorporating
this change.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
