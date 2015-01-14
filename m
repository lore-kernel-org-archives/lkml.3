Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbbANTRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:17:21 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:51162 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbANTRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:17:20 -0500
MIME-Version: 1.0
In-Reply-To: <20150114165204.GA19925@google.com>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
	<1421090600-9750-3-git-send-email-yinghai@kernel.org>
	<20150114165204.GA19925@google.com>
Date: Wed, 14 Jan 2015 11:17:19 -0800
X-Google-Sender-Auth: WXX7KVIFgOUHSYgZJGa__IgG_eM
Message-ID: <CAE9FiQU3gVq2BcK-djpjnOn7EtiPLX1Zo_OnNDTqJJmjNY27fw@mail.gmail.com>
Subject: Re: [PATCH 02/10] PCI, x86: clip firmware assigned resource under
 parent bridge's
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 8:52 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jan 12, 2015 at 11:23:12AM -0800, Yinghai Lu wrote:

> There's a lot of duplicated code in these patches.  Is it possible to
> factor this out a bit, e.g., something like this?
>
>   int pci_claim_bridge_resource(struct pci_dev *dev, int i)
>   {
>     if ((dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
>       return 0;
>
>     if (pci_claim_resource(dev, i) == 0)
>       return 0;         /* claimed the window */
>
>     if (!pci_bus_clip_resource(dev, i))
>       return -EINVAL;   /* clipping didn't change anything */
>
>     if (dev->subordinate)
>       pci_setup_bridge(dev->subordinate);
>     if (pci_claim_resource(dev, i) == 0)
>       return 0;         /* claimed a smaller window */
>
>     return -EINVAL;
>   }

ok. will have one in setup_bus.c

>
>>  }
>>
>>  static void pcibios_allocate_bus_resources(struct pci_bus *bus)
>> @@ -234,8 +251,12 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
>>       struct pci_bus *child;
>>
>>       /* Depth-First Search on bus tree */
>> -     if (bus->self)
>> -             pcibios_allocate_bridge_resources(bus->self);
>> +     if (bus->self) {
>> +             bool changed = pcibios_allocate_bridge_resources(bus->self);
>> +
>> +             if (changed)
>> +                     pci_setup_bridge(bus);
>> +     }
>>       list_for_each_entry(child, &bus->children, node)
>>               pcibios_allocate_bus_resources(child);
>>  }
>> @@ -274,18 +295,27 @@ static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
>>                               dev_dbg(&dev->dev,
>>                                       "BAR %d: reserving %pr (d=%d, p=%d)\n",
>>                                       idx, r, disabled, pass);
>> -                             if (pci_claim_resource(dev, idx) < 0) {
>> -                                     if (r->flags & IORESOURCE_PCI_FIXED) {
>> -                                             dev_info(&dev->dev, "BAR %d %pR is immovable\n",
>> +
>> +                             if (pci_claim_resource(dev, idx) >= 0)
>> +                                     continue;
>> +
>> +                             if (r->flags & IORESOURCE_PCI_FIXED) {
>> +                                     dev_info(&dev->dev, "BAR %d %pR is immovable\n",
>>                                                        idx, r);
>> -                                     } else {
>> -                                             /* We'll assign a new address later */
>> -                                             pcibios_save_fw_addr(dev,
>> -                                                             idx, r->start);
>> -                                             r->end -= r->start;
>> -                                             r->start = 0;
>> -                                     }
>> +                                     continue;
>> +                             }
>> +
>> +                             /* try again with clip */
>> +                             if (pci_bus_clip_resource(dev, r)) {
>> +                                     pci_update_resource(dev, idx);
>> +                                     if (pci_claim_resource(dev, idx) >= 0)
>> +                                             continue;
>
> This hunk doesn't make sense to me.  This only deals with standard BARs and
> IOV BARS.  It doesn't deal with bridge windows at all.  The sizes of these
> BARs and IOV BARs are fixed and there's no point in trying to clip them
> because we can't tell the hardware that the BAR is now smaller.
>
> It's different for bridge windows because we can adjust their size.

ok, will drop that.
