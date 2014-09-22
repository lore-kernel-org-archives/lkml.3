Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaIVPPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:15:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49464 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753043AbaIVPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:15:12 -0400
Date: Mon, 22 Sep 2014 17:15:06 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark yao <mark.yao@rock-chips.com>, heiko@sntech.de,
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
        djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
        cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Message-ID: <20140922171506.31d59a76@bbrezillon>
In-Reply-To: <3036415.u40f3Xnhod@wuerfel>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
	<1411382934-1763-1-git-send-email-mark.yao@rock-chips.com>
	<3036415.u40f3Xnhod@wuerfel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 16:43:31 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 22 September 2014 18:48:54 Mark yao wrote:
> > diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
> > new file mode 100644
> > index 0000000..7146c80
> > --- /dev/null
> > +++ b/drivers/gpu/drm/rockchip/Kconfig
> > @@ -0,0 +1,19 @@
> > +config DRM_ROCKCHIP
> > +	tristate "DRM Support for Rockchip"
> > +	depends on DRM && ROCKCHIP_IOMMU
> > +	select ARM_DMA_USE_IOMMU
> > +	select IOMMU_API
> > +	select DRM_KMS_HELPER
> > +	select DRM_KMS_FB_HELPER
> > +	select DRM_PANEL
> > +	select FB_CFB_FILLRECT
> > +	select FB_CFB_COPYAREA
> > +	select FB_CFB_IMAGEBLIT
> > +	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
> > +	select VIDEOMODE_HELPERS
> 
> Be careful with 'select', at least some of these should be 'depends on'.
> In particular IOMMU_API and ARM_DMA_USE_IOMMU, but possibly others
> as well. Just check how the symbols are used normally, if you get this
> wrong, we can end up with incorrect dependencies or loops.
> 
> > diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
> > new file mode 100644
> > index 0000000..6e6d468
> > --- /dev/null
> > +++ b/drivers/gpu/drm/rockchip/Makefile
> > @@ -0,0 +1,10 @@
> > +#
> > +# Makefile for the drm device driver.  This driver provides support for the
> > +# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
> > +
> > +ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip
> 
> The second one should not be required.
> 
> > +static int rockchip_drm_load(struct drm_device *drm_dev, unsigned long flags)
> > +{
> > +	struct rockchip_drm_private *private;
> > +	struct dma_iommu_mapping *mapping;
> > +	struct device *dev = drm_dev->dev;
> > +	int ret;
> > +
> > +	private = devm_kzalloc(drm_dev->dev, sizeof(*private), GFP_KERNEL);
> > +	if (!private)
> > +		return -ENOMEM;
> > +
> > +	dev_set_drvdata(drm_dev->dev, dev);
> > +	drm_dev->dev_private = private;
> > +
> > +	drm_mode_config_init(drm_dev);
> > +
> > +	rockchip_drm_mode_config_init(drm_dev);
> > +
> > +	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
> > +				      GFP_KERNEL);
> > +	if (!dev->dma_parms) {
> > +		ret = -ENOMEM;
> > +		goto err_config_cleanup;
> > +	}
> > +
> > +	/* TODO(djkurtz): fetch the mapping start/size from somewhere */
> > +	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x10000000,
> > +					   SZ_1G);
> > +	if (IS_ERR(mapping)) {
> > +		ret = PTR_ERR(mapping);
> > +		goto err_config_cleanup;
> > +	}
> > +
> > +	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> 
> This is the default coherent mask. If you call this function, you
> should normally check the return value, or call dma_set_mask first,
> which you apparently don't do here, and in another place in this
> patch.

By "This is the default mask" do you mean it shouldn't be called at
all ? Cause I ran into some trouble when not calling this in my
atmel-hlcdc driver.
Actually, in my case the platform device is created by the MFD core
which seems to let the coherent_dma_mask uninitialized.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
