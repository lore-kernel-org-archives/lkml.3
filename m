Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaIHQvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:51:31 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:56677 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaIHQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:51:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140908112810.GA2799@dragon>
References: <BD2B99C7-743D-429F-801E-FCFAFAE4A7DB@electrocompaniet.no> <20140908112810.GA2799@dragon>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 8 Sep 2014 10:51:06 -0600
Message-ID: <CAErSpo4scddSydpoVqb73pBvJshOq=YJcV17ePGe0uyQ+xymhw@mail.gmail.com>
Subject: Re: [PATCH] imx6 PCI Host initialisation order
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Raymond van der Rots <raymond@electrocompaniet.no>,
        Zhu Richard-R65037 <r65037@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 5:28 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> Hi Raymond,
>
> It seems that there is already a similar patch [1] from Tim floating
> on the list.
>
> Shawn
>
> [1] http://www.spinics.net/lists/linux-pci/msg33520.html

Yes.  MAINTAINERS lists Richard Zhu <r65037@freescale.com> and Shawn
Guo <shawn.guo@freescale.com> (hi Shawn :)) as the caretakers for
pci-imx6.c.  Neither has acked it yet, and Richard asked for a comment
update, which I haven't seen yet.  So I haven't applied it yet.

> On Mon, Sep 08, 2014 at 11:10:37AM +0200, Raymond van der Rots wrote:
>> Hi,
>>
>> The imx6dl on our hardware board frequently had problems bringing up the PCI link, with or without peripherals connected. I found these issues to be due to the initialisation order of the PCI Host.
>>
>> The host driver first enables the phy, and then enables its clocks. However, according to the reference manual (IMX6SDLRM, page 2033):
>> > The phy_ref_ssp_en signal must remain deasserted until the reference clock is running at the appropriate frequency, at which point phy_ref_ssp_en can be asserted.
>>
>>
>> Which implies that the clocks should be brought up first, after which the peripheral should be enabled.
>> This patch changes that initialisation order.
>>
>> I do not have other hardware with an imx6dl, so this patch has only been tested on our board. Could someone confirm that this is more technically correct or improves behaviour?
>>
>> Signed-off-by: Raymond van der Rots <raymond@electrocompaniet.no>
>> ---
>> diff --git a/drivers/pci/host/pci-imx6.c b/drivers/pci/host/pci-imx6.c
>> index a568efa..17c35b4 100644
>> --- a/drivers/pci/host/pci-imx6.c
>> +++ b/drivers/pci/host/pci-imx6.c
>> @@ -228,11 +228,6 @@ static int imx6_pcie_deassert_core_reset(struct pcie_port *pp)
>>       struct imx6_pcie *imx6_pcie = to_imx6_pcie(pp);
>>       int ret;
>>
>> -     regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
>> -                     IMX6Q_GPR1_PCIE_TEST_PD, 0 << 18);
>> -     regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
>> -                     IMX6Q_GPR1_PCIE_REF_CLK_EN, 1 << 16);
>> -
>>       ret = clk_prepare_enable(imx6_pcie->pcie_phy);
>>       if (ret) {
>>               dev_err(pp->dev, "unable to enable pcie_phy clock\n");
>> @@ -254,6 +249,11 @@ static int imx6_pcie_deassert_core_reset(struct pcie_port *pp)
>>       /* allow the clocks to stabilize */
>>       usleep_range(200, 500);
>>
>> +     regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
>> +                     IMX6Q_GPR1_PCIE_TEST_PD, 0 << 18);
>> +     regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
>> +                     IMX6Q_GPR1_PCIE_REF_CLK_EN, 1 << 16);
>> +
>>       /* Some boards don't have PCIe reset GPIO. */
>>       if (gpio_is_valid(imx6_pcie->reset_gpio)) {
>>               gpio_set_value(imx6_pcie->reset_gpio, 0);
>>
>>
