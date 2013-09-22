Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3IVVyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:54:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39788 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3IVVyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:54:10 -0400
Date: Sun, 22 Sep 2013 22:53:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i2c: Fix broken TDA998x audio (was: Re: [PATCH v2
	5/8] drm/i2c: tda998x: add video and audio input configuration)
Message-ID: <20130922215342.GA18019@n2100.arm.linux.org.uk>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376509413-1462-6-git-send-email-sebastian.hesselbarth@gmail.com> <20130902145057.GX6617@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130902145057.GX6617@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Mon, Sep 02, 2013 at 03:50:57PM +0100, Russell King - ARM Linux wrote:
> On Wed, Aug 14, 2013 at 09:43:30PM +0200, Sebastian Hesselbarth wrote:
> > From: Russell King <rmk+kernel@arm.linux.org.uk>
> > 
> > This patch adds tda998x specific parameters to allow it to be configured
> > for different boards using it. Also, this implements rudimentary audio
> > support for S/PDIF attached controllers.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > Tested-by: Darren Etheridge <detheridge@ti.com>
> > ---
> 
> It looks like there's been a bug introduced in this patch (which wasn't
> in my original).
> 
> > @@ -445,8 +681,7 @@ tda998x_encoder_dpms(struct drm_encoder *encoder, int mode)
> >  
> >  	switch (mode) {
> >  	case DRM_MODE_DPMS_ON:
> > -		/* enable audio and video ports */
> > -		reg_write(encoder, REG_ENA_AP, 0xff);
> > +		/* enable video ports, audio will be enabled later */
> >  		reg_write(encoder, REG_ENA_VP_0, 0xff);
> >  		reg_write(encoder, REG_ENA_VP_1, 0xff);
> >  		reg_write(encoder, REG_ENA_VP_2, 0xff);
> 
> I also disabled the writing to REG_ENA_AP in the DPMS off path as well,
> which clears this register.
> 
> That seems to be missing from this patch, and it means that when the
> display is placed into DPMS-off mode, the audio inputs are disabled,
> never to be re-enabled.  There is no need to disable the audio input
> in DPMS-off mode.
> 
> 8<=============
> From: Russell King <rmk+kernel@arm.linux.org.uk>
> Subject: [PATCH] drm/i2c: Fix broken TDA998x audio
> 
> In patch "drm/i2c: tda998x: add video and audio input configuration" in
> its original version, disabling the audio input port was removed.  The
> version which was submitted for merging had this change deleted, which
> results in audio being non-functional.  Fix this by removing the write.
> While here, update the comment too.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> --- 
>  drivers/gpu/drm/i2c/tda998x_drv.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 5742cfc..59878af 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -705,8 +705,7 @@ tda998x_encoder_dpms(struct drm_encoder *encoder, int mode)
>  		reg_write(encoder, REG_VIP_CNTRL_2, priv->vip_cntrl_2);
>  		break;
>  	case DRM_MODE_DPMS_OFF:
> -		/* disable audio and video ports */
> -		reg_write(encoder, REG_ENA_AP, 0x00);
> +		/* disable video ports */
>  		reg_write(encoder, REG_ENA_VP_0, 0x00);
>  		reg_write(encoder, REG_ENA_VP_1, 0x00);
>  		reg_write(encoder, REG_ENA_VP_2, 0x00);
