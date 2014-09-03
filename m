Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaICDVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:21:18 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:7446
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753108AbaICDVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:21:15 -0400
Date: Wed, 3 Sep 2014 10:59:48 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <rmk+kernel@arm.linux.org.uk>,
        <shawn.guo@linaro.org>, <peter.griffin@linaro.org>,
        <tgih.jun@samsung.com>, <h80.chung@samsung.com>,
        <ulf.hansson@linaro.org>, <chris@printf.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: Enable boot partition access
 from DT
Message-ID: <20140903025944.GA18325@shlinux1.ap.freescale.net>
References: <1409672977-26972-1-git-send-email-jean-michel.hautbois@vodalys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409672977-26972-1-git-send-email-jean-michel.hautbois@vodalys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(199003)(189002)(51704005)(64706001)(46102001)(50986999)(85852003)(104016003)(33656002)(102836001)(230783001)(83072002)(47776003)(80022001)(87936001)(92566001)(26826002)(20776003)(95666004)(74502001)(83506001)(74662001)(31966008)(4396001)(92726001)(90102001)(575784001)(110136001)(107046002)(23726002)(46406003)(21056001)(76482001)(79102001)(99396002)(68736004)(81542001)(77982001)(54356999)(84676001)(81342001)(76176999)(6806004)(97736001)(106466001)(85306004)(105606002)(19580405001)(50466002)(83322001)(97756001)(19580395003)(44976005)(42262002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB576;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Aisheng.Dong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 05:49:37PM +0200, Jean-Michel Hautbois wrote:
> This property is useful when we don't want to access boot partitions on eMMC
> 

Any special reason why not access boot partitions on eMMC?
Not allow user to access it?

> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> ---
>  Documentation/devicetree/bindings/mmc/mmc.txt | 1 +
>  drivers/mmc/host/sdhci-esdhc-imx.c            | 8 ++++++++
>  include/linux/platform_data/mmc-esdhc-imx.h   | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
> index 431716e..59cc854 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/mmc.txt
> @@ -40,6 +40,7 @@ Optional properties:
>  - mmc-hs200-1_2v: eMMC HS200 mode(1.2V I/O) is supported
>  - mmc-hs400-1_8v: eMMC HS400 mode(1.8V I/O) is supported
>  - mmc-hs400-1_2v: eMMC HS400 mode(1.2V I/O) is supported
> +- no-boot-part : when preset, tells to access boot partitions

The file you changed is common mmc binding doc.
You may also want to add the support in mmc_of_parse.

And since sdhci-esdhc-imx is not using mmc_of_parse currently, maybe it's time
to convert to it.

Regards
Dong Aisheng

> 
>  *NOTE* on CD and WP polarity. To use common for all SD/MMC host controllers line
>  polarity properties, we have to fix the meaning of the "normal" and "inverted"
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index ccec0e3..439e663 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -942,6 +942,11 @@ sdhci_esdhc_imx_probe_dt(struct platform_device *pdev,
> 	if (of_property_read_u32(np, "fsl,delay-line", &boarddata->delay_line))
> 		boarddata->delay_line = 0;
> 
> +	if (of_find_property(np, "no-boot-part", NULL))
> +		boarddata->access_boot_part = false;
> +	else
> +		boarddata->access_boot_part = true;
> +
> 	return 0;
>  }
>  #else
> @@ -1119,6 +1124,9 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
> 		host->quirks2 |= SDHCI_QUIRK2_NO_1_8_V;
> 	}
> 
> +	if (!boarddata->access_boot_part)
> +		host->mmc->caps2 |= MMC_CAP2_BOOTPART_NOACC;
> +
> 	err = sdhci_add_host(host);
> 	if (err)
> 		goto disable_clk;
> diff --git a/include/linux/platform_data/mmc-esdhc-imx.h b/include/linux/platform_data/mmc-esdhc-imx.h
> index 75f70f6..a34ee9e 100644
> --- a/include/linux/platform_data/mmc-esdhc-imx.h
> +++ b/include/linux/platform_data/mmc-esdhc-imx.h
> @@ -46,5 +46,6 @@ struct esdhc_platform_data {
> 	unsigned int f_max;
> 	bool support_vsel;
> 	unsigned int delay_line;
> +	bool access_boot_part;
>  };
>  #endif /* __ASM_ARCH_IMX_ESDHC_H */
> 
> 2.0.4
> 
