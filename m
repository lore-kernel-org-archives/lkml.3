Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaKIVzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 16:55:13 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41428 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaKIVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 16:55:11 -0500
MIME-Version: 1.0
In-Reply-To: <1415567571-6144-1-git-send-email-alchark@gmail.com>
References: <1415567571-6144-1-git-send-email-alchark@gmail.com>
Date: Sun, 9 Nov 2014 19:55:09 -0200
Message-ID: <CAOMZO5C+O4h=f=vtLTdBZktnfVWzfeLjOQG-oecxh_c9u-QMqA@mail.gmail.com>
Subject: Re: [PATCH] mmc: wmt-sdmmc: fix unmatched release_mem_region
From: Fabio Estevam <festevam@gmail.com>
To: Alexey Charkov <alchark@gmail.com>
Cc: Tony Prisk <linux@prisktech.co.nz>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Helmut Stengele <lautriv@coldplug.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 9, 2014 at 7:12 PM, Alexey Charkov <alchark@gmail.com> wrote:

> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               ret = -ENODEV;
> +               goto fail1;

You could save this NULL check...

> +       }
>         mmc = mmc_alloc_host(sizeof(struct wmt_mci_priv), &pdev->dev);
>         if (!mmc) {
>                 dev_err(&pdev->dev, "Failed to allocate mmc_host\n");
> @@ -813,7 +819,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
>         if (of_get_property(np, "cd-inverted", NULL))
>                 priv->cd_inverted = 1;
>
> -       priv->sdmmc_base = of_iomap(np, 0);

If you move ' res = platform_get_resource' right here as
devm_ioremap_resource() already does the NULL check.

> +       priv->sdmmc_base = devm_ioremap_resource(&pdev->dev, res);
>         if (!priv->sdmmc_base) {
>                 dev_err(&pdev->dev, "Failed to map IO space\n");
>                 ret = -ENOMEM;
