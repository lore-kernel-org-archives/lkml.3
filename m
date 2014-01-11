Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaAKRft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:35:49 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34342 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751950AbaAKRfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:35:47 -0500
Date: Sat, 11 Jan 2014 17:35:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 12/28] drm/i2c: tda998x: add DT support
Message-ID: <20140111173536.GY15937@n2100.arm.linux.org.uk>
References: <20140109120324.4e2c8aca@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120324.4e2c8aca@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:03:24PM +0100, Jean-Francois Moine wrote:
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 2ba0355..b87802f 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -28,17 +28,22 @@
>  
>  #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
>  
> +#define AUDIO_SAMPLE 48		/* 48 kHz */

Horrid definition.  It says nothing about it's units, and given that
things like 44.1kHz are common place, should _not_ be kHz.

> +
>  struct tda998x_priv {
>  	struct i2c_client *cec;
>  	struct i2c_client *hdmi;
>  	uint16_t rev;
>  	uint8_t current_page;
> -	int dpms;
> +	u8 dpms;

A 'dpms' is defined in the DRM interfaces as an 'int' and should remain
as such.

> @@ -586,17 +591,17 @@ static void tda998x_audio_mute(struct tda998x_priv *priv, bool on)
>  
>  static void
>  tda998x_configure_audio(struct tda998x_priv *priv,
> -		struct drm_display_mode *mode, struct tda998x_encoder_params *p)
> +		struct drm_display_mode *mode)
>  {
>  	uint8_t buf[6], clksel_aip, clksel_fs, ca_i2s, cts_n, adiv;
>  	uint32_t n;
>  
>  	/* Enable audio ports */
> -	reg_write(priv, REG_ENA_AP, p->audio_cfg);
> -	reg_write(priv, REG_ENA_ACLK, p->audio_clk_cfg);
> +	reg_write(priv, REG_ENA_AP, priv->audio_port);
> +	reg_write(priv, REG_ENA_ACLK, 0x01);	/* enable clock */

This is a change of configuration for SPDIF.  SPDIF _can_ have an external
clock, or the TDA998x can recover the clock itself.  Enabling the clock
unconditionally is probably the wrong thing to do.

>  
>  	/* Set audio input source */
> -	switch (p->audio_format) {
> +	switch (priv->audio_type) {
>  	case AFMT_SPDIF:
>  		reg_write(priv, REG_MUX_AP, 0x40);
>  		clksel_aip = AIP_CLKSEL_AIP(0);
> @@ -644,7 +649,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
>  	 * This is the approximate value of N, which happens to be
>  	 * the recommended values for non-coherent clocks.
>  	 */
> -	n = 128 * p->audio_sample_rate / 1000;
> +	n = 128 * AUDIO_SAMPLE;		/* acr_n = 128 * sample_rate / 1000 */

If you keep the sample rate in Hz, you don't need the comment.

>  
>  	/* Write the CTS and N values */
>  	buf[0] = 0x44;
> @@ -674,7 +679,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
>  	tda998x_audio_mute(priv, false);
>  
>  	/* Write the audio information packet */
> -	tda998x_write_aif(priv, p);
> +	tda998x_write_aif(priv);
>  }
>  
>  /* DRM encoder functions */
> @@ -698,7 +703,13 @@ tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
>  			    VIP_CNTRL_2_SWAP_F(p->swap_f) |
>  			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
>  
> -	priv->params = *p;
> +	memcpy(priv->audio_frame, p->audio_frame,
> +			sizeof priv->audio_frame);
> +
> +	if (p->audio_cfg) {
> +		priv->audio_port = p->audio_cfg;
> +		priv->audio_type = p->audio_format;
> +	}

Does this really make things better?

> @@ -1157,6 +1168,8 @@ tda998x_encoder_init(struct i2c_client *client,
>  		    struct drm_encoder_slave *encoder_slave)
>  {
>  	struct tda998x_priv *priv;
> +	struct device_node *np = client->dev.of_node;
> +	u32 video;
>  	int ret;
>  
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> @@ -1166,6 +1179,7 @@ tda998x_encoder_init(struct i2c_client *client,
>  	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
>  	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
>  	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
> +	priv->audio_frame[1] = 1;		/* channels - 1 */
>  
>  	priv->current_page = 0xff;
>  	priv->hdmi = client;
> @@ -1225,6 +1239,17 @@ tda998x_encoder_init(struct i2c_client *client,
>  	cec_write(priv, REG_CEC_FRO_IM_CLK_CTRL,
>  			CEC_FRO_IM_CLK_CTRL_GHOST_DIS | CEC_FRO_IM_CLK_CTRL_IMCLK_SEL);
>  
> +	if (!np)
> +		return 0;		/* non-DT */
> +
> +	/* get the optional video properties */
> +	ret = of_property_read_u32(np, "video-ports", &video);
> +	if (ret == 0) {
> +		priv->vip_cntrl_0 = video >> 16;
> +		priv->vip_cntrl_1 = video >> 8;
> +		priv->vip_cntrl_2 = video;
> +	}

The creation of new DT bindings requires that the bindings are documented
in Documentation/devicetree/bindings, and this is done as a separate patch
to be submitted to the device tree maintainers for review, and this must
be reviewed before the corresponding DT code can be accepted into the
kernel.  Please create such a patch and submit it for their review.

Thanks.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
