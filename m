Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaJ1OWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:22:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58483 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaJ1OWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:22:04 -0400
MIME-Version: 1.0
In-Reply-To: <1414493629-12570-2-git-send-email-wangzhou.bry@gmail.com>
References: <1414493629-12570-1-git-send-email-wangzhou.bry@gmail.com>
	<1414493629-12570-2-git-send-email-wangzhou.bry@gmail.com>
Date: Tue, 28 Oct 2014 15:22:01 +0100
Message-ID: <CAH6sp9MuL+AAvMi1VrmOhq5Y-ri2DKO3g0h1hw040h5=CRu6UQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mtd: hisilicon: add a new NAND controller driver
 for hisilicon hip04 Soc
From: Frans Klaver <fransklaver@gmail.com>
To: Zhou Wang <wangzhou.bry@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        haojian.zhuang@gmail.com, wangzhou1@hisilicon.com,
        Rob Herring <robh+dt@kernel.org>, xuwei5@hisilicon.com,
        Kumar Gala <galak@codeaurora.org>, caizhiyong@huawei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:53 AM, Zhou Wang <wangzhou.bry@gmail.com> wrote:
> +
> +static int hisi_nfc_probe(struct platform_device *pdev)
> +{
> +       int ret = 0, irq, buswidth, flag, max_chips = HINFC504_MAX_CHIP;
> +       struct device *dev = &pdev->dev;
> +       struct hinfc_host *host;
> +       struct nand_chip  *chip;
> +       struct mtd_info   *mtd;
> +       struct resource   *res;
> +       struct device_node *np = dev->of_node;
> +       struct mtd_part_parser_data ppdata;
> +
> +       host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +       if (!host)
> +               return -ENOMEM;
> +       host->dev = dev;
> +
> +       platform_set_drvdata(pdev, host);
> +       chip = &host->chip;
> +       mtd  = &host->mtd;
> +
> +       irq = platform_get_irq(pdev, 0);
> +       if (irq < 0) {
> +               dev_err(dev, "no IRQ resource defined\n");
> +               ret = -ENXIO;
> +               goto err_res;
> +       }
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       host->iobase = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(host->iobase)) {
> +               ret = PTR_ERR(host->iobase);
> +               dev_err(dev, "devm_ioremap_resource[0] fail\n");
> +               goto err_res;
> +       }
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +       chip->IO_ADDR_R = chip->IO_ADDR_W = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(chip->IO_ADDR_R)) {
> +               ret = PTR_ERR(chip->IO_ADDR_R);
> +               dev_err(dev, "devm_ioremap_resource[1] fail\n");
> +               goto err_res;
> +       }
> +
> +       mtd->priv               = chip;
> +       mtd->owner              = THIS_MODULE;
> +       mtd->name               = "hisi_nand";

+ mtd->dev.parent = &pdev->dev;

This is a bug that lives in a bunch of other nand drivers as well.
add_mtd_device (called by mtd_device_parse_register()) expects
dev.parent to be set for properly adding a device reference to the
sysfs node.

Frans
