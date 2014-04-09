Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbaDIQlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:41:16 -0400
Received: from mail1.start.ca ([64.140.120.57]:46118 "EHLO mail1.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100AbaDIQlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:41:09 -0400
Message-ID: <53457813.704@pobox.com>
Date: Wed, 09 Apr 2014 12:40:51 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: driver skip pci_set_master, fix it? No.
References: <5344251D.7040805@pobox.com> <CAErSpo6KuYLaoEsxR4jJQ98P23kNEMzMcu_-RyM3nWd6YRxgag@mail.gmail.com> <5344679E.1030008@pobox.com> <1397011868.3671.94.camel@pasglop> <53454660.5090603@pobox.com> <5345555A.20108@pobox.com> <534556CF.1010800@pobox.com> <CAErSpo63gcBZKBvF3XRjgg2jWYhTOs4Tj6yptBvdX6-_NP3VeA@mail.gmail.com>
In-Reply-To: <CAErSpo63gcBZKBvF3XRjgg2jWYhTOs4Tj6yptBvdX6-_NP3VeA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-09 11:52 AM, Bjorn Helgaas wrote:
> On Wed, Apr 9, 2014 at 8:18 AM, Mark Lord <mlord@pobox.com> wrote:
>> On 14-04-09 10:12 AM, Mark Lord wrote:
>>> On 14-04-09 09:08 AM, Mark Lord wrote:
>>>> On 14-04-08 10:51 PM, Benjamin Herrenschmidt wrote:
>>>>> On Tue, 2014-04-08 at 17:18 -0400, Mark Lord wrote:
>>>>>>> I assume you're talking about the one added by cf3e1feba7f9 ("PCI:
>>>>>>> Workaround missing pci_set_master in pci drivers"), but as far as I
>>>>>>> can tell, it only calls pci_set_master() for *bridge* devices.  What
>>>>>>> am I missing?  Is pci_set_master() being called for your endpoint?
>>>>>>> What path is that?
>>>>>>
>>>>>> Yes, it is being called during execution of the _probe() function in my driver,
>>>>>> as evidenced by the annoying (and wrong) message it produces.
>>>>>>
>>>>>> Next time I've got the hardware at hand, I'll put a "dump_stack()" into there
>>>>>> to see the exact calling path.
>>>>>
>>>>> Note that one of the reason we want to do it early on bridges is that without it,
>>>>> we may also not get the PCIe error messages.
>>>>
>>>> Sure, for bridges.
>>>>
>>>> I'll get a stack trace later today, but what I suspect is happening
>>>> is that this multi-function card is being treated by the PCI layers
>>>> as a "bridge" for purposes of the multiple virtual functions it implements.
>>>>
>>>> We will probably need to distinguish this kind of device from real bridges here.
>>>
>>> Here's the call trace, all the way back to k7_probe(),
>>> the driver's PCI "probe" function, and beyond:
>>>
>>> [   30.481454] k7: loading driver version 0.80
>>> [   30.485561] pcieport 0000:00:1c.0: driver skip pci_set_master, fix it!
> 
> This message says we're enabling bus mastering for a PCIe Root Port,
> which I think is the expected behavior and shouldn't cause trouble for
> your device (correct me if I'm wrong).
> 
> I don't know the system topology, but I'm guessing the k7 device is
> below that Root Port.  We might be enabling bus mastering for the k7
> device, too, but that's not what this message is about, and we'd have
> to look at the k7 command register to know for sure whether we did
> anything to it.
> 
>>> [   30.485580] CPU: 2 PID: 4401 Comm: insmod Tainted: G           O 3.12.14 #3
>>> [   30.485583] Hardware name: Supermicro X9SCI/X9SCA/X9SCI/X9SCA, BIOS 2.0b 09/17/2012
>>> [   30.485590]  0000000000000300 ffff88041c11b9b8 ffffffff8156c40b 0000000000000000
>>> [   30.485598]  ffff88041d2b7000 ffff88041c11b9d8 ffffffff812dc493 0000000000000300
>>> [   30.485603]  ffff88041d399000 ffff88041c11ba08 ffffffff812dc50d 0000000000001000
>>> [   30.485607] Call Trace:
>>> [   30.485616]  [<ffffffff8156c40b>] dump_stack+0x4f/0x84
>>> [   30.485622]  [<ffffffff812dc493>] pci_enable_bridge+0x93/0xa0
>>> [   30.485627]  [<ffffffff812dc50d>] pci_enable_device_flags+0x6d/0xe0
>>> [   30.485631]  [<ffffffff812dc58e>] pci_enable_device+0xe/0x10
>>> [   30.485641]  [<ffffffffa0469c0d>] k7_enable_device+0x3d/0xa30 [k7]
>>> [   30.485649]  [<ffffffffa0462d72>] ? k7_devmem_alloc+0x32/0x140 [k7]
>>> [   30.485654]  [<ffffffff81572ab6>] ? _raw_spin_lock+0x16/0x40
>>> [   30.485658]  [<ffffffff81572721>] ? _raw_spin_unlock+0x11/0x40
>>> [   30.485666]  [<ffffffffa046aee8>] k7_probe+0x458/0x630 [k7]
...
>> The e1000e network driver is suffering from this as well in 3.12.14.
> 
> I'll look at this more closely, in 3.12.14 in particular (I was
> looking at 3.14 before).  Can you collect "lspci -vv" output for one
> or both of these systems (the whole system, not just the device in
> question)?
> 
> Maybe you could read the PCI command register after the
> pci_enable_device() and verify that bus mastering is actually being
> enabled when you didn't expect it?

I've checked the master bit now in my own driver,
and you are right -- it is still 0 after pci_enable_device().

So that message is complaining about the root port driver,
not my driver or the e1000e driver.   Confusing at first.

Whoever added the message ought to have taken care of the
root ports already. So a fix may still be needed for that.

To confirm this, here are the messages and the tree view:

pcieport 0000:00:1c.4: driver skip pci_set_master, fix it!
pcieport 0000:00:1c.5: driver skip pci_set_master, fix it!
pcieport 0000:00:1c.0: driver skip pci_set_master, fix it!

lspci -t
-[0000:00]-+-00.0
           +-01.0-[01]--+-00.0
           |            \-00.1
           +-16.0
           +-16.1
           +-1a.0
           +-1c.0-[02]--+-00.0  (these are part of my "k7" device)
           |            +-00.1
           |            +-00.2
           |            +-00.3
           |            +-00.4
           |            +-00.5
           |            +-00.6
           |            \-00.7
           +-1c.4-[03]----00.0  (e1000e)
           +-1c.5-[04]----00.0  (e1000e)
           +-1d.0
           +-1e.0-[05]----03.0
           +-1f.0
           +-1f.2
           \-1f.3

Here is the simple lspci view.
The device I am working with has not yet been announced/released,
so I have to hide the identification for now (NDA).
The driver is being developed for GPL licensing/distribution though.

00:00.0 Host bridge: Intel Corporation Xeon E3-1200 Processor Family DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express
Root Port (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI
Controller #1 (rev 04)
00:16.1 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI
Controller #2 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host
Controller #2 (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1
(rev b5)
00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5
(rev b5)
00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6
(rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host
Controller #1 (rev 05)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a5)
00:1f.0 ISA bridge: Intel Corporation C204 Chipset Family LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family SATA AHCI Controller
(rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI RV380 [Radeon X600 (PCIE)]
01:00.1 Display controller: Advanced Micro Devices [AMD] nee ATI RV380 [Radeon X600]
02:00.0 Network...
02:00.1 Network...
02:00.2 Network...
02:00.3 Network...
02:00.4 Network...
02:00.5 Network...
02:00.6 Network...
02:00.7 Network...
03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
04:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
05:03.0 VGA compatible controller: Matrox Electronics Systems Ltd. MGA G200eW WPCM450 (rev 0a)
