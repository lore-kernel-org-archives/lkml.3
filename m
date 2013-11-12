Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3KLPuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:50:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36328 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3KLPuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:50:51 -0500
Message-ID: <52824E2F.9090302@ti.com>
Date: Tue, 12 Nov 2013 10:50:07 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
CC: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [PATCH 02/12] mtd: nand: davinci: check required ti,davinci-chipselect
 property
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-3-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8CEF@DNCE04.ent.ti.com>
In-Reply-To: <4F5844B3A985794BA902E12C070812375F8CEF@DNCE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 November 2013 11:53 AM, Khoronzhuk, Ivan wrote:
> The property "ti,davinci-chipselect" is required. So we have to check
> if it is set.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  drivers/mtd/nand/davinci_nand.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index d87213f..8e1c88e 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -541,10 +541,14 @@ static struct davinci_nand_pdata
>                                 GFP_KERNEL);
>                 pdev->dev.platform_data = pdata;
>                 if (!pdata)
> -                       return NULL;
> +                       return ERR_PTR(-ENOMEM);
> +
This change don't follow commit message.

>                 if (!of_property_read_u32(pdev->dev.of_node,
>                         "ti,davinci-chipselect", &prop))
>                         pdev->id = prop;
> +               else
> +                       return ERR_PTR(-EINVAL);
> +
So the check already exist but the error case wasn't handled.
This should be reflected in change log.

>                 if (!of_property_read_u32(pdev->dev.of_node,
>                         "ti,davinci-mask-ale", &prop))
>                         pdata->mask_ale = prop;
> @@ -598,6 +602,10 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>         nand_ecc_modes_t                ecc_mode;
> 
>         pdata = nand_davinci_get_pdata(pdev);
> +       if (IS_ERR(pdata)) {
> +               return PTR_ERR(pdata);
> +       }
> +
Again not related to commit log. You might want to split this patch
then.

Regards,
Santosh

