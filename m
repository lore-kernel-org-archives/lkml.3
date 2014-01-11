Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaAKSDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:03:21 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34492 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751073AbaAKSDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:03:18 -0500
Date: Sat, 11 Jan 2014 18:03:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 12/28] drm/i2c: tda998x: add DT support
Message-ID: <20140111180310.GA15937@n2100.arm.linux.org.uk>
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
> This patch adds DT support to the tda998x.
> 
> As a side effect, now, the audio sample rate is always 48kHz and the
> audio clock is always set.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

This patch breaks audio through the renaming of variable names.  When you
do such changes, *never* change all three together.  Do them one at a time,
replacing all instances of one variable before moving on to the next one.
This avoids getting the names muddled up.

> -	struct tda998x_encoder_params params;
> +
> +	u8 audio_type;		/* audio type */
> +	u8 audio_frame[6];
> +	u32 audio_port;

"audio type" is a pointless comment for a variable called "audio_type".
Explain what it is.  It's the input format, which may be SPDIF or I2S.

>  	/* Set audio input source */
> -	switch (p->audio_format) {
> +	switch (priv->audio_type) {

So, "audio_format" has become "audio_type" here.

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

Here, audio_port and audio_type are only written to if audio_cfg is
non-zero, which is not quite what is intended here.  If you want DT
to override this, then make that explicit.

Moreover, we can see that this confirms that "audio_format" becomes
"audio_type", and "audio_cfg" becomes "audio_port".

> @@ -947,8 +958,8 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
>  
>  		tda998x_write_avi(priv, mode);
>  
> -		if (priv->params.audio_cfg)
> -			tda998x_configure_audio(priv, mode, &priv->params);
> +		if (priv->audio_type)
> +			tda998x_configure_audio(priv, mode);

And here we have the real bug.  "audio_cfg" has become "audio_type",
which in the case of SPDIF, is zero.  Hence, with a SPDIF source,
tda998x_configure_audio() is no longer called.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
