Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaIKUhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:37:51 -0400
Received: from services.gouders.net ([141.101.32.176]:52369 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaIKUhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:37:50 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 11 Sep 2014 12:26:54 -0700")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Thu, 11 Sep 2014 22:33:49 +0200
Message-ID: <ghppf15236.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Thu, Sep 11, 2014 at 10:30 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> [+cc linux-pci]
>>
>>
>> On Thu, Sep 11, 2014 at 7:43 AM, Dirk Gouders <dirk@gouders.net> wrote:
>>> Andreas Noever <andreas.noever@gmail.com> writes:
>>>
>>>> On Wed, Sep 3, 2014 at 2:47 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>>> Andreas Noever <andreas.noever@gmail.com> writes:
>>>>>
>>>>>> On Wed, Sep 3, 2014 at 12:57 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>>>>> On a Tyan VX50 (B4985) I ran into problems when updating the kernel: the
>>>>>>> PCI FC Adapter is no longer recognized.
>>>>>>
>>>>>> Can you provide the output of lspci -vvv and the output of dmesg from
>>>>>> a working boot? Which card is the one that is not recognized?
>>>>>
>>>>> Sure, the card that disappeared is:
>>>>>
>>>>> 0a:00.0 Fibre Channel: LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter (rev 02)
>>>>
>>>> As far as I can tell the following is happening:
>>>> The root bus resource window (advertised by the bios?) is to small:
>>>> pci_bus 0000:00: root bus resource [bus 00-07]
>>>> Previously we didn't really care. There is a resource conflict but we
>>>> ignored it:
>>>> pci_bus 0000:0a: busn_res: can not insert [bus 0a] under [bus 00-07]
>>>> (conflicts with (null) [bus 00-07])
>>>> With the patch we mark the bridge as broken and reassign the bus to 06:
>>>> pci 0000:00:0e.0: bridge configuration invalid ([bus 0a-0a]), reconfiguring
>>>> pci 0000:00:0e.0: PCI bridge to [bus 06-07]
>>>> pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
>>>> pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
>>>> pci_bus 0000:06: busn_res: [bus 06-07] end is updated to 06
>
>> Thanks for following up on this.  It had fallen off my radar, so I
>> opened https://bugzilla.kernel.org/show_bug.cgi?id=84281 to make sure
>> I don't forget again.  Please continue the debug discussion here in
>> email.
>
> Two problems here:
> 1. This is amd two node systems. amd_bus.c tell us bus [00, 7f] is from
> first socket, but _OSC says only [0,7] is from first socket.
>
> So solution (1):
> According to Linus's principle, we should always trust HW than firmware,
> so should we just adjust bus range from _OSC before we use it?
>
> 2. After moving, LSI FC card from bus 0a to bus 07, the LSI refuse to respond.
>
> During my testing with pci busn allocation patchset, I found that if changing
> LSI Erie card to different bus, it will refuse to responding. Only
> thing that will
> make the LSI card again, is resetting the pcie link. This should be LSI firmware
> bug.
>
> Dirk, please check if you can apply attached patches to use
>
> echo 1 > /sys/bus/pci/devices/0000\:00\0e.0/link_disable
> echo 0 > /sys/bus/pci/devices/0000\:00\0e.0/link_disable
>
> to reset the link.

Thanks, Yinghai, I will apply them tomorrow and report.

What I was currently trying was to construct a test-environment so that
I do not need to do tests and diagnosis on a busy machine.

I noticed that this problem seems to start with the narrow Root
Bridge window (00-07) but every other machine that I had a look at,
starts with (00-ff), so those will not trigger my problem.

I thought I could perhaps try to shrink the window in
acpi_pci_root_add() to trigger the problem and that kind of works: it
triggers it but not exactly the same way, because it basically ends at
this code in pci_scan_bridge():

	if (max >= bus->busn_res.end) {
		dev_warn(&dev->dev, "can't allocate child bus %02x from %pR (pass %d)\n",
			 max, &bus->busn_res, pass);
		goto out;
	}

If this could work but I am just missing a small detail, I would be
glad to hear about it and do the first tests this way.  If it is
complete nonsense, I will just use the machine that triggers the problem
for the tests.

Dirk


> Solution (2)
> To workaround the problem, we could reset the pcie link after change bus num
> in the pcie bridges ?
>
> Soultion (3)
> Or we just revert the offending 1820ffdccb9b4398 (PCI: Make sure
> bus number resources stay within their parents bounds) ?
>
> Thanks
>
> Yinghai
