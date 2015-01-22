Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbbAVHdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:33:46 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:56163 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbbAVHdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:33:39 -0500
Date: Thu, 22 Jan 2015 08:33:34 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Mark Yao <mark.yao@rock-chips.com>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Kurtz <djkurtz@chromium.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 1/2] drm/rockchip: vop use is_enabled instead of dpms mode
Message-ID: <20150122073334.GU10113@phenom.ffwll.local>
Mail-Followup-To: Mark Yao <mark.yao@rock-chips.com>,
	David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Daniel Kurtz <djkurtz@chromium.org>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-rockchip@lists.infradead.org
References: <1421910333-5576-1-git-send-email-mark.yao@rock-chips.com>
 <1421910333-5576-2-git-send-email-mark.yao@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421910333-5576-2-git-send-email-mark.yao@rock-chips.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 03:05:32PM +0800, Mark Yao wrote:
> drm dpms have many power modes: ON,OFF,SUSPEND,STANDBY, etc.
> but vop only have enable/disable mode, maybe case such bug:
>  --> DRM_DPMS_ON: power on vop
>  --> DRM_DPMS_SUSPEND: power off vop
>  --> DRM_DPMS_OFF: already power off at SUSPEND, crash
> so use a bool val is more suitable.
> 
> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>

Long term I highly suggest you switch to atomic, since with atomic all the
legacy dpms modes are remapped to a simple on/off. Also the new atomic
helpers make sure that your backend isn't called multiple times, so you
can ditch all your is_enabled tracking with that.
-Daniel

> ---
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c |   34 ++++++++++++++-------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> index 9a5c571..f278c09 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> @@ -81,7 +81,7 @@ struct vop {
>  	struct drm_crtc crtc;
>  	struct device *dev;
>  	struct drm_device *drm_dev;
> -	unsigned int dpms;
> +	bool is_enabled;
>  
>  	int connector_type;
>  	int connector_out_mode;
> @@ -387,6 +387,9 @@ static void vop_enable(struct drm_crtc *crtc)
>  	struct vop *vop = to_vop(crtc);
>  	int ret;
>  
> +	if (vop->is_enabled)
> +		return;
> +
>  	ret = clk_enable(vop->hclk);
>  	if (ret < 0) {
>  		dev_err(vop->dev, "failed to enable hclk - %d\n", ret);
> @@ -427,6 +430,8 @@ static void vop_enable(struct drm_crtc *crtc)
>  
>  	drm_vblank_on(vop->drm_dev, vop->pipe);
>  
> +	vop->is_enabled = false;
> +
>  	return;
>  
>  err_disable_aclk:
> @@ -441,6 +446,9 @@ static void vop_disable(struct drm_crtc *crtc)
>  {
>  	struct vop *vop = to_vop(crtc);
>  
> +	if (vop->is_enabled)
> +		return;
> +
>  	drm_vblank_off(crtc->dev, vop->pipe);
>  
>  	disable_irq(vop->irq);
> @@ -463,6 +471,8 @@ static void vop_disable(struct drm_crtc *crtc)
>  
>  	clk_disable(vop->aclk);
>  	clk_disable(vop->hclk);
> +
> +	vop->is_enabled = false;
>  }
>  
>  /*
> @@ -742,7 +752,7 @@ static int vop_crtc_enable_vblank(struct drm_crtc *crtc)
>  	struct vop *vop = to_vop(crtc);
>  	unsigned long flags;
>  
> -	if (vop->dpms != DRM_MODE_DPMS_ON)
> +	if (!vop->is_enabled)
>  		return -EPERM;
>  
>  	spin_lock_irqsave(&vop->irq_lock, flags);
> @@ -759,8 +769,9 @@ static void vop_crtc_disable_vblank(struct drm_crtc *crtc)
>  	struct vop *vop = to_vop(crtc);
>  	unsigned long flags;
>  
> -	if (vop->dpms != DRM_MODE_DPMS_ON)
> +	if (!vop->is_enabled)
>  		return;
> +
>  	spin_lock_irqsave(&vop->irq_lock, flags);
>  	vop_mask_write(vop, INTR_CTRL0, FS_INTR_MASK, FS_INTR_EN(0));
>  	spin_unlock_irqrestore(&vop->irq_lock, flags);
> @@ -773,15 +784,8 @@ static const struct rockchip_crtc_funcs private_crtc_funcs = {
>  
>  static void vop_crtc_dpms(struct drm_crtc *crtc, int mode)
>  {
> -	struct vop *vop = to_vop(crtc);
> -
>  	DRM_DEBUG_KMS("crtc[%d] mode[%d]\n", crtc->base.id, mode);
>  
> -	if (vop->dpms == mode) {
> -		DRM_DEBUG_KMS("desired dpms mode is same as previous one.\n");
> -		return;
> -	}
> -
>  	switch (mode) {
>  	case DRM_MODE_DPMS_ON:
>  		vop_enable(crtc);
> @@ -795,8 +799,6 @@ static void vop_crtc_dpms(struct drm_crtc *crtc, int mode)
>  		DRM_DEBUG_KMS("unspecified mode %d\n", mode);
>  		break;
>  	}
> -
> -	vop->dpms = mode;
>  }
>  
>  static void vop_crtc_prepare(struct drm_crtc *crtc)
> @@ -934,9 +936,9 @@ static int vop_crtc_page_flip(struct drm_crtc *crtc,
>  	struct drm_framebuffer *old_fb = crtc->primary->fb;
>  	int ret;
>  
> -	/* when the page flip is requested, crtc's dpms should be on */
> -	if (vop->dpms > DRM_MODE_DPMS_ON) {
> -		DRM_DEBUG("failed page flip request at dpms[%d].\n", vop->dpms);
> +	/* when the page flip is requested, crtc should be on */
> +	if (!vop->is_enabled) {
> +		DRM_DEBUG("page flip request rejected because crtc is off.\n");
>  		return 0;
>  	}
>  
> @@ -1302,7 +1304,7 @@ static int vop_initial(struct vop *vop)
>  
>  	clk_disable(vop->hclk);
>  
> -	vop->dpms = DRM_MODE_DPMS_OFF;
> +	vop->is_enabled = false;
>  
>  	return 0;
>  
> -- 
> 1.7.9.5
> 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
