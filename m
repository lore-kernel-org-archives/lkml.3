Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaIKXvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:51:21 -0400
Received: from services.gouders.net ([141.101.32.176]:52527 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaIKXvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:51:19 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
	(Bjorn Helgaas's message of "Thu, 11 Sep 2014 16:51:25 -0600")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	<ghd2b1svdw.fsf@quad.gouders.net>
	<CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Fri, 12 Sep 2014 01:50:03 +0200
Message-ID: <ghvbotd8es.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

> On Thu, Sep 11, 2014 at 3:24 PM, Dirk Gouders <dirk@gouders.net> wrote:
>> Bjorn Helgaas <bhelgaas@google.com> writes:
>>
>>> On Thu, Sep 11, 2014 at 2:33 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>> What I was currently trying was to construct a test-environment so that
>>>> I do not need to do tests and diagnosis on a busy machine.
>>>>
>>>> I noticed that this problem seems to start with the narrow Root
>>>> Bridge window (00-07) but every other machine that I had a look at,
>>>> starts with (00-ff), so those will not trigger my problem.
>>>>
>>>> I thought I could perhaps try to shrink the window in
>>>> acpi_pci_root_add() to trigger the problem and that kind of works: it
>>>> triggers it but not exactly the same way, because it basically ends at
>>>> this code in pci_scan_bridge():
>>>>
>>>>         if (max >= bus->busn_res.end) {
>>>>                 dev_warn(&dev->dev, "can't allocate child bus %02x from %pR (pass %d)\n",
>>>>                          max, &bus->busn_res, pass);
>>>>                 goto out;
>>>>         }
>>>>
>>>> If this could work but I am just missing a small detail, I would be
>>>> glad to hear about it and do the first tests this way.  If it is
>>>> complete nonsense, I will just use the machine that triggers the problem
>>>> for the tests.
>>>
>>> I was about to suggest the same thing.  If the problem is related to
>>> the bus number change, we should be able to force that to happen on a
>>> different machine.  Your approach sounds good, so I'm guessing we just
>>> need a tweak.
>>>
>>> I would first double-check that the PCI adapters are identical,
>>> including the firmware on the card.  Can you also include your patch
>>> and the resulting dmesg (with debug enabled as before)?
>>
>> Currently I am at home doing just tests for understanding and that I can
>> hopefully use when I am back in the office.
>>
>> I already noticed the the backup FC Adapter on the test machine is not
>> exactly the same: it is Rev. 1 whereas the one on the failing machine is
>> Rev. 2.
>>
>> So, here at home my tests let a NIC disappear.  Different from the
>> original problem but I was just trying to reconstruct the szenario of a
>> misconfigured bridge causing a reconfiguration.
>>
>> What I was trying is:
>>
>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>> index e6ae603..fd146b3 100644
>> --- a/drivers/acpi/pci_root.c
>> +++ b/drivers/acpi/pci_root.c
>> @@ -556,6 +556,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>         strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
>>         strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>>         device->driver_data = root;
>> +       root->secondary.end = 0x02;
>>
>>         pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
>>                acpi_device_name(device), acpi_device_bid(device),
>>
>> The device that disappears is a NIC:
>>
>> 00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller (rev 09)
>> 00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor Graphics Controller (rev 09)
>> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
>> 00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
>> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
>> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
>> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
>> 00:1c.4 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 5 (rev c4)
>> 00:1c.5 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 6 (rev c4)
>> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
>> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a4)
>> 00:1f.0 ISA bridge: Intel Corporation B75 Express Chipset LPC Controller (rev 04)
>> 00:1f.2 SATA controller: Intel Corporation 7 Series/C210 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
>> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
>>
>> This is the one that is missing with the above change:
>> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
>
> This situation is a little different, so I don't think you're
> reproducing the situation we want to test.  On this box, you have:
>
>     pci_bus 0000:00: root bus resource [bus 00-02]
>     pci 0000:00:1c.0: PCI bridge to [bus 01]
>     pci 0000:00:1c.4: PCI bridge to [bus 02]
>
> so we find all the devices on bus 00 and bus 02 (there's nothing on
> bus 01).  My guess is the 03:00.0 device is normally behind the
> 00:1c.5 bridge, but we don't even scan behind that bridge because we
> can't allocate a secondary bus number for it (we're not smart enough
> to take advantage of the empty bus 01).
>
> On the failing box, it's different because we *do* have unused bus
> number space, and we do actually reconfigure the bridge to use it.
> It's just that the FC adapter doesn't respond when we use the new bus
> number for it.
>
> You might be able to do something similar on the test box by:
>
>   - Keeping your root->secondary.end = 02 patch, so you still have [bus 00-02].
>   - Ignoring bridges 00:1c.0 and 00:1c.4.  I would just test for those
> devfns in pci_scan_device() and when you see them, return NULL instead
> of trying to read the vendor ID.
>
> Then 00:1c.5 is probably configured by the BIOS for [bus 03], but
> that's outside the root bridge range, so we should reconfigure it to
> use [bus 01].  Then we should scan behind it, and we'll probably
> discover the NIC that was previously at 03:00.0.  The device *should*
> just work at the new bus number, since it probably doesn't have the
> same bug the FC adapter does.

Thanks for the explanation.  I tried to ignore the two bridges but the
machine stopped with the "reconfiguring" message.

Anyway, if I understood you correctly with the backup FC adapter I have
good chances, because there is the needed unused bus number space and I
don't have to ignore bridges.  I will test in a few hours and report.

Dirk
