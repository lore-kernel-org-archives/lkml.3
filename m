Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbaGATaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:30:18 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:49769 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaGATaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:30:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAL-B5D3M9gmefaSkGnb13UtBHt857G-ixkmhjHawO5hW2AN9xA@mail.gmail.com>
References: <20140617192734.30783.71260.stgit@amt.stowe> <CAErSpo7t2kXj2ZULLXCJSWb_awS+DCtCg51dnLbb8ztWmQdYog@mail.gmail.com>
 <CAL-B5D3M9gmefaSkGnb13UtBHt857G-ixkmhjHawO5hW2AN9xA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 1 Jul 2014 13:29:54 -0600
Message-ID: <CAErSpo4_YEEU1q1ehT2oizLRwPe1_7qOMnXR=y7WmXOp=raSag@mail.gmail.com>
Subject: Re: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed
 bit when clearing the Slot Status register's event bits
To: Myron Stowe <myron.stowe@gmail.com>
Cc: Myron Stowe <myron.stowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 10:49 AM, Myron Stowe <myron.stowe@gmail.com> wrote:
> On Tue, Jun 17, 2014 at 3:07 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Jun 17, 2014 at 1:27 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
>>> During PCIe hot-plug initialization - pciehp_probe - data structures
>>> related to slot capabilities are set up.  As part of this set up, ISRs are
>>> put in place to handle slot events and all event bits are cleared out.
>>>
>>> This patch adds the Data Link Layer State Changed (PCI_EXP_SLTSTA_DLLSC)
>>> Slot Status bit to the event bits that are cleared out during
>>> initialization.
>>
>> I think this is related to e48f1b67f668 ("PCI: pciehp: Use link change
>> notifications for hot-plug and removal").  Prior to that, pcie_isr()
>> didn't look at the PCI_EXP_SLTSTA_DLLSC bit.
>>
>> Apparently there's a non-public report of spurious messages like this
>> at boot-time, with no actual hotplug events:
>>
>>   pciehp 0000:82:04.0:pcie24: slot(4): Link Up event
>>   pciehp 0000:82:04.0:pcie24: Device 0000:83:00.0 already exists at
>> 0000:83:00, cannot hot-add
>>   pciehp 0000:82:04.0:pcie24: Cannot add device at 0000:83:00
>>
>> Device 0000:83:00.0 was enumerated previously, during the normal PCI
>> device enumeration.  I suspect DLLSC was set by the hardware when the
>> link came up after power-on, and it remained set until Linux booted.
>> Then when we take the first pciehp interrupt, we notice DLLSC is set
>> and think it's a new link state change.
>>
>> This might be system-specific, because some BIOSes might clear DLLSC
>> before handing off to the OS.  Or my theory might be all wet.
>>
>> But I think we should clear DLLSC in any case.  We clear all the other
>> RW1C bits in Slot Status, and I think we should clear DLLSC as well.
>>
>> I'd like to include a bugzilla or mailing list reference for the
>> spurious message, and I'd also like confirmation that this changes
>> actually fixes it.
>
> I just got confirmation from the reporter that the patch fixes the
> issue they were encountering.
>
> I've also asked them numerous time if I could make the bug public as I
> expect others may be hitting it and could benefit from a BZ and
> analysis/explanation.  I just repeated my request - if they reply
> positively I'll follow through with some documentation.

I'd be glad to merge this, as soon as we get more details about the
problem it fixes.  I think it's good to include some specifics, e.g.,
"Unexpected Link Up event," etc., because it helps other people with
the same problem to find the solution.  It's OK if details about
pre-production machines and so on are removed, but it's better if
changes to generic code are supported by public evidence that
everybody can evaluate.

If you want to pull out the public stuff into a kernel.org bugzilla,
that would be fine, too.  That would actually be better because then
we don't have to depend on Red Hat maintaining it.

Bjorn

>>> Reference:
>>>   PCI-SIG.  PCI Express Base Specification Revision 4.0 Version 0.3
>>>   (PCI-SIG, 2014): 7.8.11. Slot Status Register (Offset 1Ah).
>>>
>>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>>> ---
>>>
>>>  drivers/pci/hotplug/pciehp_hpc.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
>>> index 42914e0..0568416 100644
>>> --- a/drivers/pci/hotplug/pciehp_hpc.c
>>> +++ b/drivers/pci/hotplug/pciehp_hpc.c
>>> @@ -794,7 +794,7 @@ struct controller *pcie_init(struct pcie_device *dev)
>>>         pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
>>>                 PCI_EXP_SLTSTA_ABP | PCI_EXP_SLTSTA_PFD |
>>>                 PCI_EXP_SLTSTA_MRLSC | PCI_EXP_SLTSTA_PDC |
>>> -               PCI_EXP_SLTSTA_CC);
>>> +               PCI_EXP_SLTSTA_CC | PCI_EXP_SLTSTA_DLLSC);
>>>
>>>         /* Disable software notification */
>>>         pcie_disable_notification(ctrl);
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
