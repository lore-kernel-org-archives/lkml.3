Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaENNTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:19:03 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:52699 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbaENNTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:19:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140514125524.GB14571@mwanda>
References: <1400050877.8431.9.camel@iivanov-dev>
	<20140514125524.GB14571@mwanda>
Date: Wed, 14 May 2014 10:18:59 -0300
Message-ID: <CAOMZO5D7djkVN0sV6ynCqkqtq0XsoFyyNoxva=JLyuWpU3BtwA@mail.gmail.com>
Subject: Re: [patch] usb: phy: msm: devm_ioremap() doesn't return ERR_PTRs
From: Fabio Estevam <festevam@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, USB list <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 9:55 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> devm_ioremap() returns a NULL on error so the IS_ERR() check needs to be
> updated.
>
> Fixes: 6b99c68ec1f9 ('usb: phy: msm: Migrate to Managed Device Resource allocation')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index c522c4f..bd32257 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -1587,8 +1587,8 @@ static int msm_otg_probe(struct platform_device *pdev)
>
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         motg->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> -       if (IS_ERR(motg->regs))
> -               return PTR_ERR(motg->regs);
> +       if (!motg->regs)
> +               return -ENOMEM;

What about doing devm_ioremap_resource() instead?
