Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbaKRIcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:32:15 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62282 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaKRIcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:32:12 -0500
Date: Tue, 18 Nov 2014 09:32:34 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Mark Yao <mark.yao@rock-chips.com>
Cc: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net,
        djkurtz@chromium.org, cf@rock-chips.com, xxm@rock-chips.com,
        huangtao@rock-chips.com, kever.yang@rock-chips.com, yxj@rock-chips.com,
        xw@rock-chips.com
Subject: Re: [PATCH v12 1/3] drm: rockchip: Add basic drm driver
Message-ID: <20141118083234.GZ25711@phenom.ffwll.local>
Mail-Followup-To: Mark Yao <mark.yao@rock-chips.com>, heiko@sntech.de,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
	Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Grant Likely <grant.likely@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Stultz <john.stultz@linaro.org>,
	Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
	linux-rockchip@lists.infradead.org, dianders@chromium.org,
	marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net,
	djkurtz@chromium.org, cf@rock-chips.com, xxm@rock-chips.com,
	huangtao@rock-chips.com, kever.yang@rock-chips.com,
	yxj@rock-chips.com, xw@rock-chips.com
References: <1416297587-18959-1-git-send-email-mark.yao@rock-chips.com>
 <1416297629-19024-1-git-send-email-mark.yao@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416297629-19024-1-git-send-email-mark.yao@rock-chips.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 04:00:29PM +0800, Mark Yao wrote:
> From: Mark yao <mark.yao@rock-chips.com>
> 
> This patch adds the basic structure of a DRM Driver for Rockchip Socs.
> 
> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Acked-by: Daniel Vetter <daniel@ffwll.ch>
> Reviewed-by: Rob Clark <robdclark@gmail.com>
> ---
> Changes in v2:
> - use the component framework to defer main drm driver probe
>   until all VOP devices have been probed.
> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>   master device and each vop device can shared the drm dma mapping.
> - use drm_crtc_init_with_planes and drm_universal_plane_init.
> - remove unnecessary middle layers.
> - add cursor set, move funcs to rockchip drm crtc.
> - use vop reset at first init
> - reference framebuffer when used and unreference when swap out vop
> 
> Changes in v3:
> - change "crtc->fb" to "crtc->primary-fb"
> Adviced by Daniel Vetter
> - init cursor plane with universal api, remove unnecessary cursor set,move 
> 
> Changes in v4:
> Adviced by David Herrmann
> - remove drm_platform_*() usage, use register drm device directly.

Minor fixup for that part below.

[snip]

> +static int rockchip_drm_bind(struct device *dev)
> +{
> +	struct drm_device *drm;
> +	int ret;
> +
> +	drm = drm_dev_alloc(&rockchip_drm_driver, dev);
> +	if (!drm)
> +		return -ENOMEM;
> +
> +	ret = drm_dev_set_unique(drm, "%s", dev_name(dev));
> +	if (ret)
> +		goto err_free;

Please call rockchip_drm_load here directly and don't put it as the ->load
function into the driver vtable. The point of the alloc/register split is
that the driver can be completely set up _before_ we register anything.
But for backwards compat and historical reasons ->load is called somewhere
in the middle (so that you could access the minor nodes if needed, since
some drivers do that).

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
