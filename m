Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332AbaKNOKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:10:22 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61487 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965141AbaKNOKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:10:17 -0500
Message-ID: <54660D44.9020406@linaro.org>
Date: Fri, 14 Nov 2014 15:10:12 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: catalin.marinas@arm.com, will.deacon@arm.com, bhelgaas@google.com,
        Liviu.Dudau@arm.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rjw@rjwysocki.net, linaro-acpi@lists.linaro.org,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] arm64, acpi, pci: Provide arch-specific calls
 for PCI host bridge dirver (PNP0A03).
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org> <1415366876-30811-5-git-send-email-tomasz.nowicki@linaro.org> <4474363.kMvYSLl2Ev@wuerfel>
In-Reply-To: <4474363.kMvYSLl2Ev@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.2014 15:24, Arnd Bergmann wrote:
> On Friday 07 November 2014 14:27:56 Tomasz Nowicki wrote:
>>
>>   #ifdef CONFIG_PCI
>> +struct pci_controller {
>> +	struct acpi_device *companion;
>> +	int segment;
>> +	int node;		/* nearest node with memory or NUMA_NO_NODE for global allocation */
>> +};
>> +
>> +#define PCI_CONTROLLER(busdev) ((struct pci_controller *) busdev->sysdata)
>> +
>
> Don't use busdev->sysdata in architecture specific code, it belongs to the
> host bridge driver with the new model. For ACPI you don't have a host bridge
> driver, but it's better to keep these separate.
>
> The segment is always the same as the domain number, so just use that.
> The node and companion members here can get added to struct pci_host_bridge.

The reason why I put segment field to struct pci_controller is to 
initialize domain_nr of struct pci_bus being in pci_create_root_bus(), 
domain_nr can be used later on though. Correct me I am wrong.

Honestly I do not see the way to create root bus without e.g. 
sysdata.segment here.

>
>> @@ -43,7 +53,8 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
>>    */
>>   int pcibios_add_device(struct pci_dev *dev)
>>   {
>> -	dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
>> +	if (acpi_disabled)
>> +		dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
>>
>>   	return 0;
>>   }
>
> How do you assign the irq number with ACPI? Do you only support MSI?

I missed that, will add in next ver.

>
>>   /*
>>    * raw_pci_read/write - Platform-specific PCI config space access.
>> - *
>> - * Default empty implementation.  Replace with an architecture-specific setup
>> - * routine, if necessary.
>>    */
>>   int raw_pci_read(unsigned int domain, unsigned int bus,
>>   		  unsigned int devfn, int reg, int len, u32 *val)
>>   {
>> -	return -EINVAL;
>> +	char __iomem *addr;
>> +
>> +	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095))) {
>> +err:		*val = -1;
>> +		return -EINVAL;
>> +	}
>> +
>> +	rcu_read_lock();
>> +	addr = pci_dev_base(domain, bus, devfn);
>> +	if (!addr) {
>> +		rcu_read_unlock();
>> +		goto err;
>> +	}
>
> The config space accessors should probably be shared with
> drivers/pci/host/pci-host-generic.c, e.g. by moving the rest of
> the new code in there as well, or by moving the config space
> accessors from that file to drivers/pci/mmconfig.c.

Tomasz
