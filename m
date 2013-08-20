Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab3HTQ0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:26:38 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58577 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3HTQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1308201112400.2269@hadrien>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr> <20130819120249.GA5740@ulmo>
 <alpine.DEB.2.02.1308191405450.2313@hadrien> <20130819121238.GB5740@ulmo>
 <alpine.DEB.2.02.1308191414360.2313@hadrien> <20130819193339.GB4961@mithrandir>
 <alpine.DEB.2.02.1308201112400.2269@hadrien>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 20 Aug 2013 10:26:14 -0600
Message-ID: <CAErSpo4WLt7zbyfkKfvMbXMQGmp0MAS=7AFiomUjtUCfdprDUA@mail.gmail.com>
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by devm_ioremap_resource
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Thierry Reding <thierry.reding@gmail.com>, kernel-janitors@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 3:13 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Use devm_ioremap_resource instead of devm_request_and_ioremap.
>
> This was done using the semantic patch
> scripts/coccinelle/api/devm_ioremap_resource.cocci
>
> Error-handling code was manually removed from the associated calls to
> platform_get_resource.
>
> Adjust the comment at the third platform_get_resource_byname to make clear
> why ioremap is not done at this point.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> Acked-by: Thierry Reding <thierry.reding@gmail.com>
> Tested-by: Thierry Reding <thierry.reding@gmail.com>

I'm hoping this goes via arm-soc.  Let me know if you need me to do
something.  If you need it:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
> v2: add the change to the comment
>
>  drivers/pci/host/pci-tegra.c |   31 ++++++++++---------------------
>  1 file changed, 10 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
> index 7356741..2e9888a 100644
> --- a/drivers/pci/host/pci-tegra.c
> +++ b/drivers/pci/host/pci-tegra.c
> @@ -1031,32 +1031,21 @@ static int tegra_pcie_get_resources(struct tegra_pcie *pcie)
>                 return err;
>         }
>
> -       /* request and remap controller registers */
>         pads = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pads");
> -       if (!pads) {
> -               err = -EADDRNOTAVAIL;
> +       pcie->pads = devm_ioremap_resource(&pdev->dev, pads);
> +       if (IS_ERR(pcie->pads)) {
> +               err = PTR_ERR(pcie->pads);
>                 goto poweroff;
>         }
>
>         afi = platform_get_resource_byname(pdev, IORESOURCE_MEM, "afi");
> -       if (!afi) {
> -               err = -EADDRNOTAVAIL;
> -               goto poweroff;
> -       }
> -
> -       pcie->pads = devm_request_and_ioremap(&pdev->dev, pads);
> -       if (!pcie->pads) {
> -               err = -EADDRNOTAVAIL;
> -               goto poweroff;
> -       }
> -
> -       pcie->afi = devm_request_and_ioremap(&pdev->dev, afi);
> -       if (!pcie->afi) {
> -               err = -EADDRNOTAVAIL;
> +       pcie->afi = devm_ioremap_resource(&pdev->dev, afi);
> +       if (IS_ERR(pcie->afi)) {
> +               err = PTR_ERR(pcie->afi);
>                 goto poweroff;
>         }
>
> -       /* request and remap configuration space */
> +       /* request configuration space, but remap later, on demand */
>         res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cs");
>         if (!res) {
>                 err = -EADDRNOTAVAIL;
> @@ -1492,9 +1481,9 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
>                 rp->lanes = value;
>                 rp->pcie = pcie;
>
> -               rp->base = devm_request_and_ioremap(pcie->dev, &rp->regs);
> -               if (!rp->base)
> -                       return -EADDRNOTAVAIL;
> +               rp->base = devm_ioremap_resource(pcie->dev, &rp->regs);
> +               if (IS_ERR(rp->base))
> +                       return PTR_ERR(rp->base);
>
>                 list_add_tail(&rp->list, &pcie->ports);
>         }
