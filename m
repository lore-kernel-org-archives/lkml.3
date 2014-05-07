Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaEGIHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:07:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52316 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaEGIG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:06:56 -0400
Date: Wed, 7 May 2014 10:06:50 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: zImage: Allow DTB to override broken ATAG_MEM
Message-ID: <20140507080650.GA28564@pengutronix.de>
References: <1399439776-18535-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399439776-18535-1-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 10:16:16PM -0700, Bjorn Andersson wrote:
> Support overriding ATAG_MEM, by specifying non-zero content of the /memory/reg
> property in the appended DTB. This is needed to work around bootloaders passing
> broken tags.
This feels wrong. I think it's quite usual that the device tree
specifies a non-0 /memory/reg property. I checked four more or less
random dts files[1], and three of them have this property set with
actual values.

So I wouldn't be surprised if this patch results in more damage than
it's worth. The optimal fix would be to make the bootloader do the right
thing. And if you trust your dtb more than your bootloader, disable
ARM_ATAG_DTB_COMPAT.

Best regards
Uwe

[1]
arch/arm/boot/dts/am335x-bone-common.dtsi
arch/arm/boot/dts/exynos5440-sd5v1.dts
arch/arm/boot/dts/imx6q-wandboard.dts
arch/arm/boot/dts/tegra30-cardhu.dtsi
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  arch/arm/boot/compressed/atags_to_fdt.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compressed/atags_to_fdt.c
> index d1153c8..b534cd6 100644
> --- a/arch/arm/boot/compressed/atags_to_fdt.c
> +++ b/arch/arm/boot/compressed/atags_to_fdt.c
> @@ -95,6 +95,22 @@ static void merge_fdt_bootargs(void *fdt, const char *fdt_cmdline)
>  	setprop_string(fdt, "/chosen", "bootargs", cmdline);
>  }
>  
> +static int fdt_overrides_atag_mem(void *fdt)
> +{
> +	const char *memory;
> +	int len = 0;
> +
> +	memory = getprop(fdt, "/memory", "reg", &len);
> +	if (memory) {
> +		while (len--) {
> +			if (*memory++ != '\0')
[added fixup noted in follow-up-mail]

> +				return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Convert and fold provided ATAGs into the provided FDT.
>   *
> @@ -180,7 +196,7 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_space)
>  		}
>  	}
>  
> -	if (memcount) {
> +	if (memcount && !fdt_overrides_atag_mem(fdt)) {
>  		setprop(fdt, "/memory", "reg", mem_reg_property,
>  			4 * memcount * memsize);
>  	}
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
