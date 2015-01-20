Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbbATQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:16:26 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39300 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbbATQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:16:25 -0500
Date: Tue, 20 Jan 2015 16:15:55 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/8] soc: Add MediaTek pericfg controller support
Message-ID: <20150120161555.GH15924@leverpostej>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
 <1421747231-554-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421747231-554-3-git-send-email-s.hauer@pengutronix.de>
Thread-Topic: [PATCH 2/8] soc: Add MediaTek pericfg controller support
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 09:47:05AM +0000, Sascha Hauer wrote:
> This adds support for the MediaTek pericfg controller found
> on the MT8135/MT8173 SoCs. The pericfg controller contains
> miscellaneous registers for controlling peripheral resets and
> clocks.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  .../devicetree/bindings/soc/mediatek/pericfg.txt      | 19 +++++++++++++++++++
>  drivers/soc/mediatek/Kconfig                          | 10 ++++++++++
>  drivers/soc/mediatek/Makefile                         |  1 +
>  drivers/soc/mediatek/mtk-pericfg.c                    |  1 -
>  4 files changed, 30 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/soc/mediatek/pericfg.txt
> 
> diff --git a/Documentation/devicetree/bindings/soc/mediatek/pericfg.txt b/Documentation/devicetree/bindings/soc/mediatek/pericfg.txt
> new file mode 100644
> index 0000000..81d1aee
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/soc/mediatek/pericfg.txt
> @@ -0,0 +1,19 @@
> +MediaTek pericfg Controller
> +
> +The pericfg controller contains miscellaneous registers for controlling
> +clocks, resets and bus settings.
> +
> +Required properties:
> +- compatible: must be one of:
> +	mediatek,mt8135-pericfg
> +	mediatek,mt8173-pericfg
> +- reg: Address range for the pericfg controller
> +
> +Example:
> +
> +	pericfg: pericfg@10003000 {
> +		#reset-cells = <1>;
> +		#clock-cells = <1>;
> +		compatible = "mediatek,mt8135-pericfg";
> +		reg = <0 0x10003000 0 0x1000>;
> +	};

This looks identical to the infracfg (same address too). Is that
deliberate?

Mark.

> diff --git a/drivers/soc/mediatek/Kconfig b/drivers/soc/mediatek/Kconfig
> index 3ad39fe..9bdb88f 100644
> --- a/drivers/soc/mediatek/Kconfig
> +++ b/drivers/soc/mediatek/Kconfig
> @@ -10,3 +10,13 @@ config MTK_INFRACFG
>  	  contains several miscellaneous registers for clock, reset and bus
>  	  settings. Say yes here if you want to run your kernel on one of these
>  	  SoCs.
> +
> +config MTK_PERICFG
> +	tristate "MediaTek pericfg controller support"
> +	depends on ARCH_MEDIATEK || COMPILE_TEST
> +	select REGMAP
> +	help
> +	  The MediaTek pericfg controller found on MT8135 and MT8173 SoCs
> +	  contains several miscellaneous registers for clock, reset and bus
> +	  settings. Say yes here if you want to run your kernel on one of these
> +	  SoCs.
> diff --git a/drivers/soc/mediatek/Makefile b/drivers/soc/mediatek/Makefile
> index dbeb627..e67be7c 100644
> --- a/drivers/soc/mediatek/Makefile
> +++ b/drivers/soc/mediatek/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_MTK_INFRACFG) += mtk-infracfg.o
> +obj-$(CONFIG_MTK_PERICFG) += mtk-pericfg.o
> diff --git a/drivers/soc/mediatek/mtk-pericfg.c b/drivers/soc/mediatek/mtk-pericfg.c
> index b7ee902..aa9a7eb 100644
> --- a/drivers/soc/mediatek/mtk-pericfg.c
> +++ b/drivers/soc/mediatek/mtk-pericfg.c
> @@ -1,6 +1,5 @@
>  /*
>   * Copyright (c) 2014 MediaTek Inc.
> - * Author: Flora Fu <flora.fu@mediatek.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> -- 
> 2.1.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
