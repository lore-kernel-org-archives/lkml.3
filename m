Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3FRJD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:03:29 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57985 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3FRJD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:03:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130617134957.GA15602@amd.pavel.ucw.cz>
References: <20130617134957.GA15602@amd.pavel.ucw.cz>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 18 Jun 2013 10:03:05 +0100
X-Google-Sender-Auth: YQSU2CnVsPqXmbb6eh_M-FvHZcA
Message-ID: <CACxGe6sO6Tes8en905cyJwP69w82PHjwKV9+XxxXhAPMRyGYkA@mail.gmail.com>
Subject: Re: [PATCH] fix UIO with device tree but no assigned interrupt
To: Pavel Machek <pavel@denx.de>
Cc: Detlev Zundel <dzu@denx.de>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 2:49 PM, Pavel Machek <pavel@denx.de> wrote:
> If device is initialized from device tree, but has no interrupt assigned,
> uio will still try to request and interrupt old way, fails, and fails registration.
>
> This is wrong; don't try initializing irq using platform data if device tree is
> available.
>
> Signed-off-by: Pavel Machek <pavel@denx.de>
> Reported-by: Detlev Zundel <dzu@denx.de>
> Tested-by: Detlev Zundel <dzu@denx.de>
>
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 8fcc2c7..f709ead 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -213,7 +213,8 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>                 goto bad0;
>         }
>
> -       if (!uioinfo->irq) {
> +       /* interrupts from device tree are already handled above */
> +       if (!pdev->dev.of_node && !uioinfo->irq) {
>                 ret = platform_get_irq(pdev, 0);
>                 if (ret < 0) {
>                         dev_err(&pdev->dev, "failed to get IRQ\n");

This looks backwards. The OF code block is actually duplicating this
block. It would be better to drop the call to platform_get_irq from
the of node processing and let it fall through to this call.

g.
