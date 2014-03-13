Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaCMQJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:09:21 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:65280 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaCMQJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVOqBuCcQC6ku0abqstkgJWGe21ZztB-eTsyDwsvDvXNZw@mail.gmail.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com> <CACVXFVOqBuCcQC6ku0abqstkgJWGe21ZztB-eTsyDwsvDvXNZw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 13 Mar 2014 10:08:58 -0600
Message-ID: <CAErSpo4ngU60XQCD=DbFJbqNOMkOwwhHB1oau1mmr7rJQQ2+pg@mail.gmail.com>
Subject: Re: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding disabled
To: Ming Lei <tom.leiming@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 2:51 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi Bjorn,
>
> I found this patch broke virtio-pci devices.

Thanks a lot for testing this.

> On Thu, Feb 27, 2014 at 3:37 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Don't rely on BAR contents when the command register says the BAR is
>> disabled.
>>
>> If we receive a PCI device from firmware (or a hot-added device that was
>> just powered up) with the MEMORY or IO enable bits in the PCI command
>> register cleared, there's no reason to believe the BARs contain valid
>> addresses.
>
> From PCI LOCAL BUS SPECIFICATION, REV. 3.0, both
> PCI_COMMAND_IO and PCI_COMMAND_MEM should be
> cleared after reset, so looks the patch sets IORESOURCE_UNSET
> too early because PCI drivers may call pci_enable_device()
> (->pci_enable_resources()) to enable the two bits of
> PCI_COMMAND explicitly.

The point is that it's not safe to enable those two bits unless we're
certain that the BARs they control contain valid values that don't
conflict with anything else in the system.

Maybe we should only set IORESOURCE_UNSET when we find a conflict or a
BAR that's not contained by an upstream bridge window, and we should
try to reallocate then.  I'm pretty sure we do that at least in some
cases, but it would probably simplify things if we did it more
consistently, and maybe we shouldn't set it at all here in
__pci_read_base().

But I'd like to understand your situation better, so can you provide
more details, please?  Complete before/after dmesg logs would go a
long way toward illustrating the problem you're seeing.

> With this patch, driver can't enable device/resource with
> pci_enable_device() any more because IORESOURCE_UNSET
> has been set already.

>> In that case, we still know the type and size of the BAR, but this
>> patch marks the resource as "unset" so we have a chance to reassign it.
>>
>> Historically, we often used "BAR == 0" to decide the BAR is invalid.  But 0
>> is a legal BAR value, especially if the host bridge translates addresses,
>> so I think it's better to decide based on the PCI command register, and
>> store the conclusion in the IORESOURCE_UNSET bit.
>>
>> Reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=679545
>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=48451
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> ---
>>  drivers/pci/probe.c |    8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 6e34498ec9f0..02654b5ec1b9 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -177,9 +177,10 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>>
>>         mask = type ? PCI_ROM_ADDRESS_MASK : ~0;
>>
>> +       pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
>> +
>>         /* No printks while decoding is disabled! */
>>         if (!dev->mmio_always_on) {
>> -               pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
>>                 if (orig_cmd & PCI_COMMAND_DECODE_ENABLE) {
>>                         pci_write_config_word(dev, PCI_COMMAND,
>>                                 orig_cmd & ~PCI_COMMAND_DECODE_ENABLE);
>> @@ -215,9 +216,13 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>>                 if (res->flags & IORESOURCE_IO) {
>>                         l &= PCI_BASE_ADDRESS_IO_MASK;
>>                         mask = PCI_BASE_ADDRESS_IO_MASK & (u32) IO_SPACE_LIMIT;
>> +                       if (!(orig_cmd & PCI_COMMAND_IO))
>> +                               res->flags |= IORESOURCE_UNSET;
>>                 } else {
>>                         l &= PCI_BASE_ADDRESS_MEM_MASK;
>>                         mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
>> +                       if (!(orig_cmd & PCI_COMMAND_MEMORY))
>> +                               res->flags |= IORESOURCE_UNSET;
>>                 }
>>         } else {
>>                 res->flags |= (l & IORESOURCE_ROM_ENABLE);
>> @@ -252,6 +257,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>>                         /* Address above 32-bit boundary; disable the BAR */
>>                         pci_write_config_dword(dev, pos, 0);
>>                         pci_write_config_dword(dev, pos + 4, 0);
>> +                       res->flags |= IORESOURCE_UNSET;
>>                         region.start = 0;
>>                         region.end = sz64;
>>                         bar_disabled = true;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> Thanks,
> --
> Ming Lei
