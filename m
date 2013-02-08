Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947340Ab3BHXS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:18:57 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41781 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947302Ab3BHXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:18:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX6yLebtOVCRV7GDwxfJFPpVxBKJO_VJ_ndA-OjBD4LRg@mail.gmail.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
 <1360351703-20571-26-git-send-email-yinghai@kernel.org> <CAErSpo4iA17jh5rw05q=uaKOyMKesrPnxYrN2EvqWT_tGmE_FQ@mail.gmail.com>
 <CAE9FiQX6yLebtOVCRV7GDwxfJFPpVxBKJO_VJ_ndA-OjBD4LRg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 8 Feb 2013 16:18:35 -0700
Message-ID: <CAErSpo6GZvEUP2GWuQ3hUsSGBaE5Ontpp5=AizfP1yVD8bkD_g@mail.gmail.com>
Subject: Re: [PATCH v2 25/26] PCI: Disable mem in the ioapic removing path
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 3:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Feb 8, 2013 at 1:14 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Fri, Feb 8, 2013 at 12:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> For physical hot plug should be ok, but for remove/rescan path will
>>> need us to disable that.
>>>
>>> otherwise rescan mmio resource for pci ioapic device will not be
>>> sized and allocated, aka skiped.
>>
>> When we scan other PCI devices, we can size memory BARs even if
>> PCI_COMMAND_MEMORY is already set.  So there must be something
>> different about IOAPICs?  Or maybe it's something different about
>> rescan vs. the initial scan?
>
> it is in drivers/pci/setup-bus.c::__dev_sort_resources()
> it will skip the reallocation for ioapic controller.
>
> ...
>         /* Don't touch ioapic devices already enabled by firmware */
>         if (class == PCI_CLASS_SYSTEM_PIC) {
>                 u16 command;
>                 pci_read_config_word(dev, PCI_COMMAND, &command);
>                 if (command & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY))
>                         return;
>         }
>
>>
>>> For ioapic_probe:pci_enable_device will not enable the device
>>> correctly, and will bail out early.
>>
>> Exactly where and why do we bail out early?  The only early bail out I
>> see is where __pci_enable_device_flags() returns if "dev->enable_cnt >
>> 1".  Is that what you mean?
>
> pci_enable_device==>pci_enable_device_flags
> ==>do_pci_enable_device==>pcibios_enable_device==>pci_enable_resources
> ...
>                 if (!r->parent) {
>                         dev_err(&dev->dev, "device not available "
>                                 "(can't reserve %pR)\n", r);
>                         return -EINVAL;
>                 }
> ...
>
> only reassign one will have get it's parent.

Hmmm, OK.  So basically this patch is a hack to work around previous
hacks elsewhere.

We are like flies in a spider's web, bound tighter and tighter by
every loop of silk.
