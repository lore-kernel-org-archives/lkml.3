Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab3LDOPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:15:45 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52112 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab3LDOPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:15:35 -0500
Message-ID: <529F38FA.7070505@linaro.org>
Date: Wed, 04 Dec 2013 22:15:22 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI
 on ARM64
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <1386088611-2801-2-git-send-email-hanjun.guo@linaro.org> <20131203164748.0c19d346@alan.etchedpixels.co.uk>
In-Reply-To: <20131203164748.0c19d346@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月04日 00:47, One Thousand Gnomes wrote:
>> diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
>> index a6c77e8b..89a181f 100644
>> --- a/drivers/acpi/reboot.c
>> +++ b/drivers/acpi/reboot.c
>> @@ -3,12 +3,43 @@
>>   #include <linux/acpi.h>
>>   #include <acpi/reboot.h>
>>   
>> +/*
>> + * There are some rare cases in the ARM world with PCI is not one
>> + * of the buses available to us, even though we use ACPI.
> Can we have a comment that is easier to understand here and perhaps a
> better function name ?

ok, how about "Not all the ARM/ARM64 platforms with CONFIG_PCI enabled, introduce
stub function here in case of !CONFIG_PCI when using ACPI" ?

I will discuss with Graeme for a better function name


>
>> + */
>> +#ifdef CONFIG_PCI
>> +static void acpi_reset_with_writing_pci_config(u64 address, u8 reset_value)
>> +{
>> +	struct pci_bus *bus0;
>> +	unsigned int devfn;
>> +
>> +	/* The reset register can only live on bus 0. */
>> +	bus0 = pci_find_bus(0, 0);
>> +	if (!bus0)
>> +		return;
> So if you can't find the PCI eg because we have no PCI on the device you
> return silently, but
>
>
>> +static void acpi_reset_with_writing_pci_config(u64 address, u8 reset_value)
>> +{
>> +	pr_warn("Resetting with ACPI PCI RESET_REG failed, PCI is disabled\n");
>> +	return;
>> +}
> the same system without CONFIG_PCI makes a noise.
>
> What happens when you want to build a single kernel which works on both
> PCI and non PCI systems. Surely the behaviour should be the same.

Good point, thanks for the guidance, will update in next version.


>
> The other question I'd ask is given the nature of some of these bits
> would it be better to have an acpi/pci.c which holds the PCI bits ?

Sorry, I'm confused here, which PCI bits?


>
>> +		acpi_reset_with_writing_pci_config(rr->address, reset_value);
>>   		break;
>>   
>>   	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
>> diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
>> index 167f3d0..5804e77 100644
>> --- a/drivers/pnp/pnpacpi/rsparser.c
>> +++ b/drivers/pnp/pnpacpi/rsparser.c
>> @@ -113,8 +113,10 @@ static int dma_flags(struct pnp_dev *dev, int type, int bus_master,
>>   
>>   static void pnpacpi_add_irqresource(struct pnp_dev *dev, struct resource *r)
>>   {
>> +#ifdef CONFIG_PCI
>>   	if (!(r->flags & IORESOURCE_DISABLED))
>>   		pcibios_penalize_isa_irq(r->start, 1);
> Probably better avoid PCI ifdefs all over the place. Any reason the
> includes for the PCI layer can't provide this as a dummy on a non-PCI
> system ?

Agreed, I will introduce arch\arm64\include\asm\pci.h to cover pcibios_penalize_isa_irq()
as ARM did, then #ifdef here can be removed.

Thanks
Hanjun

