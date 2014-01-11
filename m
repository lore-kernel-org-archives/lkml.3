Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaAKSea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:34:30 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34535 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751073AbaAKSe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:34:28 -0500
Date: Sat, 11 Jan 2014 18:34:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 19/28] drm/i2c: tda998x: fix the value of the
	TBG_CNTRL_1 register
Message-ID: <20140111183422.GG15937@n2100.arm.linux.org.uk>
References: <20140109120543.1e3c9581@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120543.1e3c9581@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:05:43PM +0100, Jean-Francois Moine wrote:
> This patch fixes the 'toggle flag enable' bit of the TBG_CNTRL_1
> register which was set when no toggle was needed.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 192ddd2..7dbbc6b 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -1080,11 +1080,11 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
>  	 * Always generate sync polarity relative to input sync and
>  	 * revert input stage toggled sync at output stage
>  	 */
> -	reg = TBG_CNTRL_1_DWIN_DIS | TBG_CNTRL_1_TGL_EN;
> +	reg = TBG_CNTRL_1_DWIN_DIS;
>  	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
> -		reg |= TBG_CNTRL_1_H_TGL;
> +		reg |= TBG_CNTRL_1_H_TGL | TBG_CNTRL_1_TGL_EN;
>  	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
> -		reg |= TBG_CNTRL_1_V_TGL;
> +		reg |= TBG_CNTRL_1_V_TGL | TBG_CNTRL_1_TGL_EN;
>  	reg_write(priv, REG_TBG_CNTRL_1, reg);

This has me wondering whether you understand the meaning of TGL_EN here,
and what it means.

When TGL_EN is set, the inversion of the syncs is determined by the
settings of the H_TGL and V_TGL bits.  When they're zero, no inversion
happens.

However, when TGL_EN is clear, the inversion is determined by the CEA
mode setting in REG_VIDFORMAT.

What your code above means is that if a mode setting valuates as matching
a CEA mode, but has different syncs (eg, no inversion required) then we
don't set the enable bit, and we fall back to whatever is in the TDA998x
device's internal tables for the CEA mode.  This is wrong behaviour.

If we want to do this, then the right way would be to detect whether a
sync polarity has been specified (iow, whether any [NP][HV]SYNC flags
have been set) and set the TGL_EN if they have.  Otherwise, the TGL_EN
flag can be cleared.

I'm not saying that this will ever result in the TGL_EN flag being
cleared, but to me, your change above is incorrect.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
