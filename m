Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaLQPxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:53:07 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54529 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaLQPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:53:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stefan Hengelein <stefan.hengelein@fau.de>, kgene@kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Heiko Stuebner <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] ARM: SAMSUNG: remove dead #elif CONFIG_S3C24XX_DMAC
Date: Wed, 17 Dec 2014 16:52:40 +0100
Message-ID: <1921250.jGHJ6gZqGf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418830837-7422-1-git-send-email-stefan.hengelein@fau.de>
References: <1418830837-7422-1-git-send-email-stefan.hengelein@fau.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:t6FXHxEipPhldNE+mh6HYgbpITkeXc1SeOQkyBa3zzQSwnqqXJl
 cVFMlP7Oz8Qvqfgrn1rgiDbTKu1NySR7u+N77eZ8gAwWg0DSuHddxeNRg0mBOoUHf8/2FjY
 RBNkdQUczFsf5VNvpvIQi/heYwWqoIw+G9FSEXdeBvf54rt4duxaL6TUOv1tu99YJAcJaCl
 3PxOaqQ7XAZd/cE60fS9Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 16:40:37 Stefan Hengelein wrote:
> The corresponding CPP-block can never be selected since there are
> conflicting Kconfig constraints:
> - CONFIG_S3C24XX_DMAC has a dependency on ARCH_S3C24XX
> - The surrounding CPP-block needs CONFIG_S3C64XX_DEV_SPI0 to be defined.
>   - CONFIG_S3C64XX_DEV_SPI0 is only selected by MACH_WLF_CRAGG_6410
>   - MACH_WLF_CRAGG_6410 however has a dependency on ARCH_S3C64XX
>     (through a surrounding if-statement in Kconfig)
> - ARCH_S3C64XX and ARCH_S3C24XX are mutually exclusive since they are
>   declared in the same choice and cannot be enabled at the same time.
> 
> Hence, the innner block
>     "#elif defined(CONFIG_S3C24XX_DMAC)"
> cannot be enabled at the same time with the surrounding block
>     "#ifdef CONFIG_S3C64XX_DEV_SPI0"
> and therefore is dead.
> 
> This (logical) defect has been found with the undertaker tool
> (https://undertaker.cs.fau.de)

Nice catch!

> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
> ---
>  arch/arm/plat-samsung/devs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
> index 83c7d15..b38b601 100644
> --- a/arch/arm/plat-samsung/devs.c
> +++ b/arch/arm/plat-samsung/devs.c
> @@ -1134,8 +1134,6 @@ void __init s3c64xx_spi0_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
>  	pd.filter = pl330_filter;
>  #elif defined(CONFIG_S3C64XX_PL080)
>  	pd.filter = pl08x_filter_id;
> -#elif defined(CONFIG_S3C24XX_DMAC)
> -	pd.filter = s3c24xx_dma_filter;
>  #endif
>  
>  	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi0);
> 

This was introduced in 7f99ef2284b46f ("ARM: SAMSUNG: set
s3c24xx_dma_filter for s3c64xx-spi0 device"), but never used on s3c24xx as
far as I can tell. Heiko, can you comment on the patch? Did this
simply get obsoleted by the DT conversion of s3c2416 and s3c2443?

	Arnd
