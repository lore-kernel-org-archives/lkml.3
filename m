Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3HTR13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:27:29 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1907 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab3HTR12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:27:28 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <5213A6F6.4070105@broadcom.com>
Date: Tue, 20 Aug 2013 10:27:18 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Christian Daudt" <csd@broadcom.com>
cc: "Russell King" <linux@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        "Markus Mayer" <markus.mayer@linaro.org>,
        "Stephen Warren" <swarren@nvidia.com>,
        "Shawn Guo" <shawn.guo@linaro.org>, "Olof Johansson" <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: bcm: Make secure API call optional
References: <1375989594-12193-1-git-send-email-csd@broadcom.com>
In-Reply-To: <1375989594-12193-1-git-send-email-csd@broadcom.com>
X-WSS-ID: 7E0D798631W86105297-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-08 12:19 PM, Christian Daudt wrote:
> The current bcm_kona_smc_init function throws a BUG_ON if there's no SMC
> device node defined in the device tree.
>
> Since secure API access is optional depending the chip configuration,
> fix this by allowing the rest of the code to run even if there's no SMC
> device node defined
>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Signed-off-by: Christian Daudt <csd@broadcom.com>
>
> diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
> index 56d9d19..e32c1b3 100644
> --- a/arch/arm/mach-bcm/bcm_kona_smc.c
> +++ b/arch/arm/mach-bcm/bcm_kona_smc.c
> @@ -41,13 +41,14 @@ static const struct of_device_id bcm_kona_smc_ids[] __initconst = {
>   };
>   
>   /* Map in the bounce area */
> -void __init bcm_kona_smc_init(void)
> +int __init bcm_kona_smc_init(void)
>   {
>   	struct device_node *node;
>   
>   	/* Read buffer addr and size from the device tree node */
>   	node = of_find_matching_node(NULL, bcm_kona_smc_ids);
> -	BUG_ON(!node);
> +	if (!node)
> +		return -ENODEV;
>   
>   	/* Don't care about size or flags of the DT node */
>   	bridge_data.buffer_addr =
> @@ -59,7 +60,9 @@ void __init bcm_kona_smc_init(void)
>   
>   	bridge_data.initialized = 1;
>   
> -	pr_info("Secure API initialized!\n");
> +	pr_info("Kona Secure API initialized\n");
> +
> +	return 0;
>   }
>   
>   /* __bcm_kona_smc() should only run on CPU 0, with pre-emption disabled */
> diff --git a/arch/arm/mach-bcm/bcm_kona_smc.h b/arch/arm/mach-bcm/bcm_kona_smc.h
> index 3bedbed1..d098a7e 100644
> --- a/arch/arm/mach-bcm/bcm_kona_smc.h
> +++ b/arch/arm/mach-bcm/bcm_kona_smc.h
> @@ -64,7 +64,7 @@
>   #define SSAPI_BRCM_START_VC_CORE	0x0E000008
>   
>   #ifndef	__ASSEMBLY__
> -extern void bcm_kona_smc_init(void);
> +extern int __init bcm_kona_smc_init(void);
>   
>   extern unsigned bcm_kona_smc(unsigned service_id,
>   			     unsigned arg0,
> diff --git a/arch/arm/mach-bcm/board_bcm.c b/arch/arm/mach-bcm/board_bcm.c
> index 2859932..70cc44f 100644
> --- a/arch/arm/mach-bcm/board_bcm.c
> +++ b/arch/arm/mach-bcm/board_bcm.c
> @@ -29,15 +29,18 @@ static int __init kona_l2_cache_init(void)
>   	if (!IS_ENABLED(CONFIG_CACHE_L2X0))
>   		return 0;
>   
> +	if (bcm_kona_smc_init() < 0) {
> +		pr_info("Kona secure API not available. Skipping L2 init\n");
> +		return 0;
> +	}
> +
>   	bcm_kona_smc(SSAPI_ENABLE_L2_CACHE, 0, 0, 0, 0);
>   
>   	/*
>   	 * The aux_val and aux_mask have no effect since L2 cache is already
>   	 * enabled.  Pass 0s for aux_val and 1s for aux_mask for default value.
>   	 */
> -	l2x0_of_init(0, ~0);
> -
> -	return 0;
> +	return l2x0_of_init(0, ~0);
>   }
>   
>   static void __init board_init(void)
> @@ -45,8 +48,6 @@ static void __init board_init(void)
>   	of_platform_populate(NULL, of_default_bus_match_table, NULL,
>   		&platform_bus);
>   
> -	bcm_kona_smc_init();
> -
>   	kona_l2_cache_init();
>   }
>   
applied to bcm/for-3.12/soc

  thanks,
   csd


