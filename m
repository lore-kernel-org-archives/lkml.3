Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaJTMFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:05:00 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50544 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaJTME5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:04:57 -0400
Message-ID: <5444F9AF.5000104@gmail.com>
Date: Mon, 20 Oct 2014 17:31:51 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yassin Jaffer <yassinjaffer@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v6 1/2] mtd: nand: add sunxi NAND flash controller support
References: <1413805520-14947-1-git-send-email-boris.brezillon@free-electrons.com> <1413805520-14947-2-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1413805520-14947-2-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 05:15 PM, Boris Brezillon wrote:
> Add support for the sunxi NAND Flash Controller (NFC).
>
(...)

> +
> +static int sunxi_nfc_dev_ready(struct mtd_info *mtd)
> +{
> +	struct nand_chip *nand = mtd->priv;
> +	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
> +	struct sunxi_nand_rb *rb;
> +	unsigned long timeo = (sunxi_nand->nand.state == FL_ERASING ? 400 : 20);
> +	int ret;
> +
> +	if (sunxi_nand->selected < 0)
> +		return 0;
> +
> +	rb = &sunxi_nand->sels[sunxi_nand->selected].rb;
> +
> +	switch (rb->type) {
> +	case RB_NATIVE:
> +		ret = !!(readl(nfc->regs + NFC_REG_ST) &
> +			 (NFC_RB_STATE0 << rb->info.nativeid));
> +		if (ret)
> +			break;
> +
> +		sunxi_nfc_wait_int(nfc, NFC_RB_B2R, timeo);
> +		ret = !!(readl(nfc->regs + NFC_REG_ST) &
> +			 (NFC_RB_STATE0 << rb->info.nativeid));
> +		break;
> +	case RB_GPIO:
> +		ret = gpio_get_value(rb->info.gpio);
> +		break;
> +	case RB_NONE:
> +	default:
> +		ret = 0;
> +		pr_err("cannot check R/B NAND status!");

Missed terminating  new line...  :-)

> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +

(...)

> +static struct platform_driver sunxi_nfc_driver = {
> +	.driver = {
> +		.name = "sunxi_nand",
> +		.owner = THIS_MODULE,

This field updated by module_platform_driver()..

> +		.of_match_table = sunxi_nfc_ids,
> +	},
> +	.probe = sunxi_nfc_probe,
> +	.remove = sunxi_nfc_remove,
> +};
> +module_platform_driver(sunxi_nfc_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Boris BREZILLON");
> +MODULE_DESCRIPTION("Allwinner NAND Flash Controller driver");
> +MODULE_ALIAS("platform:sunxi_nand");

-- 
Regards,
Varka Bhadram.

