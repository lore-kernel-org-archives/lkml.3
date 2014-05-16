Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaEPWpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:45:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57621 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaEPWpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:45:19 -0400
Message-ID: <537694DC.3060507@ti.com>
Date: Fri, 16 May 2014 18:44:44 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        <xobs@kosagi.com>, "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware
 core driver
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <1400169692-9677-6-git-send-email-m-karicheri2@ti.com> <4195791.GS9XG8RaXW@wuerfel>
In-Reply-To: <4195791.GS9XG8RaXW@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/2014 12:28 PM, Arnd Bergmann wrote:
> On Thursday 15 May 2014 12:01:32 Murali Karicheri wrote:
>> +Sample bindings shown below:-
>> +
>> + - Remove ti,enable-linktrain if boot loader already does Link training and do EP
>> +   configuration.
>> + - Remove ti,init-phy if boot loader already initialize the phy and sets up pcie
>> +   link
> You actually have to document all the properties. Have a look at the
> other bindings for what this means.

Actually this is dw pcie variant. So I will document if there are any 
deviations from the dw-designware
bindings. Based on comments from Jingo, I think I need to add a new DT 
property for old hw that we
use in keystone. May be a compatibility string for older dw h/w like 
"snps ,dw-pcie-v3.65" is that we
could use and do things differently in the common code.

So I will update the Documentation of dw bindings  once we agree on this.
>> +
>> +               pcie@21800000 {
>> +                       compatible = "ti,keystone-pcie";
>> +                       device_type = "pci";
>> +                       clocks = <&clkpcie>;
>> +                       clock-names = "pcie";
> The dw-pcie binding lists two clocks.
Ok. As per dw documentation, pcie and pcie_bus are the clocks. But 
pci-imx6 is currently not using pcie_bus. So the pcie_bus
clock is actually optional. In the case of keystone pcie, bus clock is 
provided by the phy hardware and if I need to provide
a clock for bus, it has to be a dummy or change documentation to make 
pcie_bus an optional clock. I prefer later, but want
to know if this is true for pci-imx6. There is also a plan to move the 
pcie clock API call to designware core. So making pcie_bus
clock optional looks correct to me.

Seen/Jingoo,  any comments?

>> +                       #address-cells = >;
>> +                       #size-cells = <2>;
>> +                       reg =  <0x21800000 0x1000>, <0x0262014c 4>;
>> +                       reg-names = "reg_rc_app", "reg_devcfg";
> There should be standard names that are documented in the binding.

Currently  Documentation says

- reg: base addresses and lengths of the pcie controller,
     the phy controller, additional register for the phy controller.

And following dw drivers defines as

samsung,exynos5440-pcie

         reg = <0x290000 0x1000
             0x270000 0x1000
             0x271000 0x40>;

fsl,imx6q-pcie"
         reg = <0x01ffc000 0x4000>; /* DBI */

There are no names used for registers. So this needs to be documented in 
the dw-designware
bindings. reg_dbi is what is common to pci controller assuming at index 
0 of the both above drivers use
reg_dbi address for config space. Shall I modify the documentation to 
include optional reg name
reg_dbi  for config space base address registers? Additional registers 
are optional and varies from
platform to platform. Phy registers are actually part of Phy driver and 
should be removed from
the dw-documentation bindings. Agree?

>
>> +                       interrupts = <GIC_SPI 30 IRQ_TYPE_EDGE_RISING>,
>> +                                       <GIC_SPI 31 IRQ_TYPE_EDGE_RISING>,
>> +                                       <GIC_SPI 32 IRQ_TYPE_EDGE_RISING>,
>> +                                       <GIC_SPI 33 IRQ_TYPE_EDGE_RISING>,
>> +                                       <GIC_SPI 34 IRQ_TYPE_EDGE_RISING>,
>> +                                       <GIC_SPI 35 IRQ_TYPE_EDGE_RISING>,
>> +                                       <GIC_SPI 36 IRQ_TYPE_EDGE_RISING>,
>> +                                       <GIC_SPI 37 IRQ_TYPE_EDGE_RISING>,
>> +                                       <GIC_SPI 38 IRQ_TYPE_EDGE_RISING>; /* Error IRQ */
> What are all these interrupts?
These are MSI interrupts tied to the GIC over which MSI interrupts are 
multiplexed.  I will document
it in the keystone PCI DT bindings.
>> +                       ranges = <0x00000800 0 0x21801000 0x21801000 0 0x0002000    /* Configuration space */
>> +                                 0x81000000 0 0          0x24000000 0 0x4000       /* downstream I/O */
>> +                                 0x82000000 0 0x50000000 0x50000000 0 0x10000000>; /* non-prefetchable memory */
> Please move the config space into 'reg' now instead of 'ranges'.
> This was a mistake earlier, and there are already other front-ends
> doing the same thing.
  This has to be coordinated with other drivers when DW core makes the 
change.

Jingoo, Sean,

What is the plan for this change? I  have to defer this currently.

>
>> +                       num-lanes = <2>;
>> +                       ti,enable-linktrain;
>> +                       ti,init-phy;
>> +
>> +                       /* PCIE phy */
>> +                       phys = <&pcie0_phy>;
>> +                       phy-names = "pcie-phy";
>> +
>> +                       #interrupt-cells = <1>;
>> +                       interrupt-map-mask = <0 0 0 0>;
>> +                       interrupt-map = <0 0 0 1 &pcie_intc 1>, // INT A
>> +                                       <0 0 0 2 &pcie_intc 2>, // INT B
>> +                                       <0 0 0 3 &pcie_intc 3>, // INT C
>> +                                       <0 0 0 4 &pcie_intc 4>; // INT D
> I think this is the wrong map-mask.
I think this should be changed to

interrupt-map-mask = <0 0 0 0x7> ?

>
> 	Arnd

