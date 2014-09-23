Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaIWHF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:05:56 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:33044 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaIWHFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:05:54 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: arnd@arndb.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <831ec51fb919df76779c4f8899d90744>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54211BC5.8050700@rock-chips.com>
Date: Tue, 23 Sep 2014 15:05:41 +0800
From: Mark yao <mark.yao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
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
        yxj@roc.NULL.NULL, k-chips.com@NULL.NULL, wxt@rock-chips.com,
        xw@rock-chips.com
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com> <1411382934-1763-1-git-send-email-mark.yao@rock-chips.com> <3036415.u40f3Xnhod@wuerfel>
In-Reply-To: <3036415.u40f3Xnhod@wuerfel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月22日 22:43, Arnd Bergmann wrote:
> On Monday 22 September 2014 18:48:54 Mark yao wrote:
>> diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
>> new file mode 100644
>> index 0000000..7146c80
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/Kconfig
>> @@ -0,0 +1,19 @@
>> +config DRM_ROCKCHIP
>> +	tristate "DRM Support for Rockchip"
>> +	depends on DRM && ROCKCHIP_IOMMU
>> +	select ARM_DMA_USE_IOMMU
>> +	select IOMMU_API
>> +	select DRM_KMS_HELPER
>> +	select DRM_KMS_FB_HELPER
>> +	select DRM_PANEL
>> +	select FB_CFB_FILLRECT
>> +	select FB_CFB_COPYAREA
>> +	select FB_CFB_IMAGEBLIT
>> +	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>> +	select VIDEOMODE_HELPERS
> Be careful with 'select', at least some of these should be 'depends on'.
> In particular IOMMU_API and ARM_DMA_USE_IOMMU, but possibly others
> as well. Just check how the symbols are used normally, if you get this
> wrong, we can end up with incorrect dependencies or loops.
>
I see, I will change it.
>> diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
>> new file mode 100644
>> index 0000000..6e6d468
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/Makefile
>> @@ -0,0 +1,10 @@
>> +#
>> +# Makefile for the drm device driver.  This driver provides support for the
>> +# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
>> +
>> +ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip
> The second one should not be required.
Sure, I will change it.
>> +static int rockchip_drm_load(struct drm_device *drm_dev, unsigned long flags)
>> +{
>> +	struct rockchip_drm_private *private;
>> +	struct dma_iommu_mapping *mapping;
>> +	struct device *dev = drm_dev->dev;
>> +	int ret;
>> +
>> +	private = devm_kzalloc(drm_dev->dev, sizeof(*private), GFP_KERNEL);
>> +	if (!private)
>> +		return -ENOMEM;
>> +
>> +	dev_set_drvdata(drm_dev->dev, dev);
>> +	drm_dev->dev_private = private;
>> +
>> +	drm_mode_config_init(drm_dev);
>> +
>> +	rockchip_drm_mode_config_init(drm_dev);
>> +
>> +	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
>> +				      GFP_KERNEL);
>> +	if (!dev->dma_parms) {
>> +		ret = -ENOMEM;
>> +		goto err_config_cleanup;
>> +	}
>> +
>> +	/* TODO(djkurtz): fetch the mapping start/size from somewhere */
>> +	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x10000000,
>> +					   SZ_1G);
>> +	if (IS_ERR(mapping)) {
>> +		ret = PTR_ERR(mapping);
>> +		goto err_config_cleanup;
>> +	}
>> +
>> +	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> This is the default coherent mask. If you call this function, you
> should normally check the return value, or call dma_set_mask first,
> which you apparently don't do here, and in another place in this
> patch.
>
> 	Arnd
>
>
>


