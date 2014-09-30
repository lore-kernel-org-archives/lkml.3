Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaI3L3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:29:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27886 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaI3L3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:29:13 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-aa-542a94063968
Message-id: <542A93FD.7020002@samsung.com>
Date: Tue, 30 Sep 2014 13:29:01 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/exynos: remove ifdeferry from initialization code
References: <1410349980-10473-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1410349980-10473-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xy7psU7RCDI784bToPXeSyeLK1/ds
	FpPuT2CxeHHvIotF74KrbBZnm96wW1zeNYfNYsb5fUwWMya/ZHPg9Nj+7QGrx/3u40wefVtW
	MXp83iQXwBLFZZOSmpNZllqkb5fAlXG8Yw5rwVTPitedJ1gbGM/YdDFyckgImEgseXKBFcIW
	k7hwbz1bFyMXh5DAUkaJS2+3MEM4nxglFn1cyARSxSugJbH+2Bc2EJtFQFWieddPMJtNQFPi
	7+abYLaoQITEybt72CHqBSV+TL7HAmKLCChLrNrXzg4ylFmgk1li7pwHjCAJYQEvibO3/4M1
	CAk4S1yefh9sEKeAi8TN00eB4hxADXoS9y9qgYSZBeQlNq95yzyBUWAWkhWzEKpmIalawMi8
	ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk3L/uYFx6zOoQowAHoxIPb4KiVogQa2JZcWXu
	IUYJDmYlEd6z/UAh3pTEyqrUovz4otKc1OJDjEwcnFINjBlTzMsvuT8x6RK1mHlN9chJ8/7S
	qm9yHiwzAs913v0aIDr91QtG+e6qmdK7r95qs77GwJTUV3flU71uL5tB4dxK5hLGnHvXT6rk
	V+46Kdbpc9Vr0SLX/BlZGquMTrl/+SToHuHYtpS7rNRoQ7vim+s/1IXKpxwSXyR7d+a33PxJ
	LNV7uGbOUmIpzkg01GIuKk4EAMphEnFVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inki,

Gently ping.

Andrzej

On 09/10/2014 01:53 PM, Andrzej Hajda wrote:
> The patch replaces separate calls to driver (de)registration by
> loops over the array of drivers. As a result it significantly
> decreases number of ifdefs. Additionally it moves device registration
> related ifdefs to header file.
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi Inki,
>
> During testing your component match support patch [1] I have prepared patch
> removing most ifdefs from exynos_drm_drv.c. It is based on your patch, but
> I can rebase it if necessary.
>
> [1]: http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/37031
>
> Regards
> Andrzej
> ---
>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 170 +++++++-------------------------
>  drivers/gpu/drm/exynos/exynos_drm_drv.h |  25 +++--
>  2 files changed, 48 insertions(+), 147 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index b2c710a..a660e46 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -553,74 +553,54 @@ static const struct component_master_ops exynos_drm_ops = {
>  	.unbind		= exynos_drm_unbind,
>  };
>  
> -static int exynos_drm_platform_probe(struct platform_device *pdev)
> -{
> -	struct component_match *match;
> -	int ret;
> -
> -	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> -	exynos_drm_driver.num_ioctls = ARRAY_SIZE(exynos_ioctls);
> -
> +static struct platform_driver * const exynos_drm_drivers[] = {
>  #ifdef CONFIG_DRM_EXYNOS_FIMD
> -	ret = platform_driver_register(&fimd_driver);
> -	if (ret < 0)
> -		return ret;
> +	&fimd_driver,
>  #endif
> -
>  #ifdef CONFIG_DRM_EXYNOS_DP
> -	ret = platform_driver_register(&dp_driver);
> -	if (ret < 0)
> -		goto err_unregister_fimd_drv;
> +	&dp_driver,
>  #endif
> -
>  #ifdef CONFIG_DRM_EXYNOS_DSI
> -	ret = platform_driver_register(&dsi_driver);
> -	if (ret < 0)
> -		goto err_unregister_dp_drv;
> +	&dsi_driver,
>  #endif
> -
>  #ifdef CONFIG_DRM_EXYNOS_HDMI
> -	ret = platform_driver_register(&mixer_driver);
> -	if (ret < 0)
> -		goto err_unregister_dsi_drv;
> -	ret = platform_driver_register(&hdmi_driver);
> -	if (ret < 0)
> -		goto err_unregister_mixer_drv;
> +	&mixer_driver,
> +	&hdmi_driver,
>  #endif
> -
>  #ifdef CONFIG_DRM_EXYNOS_G2D
> -	ret = platform_driver_register(&g2d_driver);
> -	if (ret < 0)
> -		goto err_unregister_hdmi_drv;
> +	&g2d_driver,
>  #endif
> -
>  #ifdef CONFIG_DRM_EXYNOS_FIMC
> -	ret = platform_driver_register(&fimc_driver);
> -	if (ret < 0)
> -		goto err_unregister_g2d_drv;
> +	&fimc_driver,
>  #endif
> -
>  #ifdef CONFIG_DRM_EXYNOS_ROTATOR
> -	ret = platform_driver_register(&rotator_driver);
> -	if (ret < 0)
> -		goto err_unregister_fimc_drv;
> +	&rotator_driver,
>  #endif
> -
>  #ifdef CONFIG_DRM_EXYNOS_GSC
> -	ret = platform_driver_register(&gsc_driver);
> -	if (ret < 0)
> -		goto err_unregister_rotator_drv;
> +	&gsc_driver,
>  #endif
> -
>  #ifdef CONFIG_DRM_EXYNOS_IPP
> -	ret = platform_driver_register(&ipp_driver);
> -	if (ret < 0)
> -		goto err_unregister_gsc_drv;
> +	&ipp_driver,
> +#endif
> +};
> +
> +static int exynos_drm_platform_probe(struct platform_device *pdev)
> +{
> +	struct component_match *match;
> +	int ret, i;
> +
> +	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +	exynos_drm_driver.num_ioctls = ARRAY_SIZE(exynos_ioctls);
> +
> +	for (i = 0; i < ARRAY_SIZE(exynos_drm_drivers); ++i) {
> +		ret = platform_driver_register(exynos_drm_drivers[i]);
> +		if (ret < 0)
> +			goto err_unregister_drivers;
> +	}
>  
>  	ret = exynos_platform_device_ipp_register();
>  	if (ret < 0)
> -		goto err_unregister_ipp_drv;
> -#endif
> +		goto err_unregister_drivers;
>  
>  	match = exynos_drm_match_add(&pdev->dev);
>  	if (IS_ERR(match)) {
> @@ -632,96 +612,24 @@ static int exynos_drm_platform_probe(struct platform_device *pdev)
>  						match);
>  
>  err_unregister_ipp_dev:
> -
> -#ifdef CONFIG_DRM_EXYNOS_IPP
>  	exynos_platform_device_ipp_unregister();
> -err_unregister_ipp_drv:
> -	platform_driver_unregister(&ipp_driver);
> -err_unregister_gsc_drv:
> -#endif
>  
> -#ifdef CONFIG_DRM_EXYNOS_GSC
> -	platform_driver_unregister(&gsc_driver);
> -err_unregister_rotator_drv:
> -#endif
> +err_unregister_drivers:
> +	while (--i >= 0)
> +		platform_driver_unregister(exynos_drm_drivers[i]);
>  
> -#ifdef CONFIG_DRM_EXYNOS_ROTATOR
> -	platform_driver_unregister(&rotator_driver);
> -err_unregister_fimc_drv:
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_FIMC
> -	platform_driver_unregister(&fimc_driver);
> -err_unregister_g2d_drv:
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_G2D
> -	platform_driver_unregister(&g2d_driver);
> -err_unregister_hdmi_drv:
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_HDMI
> -	platform_driver_unregister(&hdmi_driver);
> -err_unregister_mixer_drv:
> -	platform_driver_unregister(&mixer_driver);
> -err_unregister_dsi_drv:
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_DSI
> -	platform_driver_unregister(&dsi_driver);
> -err_unregister_dp_drv:
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_DP
> -	platform_driver_unregister(&dp_driver);
> -err_unregister_fimd_drv:
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_FIMD
> -	platform_driver_unregister(&fimd_driver);
> -#endif
>  	return ret;
>  }
>  
>  static int exynos_drm_platform_remove(struct platform_device *pdev)
>  {
> -#ifdef CONFIG_DRM_EXYNOS_IPP
> -	exynos_platform_device_ipp_unregister();
> -	platform_driver_unregister(&ipp_driver);
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_GSC
> -	platform_driver_unregister(&gsc_driver);
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_ROTATOR
> -	platform_driver_unregister(&rotator_driver);
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_FIMC
> -	platform_driver_unregister(&fimc_driver);
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_G2D
> -	platform_driver_unregister(&g2d_driver);
> -#endif
> -
> -#ifdef CONFIG_DRM_EXYNOS_HDMI
> -	platform_driver_unregister(&mixer_driver);
> -	platform_driver_unregister(&hdmi_driver);
> -#endif
> +	int i;
>  
> -#ifdef CONFIG_DRM_EXYNOS_FIMD
> -	platform_driver_unregister(&fimd_driver);
> -#endif
> +	exynos_platform_device_ipp_unregister();
>  
> -#ifdef CONFIG_DRM_EXYNOS_DSI
> -	platform_driver_unregister(&dsi_driver);
> -#endif
> +	for (i = ARRAY_SIZE(exynos_drm_drivers) - 1; i >= 0; --i)
> +		platform_driver_unregister(exynos_drm_drivers[i]);
>  
> -#ifdef CONFIG_DRM_EXYNOS_DP
> -	platform_driver_unregister(&dp_driver);
> -#endif
>  	component_master_del(&pdev->dev, &exynos_drm_ops);
>  	return 0;
>  }
> @@ -745,11 +653,9 @@ static int exynos_drm_init(void)
>  	if (IS_ERR(exynos_drm_pdev))
>  		return PTR_ERR(exynos_drm_pdev);
>  
> -#ifdef CONFIG_DRM_EXYNOS_VIDI
>  	ret = exynos_drm_probe_vidi();
>  	if (ret < 0)
>  		goto err_unregister_pd;
> -#endif
>  
>  	ret = platform_driver_register(&exynos_drm_platform_driver);
>  	if (ret)
> @@ -758,11 +664,9 @@ static int exynos_drm_init(void)
>  	return 0;
>  
>  err_remove_vidi:
> -#ifdef CONFIG_DRM_EXYNOS_VIDI
>  	exynos_drm_remove_vidi();
>  
>  err_unregister_pd:
> -#endif
>  	platform_device_unregister(exynos_drm_pdev);
>  
>  	return ret;
> @@ -771,9 +675,9 @@ err_unregister_pd:
>  static void exynos_drm_exit(void)
>  {
>  	platform_driver_unregister(&exynos_drm_platform_driver);
> -#ifdef CONFIG_DRM_EXYNOS_VIDI
> +
>  	exynos_drm_remove_vidi();
> -#endif
> +
>  	platform_device_unregister(exynos_drm_pdev);
>  }
>  
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.h b/drivers/gpu/drm/exynos/exynos_drm_drv.h
> index 69a6fa3..76d5d02 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.h
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.h
> @@ -324,15 +324,14 @@ int exynos_platform_device_hdmi_register(void);
>   */
>  void exynos_platform_device_hdmi_unregister(void);
>  
> -/*
> - * this function registers exynos drm ipp platform device.
> - */
> +#ifdef CONFIG_DRM_EXYNOS_IPP
>  int exynos_platform_device_ipp_register(void);
> -
> -/*
> - * this function unregisters exynos drm ipp platform device if it exists.
> - */
>  void exynos_platform_device_ipp_unregister(void);
> +#else
> +static inline int exynos_platform_device_ipp_register(void) { return 0; }
> +static inline void exynos_platform_device_ipp_unregister(void) {}
> +#endif
> +
>  
>  #ifdef CONFIG_DRM_EXYNOS_DPI
>  struct exynos_drm_display * exynos_dpi_probe(struct device *dev);
> @@ -343,15 +342,13 @@ exynos_dpi_probe(struct device *dev) { return NULL; }
>  static inline int exynos_dpi_remove(struct device *dev) { return 0; }
>  #endif
>  
> -/*
> - * this function registers exynos drm vidi platform device/driver.
> - */
> +#ifdef CONFIG_DRM_EXYNOS_VIDI
>  int exynos_drm_probe_vidi(void);
> -
> -/*
> - * this function unregister exynos drm vidi platform device/driver.
> - */
>  void exynos_drm_remove_vidi(void);
> +#else
> +static inline int exynos_drm_probe_vidi(void) { return 0; }
> +static inline void exynos_drm_remove_vidi(void) {}
> +#endif
>  
>  /* This function creates a encoder and a connector, and initializes them. */
>  int exynos_drm_create_enc_conn(struct drm_device *dev,

