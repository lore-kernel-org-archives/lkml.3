Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaBEIC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:02:56 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46302 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaBEICy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:02:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140205065254.29445.77939.sendpatchset@w520>
References: <20140205065243.29445.76593.sendpatchset@w520>
	<20140205065254.29445.77939.sendpatchset@w520>
Date: Wed, 5 Feb 2014 09:02:53 +0100
X-Google-Sender-Auth: thlO0eW0cvjdXWPkhethZ4qfSGo
Message-ID: <CAMuHMdVrkPybrONnw5fZaMZ-vuaq_arrBMZvnRYZ9EnvE8Y4cA@mail.gmail.com>
Subject: Re: [PATCH 01/04] PCI: rcar: Register each instance independently
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-pci@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Valentine <valentine.barshak@cogentembedded.com>,
        Simon Horman <horms@verge.net.au>, Bjorn Helgaas <bhelgaas@google.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 7:52 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> +static int rcar_pci_probe(struct platform_device *pdev)
>  {
>         struct resource *cfg_res, *mem_res;
>         struct rcar_pci_priv *priv;
>         void __iomem *reg;
> +       struct hw_pci hw;
>
>         cfg_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         reg = devm_ioremap_resource(&pdev->dev, cfg_res);
> @@ -308,31 +271,26 @@ static int __init rcar_pci_probe(struct
>         priv->reg = reg;
>         priv->dev = &pdev->dev;
>
> -       return rcar_pci_add_controller(priv);
> +       memset(&hw, 0, sizeof(hw));
> +       hw.nr_controllers = 1;
> +       hw.private_data = (void **)&priv;

This raised a red flag: taking the address of a variable on the stack.
I know it's correct, as hw.private_data is an array of pointers copied
by pci_common_init_dev() below.
But perhaps it's a good idea to turn priv into an array with one element,
to make this clearer, and avoid the ugly cast?

> +       hw.map_irq = rcar_pci_map_irq;
> +       hw.ops = &rcar_pci_ops;
> +       hw.setup = rcar_pci_setup;
> +       pci_common_init_dev(&pdev->dev, &hw);
> +       return 0;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
