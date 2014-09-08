Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaIHMCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:02:05 -0400
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:55374
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753047AbaIHMCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:02:03 -0400
X-Greylist: delayed 2008 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 08:02:03 EDT
Date: Mon, 8 Sep 2014 19:28:11 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Raymond van der Rots <raymond@electrocompaniet.no>
CC: <r65037@freescale.com>, <linux-kernel@vger.kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>, <bhelgaas@google.com>
Subject: Re: [PATCH] imx6 PCI Host initialisation order
Message-ID: <20140908112810.GA2799@dragon>
References: <BD2B99C7-743D-429F-801E-FCFAFAE4A7DB@electrocompaniet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BD2B99C7-743D-429F-801E-FCFAFAE4A7DB@electrocompaniet.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019017)(6009001)(24454002)(199003)(189002)(51704005)(21056001)(64706001)(46406003)(44976005)(6806004)(31966008)(92566001)(47776003)(80022001)(20776003)(54356999)(81542001)(95666004)(97756001)(19580395003)(19580405001)(83322001)(68736004)(69596002)(81342001)(4396001)(105606002)(99396002)(50466002)(76176999)(50986999)(74662001)(104016003)(85852003)(33716001)(74502001)(87936001)(83072002)(92726001)(86362001)(15202345003)(23726002)(84676001)(15975445006)(107046002)(77982001)(83506001)(97736003)(26826002)(102836001)(33656002)(79102001)(90102001)(85306004)(81156004)(57986006)(106466001)(76482001)(46102001)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB0853;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03283976A6
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Raymond,

It seems that there is already a similar patch [1] from Tim floating
on the list.

Shawn

[1] http://www.spinics.net/lists/linux-pci/msg33520.html

On Mon, Sep 08, 2014 at 11:10:37AM +0200, Raymond van der Rots wrote:
> Hi,
> 
> The imx6dl on our hardware board frequently had problems bringing up the PCI link, with or without peripherals connected. I found these issues to be due to the initialisation order of the PCI Host.
> 
> The host driver first enables the phy, and then enables its clocks. However, according to the reference manual (IMX6SDLRM, page 2033):
> > The phy_ref_ssp_en signal must remain deasserted until the reference clock is running at the appropriate frequency, at which point phy_ref_ssp_en can be asserted.
> 
> 
> Which implies that the clocks should be brought up first, after which the peripheral should be enabled.
> This patch changes that initialisation order.
> 
> I do not have other hardware with an imx6dl, so this patch has only been tested on our board. Could someone confirm that this is more technically correct or improves behaviour?
> 
> Signed-off-by: Raymond van der Rots <raymond@electrocompaniet.no>
> ---
> diff --git a/drivers/pci/host/pci-imx6.c b/drivers/pci/host/pci-imx6.c
> index a568efa..17c35b4 100644
> --- a/drivers/pci/host/pci-imx6.c
> +++ b/drivers/pci/host/pci-imx6.c
> @@ -228,11 +228,6 @@ static int imx6_pcie_deassert_core_reset(struct pcie_port *pp)
>  	struct imx6_pcie *imx6_pcie = to_imx6_pcie(pp);
>  	int ret;
>  
> -	regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
> -			IMX6Q_GPR1_PCIE_TEST_PD, 0 << 18);
> -	regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
> -			IMX6Q_GPR1_PCIE_REF_CLK_EN, 1 << 16);
> -
>  	ret = clk_prepare_enable(imx6_pcie->pcie_phy);
>  	if (ret) {
>  		dev_err(pp->dev, "unable to enable pcie_phy clock\n");
> @@ -254,6 +249,11 @@ static int imx6_pcie_deassert_core_reset(struct pcie_port *pp)
>  	/* allow the clocks to stabilize */
>  	usleep_range(200, 500);
>  
> +	regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
> +			IMX6Q_GPR1_PCIE_TEST_PD, 0 << 18);
> +	regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
> +			IMX6Q_GPR1_PCIE_REF_CLK_EN, 1 << 16);
> +
>  	/* Some boards don't have PCIe reset GPIO. */
>  	if (gpio_is_valid(imx6_pcie->reset_gpio)) {
>  		gpio_set_value(imx6_pcie->reset_gpio, 0);
> 
> 
