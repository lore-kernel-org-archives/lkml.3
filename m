Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967035Ab3E2Uqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:46:50 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:32953 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966734Ab3E2Uqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:46:42 -0400
Date: Wed, 29 May 2013 22:49:37 +0200
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com, hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, ezequiel.garcia@free-electrons.com,
        timo.teras@iki.fi
Subject: Re: [RFC 3/3] saa7115: Implement i2c_board_info.platform data
Message-ID: <20130529204937.GE2367@dell.arpanet.local>
References: <1369860078-10334-1-git-send-email-jonarne@jonarne.no>
 <1369860078-10334-4-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369860078-10334-4-git-send-email-jonarne@jonarne.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:41:18PM +0200, Jon Arne Jørgensen wrote:
> Implement i2c_board_info.platform_data handling in the driver so we can
> make device specific changes to the chips we support.
> 
> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> ---
>  drivers/media/i2c/saa7115.c |  62 +++++++++++++++++++++++--
>  include/media/saa7115.h     | 109 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 166 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> index ccfaac9..8e915c7 100644
> --- a/drivers/media/i2c/saa7115.c
> +++ b/drivers/media/i2c/saa7115.c
> @@ -228,7 +228,7 @@ static const unsigned char saa7113_init[] = {
>  	R_05_INPUT_CNTL_4, 0x00,
>  	R_06_H_SYNC_START, 0xe9,
>  	R_07_H_SYNC_STOP, 0x0d,
> -	R_08_SYNC_CNTL, 0x98,
> +	R_08_SYNC_CNTL, SAA7113_R08_DEFAULT,
>  	R_09_LUMA_CNTL, 0x01,
>  	R_0A_LUMA_BRIGHT_CNTL, 0x80,
>  	R_0B_LUMA_CONTRAST_CNTL, 0x47,
> @@ -236,11 +236,10 @@ static const unsigned char saa7113_init[] = {
>  	R_0D_CHROMA_HUE_CNTL, 0x00,
>  	R_0E_CHROMA_CNTL_1, 0x01,
>  	R_0F_CHROMA_GAIN_CNTL, 0x2a,
> -	R_10_CHROMA_CNTL_2, 0x00,
> +	R_10_CHROMA_CNTL_2, SAA7113_R10_DEFAULT,
>  	R_11_MODE_DELAY_CNTL, 0x0c,
> -	R_12_RT_SIGNAL_CNTL, 0x01,
> -	R_13_RT_X_PORT_OUT_CNTL, 0x00,
> -	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,	/* RESERVED */
> +	R_12_RT_SIGNAL_CNTL, SAA7113_R12_DEFAULT,
> +	R_13_RT_X_PORT_OUT_CNTL, SAA7113_R13_DEFAULT,
>  	R_15_VGATE_START_FID_CHG, 0x00,
>  	R_16_VGATE_STOP, 0x00,
>  	R_17_MISC_VGATE_CONF_AND_MSB, 0x00,
> @@ -1583,6 +1582,53 @@ static const struct v4l2_subdev_ops saa711x_ops = {
>  
>  /* ----------------------------------------------------------------------- */
>  
> +static void saa7115_load_platform_data(struct saa711x_state *state,
> +				       struct saa7115_platform_data *data)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 work;
> +
> +	switch (state->ident) {
> +	case V4L2_IDENT_GM7113C:
> +		if (data->saa7113_r08_htc !=
> +		    (SAA7113_R08_DEFAULT & SAA7113_R08_HTC_MASK)) {
> +			work = saa711x_read(sd, R_08_SYNC_CNTL);
> +			saa711x_write(sd, R_08_SYNC_CNTL, (work & 0xe7) |
> +					(data->saa7113_r08_htc << 3));
> +		}
> +		if (data->saa7113_r10_ofts !=
> +		    (SAA7113_R10_DEFAULT & SAA7113_R10_OFTS_MASK)) {
> +			work = saa711x_read(sd, R_10_CHROMA_CNTL_2);
> +			saa711x_write(sd, R_10_CHROMA_CNTL_2, (work & 0x3f) |
> +					(data->saa7113_r10_ofts << 6));
> +		}
> +		if (data->saa7113_r10_vrln !=
> +		    (SAA7113_R10_DEFAULT & SAA7113_R10_VRLN_MASK)) {
> +			work = saa711x_read(sd, R_10_CHROMA_CNTL_2);
> +			saa711x_write(sd, R_10_CHROMA_CNTL_2, (work & 0xf7) |
> +					(1 << 3));
> +		}
> +		if (data->saa7113_r12_rts0 !=
> +		    (SAA7113_R12_DEFAULT & SAA7113_R12_RTS0_MASK)) {
> +			work = saa711x_read(sd, R_12_RT_SIGNAL_CNTL);
> +			saa711x_write(sd, R_12_RT_SIGNAL_CNTL, (work & 0xf0) |
> +					data->saa7113_r12_rts0);
> +		}
> +		if (data->saa7113_r12_rts1 !=
> +		    (SAA7113_R12_DEFAULT & SAA7113_R12_RTS1_MASK)) {
> +			work = saa711x_read(sd, R_12_RT_SIGNAL_CNTL);
> +			saa711x_write(sd, R_12_RT_SIGNAL_CNTL, (work & 0x0f) |
> +					(data->saa7113_r12_rts1 << 4));
> +		}
> +		if (data->saa7113_r13_adlsb !=
> +		    (SAA7113_R13_DEFAULT & SAA7113_R13_ADLSB_MASK)) {
> +			work = saa711x_read(sd, R_13_RT_X_PORT_OUT_CNTL);
> +			saa711x_write(sd, R_13_RT_X_PORT_OUT_CNTL,
> +					(work & 0x7f) | (1 << 7));
> +		}
> +	}
> +}
> +

I've made some grave mistakes here.
Will fix and repost.

>  /**
>   * saa711x_detect_chip - Detects the saa711x (or clone) variant
>   * @client:		I2C client structure.
> @@ -1769,6 +1815,12 @@ static int saa711x_probe(struct i2c_client *client,
>  	}
>  	if (state->ident > V4L2_IDENT_SAA7111A)
>  		saa711x_writeregs(sd, saa7115_init_misc);
> +
> +	if (client->dev.platform_data) {
> +		struct saa7115_platform_data *data = client->dev.platform_data;
> +		saa7115_load_platform_data(state, data);
> +	}
> +
>  	saa711x_set_v4lstd(sd, V4L2_STD_NTSC);
>  	v4l2_ctrl_handler_setup(hdl);
>  
> diff --git a/include/media/saa7115.h b/include/media/saa7115.h
> index 4079186..7bb4a11 100644
> --- a/include/media/saa7115.h
> +++ b/include/media/saa7115.h
> @@ -64,5 +64,114 @@
>  #define SAA7115_FREQ_FL_APLL         (1 << 2) /* SA 3A[3], APLL, SAA7114/5 only */
>  #define SAA7115_FREQ_FL_DOUBLE_ASCLK (1 << 3) /* SA 39, LRDIV, SAA7114/5 only */
>  
> +/* SAA7113 (and GM7113) Register settings */
> +/* Vertical noise reduction */
> +#define SAA7113_R08_VNOI_NORMAL (0x0 << 0)
> +#define SAA7113_R08_VNOI_FAST	(0x1 << 0)
> +#define SAA7113_R08_VNOI_FREE	(0x2 << 0) /* NOTE: AUFD must be disabled */
> +#define SAA7113_R08_VNOI_BYPS	(0x3 << 0)
> +/* Horizontal PLL */
> +#define SAA7113_R08_PLL_CLOSED (0x0 << 2)
> +#define SAA7113_R08_PLL_OPEN   (0x1 << 2)  /* Horizontal freq. fixed */
> +/* Horizontal time constant */
> +#define SAA7113_R08_HTC_TV   (0x0 << 3)
> +#define SAA7113_R08_HTC_VTR  (0x1 << 3)
> +#define SAA7113_R08_HTC_FLM  (0x3 << 3)    /* Fast locking mode */
> +#define SAA7113_R08_HTC_MASK (0x3 << 3)
> +/* Forced ODD/EVEN toggle FOET */
> +#define SAA7113_R08_FOET_INTERLACED (0x0 << 5)
> +#define SAA7113_R08_FOET_FORCE	    (0x1 << 5)
> +/* Field selection FSEL */
> +#define SAA7113_R08_FSEL_50HZ_625 (0x0 << 6)
> +#define SAA7113_R08_FSEL_60HZ_525 (0x1 << 6)
> +/* Automatic field detection AUFD */
> +#define SAA7113_R08_AUFD_DISABLE (0x0 << 7)
> +#define SAA7113_R08_AUFD_ENABLE  (0x1 << 7)
> +
> +/* Luminance delay compensation */
> +#define SAA7113_R10_YDEL_MASK 0x7
> +/* VRLN Pulse position and length */
> +#define SAA7113_R10_VRLN_240_286 (0x0 << 3)
> +#define SAA7113_R10_VRLN_242_288 (0x1 << 3)
> +#define SAA7113_R10_VRLN_MASK (0x1 << 3)
> +/* Fine position of HS */
> +#define SAA7113_R10_HDEL_MASK (0x3 << 4)
> +/* Output format selection */
> +#define SAA7113_R10_OFTS_ITU656    (0x0 << 6)
> +#define SAA7113_R10_OFTS_VREF	   (0x1 << 6)
> +#define SAA7113_R10_OFTS_DATA_TYPE (0x2 << 6)
> +#define SAA7113_R10_OFTS_MASK	   (0x3 << 6)
> +
> +/* RTS0/1 Output control */
> +#define SAA7113_R12_RTS0_ADC_LSB (0x1 << 0)
> +#define SAA7113_R12_RTS0_GPSW0	 (0x2 << 0)
> +#define SAA7113_R12_RTS0_HL	 (0x3 << 0)
> +#define SAA7113_R12_RTS0_VL	 (0x4 << 0)
> +#define SAA7113_R12_RTS0_DL	 (0x5 << 0)
> +#define SAA7113_R12_RTS0_PLIN	 (0x6 << 0)
> +#define SAA7113_R12_RTS0_HREF_HS (0x7 << 0)
> +#define SAA7113_R12_RTS0_HS	 (0x8 << 0)
> +#define SAA7113_R12_RTS0_HQ	 (0x9 << 0)
> +#define SAA7113_R12_RTS0_ODD	 (0xa << 0)
> +#define SAA7113_R12_RTS0_VS	 (0xb << 0)
> +#define SAA7113_R12_RTS0_V123	 (0xc << 0)
> +#define SAA7113_R12_RTS0_VGATE	 (0xd << 0)
> +#define SAA7113_R12_RTS0_VREF	 (0xe << 0)
> +#define SAA7113_R12_RTS0_FID	 (0xf << 0)
> +#define SAA7113_R12_RTS0_MASK	 (0xf << 0)
> +#define SAA7113_R12_RTS1_ADC_LSB (0x1 << 4)
> +#define SAA7113_R12_RTS1_GPSW1	 (0x2 << 4)
> +#define SAA7113_R12_RTS1_HL	 (0x3 << 4)
> +#define SAA7113_R12_RTS1_VL	 (0x4 << 4)
> +#define SAA7113_R12_RTS1_DL	 (0x5 << 4)
> +#define SAA7113_R12_RTS1_PLIN	 (0x6 << 4)
> +#define SAA7113_R12_RTS1_HREF_HS (0x7 << 4)
> +#define SAA7113_R12_RTS1_HS	 (0x8 << 4)
> +#define SAA7113_R12_RTS1_HQ	 (0x9 << 4)
> +#define SAA7113_R12_RTS1_ODD	 (0xa << 4)
> +#define SAA7113_R12_RTS1_VS	 (0xb << 4)
> +#define SAA7113_R12_RTS1_V123	 (0xc << 4)
> +#define SAA7113_R12_RTS1_VGATE	 (0xd << 4)
> +#define SAA7113_R12_RTS1_VREF	 (0xe << 4)
> +#define SAA7113_R12_RTS1_FID	 (0xf << 4)
> +#define SAA7113_R12_RTS1_MASK	 (0xf << 4)
> +
> +/* Analog test select */
> +#define SAA7113_R13_AOSL_ITP1 (0x0 << 0)
> +#define SAA7113_R13_AOSL_AD1  (0x1 << 0)
> +#define SAA7113_R13_AOSL_AD2  (0x2 << 0)
> +#define SAA7113_R13_AOSL_ITP2 (0x3 << 0)
> +/* Field ID polarity */
> +#define SAA7113_R13_FIDP_DEFAULT  (0x0 << 3)
> +#define SAA7113_R13_FIDP_INVERTED (0x1 << 3)
> +/* Status byte functionality */
> +#define SAA7113_R13_OLDSB_DEFAUL (0x0 << 4)
> +#define SAA7113_R13_OLDSB_COMPAT (0x1 << 4)
> +/* Analog-to-digital converter output bits on VPO7 to VPO0 in bypass mode */
> +#define SAA7113_R13_ADLSB_MSB  (0x0 << 7)
> +#define SAA7113_R13_ADLSB_LSB  (0x1 << 7)
> +#define SAA7113_R13_ADLSB_MASK (0x1 << 7)
> +
> +
> +/* Defaults according to datasheet */
> +#define SAA7113_R08_DEFAULT (SAA7113_R08_AUFD_ENABLE | \
> +			     SAA7113_R08_HTC_FLM)
> +#define SAA7113_R10_DEFAULT 0x0
> +#define SAA7113_R12_DEFAULT SAA7113_R12_RTS0_ADC_LSB
> +#define SAA7113_R13_DEFAULT 0x0
> +
> +struct saa7115_platform_data {
> +	/* Horizontal time constant */
> +	u8 saa7113_r08_htc;
> +
> +	u8 saa7113_r10_vrln;
> +	u8 saa7113_r10_ofts;
> +
> +	u8 saa7113_r12_rts0;
> +	u8 saa7113_r12_rts1;
> +
> +	u8 saa7113_r13_adlsb;
> +};
> +
>  #endif
>  
> -- 
> 1.8.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
