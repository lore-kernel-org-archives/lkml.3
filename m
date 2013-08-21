Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3HUSdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:33:53 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:57403 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3HUSdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:33:52 -0400
Date: Wed, 21 Aug 2013 20:33:55 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/8] drm/i2c: tda998x: add video and audio input
 configuration
Message-ID: <20130821203355.5bbc69d1@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Aug 14 12:43:30 PDT 2013, Sebastian Hesselbarth wrote:
> From: Russell King <rmk+kernel at arm.linux.org.uk>
> 
> This patch adds tda998x specific parameters to allow it to be configured
> for different boards using it. Also, this implements rudimentary audio
> support for S/PDIF attached controllers.

It seems that this patch mixes two different functions:
- configuration
- audio

About configuration, why don't you use the standard way to set the
device parameters, i.e. board info and DT?

> Signed-off-by: Russell King <rmk+kernel at arm.linux.org.uk>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth at gmail.com>
> Tested-by: Darren Etheridge <detheridge at ti.com>
> ---
> Changelog:
> for v1:
> - set AUDIO_DIV to SERCLK/16 for modes with pixclk >100MHz
> - also calculate CTS
> v1->v2:
> - Remove CTS calculation as it isn't used in current TDA998x setup
>   (Reported by Russell King)
> - Remove debug left-over (Reported by Russell King)
> - Use correct tda998x include (Reported by Russell King)
> 
> Cc: David Airlie <airlied at linux.ie>
> Cc: Darren Etheridge <detheridge at ti.com>
> Cc: Rob Clark <robdclark at gmail.com>
> Cc: Russell King <rmk+kernel at arm.linux.org.uk>
> Cc: Daniel Vetter <daniel.vetter at ffwll.ch>
> Cc: dri-devel at lists.freedesktop.org
> Cc: linux-kernel at vger.kernel.org
> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c |  268 +++++++++++++++++++++++++++++++++++--
>  include/drm/i2c/tda998x.h         |   30 +++++
>  2 files changed, 290 insertions(+), 8 deletions(-)
>  create mode 100644 include/drm/i2c/tda998x.h
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 527d11b..2b64dfa 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
	[snip]
> @@ -344,6 +390,23 @@ fail:
>  	return ret;
>  }
>  
> +static void
> +reg_write_range(struct drm_encoder *encoder, uint16_t reg, uint8_t *p, int cnt)
> +{
> +	struct i2c_client *client = drm_i2c_encoder_get_client(encoder);
> +	uint8_t buf[cnt+1];
> +	int ret;
> +
> +	buf[0] = REG2ADDR(reg);
> +	memcpy(&buf[1], p, cnt);
> +
> +	set_page(encoder, reg);
> +
> +	ret = i2c_master_send(client, buf, cnt + 1);
> +	if (ret < 0)
> +		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
> +}
> +

It seems simpler to reserve one byte in the caller buffer for the
register address and avoid a memcpy.

>  static uint8_t
>  reg_read(struct drm_encoder *encoder, uint16_t reg)
>  {
> @@ -412,7 +475,7 @@ tda998x_reset(struct drm_encoder *encoder)
>  	reg_write(encoder, REG_SERIALIZER,   0x00);
>  	reg_write(encoder, REG_BUFFER_OUT,   0x00);
>  	reg_write(encoder, REG_PLL_SCG1,     0x00);
> -	reg_write(encoder, REG_AUDIO_DIV,    0x03);
> +	reg_write(encoder, REG_AUDIO_DIV,    AUDIO_DIV_SERCLK_8);
>  	reg_write(encoder, REG_SEL_CLK,      SEL_CLK_SEL_CLK1 | SEL_CLK_ENA_SC_CLK);
>  	reg_write(encoder, REG_PLL_SCGN1,    0xfa);
>  	reg_write(encoder, REG_PLL_SCGN2,    0x00);
> @@ -424,11 +487,184 @@ tda998x_reset(struct drm_encoder *encoder)
>  	reg_write(encoder, REG_MUX_VP_VIP_OUT, 0x24);
>  }
>  
> +static uint8_t tda998x_cksum(uint8_t *buf, size_t bytes)
> +{
> +	uint8_t sum = 0;
> +
> +	while (bytes--)
> +		sum += *buf++;
> +	return (255 - sum) + 1;
> +}

Simpler:

static uint8_t tda998x_cksum(uint8_t *buf, size_t bytes)
{
	int sum = 0;			/* avoid byte computation */

	while (bytes--)
		sum -= *buf++;		/* avoid a substraction */
	return sum;
}

> +
> +#define HB(x) (x)
> +#define PB(x) (HB(2) + 1 + (x))
> +
> +static void
> +tda998x_write_if(struct drm_encoder *encoder, uint8_t bit, uint16_t addr,
> +		 uint8_t *buf, size_t size)
> +{
> +	buf[PB(0)] = tda998x_cksum(buf, size);
> +
> +	reg_clear(encoder, REG_DIP_IF_FLAGS, bit);
> +	reg_write_range(encoder, addr, buf, size);
> +	reg_set(encoder, REG_DIP_IF_FLAGS, bit);
> +}
> +
> +static void
> +tda998x_write_aif(struct drm_encoder *encoder, struct tda998x_encoder_params *p)
> +{
> +	uint8_t buf[PB(5) + 1];
> +
> +	buf[HB(0)] = 0x84;
> +	buf[HB(1)] = 0x01;
> +	buf[HB(2)] = 10;

Why don't you use the constants which are defined in hdmi.h?

> +	buf[PB(0)] = 0;
> +	buf[PB(1)] = p->audio_frame[1] & 0x07; /* CC */
> +	buf[PB(2)] = p->audio_frame[2] & 0x1c; /* SF */
> +	buf[PB(4)] = p->audio_frame[4];
> +	buf[PB(5)] = p->audio_frame[5] & 0xf8; /* DM_INH + LSV */
> +
> +	tda998x_write_if(encoder, DIP_IF_FLAGS_IF4, REG_IF4_HB0, buf,
> +			 sizeof(buf));
> +}
> +
> +static void
> +tda998x_write_avi(struct drm_encoder *encoder, struct drm_display_mode *mode)
> +{
> +	uint8_t buf[PB(13) + 1];
> +
> +	memset(buf, 0, sizeof(buf));
> +	buf[HB(0)] = 0x82;
> +	buf[HB(1)] = 0x02;
> +	buf[HB(2)] = 13;
> +	buf[PB(4)] = drm_match_cea_mode(mode);
> +
> +	tda998x_write_if(encoder, DIP_IF_FLAGS_IF2, REG_IF2_HB0, buf,
> +			 sizeof(buf));
> +}
> +
> +static void tda998x_audio_mute(struct drm_encoder *encoder, bool on)
> +{
> +	if (on) {
> +		reg_set(encoder, REG_SOFTRESET, SOFTRESET_AUDIO);
> +		reg_clear(encoder, REG_SOFTRESET, SOFTRESET_AUDIO);
> +		reg_set(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
> +	} else {
> +		reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
> +	}
> +}
> +
> +static void
> +tda998x_configure_audio(struct drm_encoder *encoder,
> +		struct drm_display_mode *mode, struct tda998x_encoder_params *p)
> +{
> +	uint8_t buf[6], clksel_aip, clksel_fs, ca_i2s, cts_n, adiv;
> +	uint32_t n;
> +
> +	/* Enable audio ports */
> +	reg_write(encoder, REG_ENA_AP, p->audio_cfg);
> +	reg_write(encoder, REG_ENA_ACLK, p->audio_clk_cfg);
> +
> +	/* Set audio input source */
> +	switch (p->audio_format) {
> +	case AFMT_SPDIF:
> +		reg_write(encoder, REG_MUX_AP, 0x40);
> +		clksel_aip = AIP_CLKSEL_AIP(0);
> +		/* FS64SPDIF */
> +		clksel_fs = AIP_CLKSEL_FS(2);
> +		cts_n = CTS_N_M(3) | CTS_N_K(3);
> +		ca_i2s = 0;
> +		break;
> +
> +	case AFMT_I2S:
> +		reg_write(encoder, REG_MUX_AP, 0x64);
> +		clksel_aip = AIP_CLKSEL_AIP(1);
> +		/* ACLK */
> +		clksel_fs = AIP_CLKSEL_FS(0);
> +		cts_n = CTS_N_M(3) | CTS_N_K(3);
> +		ca_i2s = CA_I2S_CA_I2S(0);
> +		break;
> +	}
> +
> +	reg_write(encoder, REG_AIP_CLKSEL, clksel_aip);
> +	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
> +
> +	/* Enable automatic CTS generation */
> +	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_ACR_MAN);
> +	reg_write(encoder, REG_CTS_N, cts_n);
> +
> +	/*
> +	 * Audio input somehow depends on HDMI line rate which is
> +	 * related to pixclk. Testing showed that modes with pixclk
> +	 * >100MHz need a larger divider while <40MHz need the default.
> +	 * There is no detailed info in the datasheet, so we just
> +	 * assume 100MHz requires larger divider.
> +	 */
> +	if (mode->clock > 100000)
> +		adiv = AUDIO_DIV_SERCLK_16;
> +	else
> +		adiv = AUDIO_DIV_SERCLK_8;
> +	reg_write(encoder, REG_AUDIO_DIV, adiv);
> +
> +	/*
> +	 * This is the approximate value of N, which happens to be
> +	 * the recommended values for non-coherent clocks.
> +	 */
> +	n = 128 * p->audio_sample_rate / 1000;
> +
> +	/* Write the CTS and N values */
> +	buf[0] = 0x44;
> +	buf[1] = 0x42;
> +	buf[2] = 0x01;

The CTS value is strange, but that does not matter: its generation is
automatic (see above).

> +	buf[3] = n;
> +	buf[4] = n >> 8;
> +	buf[5] = n >> 16;
> +	reg_write_range(encoder, REG_ACR_CTS_0, buf, 6);
> +
> +	/* Set CTS clock reference */
> +	reg_write(encoder, REG_AIP_CLKSEL, clksel_aip | clksel_fs);
> +
> +	/* Reset CTS generator */
> +	reg_set(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
> +	reg_clear(encoder, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
> +
> +	/* Write the channel status */
> +	buf[0] = 0x04;
> +	buf[1] = 0x00;
> +	buf[2] = 0x00;
> +	buf[3] = 0xf1;
> +	reg_write_range(encoder, REG_CH_STAT_B(0), buf, 4);
	[snip]

>From what I understood in the NXP driver, buf[3] depends on the sample
rate: 0xf1 for 44.1kHz and 0xd1 for 48kHz.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
