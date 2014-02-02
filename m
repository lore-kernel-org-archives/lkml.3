Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaBBR3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 12:29:44 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:59962 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbaBBR3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 12:29:43 -0500
Date: Sun, 2 Feb 2014 18:30:00 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v5 02/23] drm/i2c: tda998x: check more I/O errors
Message-ID: <20140202183000.1cf9ca9c@armhf>
In-Reply-To: <20140202162057.GE26684@n2100.arm.linux.org.uk>
References: <cover.1390986082.git.moinejf@free.fr>
	<9ebf1fdd613b5747aefb3ee21c9c246d102f1a47.1390986082.git.moinejf@free.fr>
	<20140202162057.GE26684@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Feb 2014 16:20:58 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sat, Jan 25, 2014 at 06:14:45PM +0100, Jean-Francois Moine wrote:
> > This patch adds more error checking inn I2C I/O functions.
> > In case of I/O error, this permits to avoid writing in bad controller
> > pages, a bad chipset detection or looping when getting the EDID.
> 
> I've just looked at this again, and spotted something:
> 
> > -static uint8_t
> > +static int
> >  reg_read(struct tda998x_priv *priv, uint16_t reg)
> >  {
> >  	uint8_t val = 0;
> > -	reg_read_range(priv, reg, &val, sizeof(val));
> > +	int ret;
> > +
> > +	ret = reg_read_range(priv, reg, &val, sizeof(val));
> > +	if (ret < 0)
> > +		return ret;
> 
> So yes, this can return negative numbers.
> 
> > @@ -1158,8 +1184,11 @@ tda998x_encoder_init(struct i2c_client *client,
> >  	tda998x_reset(priv);
> >  
> >  	/* read version: */
> > -	priv->rev = reg_read(priv, REG_VERSION_LSB) |
> > -			reg_read(priv, REG_VERSION_MSB) << 8;
> > +	ret = reg_read(priv, REG_VERSION_LSB) |
> > +		(reg_read(priv, REG_VERSION_MSB) << 8);
> > +	if (ret < 0)
> > +		goto fail;
> > +	priv->rev = ret;
> 
> Two issues here:
> 
> 1. The additional parens are /really/ not required.
> 2. What if reg_read(priv, REG_VERSION_MSB) returns a negative number?
> 
> If we're going to the extent of attempting to make the read/write
> functions return errors, we should at least handle errors generated
> by them properly, otherwise it's pointless making them return errors.
> 
> 	ret = reg_read(priv, REG_VERSION_LSB);
> 	if (ret < 0)
> 		goto fail;
> 
> 	priv->rev = ret;
> 
> 	ret = reg_read(priv, REG_VERSION_MSB);
> 	if (ret < 0)
> 		goto fail;
> 
> 	priv->rev |= ret << 8;
> 
> If you want it to look slightly nicer:
> 
> 	int rev_lo, rev_hi;
> 
> 	rev_lo = reg_read(priv, REG_VERSION_LSB);
> 	rev_hi = reg_read(priv, REG_VERSION_MSB);
> 	if (rev_lo < 0 || rev_hi < 0) {
> 		ret = rev_lo < 0 ? rev_lo : rev_hi;
> 		goto fail;
> 	}
> 
> 	priv->rev = rev_lo | rev_hi << 8;
> 
> I'm happy to commit such a change after this patch to clean it up, or if
> you want to regenerate your patch 2 and post /just/ that incorporating
> this change.

I think that my code works correctly: when there is an error, the
result of reg_read() is minus the error code, and this error code is
always lower than 8388607 (0x7fffff). Then, reg_read() << 8 will always
be negative.

Otherwise, I may redo a patch about the useless parenthesis.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
