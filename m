Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551Ab3DPWf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 18:35:27 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:39229 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965426Ab3DPWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 18:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1304161324500.30779@chino.kir.corp.google.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
 <1365781470-32379-10-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.02.1304161324500.30779@chino.kir.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 16 Apr 2013 16:35:04 -0600
Message-ID: <CAErSpo7A3paLJ8u5FxPZpy=9yT_ZkXvEbcHbKLd7iMutdDaBUA@mail.gmail.com>
Subject: Re: [PATCH v9 09/16] PCI, x86: implement pcibios_{add|remove}_bus() hooks
To: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 2:27 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 12 Apr 2013, Jiang Liu wrote:
>
>> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
>> index 901177d..305c68b 100644
>> --- a/arch/x86/pci/common.c
>> +++ b/arch/x86/pci/common.c
>> @@ -6,6 +6,7 @@
>>
>>  #include <linux/sched.h>
>>  #include <linux/pci.h>
>> +#include <linux/pci-acpi.h>
>>  #include <linux/ioport.h>
>>  #include <linux/init.h>
>>  #include <linux/dmi.h>
>> @@ -170,6 +171,16 @@ void pcibios_fixup_bus(struct pci_bus *b)
>>               pcibios_fixup_device_resources(dev);
>>  }
>>
>> +void pcibios_add_bus(struct pci_bus *bus)
>> +{
>> +     acpi_pci_add_bus(bus);
>> +}
>> +
>> +void pcibios_remove_bus(struct pci_bus *bus)
>> +{
>> +     acpi_pci_remove_bus(bus);
>> +}
>> +
>>  /*
>>   * Only use DMI information to set this if nothing was passed
>>   * on the kernel command line (which was parsed earlier).
>
> This causes build errors when CONFIG_ACPI isn't enabled since both
> acpi_pci_{add,remove}_bus() aren't defined in such a configuration:
>
> arch/x86/pci/common.c: In function 'pcibios_add_bus':
> arch/x86/pci/common.c:176:2: error: implicit declaration of function 'acpi_pci_add_bus'
> arch/x86/pci/common.c: In function 'pcibios_remove_bus':
> arch/x86/pci/common.c:181:2: error: implicit declaration of function 'acpi_pci_remove_bus'

Thanks for the report!

I'm pretty sure I fixed this:
http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/jiang-subdrivers&id=3b63aaa70e1ccc4b66d60acc78da09700706a703

The acpi_pci_add_bus()/acpi_pci_remove_bus() stubs for CONFIG_ACPI=n
were added early in the series (patch 07/16: "PCI/ACPI: Prepare stub
functions to handle ACPI PCI (hotplug) slots") but were mistakenly
removed in patch 12/16: "PCI: acpiphp: Do not use ACPI PCI subdriver
mechanism".

I updated my "next" branch with the fixed version of patch 12/16, so
the 20130417 linux-next tree should have the fix.

Bjorn
