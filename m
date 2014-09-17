Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaIQOL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:11:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54517 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbaIQOL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:11:56 -0400
Message-ID: <541996A9.306@ti.com>
Date: Wed, 17 Sep 2014 10:11:53 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH - v4] PCI: keystone: add a pci quirk to limit mrrs
References: <1410195814-30414-1-git-send-email-m-karicheri2@ti.com> <20140916215448.GB5050@google.com>
In-Reply-To: <20140916215448.GB5050@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 05:54 PM, Bjorn Helgaas wrote:
> On Mon, Sep 08, 2014 at 01:03:34PM -0400, Murali Karicheri wrote:
>> Keystone PCI controller has a limitation that memory read request
>> size must not exceed 256 bytes. This is a hardware limitation and
>> add a quirk to force this limit on all downstream devices by
>> updating mrrs.
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>
> Applied to pci/host-keystone for v3.18, thanks.
>
> I moved the pci-keystone.txt update regarding pci=pcie_bus_perf into this
> patch.  This is where it belongs, isn't it?  I'm pretty sure it wasn't
> related to setting the PCI device ID dynamically.
Yes. Thanks for taking care of the documentation part.

Thanks
Murali

>
>> ---
>>    -v4: re-send removing extra lines
>>    -v3: added check for vendor id and use pci_matc_id() to do matching
>>    -v2: made the quirk happens after tuning
>>    -v1: changed printk to indicate PCI bdf
>>
>>   drivers/pci/host/pci-keystone.c |   45 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 45 insertions(+)
>>
>> diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
>> index c1cfaef..ff8ed25 100644
>> --- a/drivers/pci/host/pci-keystone.c
>> +++ b/drivers/pci/host/pci-keystone.c
>> @@ -42,8 +42,53 @@
>>   /* DEV_STAT_CTRL */
>>   #define PCIE_CAP_BASE		0x70
>>
>> +/* PCIE controller device IDs */
>> +#define PCIE_RC_K2HK		0xb008
>> +#define PCIE_RC_K2E		0xb009
>> +#define PCIE_RC_K2L		0xb00a
>> +
>>   #define to_keystone_pcie(x)	container_of(x, struct keystone_pcie, pp)
>>
>> +static void quirk_limit_mrrs(struct pci_dev *dev)
>> +{
>> +	struct pci_bus *bus = dev->bus;
>> +	struct pci_dev *bridge = bus->self;
>> +	static const struct pci_device_id rc_pci_devids[] = {
>> +		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2HK),
>> +		 .class = PCI_CLASS_BRIDGE_PCI<<  8, .class_mask = ~0, },
>> +		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2E),
>> +		 .class = PCI_CLASS_BRIDGE_PCI<<  8, .class_mask = ~0, },
>> +		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2L),
>> +		 .class = PCI_CLASS_BRIDGE_PCI<<  8, .class_mask = ~0, },
>> +		{ 0, },
>> +	};
>> +
>> +	if (pci_is_root_bus(bus))
>> +		return;
>> +
>> +	/* look for the host bridge */
>> +	while (!pci_is_root_bus(bus)) {
>> +		bridge = bus->self;
>> +		bus = bus->parent;
>> +	}
>> +
>> +	if (bridge) {
>> +		/*
>> +		 * Keystone PCI controller has a h/w limitation of
>> +		 * 256 bytes maximum read request size. It can't handle
>> +		 * anything higher than this. So force this limit on
>> +		 * all downstream devices
>> +		 */
>> +		if (pci_match_id(rc_pci_devids, bridge)) {
>> +			if (pcie_get_readrq(dev)>  256) {
>> +				dev_info(&dev->dev, "limiting mrrs to 256\n");
>> +				pcie_set_readrq(dev, 256);
>> +			}
>> +		}
>> +	}
>> +}
>> +DECLARE_PCI_FIXUP_ENABLE(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_mrrs);
>> +
>>   static int ks_pcie_establish_link(struct keystone_pcie *ks_pcie)
>>   {
>>   	struct pcie_port *pp =&ks_pcie->pp;
>> --
>> 1.7.9.5
>>


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
