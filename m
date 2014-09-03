Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaICIbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:31:00 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:47643 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaICIa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <1409672977-26972-1-git-send-email-jean-michel.hautbois@vodalys.com>
References: <1409672977-26972-1-git-send-email-jean-michel.hautbois@vodalys.com>
Date: Wed, 3 Sep 2014 10:30:56 +0200
Message-ID: <CAPDyKFrwCzQJvbpbue4T=HWLmbq5sZOP3RXwiupKvXe71uboUw@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: Enable boot partition access from DT
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <b29396@freescale.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>, h80.chung@samsung.com,
        Chris Ball <chris@printf.net>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 September 2014 17:49, Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com> wrote:
> This property is useful when we don't want to access boot partitions on eMMC
>
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
>
>  *NOTE* on CD and WP polarity. To use common for all SD/MMC host controllers line
>  polarity properties, we have to fix the meaning of the "normal" and "inverted"
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index ccec0e3..439e663 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -942,6 +942,11 @@ sdhci_esdhc_imx_probe_dt(struct platform_device *pdev,
>         if (of_property_read_u32(np, "fsl,delay-line", &boarddata->delay_line))
>                 boarddata->delay_line = 0;
>
> +       if (of_find_property(np, "no-boot-part", NULL))
> +               boarddata->access_boot_part = false;
> +       else
> +               boarddata->access_boot_part = true;
> +
>         return 0;
>  }
>  #else
> @@ -1119,6 +1124,9 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
>                 host->quirks2 |= SDHCI_QUIRK2_NO_1_8_V;
>         }
>
> +       if (!boarddata->access_boot_part)
> +               host->mmc->caps2 |= MMC_CAP2_BOOTPART_NOACC;
> +

Hmm, I don't think MMC_CAP2_BOOTPART_NOACC should have a DT binding.
Does it describe the hardware in some form?

Actually I would like to question why MMC_CAP2_BOOTPART_NOACC exists
at all. If there are cards that don't supports the BOOT area,
shouldn't we have a card quirk for it instead of a host cap? Maybe
Adrian Hunter, how originally wrote the patch for adding
MMC_CAP2_BOOTPART_NOACC, could help me understand the reasons behind
it!?

Kind regards
Uffe
