Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbaDIR0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:26:35 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:45310 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424AbaDIR0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:26:33 -0400
MIME-Version: 1.0
In-Reply-To: <53457813.704@pobox.com>
References: <5344251D.7040805@pobox.com> <CAErSpo6KuYLaoEsxR4jJQ98P23kNEMzMcu_-RyM3nWd6YRxgag@mail.gmail.com>
 <5344679E.1030008@pobox.com> <1397011868.3671.94.camel@pasglop>
 <53454660.5090603@pobox.com> <5345555A.20108@pobox.com> <534556CF.1010800@pobox.com>
 <CAErSpo63gcBZKBvF3XRjgg2jWYhTOs4Tj6yptBvdX6-_NP3VeA@mail.gmail.com> <53457813.704@pobox.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Apr 2014 11:26:12 -0600
Message-ID: <CAErSpo4608T10tgafFc_Sa+KHA7821S_efZn8JTUmW52hQXXOQ@mail.gmail.com>
Subject: Re: driver skip pci_set_master, fix it? No.
To: Mark Lord <mlord@pobox.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 10:40 AM, Mark Lord <mlord@pobox.com> wrote:
> On 14-04-09 11:52 AM, Bjorn Helgaas wrote:
>> On Wed, Apr 9, 2014 at 8:18 AM, Mark Lord <mlord@pobox.com> wrote:
>>> On 14-04-09 10:12 AM, Mark Lord wrote:
>>>> On 14-04-09 09:08 AM, Mark Lord wrote:
>>>>> On 14-04-08 10:51 PM, Benjamin Herrenschmidt wrote:
>>>>>> On Tue, 2014-04-08 at 17:18 -0400, Mark Lord wrote:
>>>>>>>> I assume you're talking about the one added by cf3e1feba7f9 ("PCI:
>>>>>>>> Workaround missing pci_set_master in pci drivers"), but as far as I
>>>>>>>> can tell, it only calls pci_set_master() for *bridge* devices.  What
>>>>>>>> am I missing?  Is pci_set_master() being called for your endpoint?
>>>>>>>> What path is that?
>>>>>>>
>>>>>>> Yes, it is being called during execution of the _probe() function in my driver,
>>>>>>> as evidenced by the annoying (and wrong) message it produces.
>>>>>>>
>>>>>>> Next time I've got the hardware at hand, I'll put a "dump_stack()" into there
>>>>>>> to see the exact calling path.
>>>>>>
>>>>>> Note that one of the reason we want to do it early on bridges is that without it,
>>>>>> we may also not get the PCIe error messages.
>>>>>
>>>>> Sure, for bridges.
>>>>>
>>>>> I'll get a stack trace later today, but what I suspect is happening
>>>>> is that this multi-function card is being treated by the PCI layers
>>>>> as a "bridge" for purposes of the multiple virtual functions it implements.
>>>>>
>>>>> We will probably need to distinguish this kind of device from real bridges here.
>>>>
>>>> Here's the call trace, all the way back to k7_probe(),
>>>> the driver's PCI "probe" function, and beyond:
>>>>
>>>> [   30.481454] k7: loading driver version 0.80
>>>> [   30.485561] pcieport 0000:00:1c.0: driver skip pci_set_master, fix it!
>>
>> This message says we're enabling bus mastering for a PCIe Root Port,
>> which I think is the expected behavior and shouldn't cause trouble for
>> your device (correct me if I'm wrong).
>>
>> I don't know the system topology, but I'm guessing the k7 device is
>> below that Root Port.  We might be enabling bus mastering for the k7
>> device, too, but that's not what this message is about, and we'd have
>> to look at the k7 command register to know for sure whether we did
>> anything to it.
>>
>>>> [   30.485580] CPU: 2 PID: 4401 Comm: insmod Tainted: G           O 3.12.14 #3
>>>> [   30.485583] Hardware name: Supermicro X9SCI/X9SCA/X9SCI/X9SCA, BIOS 2.0b 09/17/2012
>>>> [   30.485590]  0000000000000300 ffff88041c11b9b8 ffffffff8156c40b 0000000000000000
>>>> [   30.485598]  ffff88041d2b7000 ffff88041c11b9d8 ffffffff812dc493 0000000000000300
>>>> [   30.485603]  ffff88041d399000 ffff88041c11ba08 ffffffff812dc50d 0000000000001000
>>>> [   30.485607] Call Trace:
>>>> [   30.485616]  [<ffffffff8156c40b>] dump_stack+0x4f/0x84
>>>> [   30.485622]  [<ffffffff812dc493>] pci_enable_bridge+0x93/0xa0
>>>> [   30.485627]  [<ffffffff812dc50d>] pci_enable_device_flags+0x6d/0xe0
>>>> [   30.485631]  [<ffffffff812dc58e>] pci_enable_device+0xe/0x10
>>>> [   30.485641]  [<ffffffffa0469c0d>] k7_enable_device+0x3d/0xa30 [k7]
>>>> [   30.485649]  [<ffffffffa0462d72>] ? k7_devmem_alloc+0x32/0x140 [k7]
>>>> [   30.485654]  [<ffffffff81572ab6>] ? _raw_spin_lock+0x16/0x40
>>>> [   30.485658]  [<ffffffff81572721>] ? _raw_spin_unlock+0x11/0x40
>>>> [   30.485666]  [<ffffffffa046aee8>] k7_probe+0x458/0x630 [k7]
> ...
>>> The e1000e network driver is suffering from this as well in 3.12.14.
>>
>> I'll look at this more closely, in 3.12.14 in particular (I was
>> looking at 3.14 before).  Can you collect "lspci -vv" output for one
>> or both of these systems (the whole system, not just the device in
>> question)?
>>
>> Maybe you could read the PCI command register after the
>> pci_enable_device() and verify that bus mastering is actually being
>> enabled when you didn't expect it?
>
> I've checked the master bit now in my own driver,
> and you are right -- it is still 0 after pci_enable_device().
>
> So that message is complaining about the root port driver,
> not my driver or the e1000e driver.   Confusing at first.
>
> Whoever added the message ought to have taken care of the
> root ports already. So a fix may still be needed for that.

Definitely confusing.  That message has already been removed by
fbeeb822f6f4 ("PCI: Drop warning about drivers that don't use
pci_set_master()").  I'm sorry it wasn't removed soon enough to save
you the confusion :)

So I think your concern is resolved.  Let me know if it's not and I'll
look into it more.

Thanks,
  Bjorn
