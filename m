Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab3GWSjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:39:04 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:46636 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933863Ab3GWSit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <1371460573-30004-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-14-git-send-email-tushar.behera@linaro.org> <1371460573-30004-1-git-send-email-tushar.behera@linaro.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 23 Jul 2013 12:38:28 -0600
Message-ID: <CAErSpo7hHSmO6euUtJABLB-xeK9u+J2h6z905e5DrcZv5gZoEA@mail.gmail.com>
Subject: Re: [PATCH V2 6/6] pci: mvebu: Convert to use devm_ioremap_resource
To: Tushar Behera <tushar.behera@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>, patches@linaro.org,
        sachin.kamat@linaro.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Thomas]

On Mon, Jun 17, 2013 at 3:16 AM, Tushar Behera <tushar.behera@linaro.org> wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
>
> While at it, modify mvebu_pcie_map_registers() to propagate error code.
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: linux-pci@vger.kernel.org
> CC: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thomas has a bunch of mvebu patches in the pipeline, so I assume he
will incorporate this if appropriate.  I don't want to put it in my
tree and cause conflicts with his changes.  Let me know if I should do
something else here.

Bjorn

> ---
> Changes for V2:
> * Return proper error code in mvebu_pcie_map_registers.
>
>  drivers/pci/host/pci-mvebu.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
> index 13a633b..8fc2a82 100644
> --- a/drivers/pci/host/pci-mvebu.c
> +++ b/drivers/pci/host/pci-mvebu.c
> @@ -750,9 +750,9 @@ mvebu_pcie_map_registers(struct platform_device *pdev,
>
>         ret = of_address_to_resource(np, 0, &regs);
>         if (ret)
> -               return NULL;
> +               return ERR_PTR(ret);
>
> -       return devm_request_and_ioremap(&pdev->dev, &regs);
> +       return devm_ioremap_resource(&pdev->dev, &regs);
>  }
>
>  static int __init mvebu_pcie_probe(struct platform_device *pdev)
> @@ -842,9 +842,10 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
>                         continue;
>
>                 port->base = mvebu_pcie_map_registers(pdev, child, port);
> -               if (!port->base) {
> +               if (IS_ERR(port->base)) {
>                         dev_err(&pdev->dev, "PCIe%d.%d: cannot map registers\n",
>                                 port->port, port->lane);
> +                       port->base = NULL;
>                         continue;
>                 }
>
> --
> 1.7.9.5
>
