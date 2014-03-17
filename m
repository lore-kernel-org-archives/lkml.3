Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaCQQgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:36:51 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:46801 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbaCQQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:36:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMxnaaUSs2KXL9=VKLpM=+vyb0RZ4iWPp4WawfFaw+kNbWfNSg@mail.gmail.com>
References: <CAMxnaaXd9-VbxSYa9q1YVT+fwfDFYKGG2Hq-1jkc-awLX-HwtQ@mail.gmail.com>
 <CAErSpo5fkaFNq_qTZ+gTDMV554f4diOXQ7_4bsHqj06iAGTpHg@mail.gmail.com>
 <CAE9FiQVNFqTw+92qy8zcwG1haiSZzU+KE3oh4YnjNc_aE6KUnA@mail.gmail.com>
 <20140308010456.GA30660@google.com> <CAMxnaaVfpJCW7e-b80y4wmVWcRDK5t7qY+pNn71CsLPRN2ojnA@mail.gmail.com>
 <CAErSpo4MQsAer7FM0kU5mMOGRok0oFMWX1FqFijmswutjyNoRg@mail.gmail.com>
 <CAMxnaaWr0z1zbpFQPX6UvYbnxhfA+3aj4ffhCBpp1i4ZLsGTPg@mail.gmail.com>
 <20140311001003.GA14367@google.com> <CAMxnaaUSs2KXL9=VKLpM=+vyb0RZ4iWPp4WawfFaw+kNbWfNSg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Mar 2014 10:36:27 -0600
Message-ID: <CAErSpo6APp4QufzfXUxx6vf4iQk60dmoW-t=OP503uH5P96LHg@mail.gmail.com>
Subject: Re: [Bug] PCI: Enable INTx if BIOS left them disabled - triggers
 during rescan
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 6:52 AM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> On Tue, Mar 11, 2014 at 1:10 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Mar 11, 2014 at 12:10:02AM +0100, Andreas Noever wrote:
>>> On Mon, Mar 10, 2014 at 9:43 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> > On Sat, Mar 8, 2014 at 2:55 AM, Andreas Noever <andreas.noever@gmail.com> wrote:
>>> >> On Sat, Mar 8, 2014 at 2:04 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> >
>>> >>> If we did that, INTX_DISABLE would be cleared by the first
>>> >>> pci_enable_device() and pci_reenable_device() wouldn't do anything,
>>> >>> leaving it cleared.  The resulting state (cleared) would be the same,
>>> >>> but the transitions would be gone, and maybe those are important.
>>> >> Just a quick note: With pci_intx_for_msi removed no hotplug events are
>>> >> ever delivered. Everything else still works though. So it is either a
>>> >> problem specific to Thunderbolt bridges or maybe it just affects
>>> >> hotplug (and PME?) interrupts.
>>> >
>>> > Interesting.  This is on a MacBook, isn't it?  If you have Mac OS on
>>> > it, is there a way you can do the equivalent of lspci on it?  I'm
>>> > curious about whether it sets INTx_DISABLE when it enables MSI.
>>>
>>> lspci -vv and lspci -vv -xxxx attached (yes, someone made a port).
>>>
>>> It looks like Mac OS sets DisINTx for all devices that have MSI
>>> enabled. The only exception is the Thunderbolt controller (no
>>> idea...). But the hotplug bridges all have DisINTx+.
>>
>> OK, thanks.  I don't know what to make of that.
>>
>> Here's a possible patch; can you try it out?
>>
>>
>> PCI: Do not enable INTx in pci_reenable_device()
>>
>> From: Bjorn Helgaas <bhelgaas@google.com>
>>
>> Previously we cleared the Interrupt Disable bit in do_pci_enable_device(),
>> which is used by both pci_enable_device() and pci_reenable_device().  But
>> we use pci_reenable_device() after the driver may have enabled MSI or
>> MSI-X, and we *set* Interrupt Disable as part of enabling MSI/MSI-X.
>>
>> The pciehp hot-plug path uses pci_reenable_device() on the hotplug bridge,
>> and clearing its Interrupt Disable bit makes its hotplug event-reporting
>> MSI stop working.
>>
>> Fixes: 1f42db786b14 PCI: Enable INTx if BIOS left them disabled
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=71691
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> ---
>>  drivers/pci/pci.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 8dc3e701ec57..79fc89c6c3f3 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -1192,6 +1192,9 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
>>                 return err;
>>         pci_fixup_device(pci_fixup_enable, dev);
>>
>> +       if (dev->msi_enabled || dev->msix_enabled)
>> +               return 0;
>> +
>>         pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
>>         if (pin) {
>>                 pci_read_config_word(dev, PCI_COMMAND, &cmd);
>
> That fixes it.

Thanks for testing this, Andreas.  I merged it and it's in Linus' tree now.

Would you mind booting with "pci=earlydump" sometime and attaching the
dmesg to the bugzilla?  Your lspci output shows that INTx_DISABLE is
set, and I'm curious about whether it was set by the BIOS or by Mac
OS.

Bjorn
