Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3CNEQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:16:09 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:48549 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3CNEQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:16:07 -0400
Message-ID: <51414F02.3020209@gmail.com>
Date: Wed, 13 Mar 2013 22:16:02 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@gmail.com>
CC: Xiangliang Yu <yuxiangl@marvell.com>, Bjorn Helgaas <bhelgaas@google.com>,
        yxlraid <yxlraid@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host controller
References: <1362666556-10036-1-git-send-email-yxlraid@gmail.com> <CAErSpo7feQK7pXD=moA_hf=Y-j82oZZKwfDNzfo2Ea7i9VPxtA@mail.gmail.com> <F766E4F80769BD478052FB6533FA745D25F436856A@SC-VEXCH4.marvell.com> <CAErSpo6RDC+QyyN4kwt7-kU5d8b1iu+zCQZTGZPxCJU2UicTCA@mail.gmail.com> <F766E4F80769BD478052FB6533FA745D25F436861C@SC-VEXCH4.marvell.com> <CAL-B5D05V124xbG7z6UK9UWJ5PqmAVkqShdrMjWSGHDpTYZLQQ@mail.gmail.com>
In-Reply-To: <CAL-B5D05V124xbG7z6UK9UWJ5PqmAVkqShdrMjWSGHDpTYZLQQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 09:18 PM, Myron Stowe wrote:
> On Thu, Mar 7, 2013 at 11:51 PM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
>> Hi, Bjorn
>>
>>>>>> Fix system hang issue: if first accessed resource file of BAR0 ~
>>>>>> BAR4, system will hang after executing lspci command
>>>>>
>>>>> This needs more explanation.  We've already read the BARs by the time
>>>>> header quirks are run, so apparently it's not just the mere act of
>>>>> accessing a BAR that causes a hang.
>>>>>
>>>>> We need to know exactly what's going on here.  For example, do BARs
>>>>> 0-4 exist?  Does the device decode accesses to the regions described
>>>>> by the BARs?  The PCI core has to know what resources the device uses,
>>>>> so if the device decodes accesses, we can't just throw away the
>>>>> start/end information.
>>>> The BARs 0-4 is exist and the PCI device is enable IO space, but user access
>>> the regions file by udevadm command with info parameter, the system will hang.
>>>> Like this: udevadmin info --attribut-walk
>>> --path=/sys/device/pci-device/000:*.
>>>> Because the device is just AHCI host controller, don't need the BAR0 ~ 4 region
>>> file.
>>>> Is my explanation ok for the patch?
>>>
>>> No, I still don't know what causes the hang; I only know that udevadm
>>> can trigger it.  I don't want to just paper over the problem until we
>>> know what the root cause is.
>>>
>>> Does "lspci -H1 -vv" also cause a hang?  What about "setpci -s<dev>
>>> BASE_ADDRESS_0"?  "setpci -H1 -s<dev> BASE_ADDRESS_0"?
>> The commands are ok because the commands can't find the device after accessing IO port.
>
> Xiangliang:
>
> Sorry but I didn't understand your response above, could you elaborate
> a little more?
>
>
> Are the first five BARs of the suspect device all mapping to I/O port
> space - i.e. similar to something like this (a capture and inclusion
> of an 'lspci' of the suspect device would be nice to see):
>    00:1f.2 SATA controller:
>      Region 0: I/O ports at 1860 [size=8]
>      Region 1: I/O ports at 1814 [size=4]
>      Region 2: I/O ports at 1818 [size=8]
>      Region 3: I/O ports at 1810 [size=4]
>      Region 4: I/O ports at 1840 [size=32]
>      Region 5: Memory at f2827000 (32-bit, non-prefetchable) [size=2K]
>
> You have done a good job isolating the issue so far.  As Bjorn noted;
> it's looking as if the problem is with accessing the I/O port space
> mapped by the suspect device's BAR(s), not with accessing the BAR(s)
> in the device's configuration space.

It would seem so. My question is what is accessing the IO port space in 
the first place. BAR5 is the MMIO region used by the AHCI driver. BARs 
0-4 are the legacy SFF-compatible ATA ports. Nothing should be messing 
with those IO ports while AHCI is enabled. It's expected that doing that 
will break things.

If something in udev is randomly groveling around inside the resource 
files for those BARs in sysfs, that seems like a really bad thing.

>
> As you responded positively to earlier, as proposed the suspect device
> will still actively be decoding accesses to the regions described by
> the BARs.  Because the device is actively decoding the PCI core can't
> just throw away the BAR's corresponding resource regions, as the patch
> is currently doing, due to the possibility of another device being
> added at a later time.
>
> If a subsequent device were added later, the core may need to try and
> allocate resources for it and, in the worst case scenario, the core
> could end up allocating resources that conflict with this suspect
> device as a consequence of the suspect device's original resource
> allocations having been silently thrown away.  The result would be
> both devices believing they each exclusively own the same set (or
> subset) of I/O port mappings and thus both actively decoding accesses
> to such which.  A situation that would obviously be disastrous.
>
> There is still something going on here that we still do not
> understand.  Could you please capture the following information to
> help further isolate the issue:
>    A 'dmesg' log from the system which was booted using both the
> "debug" and "ignore_loglevel" boot parameters, a 'lspci -xxx -s<dev>'
> capture, and a 'lspci -vv' capture.
>
> Thanks,
>   Myron
>
>> The root cause is that accessing of IO port will make the chip go bad. So, the point of the patch is don't export capability of the IO accessing.
>>
>>>
>>>>>
>>>>>> ---
>>>>>>   drivers/pci/quirks.c |   15 +++++++++++++++
>>>>>>   1 files changed, 15 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>>>>>> index 0369fb6..d49f8dc 100644
>>>>>> --- a/drivers/pci/quirks.c
>>>>>> +++ b/drivers/pci/quirks.c
>>>>>> @@ -44,6 +44,21 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
>>>>>>   DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>>>>>>                                  PCI_CLASS_BRIDGE_HOST, 8,
>>>>> quirk_mmio_always_on);
>>>>>>
>>>>>> +/* The BAR0 ~ BAR4 of Marvell 9125 device can't be accessed
>>>>>> +*  by IO resource file, and need to skip the files
>>>>>> +*/
>>>>>> +static void quirk_marvell_mask_bar(struct pci_dev *dev)
>>>>>> +{
>>>>>> +       int i;
>>>>>> +
>>>>>> +       for (i = 0; i < 5; i++)
>>>>>> +               if (dev->resource[i].start)
>>>>>> +                       dev->resource[i].start =
>>>>>> +                               dev->resource[i].end = 0;
>>>>>> +}
>>>>>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9125,
>>>>>> +                               quirk_marvell_mask_bar);
>>>>>> +
>>>>>>   /* The Mellanox Tavor device gives false positive parity errors
>>>>>>    * Mark this device with a broken_parity_status, to allow
>>>>>>    * PCI scanning code to "skip" this now blacklisted device.
>>>>>> --
>>>>>> 1.7.5.4
>>>>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

