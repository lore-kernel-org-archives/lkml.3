Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbaE2NRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:17:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45993 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaE2NR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:17:28 -0400
Message-ID: <5387332F.7050404@ti.com>
Date: Thu, 29 May 2014 18:46:31 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "arnd@arndb.de" <arnd@arndb.de>, "tony@atomide.com" <tony@atomide.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should
 be specified in 'reg'
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-4-git-send-email-kishon@ti.com> <2CC2A0A4A178534D93D5159BF3BCB6619B94AD3904@EAPEX1MAIL1.st.com>
In-Reply-To: <2CC2A0A4A178534D93D5159BF3BCB6619B94AD3904@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 29 May 2014 12:41 PM, Mohit KUMAR DCG wrote:
> Hello Kishon,
> 
>> -----Original Message-----
>> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
>> Sent: Thursday, May 29, 2014 12:08 PM
>> To: devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org; linux-omap@vger.kernel.org; linux-
>> pci@vger.kernel.org; linux-kernel@vger.kernel.org
>> Cc: arnd@arndb.de; tony@atomide.com; jg1.han@samsung.com;
>> kishon@ti.com; Jason Gunthorpe; Bjorn Helgaas; Mohit KUMAR DCG; Marek
>> Vasut
>> Subject: [PATCH v2 03/18] PCI: designware: Configuration space should be
>> specified in 'reg'
>>
>> The configuration address space has so far been specified in *ranges*,
>> however it should be specified in *reg* making it a platform MEM resource.
>> Hence used 'platform_get_resource_*' API to get configuration address
>> space in the designware driver.
>>
>> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Mohit Kumar <mohit.kumar@st.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> Cc: Marek Vasut <marex@denx.de>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
>>  drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
>>  2 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> index d6fae13..8314360 100644
>> --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> @@ -6,6 +6,7 @@ Required properties:
>>  	as "samsung,exynos5440-pcie" or "fsl,imx6q-pcie".
>>  - reg: base addresses and lengths of the pcie controller,
>>  	the phy controller, additional register for the phy controller.
>> +	The configuration address space should also be specified here.
>>  - interrupts: interrupt values for level interrupt,
>>  	pulse interrupt, special interrupt.
>>  - clocks: from common clock binding: handle to pci clock.
>> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-
>> designware.c
>> index c4e3732..603b386 100644
>> --- a/drivers/pci/host/pcie-designware.c
>> +++ b/drivers/pci/host/pcie-designware.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/of_pci.h>
>>  #include <linux/pci.h>
>>  #include <linux/pci_regs.h>
>> +#include <linux/platform_device.h>
>>  #include <linux/types.h>
>>
>>  #include "pcie-designware.h"
>> @@ -392,11 +393,23 @@ static const struct irq_domain_ops
>> msi_domain_ops = {  int __init dw_pcie_host_init(struct pcie_port *pp)  {
>>  	struct device_node *np = pp->dev->of_node;
>> +	struct platform_device *pdev = to_platform_device(pp->dev);
>>  	struct of_pci_range range;
>>  	struct of_pci_range_parser parser;
>> +	struct resource *cfg_res;
>>  	u32 val;
>>  	int i;
>>
>> +	cfg_res = platform_get_resource_byname(pdev,
>> IORESOURCE_MEM, "config");
>> +	if (cfg_res) {
>> +		pp->config.cfg0_size = resource_size(cfg_res)/2;
>> +		pp->config.cfg1_size = resource_size(cfg_res)/2;
>> +		pp->cfg0_base = cfg_res->start;
>> +		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
>> +	} else {
>> +		dev_err(pp->dev, "missing *config* reg space\n");
>> +	}
>> +
>>  	if (of_pci_range_parser_init(&parser, np)) {
>>  		dev_err(pp->dev, "missing ranges property\n");
>>  		return -EINVAL;
>> @@ -429,6 +442,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>>  			of_pci_range_to_resource(&range, np, &pp->cfg);
>>  			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
>>  			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
>> +			pp->cfg0_base = pp->cfg.start;
>> +			pp->cfg1_base = pp->cfg.start + pp-
>>> config.cfg0_size;
> 
> - As you are getting cfg address space as MEM resource, so remove above code that
>  gets the configuration space from dt range. Also correct dt for pcie cfg space for the platforms
>  based on this driver.

Ok. Will send that as a separate patch converting all platforms to use MEM
resource.

Thanks
Kishon
