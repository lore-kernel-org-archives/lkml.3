Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaHZP6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:58:32 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47391 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaHZP6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAMxnaaUXfQnig8koXxJ4PeA7+3F7aNZWvtFCmTPLem4q0_PZ9g@mail.gmail.com>
References: <6486222925419988442@unknownmsgid> <CAKbGBLizXPqs6yAsi_ew3vMyMWOYfCnEKMV-JFb5w+YAqGVUPw@mail.gmail.com>
 <CAMxnaaXwY1oyaws-SG3=DzO0qo12bT0-6V9mti7fO11--sp7Zw@mail.gmail.com>
 <CAKbGBLivQ1cP_EN=maQ0fHAUKfmpWyEY1T5frqv4nAqTdXw5GQ@mail.gmail.com>
 <CAMxnaaXwrgh4XVUEhEVDfUJ=9n+OWD3Ncj-=FOHUQ1Jw5xwSvw@mail.gmail.com>
 <20140815173539.GA2012@twoflower.us-west-2.compute.internal> <CAMxnaaUXfQnig8koXxJ4PeA7+3F7aNZWvtFCmTPLem4q0_PZ9g@mail.gmail.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Tue, 26 Aug 2014 17:58:10 +0200
Message-ID: <CAMxnaaVfr5=8OuMMWdH4q2eNsDpXnv9y+h3NEnEczXH3LYnZ-g@mail.gmail.com>
Subject: Re: Thunderbolt driver hotplug not working correctly
To: Steven Noonan <steven@uplinklabs.net>
Cc: Greg KH <greg@kroah.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:14 PM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> (apparently I hit "reply" instead of "reply all" sometime back, sorry
> for that. Readding ccs)
>
> On Fri, Aug 15, 2014 at 7:35 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> On Fri, Aug 15, 2014 at 04:03:08PM +0200, Andreas Noever wrote:
>>> On Fri, Aug 15, 2014 at 2:48 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>>> > On Fri, Aug 15, 2014 at 5:41 AM, Andreas Noever
>>> > <andreas.noever@gmail.com> wrote:
>>> >> On Fri, Aug 15, 2014 at 1:24 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>>> >>> On Wed, Aug 13, 2014 at 4:05 PM, Andreas Noever
>>> >>> <andreas.noever@gmail.com> wrote:
>>> >>>> Hello Steven,
>>> >>>>
>>> >>>> I think that there are two problems:
>>> >>>>  - The Kernel does not notice that the device is gone.
>>> >>>>  - The first hotplug operation, after removing a coldplugged device fails.
>>> >>>>
>>> >>>> For the first one could you check whether thie pciehp (sub)-driver is loaded?
>>> >>>> (dmesg | grep pciehp should show something, the config option is
>>> >>>> CONFIG_HOTPLUG_PCI_PCIE).
>>> >>>>
>>> >>>> I was able reproduce the second problem on my machine. Could you test whether
>>> >>>> this patch fixes the problem?
>>> >>>>
>>> >>>
>>> >>> With the patch I see that PCI bridge 09:00.0 survives the hotplug
>>> >>> events, but the bridge at 0a:00.0 and the Ethernet controller don't
>>> >>> survive.
>>> >>
>>> >> Is CONFIG_HOTPLUG_PCI_PCIE set? Any output from pciehp?
>>> >
>>> > CONFIG_HOTPLUG_PCI_PCIE=y
>>> >
>>> > Aug 15 04:17:55 twoflower kernel: pci_hotplug: PCI Hot Plug PCI Core
>>> > version: 0.5
>>> > Aug 15 04:17:55 twoflower kernel: pciehp: Using ACPI for slot detection.
>>> > Aug 15 04:17:55 twoflower kernel: pciehp 0000:07:00.0:pcie24: Slot #0
>>> > AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
>>> > Aug 15 04:17:55 twoflower kernel: pciehp 0000:07:00.0:pcie24: service
>>> > driver pciehp loaded
>>> > Aug 15 04:17:55 twoflower kernel: pciehp: PCI Express Hot Plug
>>> > Controller Driver version: 0.4
>>> >
>>> > And that's all I get from pciehp.
>>>
>>> 07:00 is not one of the downstream ports. The driver should bind to
>>> 07:03-06. (On my system :00 does not even have the hotplug cap set).
>>>
>>> Does pciehp.pciehp_force=1 help?
>>
>> That looks more sensible.
>>
>> Aug 15 10:20:18 twoflower kernel: Command line: BOOT_IMAGE=/vmlinuz-3.16.0-ec2-11383-gc9d2642-dirty root=UUID=6146fd5a-e8b0-449f-8ba4-36676f089aae rw earlyprintk=verbose loglevel=5 libata.force=noncq rootflags=data=writeback intel_pstate=disable i915.lvds_channel_mode=2 pciehp.pciehp_force=1
>> Aug 15 10:20:18 twoflower kernel: Kernel command line: BOOT_IMAGE=/vmlinuz-3.16.0-ec2-11383-gc9d2642-dirty root=UUID=6146fd5a-e8b0-449f-8ba4-36676f089aae rw earlyprintk=verbose loglevel=5 libata.force=noncq rootflags=data=writeback intel_pstate=disable i915.lvds_channel_mode=2 pciehp.pciehp_force=1
>> Aug 15 10:20:18 twoflower kernel: pciehp: Using ACPI for slot detection.
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:00:1c.0:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.0
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:00:1c.0:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:00.0:pcie24: Bypassing BIOS check for pciehp use on 0000:07:00.0
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:00.0:pcie24: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:00.0:pcie24: Device 0000:08:00.0 already exists at 0000:08:00, cannot hot-add
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:00.0:pcie24: Cannot add device at 0000:08:00
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:00.0:pcie24: service driver pciehp loaded
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:03.0:pcie24: Bypassing BIOS check for pciehp use on 0000:07:03.0
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:03.0:pcie24: Slot #3 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:03.0:pcie24: Device 0000:09:00.0 already exists at 0000:09:00, cannot hot-add
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:03.0:pcie24: Cannot add device at 0000:09:00
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:03.0:pcie24: service driver pciehp loaded
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:04.0:pcie24: Bypassing BIOS check for pciehp use on 0000:07:04.0
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:04.0:pcie24: Slot #4 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:04.0:pcie24: service driver pciehp loaded
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:05.0:pcie24: Bypassing BIOS check for pciehp use on 0000:07:05.0
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:05.0:pcie24: Slot #5 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:05.0:pcie24: service driver pciehp loaded
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:06.0:pcie24: Bypassing BIOS check for pciehp use on 0000:07:06.0
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:06.0:pcie24: Slot #6 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:07:06.0:pcie24: service driver pciehp loaded
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:0a:00.0:pcie24: Bypassing BIOS check for pciehp use on 0000:0a:00.0
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:0a:00.0:pcie24: Slot #9 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:0a:00.0:pcie24: Timeout on hotplug command 0x00000000 (issued 0 msec ago)
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:0a:00.0:pcie24: Device 0000:0b:00.0 already exists at 0000:0b:00, cannot hot-add
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:0a:00.0:pcie24: Cannot add device at 0000:0b:00
>> Aug 15 10:20:18 twoflower kernel: pciehp 0000:0a:00.0:pcie24: service driver pciehp loaded
>> Aug 15 10:20:18 twoflower kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>>
>> Though the "cannot hot-add" lines are worrying. The above is a boot with
>> the Ethernet dongle attached at boot.
>
> Yes this is strange. Either the hp driver is getting spurious hotplug
> events or the thunderbolt driver tries to hotplug the already
> configured device. Can you send me the full dmesg and lspci -vvnn
> output for this scenario? Please also pass pciehp.pciehp_debug=1 to
> the kernel.
>
>> And here's a hotplug attempt (which at least successfully *removes* the device
>> from the tg3 driver's perspective, but hot-adding the device still fails):
>>
>> Aug 15 10:24:03 twoflower kernel: pciehp 0000:07:03.0:pcie24: slot(3-1): Link Down event
>> Aug 15 10:24:03 twoflower kernel: pciehp 0000:07:03.0:pcie24: Cannot remove display device 0000:09:00.0
>> Aug 15 10:24:04 twoflower kernel: pciehp 0000:07:03.0:pcie24: slot(3-1): Link Up event
>> Aug 15 10:24:04 twoflower kernel: pciehp 0000:07:03.0:pcie24: Device 0000:09:00.0 already exists at 0000:09:00, cannot hot-add
>> Aug 15 10:24:04 twoflower kernel: pciehp 0000:07:03.0:pcie24: Cannot add device at 0000:09:00
>> Aug 15 10:24:04 twoflower kernel: pciehp 0000:07:03.0:pcie24: slot(3-1): Link Down event
>> Aug 15 10:24:04 twoflower kernel: pciehp 0000:07:03.0:pcie24: Cannot remove display device 0000:09:00.0
>> Aug 15 10:24:04 twoflower kernel: pciehp 0000:07:03.0:pcie24: Card not present on Slot(3-1)
>> Aug 15 10:24:06 twoflower kernel: pciehp 0000:0a:00.0:pcie24: unloading service driver pciehp
>> Aug 15 10:24:06 twoflower kernel: pciehp 0000:0a:00.0:pcie24: Timeout on hotplug command 0x00001038 (issued 232550 msec ago)
>> Aug 15 10:24:27 twoflower kernel: pciehp 0000:07:03.0:pcie24: Card present on Slot(3-1)
>> Aug 15 10:24:27 twoflower kernel: pciehp 0000:07:03.0:pcie24: slot(3-1): Link Up event
>> Aug 15 10:24:27 twoflower kernel: pciehp 0000:07:03.0:pcie24: Link Up event ignored on slot(3-1): already powering on
>> Aug 15 10:24:27 twoflower kernel: pciehp 0000:0a:00.0:pcie24: Bypassing BIOS check for pciehp use on 0000:0a:00.0
>> Aug 15 10:24:27 twoflower kernel: pciehp 0000:0a:00.0:pcie24: Slot #9 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
>> Aug 15 10:24:27 twoflower kernel: pciehp 0000:0a:00.0:pcie24: Timeout on hotplug command 0x00000000 (issued 0 msec ago)
>> Aug 15 10:24:47 twoflower kernel: pciehp 0000:07:03.0:pcie24: Card not present on Slot(3-1)
>> Aug 15 10:24:47 twoflower kernel: pciehp 0000:07:03.0:pcie24: slot(3-1): Link Down event
>> Aug 15 10:24:47 twoflower kernel: pciehp 0000:07:03.0:pcie24: Link Down event ignored on slot(3-1): already powering off
>
>
> "Cannot remove display device 0000:09:00.0"... The message comes from
> http://lxr.free-electrons.com/source/drivers/pci/hotplug/pciehp_pci.c#L112
>
> The pciehp driver tries to read from the removed device (which returns
> 0xffff) and thus it thinks that the VGA flag is set. I have no idea
> why presence is true here (it is read a few lines earlier). This is of
> course a little bit racy..
>
>> Without the dongle attached at boot, the thunderbolt driver (and rest of the
>> kernel, for that matter) still stays silent when hotplugging it:
>>
>> Aug 15 10:26:24 twoflower kernel: Command line: BOOT_IMAGE=/vmlinuz-3.16.0-ec2-11383-gc9d2642-dirty root=UUID=6146fd5a-e8b0-449f-8ba4-36676f089aae rw earlyprintk=verbose loglevel=5 libata.force=noncq rootflags=data=writeback intel_pstate=disable i915.lvds_channel_mode=2 pciehp.pciehp_force=1
>> Aug 15 10:26:24 twoflower kernel: Kernel command line: BOOT_IMAGE=/vmlinuz-3.16.0-ec2-11383-gc9d2642-dirty root=UUID=6146fd5a-e8b0-449f-8ba4-36676f089aae rw earlyprintk=verbose loglevel=5 libata.force=noncq rootflags=data=writeback intel_pstate=disable i915.lvds_channel_mode=2 pciehp.pciehp_force=1
>> Aug 15 10:26:24 twoflower kernel: pciehp 0000:00:1c.0:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.0
>> Aug 15 10:26:24 twoflower kernel: pciehp 0000:00:1c.0:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
>> Aug 15 10:26:24 twoflower kernel: pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
>> Aug 15 10:26:24 twoflower kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>>
>> Looking in lspci, it appears a bunch of devices (all of 06:00.0 and up) are
>> missing, which explains the thunderbolt driver's silence. Does Apple's firmware
>> only announce that the thunderbolt bus exists when a device is attached at
>> boot?
>
> Yes, you can try passing acpi_osi=Darwin. If that makes 06:00 etc.
> appear then I would also be interested in dmesg and lspci -vvnn.

If you have time can you also run a test with the acpi patches
applied? These would be the last four patches from
https://github.com/anoever/thunderbolt/tree/acpi_rebased

Try applying those and booting without a TB device attached and
without acpi/pciehp parameters. Check that the TB controller is
present (06:00.0 and below) and that pciehp gets loeaded for 07:03-06.
Then plug in a TB device.


> Thanks,
> Andreas
>
>>>
>>> >>>>
>>> >>>> ---
>>> >>>>  drivers/thunderbolt/path.c | 21 ++++++++++++++++++++-
>>> >>>>  1 file changed, 20 insertions(+), 1 deletion(-)
>>> >>>>
>>> >>>> diff --git a/drivers/thunderbolt/path.c b/drivers/thunderbolt/path.c
>>> >>>> index 8fcf8a7..9562cd0 100644
>>> >>>> --- a/drivers/thunderbolt/path.c
>>> >>>> +++ b/drivers/thunderbolt/path.c
>>> >>>> @@ -150,7 +150,26 @@ int tb_path_activate(struct tb_path *path)
>>> >>>>
>>> >>>>         /* Activate hops. */
>>> >>>>         for (i = path->path_length - 1; i >= 0; i--) {
>>> >>>> -               struct tb_regs_hop hop;
>>> >>>> +               struct tb_regs_hop hop = { 0 };
>>> >>>> +
>>> >>>> +               /*
>>> >>>> +                * We do (currently) not tear down paths setup by the firmeware.
>>> >>>> +                * If a firmware device is unplugged and plugged in again then
>>> >>>> +                * it can happen that we reuse some of the hops from the (now
>>> >>>> +                * defunct) firmeware path. This causes the hotplug operation to
>>> >>>> +                * fail (the pci device does not show up). Clearing the hop
>>> >>>> +                * before overwriting it fixes the problem.
>>> >>>> +                *
>>> >>>> +                * Should be removed once we discover and tear down firmeware
>>> >>>> +                * paths.
>>> >>>> +                */
>>> >>>> +               res = tb_port_write(path->hops[i].in_port, &hop, TB_CFG_HOPS,
>>> >>>> +                                   2 * path->hops[i].in_hop_index, 2);
>>> >>>> +               if (res) {
>>> >>>> +                       __tb_path_deactivate_hops(path, i);
>>> >>>> +                       __tb_path_deallocate_nfc(path, 0);
>>> >>>> +                       goto err;
>>> >>>> +               }
>>> >>>>
>>> >>>>                 /* dword 0 */
>>> >>>>                 hop.next_hop = path->hops[i].next_hop_index;
>>> >>>> --
>>> >>>> 2.0.4
>>> >>>>
