Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaDGQjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:39:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58587 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbaDGQjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:39:09 -0400
Message-ID: <5342D47F.4010506@ti.com>
Date: Mon, 7 Apr 2014 12:38:23 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Richard Zhu <r65037@freescale.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RESEND: RFC PATCH 3/3] pcie: keystone: add pcie driver based
 on designware core driver
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com> <1395707726-20437-4-git-send-email-m-karicheri2@ti.com> <235376049.yyfljDtinu@wuerfel> <20140325165421.GB30641@obsidianresearch.com>
In-Reply-To: <20140325165421.GB30641@obsidianresearch.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2014 12:54 PM, Jason Gunthorpe wrote:
> On Tue, Mar 25, 2014 at 08:44:36AM +0100, Arnd Bergmann wrote:
>
>> I have no idea how this would work with the standard interrupt-map property,
>> since the legacy interrupt host is now the same device as the pci host.
>>
>> Maybe it's better to move the legacy irqchip handling entirely out of
>> the driver and use a separate device node for the registers so it can
>> come with its own #interrupt-cells, and then refer to this irqchip from
>> the interrupt-map.
> The other DW PCI-E drivers are being fixed to use interrupt-map, so I
> think this driver should be fixed before it goes in as well.
Jason,

Could you send me a patch reference or branch that I can review to 
better understand
changes required in my driver to use the bindings you have described below?

Murali
> Other PCI-E hosts have handled this particular problem with a
> construction like this:
>
>         pcie@21800000 {
>                 compatible = "ti,keystone2-pcie";
>                 device_type = "pci";
>                 #address-cells = <3>;
>                 #size-cells = <2>;
>                 #interrupt-cells = <1>;
> 	       reg = ..
>
>                 pcie_intc: interrupt-controller {
>                    interrupt-controller;
> 		  #address-cells = <0>;
>                    #interrupt-cells = <1>;
>                 }
>
>                 interrupts =  ... enough to decode INTx;
>
> 	       interrtup-map = <0 0 0 1 &pcie_intc 1>, // INT A
> 	                       <0 0 0 2 &pcie_intc 2>, // INT B
>                                 <0 0 0 3 &pcie_intc 3>, // INT C
>                                 <0 0 0 4 &pcie_intc 4>; // INT D
>         }
>
> When the legacy irq domain is created it should be bound to the
> pcie_intc node, not to pcie node.
>
> ks_pcie_map_irq should be removed.
The latest dw core driver still had map_irq() being provided by the driver.
So any patch reference will help me understand that you describe here.

Thanks

Murali
>
>>> +#ifdef CONFIG_PCIE_KEYSTONE
>>> +/*
>>> + * The KeyStone PCIe controller has maximum read request size of 256 bytes.
>>> + * Force this configuration for all EP including bridges.
>>> + */
>>> +static void quirk_limit_readrequest(struct pci_dev *dev)
>>> +{
>>> +	pcie_set_readrq(dev, 256);
>>> +}
>>> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
>>> +#endif /* CONFIG_TI_KEYSTONE_PCIE */
>> You can't do this:
>>
>> A quirk for a specific hardware must not be enabled by compile-time options.
>> You have to find a different way to do this.
> This configuration should happen automatically by the PCI core if the
> config spaces are correct. See pcie_write_mrrs, pcie_write_mps,
> pcie_bus_configure_settings, etc.
>
> Your host will need to conform to the PCI spec and provide a root
> port bridge header for this to work.
>
> Also, even in the keystone case the MRRS should not be globally forced
> like this, there may be other bridges in the system with a 128 byte
> MPS.
>
> Jason

