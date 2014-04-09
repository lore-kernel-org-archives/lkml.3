Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbaDIOMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:12:53 -0400
Received: from mail1.start.ca ([64.140.120.57]:50789 "EHLO mail1.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761AbaDIOMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:12:52 -0400
Message-ID: <5345555A.20108@pobox.com>
Date: Wed, 09 Apr 2014 10:12:42 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: driver skip pci_set_master, fix it? No.
References: <5344251D.7040805@pobox.com>	 <CAErSpo6KuYLaoEsxR4jJQ98P23kNEMzMcu_-RyM3nWd6YRxgag@mail.gmail.com>	 <5344679E.1030008@pobox.com> <1397011868.3671.94.camel@pasglop> <53454660.5090603@pobox.com>
In-Reply-To: <53454660.5090603@pobox.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-09 09:08 AM, Mark Lord wrote:
> On 14-04-08 10:51 PM, Benjamin Herrenschmidt wrote:
>> On Tue, 2014-04-08 at 17:18 -0400, Mark Lord wrote:
>>>> I assume you're talking about the one added by cf3e1feba7f9 ("PCI:
>>>> Workaround missing pci_set_master in pci drivers"), but as far as I
>>>> can tell, it only calls pci_set_master() for *bridge* devices.  What
>>>> am I missing?  Is pci_set_master() being called for your endpoint?
>>>> What path is that?
>>>
>>> Yes, it is being called during execution of the _probe() function in my driver,
>>> as evidenced by the annoying (and wrong) message it produces.
>>>
>>> Next time I've got the hardware at hand, I'll put a "dump_stack()" into there
>>> to see the exact calling path.
>>
>> Note that one of the reason we want to do it early on bridges is that without it,
>> we may also not get the PCIe error messages.
> 
> Sure, for bridges.
> 
> I'll get a stack trace later today, but what I suspect is happening
> is that this multi-function card is being treated by the PCI layers
> as a "bridge" for purposes of the multiple virtual functions it implements.
> 
> We will probably need to distinguish this kind of device from real bridges here.

Here's the call trace, all the way back to k7_probe(),
the driver's PCI "probe" function, and beyond:

[   30.481454] k7: loading driver version 0.80
[   30.485561] pcieport 0000:00:1c.0: driver skip pci_set_master, fix it!
[   30.485580] CPU: 2 PID: 4401 Comm: insmod Tainted: G           O 3.12.14 #3
[   30.485583] Hardware name: Supermicro X9SCI/X9SCA/X9SCI/X9SCA, BIOS 2.0b 09/17/2012
[   30.485590]  0000000000000300 ffff88041c11b9b8 ffffffff8156c40b 0000000000000000
[   30.485598]  ffff88041d2b7000 ffff88041c11b9d8 ffffffff812dc493 0000000000000300
[   30.485603]  ffff88041d399000 ffff88041c11ba08 ffffffff812dc50d 0000000000001000
[   30.485607] Call Trace:
[   30.485616]  [<ffffffff8156c40b>] dump_stack+0x4f/0x84
[   30.485622]  [<ffffffff812dc493>] pci_enable_bridge+0x93/0xa0
[   30.485627]  [<ffffffff812dc50d>] pci_enable_device_flags+0x6d/0xe0
[   30.485631]  [<ffffffff812dc58e>] pci_enable_device+0xe/0x10
[   30.485641]  [<ffffffffa0469c0d>] k7_enable_device+0x3d/0xa30 [k7]
[   30.485649]  [<ffffffffa0462d72>] ? k7_devmem_alloc+0x32/0x140 [k7]
[   30.485654]  [<ffffffff81572ab6>] ? _raw_spin_lock+0x16/0x40
[   30.485658]  [<ffffffff81572721>] ? _raw_spin_unlock+0x11/0x40
[   30.485666]  [<ffffffffa046aee8>] k7_probe+0x458/0x630 [k7]

[   30.485682]  [<ffffffff812de3d6>] local_pci_probe+0x46/0x80
[   30.485696]  [<ffffffff812de6f1>] pci_device_probe+0x101/0x110
[   30.485702]  [<ffffffff813941d6>] driver_probe_device+0x76/0x240
[   30.485705]  [<ffffffff8139443b>] __driver_attach+0x9b/0xa0
[   30.485709]  [<ffffffff813943a0>] ? driver_probe_device+0x240/0x240
[   30.485713]  [<ffffffff81392385>] bus_for_each_dev+0x55/0x90
[   30.485717]  [<ffffffff81393ce9>] driver_attach+0x19/0x20
[   30.485720]  [<ffffffff81393814>] bus_add_driver+0x104/0x290
[   30.485724]  [<ffffffff81394abf>] driver_register+0x5f/0xf0
[   30.485728]  [<ffffffff812dd3f6>] __pci_register_driver+0x46/0x50
[   30.485736]  [<ffffffffa024c16e>] k7_init+0x16e/0x1000 [k7]
[   30.485746]  [<ffffffffa024c000>] ? 0xffffffffa024bfff
[   30.485765]  [<ffffffff81000302>] do_one_initcall+0x112/0x160
[   30.485779]  [<ffffffff81038143>] ? set_memory_nx+0x43/0x50
[   30.485785]  [<ffffffff810abbe1>] load_module+0x1e51/0x2480
[   30.485789]  [<ffffffff810a8b10>] ? show_initstate+0x50/0x50
[   30.485794]  [<ffffffff810ac2ae>] SyS_init_module+0x9e/0xc0
[   30.485799]  [<ffffffff8157389b>] tracesys+0xdd/0xe
