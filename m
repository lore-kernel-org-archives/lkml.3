Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbbATCjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:39:44 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43481 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbATCjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:39:41 -0500
Message-ID: <54BDBFD4.7050207@linaro.org>
Date: Tue, 20 Jan 2015 10:39:16 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 06/17] ARM64 / ACPI: Make PCI optional for ACPI on
 ARM64
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-7-git-send-email-hanjun.guo@linaro.org> <20150116094913.GA13634@e104818-lin.cambridge.arm.com> <54BB51F1.8000900@linaro.org> <20150119104240.GE11835@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150119104240.GE11835@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月19日 18:42, Catalin Marinas wrote:
> On Sun, Jan 18, 2015 at 06:25:53AM +0000, Hanjun Guo wrote:
>> On 2015年01月16日 17:49, Catalin Marinas wrote:
>>> On Wed, Jan 14, 2015 at 03:04:54PM +0000, Hanjun Guo wrote:
>>>> --- a/arch/arm64/kernel/pci.c
>>>> +++ b/arch/arm64/kernel/pci.c
>>>> @@ -10,6 +10,7 @@
>>>>     *
>>>>     */
>>>>
>>>> +#include <linux/acpi.h>
>>>>    #include <linux/init.h>
>>>>    #include <linux/io.h>
>>>>    #include <linux/kernel.h>
>>>> @@ -68,3 +69,30 @@ void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
>>>>    	bus->domain_nr = domain;
>>>>    }
>>>>    #endif
>>>> +
>>>> +/*
>>>> + * raw_pci_read/write - Platform-specific PCI config space access.
>>>> + *
>>>> + * Default empty implementation.  Replace with an architecture-specific setup
>>>> + * routine, if necessary.
>>>> + */
>>>> +int raw_pci_read(unsigned int domain, unsigned int bus,
>>>> +		  unsigned int devfn, int reg, int len, u32 *val)
>>>> +{
>>>> +	return -EINVAL;
>>>> +}
>>>> +
>>>> +int raw_pci_write(unsigned int domain, unsigned int bus,
>>>> +		unsigned int devfn, int reg, int len, u32 val)
>>>> +{
>>>> +	return -EINVAL;
>>>> +}
>>>> +
>>>> +#ifdef CONFIG_ACPI
>>>> +/* Root bridge scanning */
>>>> +struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>>>> +{
>>>> +	/* TODO: Should be revisited when implementing PCI on ACPI */
>>>> +	return NULL;
>>>> +}
>>>> +#endif
> [...]
>>> When PCI is enabled and the above functions are compiled in, do they
>>> need to return any useful data or just -EINVAL. Are they ever called?
>>
>> They will be called if PCI root bridge is defined in DSDT, should I
>> print some warning message before it is implemented?
>
> My point: do they need to return real data when a PCI root bridge is
> defined in DSDT or you always expect them to always return some -E*? Can
> you explain why?

Not always return -E* or NULL;

For raw_pci_read/write(), they are needed to access the PCI config space
before the PCI root bus is created. so they will return 0 if access to
PCI config space is ok; pci_acpi_scan_root() will return root bus
pointer if it is successfully created.

Thanks
Hanjun
