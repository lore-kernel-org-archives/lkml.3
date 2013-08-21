Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3HUWlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:41:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42360 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3HUWli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:41:38 -0400
Date: Wed, 21 Aug 2013 23:41:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/8] drm/i2c: tda998x: add video and audio input
	configuration
Message-ID: <20130821224126.GB6617@n2100.arm.linux.org.uk>
References: <20130821203355.5bbc69d1@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821203355.5bbc69d1@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 08:33:55PM +0200, Jean-Francois Moine wrote:
> On Wed Aug 14 12:43:30 PDT 2013, Sebastian Hesselbarth wrote:
> > +static void
> > +reg_write_range(struct drm_encoder *encoder, uint16_t reg, uint8_t *p, int cnt)
> > +{
> > +	struct i2c_client *client = drm_i2c_encoder_get_client(encoder);
> > +	uint8_t buf[cnt+1];
> > +	int ret;
> > +
> > +	buf[0] = REG2ADDR(reg);
> > +	memcpy(&buf[1], p, cnt);
> > +
> > +	set_page(encoder, reg);
> > +
> > +	ret = i2c_master_send(client, buf, cnt + 1);
> > +	if (ret < 0)
> > +		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
> > +}
> > +
> 
> It seems simpler to reserve one byte in the caller buffer for the
> register address and avoid a memcpy.

And by doing so create an obtuse API.  No thanks.

> > +static void
> > +tda998x_write_aif(struct drm_encoder *encoder, struct tda998x_encoder_params *p)
> > +{
> > +	uint8_t buf[PB(5) + 1];
> > +
> > +	buf[HB(0)] = 0x84;
> > +	buf[HB(1)] = 0x01;
> > +	buf[HB(2)] = 10;
> 
> Why don't you use the constants which are defined in hdmi.h?

Because I was not aware of them.

> > +	/* Write the CTS and N values */
> > +	buf[0] = 0x44;
> > +	buf[1] = 0x42;
> > +	buf[2] = 0x01;
> 
> The CTS value is strange, but that does not matter: its generation is
> automatic (see above).

Correct - however not strange, if you've read the HDMI specification.

> > +	buf[3] = n;
> > +	buf[4] = n >> 8;
> > +	buf[5] = n >> 16;
> > +	reg_write_range(encoder, REG_ACR_CTS_0, buf, 6);
> > +
> > +	/* Set CTS clock reference */
> > +	reg_write(encoder, REG_AIP_CLKSEL, clksel_aip | clksel_fs);
> > +
> > +	/* Reset CTS generator */
> > +	reg_set(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
> > +	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
> > +
> > +	/* Write the channel status */
> > +	buf[0] = 0x04;
> > +	buf[1] = 0x00;
> > +	buf[2] = 0x00;
> > +	buf[3] = 0xf1;
> > +	reg_write_range(encoder, REG_CH_STAT_B(0), buf, 4);
> 	[snip]
> 
> From what I understood in the NXP driver, buf[3] depends on the sample
> rate: 0xf1 for 44.1kHz and 0xd1 for 48kHz.

Correct, but the driver has no way to know this.  The above reflects how
the NXP driver on the Cubox implements this (which we know works for
multiple different sample rates).  This is because we use SPDIF, which
encodes the sample rate in the channel status information, which is then
presumably passed through by the TDA998x.  I wouldn't know, I don't have
a HDMI debugger.

What I do know is that it works for multiple sample rates.
