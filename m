Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaIIUnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:43:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52976 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaIIUnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:43:04 -0400
Message-ID: <540F6646.3010607@ti.com>
Date: Tue, 9 Sep 2014 16:42:46 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bhelgaas@google.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] PCI: keystone: update to support multiple pci
 ports
References: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com> <1410293835-13050-2-git-send-email-m-karicheri2@ti.com> <3294679.puV171E8qx@wuerfel>
In-Reply-To: <3294679.puV171E8qx@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 04:28 PM, Arnd Bergmann wrote:
> On Tuesday 09 September 2014 16:17:15 Murali Karicheri wrote:
>> K2E SoC has two PCI ports. The SATA controller is connected to second
>> PCI port (port 1). This patch enhances the driver to support multiple
>> ports.
>>
>> Update the DT Documentation for the new attribute, ti,pcie-port and
>> remove the note for bootargs as this is no longer needed.
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>> ---
>>   - updated based on comment against v1
>>   .../devicetree/bindings/pci/pci-keystone.txt       |    8 +++++---
>>   drivers/pci/host/pci-keystone.c                    |   15 ++++++++++-----
>>   drivers/pci/host/pci-keystone.h                    |    4 ++--
>>   3 files changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/pci/pci-keystone.txt b/Documentation/devicetree/bindings/pci/pci-keystone.txt
>> index bedacf0..c8f5773 100644
>> --- a/Documentation/devicetree/bindings/pci/pci-keystone.txt
>> +++ b/Documentation/devicetree/bindings/pci/pci-keystone.txt
>> @@ -56,11 +56,13 @@ Optional properties:-
>>   	phy-names: name of the Generic Keystine SerDes phy for PCI
>>   	  - If boot loader already does PCI link establishment, then phys and
>>   	    phy-names shouldn't be present.
>> +	ti,pcie-port: PCI port number. This is used to configure the PCI port
>> +	    number. For example K2E SoC supports 2 PCI ports and PCI bindings
>> +	    for the second port adds ti,pcie-port =<1>  to identify second port
>> +	    and driver uses this to configure the PCI mode register for second
>> +	    port. If not present, port number 0 is assumed.
>
> Is this still needed? I thought with patch 1 removed, we no longer had
> a reason to know the port number.
>
You are right. I will remove it and re-send.

>> -=========================
>> -Driver requires pci=pcie_bus_perf in the bootargs for proper functioning.
>> diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
>> index f1119eb..893820d 100644
>> --- a/drivers/pci/host/pci-keystone.c
>> +++ b/drivers/pci/host/pci-keystone.c
>> @@ -253,8 +253,8 @@ static int keystone_pcie_fault(unsigned long addr, unsigned int fsr,
>>
>>   static void __init ks_pcie_host_init(struct pcie_port *pp)
>>   {
>> -	u32 vendor_device_id, val;
>>   	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
>> +	u32 val;
>>
>>   	ks_pcie_establish_link(ks_pcie);
>>   	ks_dw_pcie_setup_rc_app_regs(ks_pcie);
>> @@ -263,8 +263,7 @@ static void __init ks_pcie_host_init(struct pcie_port *pp)
>>   			pp->dbi_base + PCI_IO_BASE);
>>
>>   	/* update the Vendor ID */
>> -	vendor_device_id = readl(ks_pcie->va_reg_pciid);
>> -	writew((vendor_device_id>>  16), pp->dbi_base + PCI_DEVICE_ID);
>> +	writew(ks_pcie->device_id, pp->dbi_base + PCI_DEVICE_ID);
>>
>>   	/* update the DEV_STAT_CTRL to publish right mrrs */
>>   	val = readl(pp->dbi_base + PCIE_CAP_BASE + PCI_EXP_DEVCTL);
>
> This change must have slipped in accidentally, at least it's not
> described in the changelog. Should this be another patch?
> The change seems useful.
Are you referring to mrrs or update to device id?  device id is in a SoC 
register at index2 and is read and updated by the driver here. MRRS 
update was originally in the code.

Murali
>
> 	Arnd

