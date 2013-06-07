Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3FGJBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:01:53 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3790 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3FGJBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:01:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jon Arne =?utf-8?q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Subject: Re: [RFC v2 2/2] saa7115: Remove gm7113c video_std register change
Date: Fri, 7 Jun 2013 11:01:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com, hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, ezequiel.garcia@free-electrons.com,
        timo.teras@iki.fi
References: <1370000426-3324-1-git-send-email-jonarne@jonarne.no> <1370000426-3324-3-git-send-email-jonarne@jonarne.no>
In-Reply-To: <1370000426-3324-3-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201306071101.06774.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 31 2013 13:40:26 Jon Arne Jørgensen wrote:
> On video std change, the driver would disable the automatic field
> detection on the gm7113c chip, and force either 50Hz or 60Hz.
> Don't do this any more.

Sorry, I'm not entirely sure what is happening here. Why would the gm7113c
behave different in this respect compared to the saa7113?

One thing to remember is that the chip should never get in a mode where
switching from e.g. NTSC to PAL on the input would change the output timings
to the bridge chip as well to PAL. Because that might cause DMA buffer
overruns. So if the user calls S_STD, then the bridge should always be
certain it gets whatever std was specified.

I'm not sure whether this patch puts the gm7113c in such a mode, but if it
does, then it should be redone.

Regards,

	Hans

> 
> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> ---
>  drivers/media/i2c/saa7115.c | 26 ++------------------------
>  1 file changed, 2 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> index 4a52b4d..ba18e57 100644
> --- a/drivers/media/i2c/saa7115.c
> +++ b/drivers/media/i2c/saa7115.c
> @@ -479,24 +479,6 @@ static const unsigned char saa7115_cfg_50hz_video[] = {
>  
>  /* ============== SAA7715 VIDEO templates (end) =======  */
>  
> -/* ============== GM7113C VIDEO templates =============  */
> -static const unsigned char gm7113c_cfg_60hz_video[] = {
> -	R_08_SYNC_CNTL, 0x68,			/* 0xBO: auto detection, 0x68 = NTSC */
> -	R_0E_CHROMA_CNTL_1, 0x07,		/* video autodetection is on */
> -
> -	0x00, 0x00
> -};
> -
> -static const unsigned char gm7113c_cfg_50hz_video[] = {
> -	R_08_SYNC_CNTL, 0x28,			/* 0x28 = PAL */
> -	R_0E_CHROMA_CNTL_1, 0x07,
> -
> -	0x00, 0x00
> -};
> -
> -/* ============== GM7113C VIDEO templates (end) =======  */
> -
> -
>  static const unsigned char saa7115_cfg_vbi_on[] = {
>  	R_80_GLOBAL_CNTL_1, 0x00,			/* reset tasks */
>  	R_88_POWER_SAVE_ADC_PORT_CNTL, 0xd0,		/* reset scaler */
> @@ -981,16 +963,12 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
>  	// This works for NTSC-M, SECAM-L and the 50Hz PAL variants.
>  	if (std & V4L2_STD_525_60) {
>  		v4l2_dbg(1, debug, sd, "decoder set standard 60 Hz\n");
> -		if (state->ident == V4L2_IDENT_GM7113C)
> -			saa711x_writeregs(sd, gm7113c_cfg_60hz_video);
> -		else
> +		if (state->ident != V4L2_IDENT_GM7113C)
>  			saa711x_writeregs(sd, saa7115_cfg_60hz_video);
>  		saa711x_set_size(sd, 720, 480);
>  	} else {
>  		v4l2_dbg(1, debug, sd, "decoder set standard 50 Hz\n");
> -		if (state->ident == V4L2_IDENT_GM7113C)
> -			saa711x_writeregs(sd, gm7113c_cfg_50hz_video);
> -		else
> +		if (state->ident != V4L2_IDENT_GM7113C)
>  			saa711x_writeregs(sd, saa7115_cfg_50hz_video);
>  		saa711x_set_size(sd, 720, 576);
>  	}
> 
