Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbbAGOjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:39:42 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:37525 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752656AbbAGOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:39:40 -0500
Message-ID: <54AD4511.30702@arm.com>
Date: Wed, 07 Jan 2015 14:39:13 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Dave Airlie <airlied@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
References: <cover.1420628786.git.moinejf@free.fr> <0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>
In-Reply-To: <0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/15 09:10, Jean-Francois Moine wrote:
> This patch permits the definition of the audio ports from the device tree.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  .../devicetree/bindings/drm/i2c/tda998x.txt        | 18 +++++++
>  drivers/gpu/drm/i2c/tda998x_drv.c                  | 60 ++++++++++++++++++----
>  2 files changed, 69 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> index e9e4bce..e50e7cd 100644
> --- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> +++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> @@ -17,6 +17,20 @@ Optional properties:
>    - video-ports: 24 bits value which defines how the video controller
>  	output is wired to the TDA998x input - default: <0x230145>
>  
> +  - audio-ports: must contain one or two values selecting the source
> +	in the audio port.
> +	The source type is given by the corresponding entry in
> +	the audio-port-names property.

I think that this entry might benefit from a little more explanation.
The value specified here selects which pins on the chip provide the
audio input doesn't it?  In the outline datasheet that I have these are
listed in table 17:

Audio port 	Input configuration
		S/PDIF 		I2S-bus
AP0 		- 		WS (word select)
AP1 		S/PDIF input 	I2S-bus channel 0
AP2 		S/PDIF input 	I2S-bus channel 1
AP3[1] 				I2S-bus channel 2
AP4[1] 				I2S-bus channel 3
ACLK 		- 		SCK (I2S-bus clock)

[1] Depending on package.

	Andrew

> +
> +  - audio-port-names: must contain entries matching the entries in
> +	the audio-ports property.
> +	Each value may be "i2s" or "spdif", giving the type of
> +	the audio source.
> +
> +  - #sound-dai-cells: must be set to <1> for use with the simple-card.
> +	The TDA998x audio CODEC always defines two DAIs.
> +	The DAI 0 is the S/PDIF input and the DAI 1 is the I2S input.
> +
>  Example:
>  
>  	tda998x: hdmi-encoder {
> @@ -26,4 +40,8 @@ Example:
>  		interrupts = <27 2>;		/* falling edge */
>  		pinctrl-0 = <&pmx_camera>;
>  		pinctrl-names = "default";
> +
> +		audio-ports = <0x04>, <0x03>;
> +		audio-port-names = "spdif", "i2s";
> +		#sound-dai-cells = <1>;
>  	};
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 70658af..9d9b072 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -20,6 +20,7 @@
>  #include <linux/module.h>
>  #include <linux/irq.h>
>  #include <sound/asoundef.h>
> +#include <linux/platform_device.h>
>  
>  #include <drm/drmP.h>
>  #include <drm/drm_crtc_helper.h>
> @@ -44,6 +45,8 @@ struct tda998x_priv {
>  	wait_queue_head_t wq_edid;
>  	volatile int wq_edid_wait;
>  	struct drm_encoder *encoder;
> +
> +	u8 audio_ports[2];
>  };
>  
>  #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
> @@ -1254,12 +1257,16 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
>  {
>  	struct device_node *np = client->dev.of_node;
>  	u32 video;
> -	int rev_lo, rev_hi, ret;
> +	int i, rev_lo, rev_hi, ret;
> +	const char *p;
>  
>  	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
>  	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
>  	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
>  
> +	priv->params.audio_frame[1] = 1;		/* channels - 1 */
> +	priv->params.audio_sample_rate = 48000;		/* 48kHz */
> +
>  	priv->current_page = 0xff;
>  	priv->hdmi = client;
>  	priv->cec = i2c_new_dummy(client->adapter, 0x34);
> @@ -1351,15 +1358,50 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
>  	/* enable EDID read irq: */
>  	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
>  
> -	if (!np)
> -		return 0;		/* non-DT */
> +	/* get the device tree parameters */
> +	if (np) {
> +
> +		/* optional video properties */
> +		ret = of_property_read_u32(np, "video-ports", &video);
> +		if (ret == 0) {
> +			priv->vip_cntrl_0 = video >> 16;
> +			priv->vip_cntrl_1 = video >> 8;
> +			priv->vip_cntrl_2 = video;
> +		}
> +
> +		/* optional audio properties */
> +		for (i = 0; i < 2; i++) {
> +			u32 port;
>  
> -	/* get the optional video properties */
> -	ret = of_property_read_u32(np, "video-ports", &video);
> -	if (ret == 0) {
> -		priv->vip_cntrl_0 = video >> 16;
> -		priv->vip_cntrl_1 = video >> 8;
> -		priv->vip_cntrl_2 = video;
> +			ret = of_property_read_u32_index(np, "audio-ports", i, &port);
> +			if (ret)
> +				break;
> +			ret = of_property_read_string_index(np, "audio-port-names",
> +							i, &p);
> +			if (ret) {
> +				dev_err(&client->dev,
> +					"missing audio-port-names[%d]\n", i);
> +				break;
> +			}
> +			if (strcmp(p, "spdif") == 0) {
> +				priv->audio_ports[0] = port;
> +			} else if (strcmp(p, "i2s") == 0) {
> +				priv->audio_ports[1] = port;
> +			} else {
> +				dev_err(&client->dev,
> +					"bad audio-port-names '%s'\n", p);
> +				break;
> +			}
> +		}
> +		if (priv->audio_ports[0]) {
> +			priv->params.audio_cfg = priv->audio_ports[0];
> +			priv->params.audio_format = AFMT_SPDIF;
> +			priv->params.audio_clk_cfg = 0;
> +		} else {
> +			priv->params.audio_cfg = priv->audio_ports[1];
> +			priv->params.audio_format = AFMT_I2S;
> +			priv->params.audio_clk_cfg = 1;
> +		}
>  	}
>  
>  	return 0;
> 

