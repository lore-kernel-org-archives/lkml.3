Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209Ab3BJUdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 15:33:06 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:54204 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3BJUdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 15:33:04 -0500
MIME-Version: 1.0
In-Reply-To: <1360506199.3461.5.camel@thor.lan>
References: <Pine.LNX.4.44L0.1302051520220.2245-100000@iolanthe.rowland.org>
	<1360466060.3703.15.camel@thor.lan>
	<1360506199.3461.5.camel@thor.lan>
Date: Sun, 10 Feb 2013 12:33:01 -0800
X-Google-Sender-Auth: leW6KBHhELA7ii63ALrbQOpIF5Y
Message-ID: <CAE9FiQX0Jzqi=Dy=r3MoU9vK7HgAf+919LvbgLygW7VH3O4=bg@mail.gmail.com>
Subject: Re: [Bisected] [-next-20130204] usb/hcd: irq 18: nobody cared
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 6:23 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On Sat, 2013-02-09 at 22:14 -0500, Peter Hurley wrote:
>> On Tue, 2013-02-05 at 15:26 -0500, Alan Stern wrote:
>> > On Tue, 5 Feb 2013, Peter Hurley wrote:
>> >
>> > > With -next-20130204:
>> > >
>> > > [   33.855570] irq 18: nobody cared (try booting with the "irqpoll" option)
>> > > [   33.855580] Pid: 0, comm: swapper/4 Not tainted 3.8.0-next-20130204-xeon #20130204
>> > > [   33.855582] Call Trace:
>> > > [   33.855585]  <IRQ>  [<ffffffff810f1076>] __report_bad_irq+0x36/0xe0
>> > > [   33.855600]  [<ffffffff810f152a>] note_interrupt+0x1aa/0x200
>> > > [   33.855606]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
>> > > [   33.855610]  [<ffffffff810eed89>] handle_irq_event_percpu+0xc9/0x260
>> > > [   33.855614]  [<ffffffff810eef68>] handle_irq_event+0x48/0x70
>> > > [   33.855618]  [<ffffffff810f20ba>] handle_fasteoi_irq+0x5a/0x100
>> > > [   33.855624]  [<ffffffff810182f2>] handle_irq+0x22/0x40
>> > > [   33.855630]  [<ffffffff816e2a9a>] do_IRQ+0x5a/0xd0
>> > > [   33.855636]  [<ffffffff816d97ad>] common_interrupt+0x6d/0x6d
>> > > [   33.855638]  <EOI>  [<ffffffff810f8e2a>] ? rcu_eqs_enter_common+0x4a/0x320
>> > > [   33.855646]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
>> > > [   33.855649]  [<ffffffff8101ed99>] ? mwait_idle+0x29/0x1b0
>> > > [   33.855653]  [<ffffffff8101f8a6>] cpu_idle+0x116/0x130
>> > > [   33.855658]  [<ffffffff816c0c0f>] start_secondary+0x251/0x258
>> > > [   33.855660] handlers:
>> > > [   33.855664] [<ffffffff814f98a0>] usb_hcd_irq
>> > > [   33.855667] Disabling IRQ #18
>> > >
>> > > From earlier in the boot log:
>> > > [    1.297020] uhci_hcd 0000:00:1d.2: setting latency timer to 64
>> > > [    1.297032] uhci_hcd 0000:00:1d.2: UHCI Host Controller
>> > > [    1.297040] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
>> > > [    1.297076] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
>> > > [    1.297213] hub 4-0:1.0: USB hub found
>> > > [    1.297221] hub 4-0:1.0: 2 ports detected
>> > >
>> > > lsusb:
>> > > ...
>> > > Bus 004 Device 002: ID 0764:0501 Cyber Power System, Inc. CP1500 AVR UPS
>> > > Bus 004 Device 003: ID 046d:c52b Logitech, Inc. Unifying Receiver
>>
>> [...]
>>
>> > If the suggestion above doesn't work out, bisection may be the best way
>> > to find the answer.
>>
>> This bad irq bisected to:
>>
>> 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4 is the first bad commit
>> commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4
>> Author: Yinghai Lu <yinghai@kernel.org>
>> Date:   Mon Jan 21 13:20:52 2013 -0800
>>
>>     PCI: Put pci_dev in device tree as early as possible
>>
>>     We want to put pci_dev structs in the device tree as soon as possible so
>>     for_each_pci_dev() iteration will not miss them, but driver attachment
>>     needs to be delayed until after pci_assign_unassigned_resources() to make
>>     sure all devices have resources assigned first.
>>
>>     This patch moves device registering from pci_bus_add_devices() to
>>     pci_device_add(), which happens earlier, leaving driver attachment in
>>     pci_bus_add_devices().
>>
>>     It also removes unattached child bus handling in pci_bus_add_devices().
>>     That's not needed because child bus via pci_add_new_bus() is already
>>     in parent bus children list.
>>
>>     [bhelgaas: changelog]
>>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>     Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> :040000 040000 0540c98d04d00de24b4e12fa750f6cd26c5addd2 2e24946cb7165a4028b7efb0a622271cc3990005 M    drivers
>>
>> All is fine if I revert these 2 commits:
>>
>> 40064ac PCI: Remove unused "rc" in virtfn_add_bus()
>> 4f53509 (HEAD, refs/bisect/bad) PCI: Put pci_dev in device tree as early as possible
>>
>> Any ideas how these are causing the USB HCD core / hid-logitech-dj
>> driver to drop interrupts?
>
> https://bugzilla.kernel.org/show_bug.cgi?id=53561
>
> Maybe this is some interaction with all the new ACPI code and fixes
> written in those 8 days.

interrupt routing seems get changed:
next:
   5:          0          0          0          0          0
0          0          0   IO-APIC-fasteoi   snd_ctxfi
  18:      99970         13         16         20      99940
13         13         16   IO-APIC-fasteoi   uhci_hcd:usb4
v3.8-rc7:
  18:        424         15         11        112        420
16         18        105   IO-APIC-fasteoi   uhci_hcd:usb4, snd_ctxfi

These messages in the bad dmesg log are interesting since PCI INT A is routed
on
irq 18 with the kernels that work.
[    8.983246] pci 0000:00:1e.0: can't derive routing for PCI INT A
[    8.983600] snd_ctxfi 0000:09:02.0: PCI INT A: no GSI - using ISA IRQ 5
...

acpi_pci_irq_add_prt() add wrong bus for that bridge, because that
that bridge is not scanned.

Will check if I can produce one patch for it.

Thanks

Yinghai
