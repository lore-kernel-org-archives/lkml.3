Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3IENMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:12:09 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:47660 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3IENLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:11:53 -0400
MIME-Version: 1.0
In-Reply-To: <81108254.GSTBHzP5cb@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
	<1378352279.3246.183.camel@ul30vt.home>
	<CAOLK0pySsrXEjbLor0v3zhbtUGx_437d0r5WAxWnufzZ+QwpCQ@mail.gmail.com>
	<81108254.GSTBHzP5cb@vostro.rjw.lan>
Date: Thu, 5 Sep 2013 09:11:51 -0400
Message-ID: <CAOLK0pyRY0iXt2JN42onPLn7LG8O7R7i3FaKVL7xS63uCg+7kw@mail.gmail.com>
Subject: Re: [PATCH 25/30] ACPI / hotplug / PCI: Check for new devices on
 enabled slots
From: Lan Tianyu <lantianyu1986@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/5 Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday, September 05, 2013 02:17:06 PM Lan Tianyu wrote:
>> 2013/9/5 Alex Williamson <alex.williamson@redhat.com>:
>> > On Thu, 2013-09-05 at 01:35 +0200, Rafael J. Wysocki wrote:
>> >> On Wednesday, September 04, 2013 05:12:14 PM Alex Williamson wrote:
>> >> > On Thu, 2013-09-05 at 00:54 +0200, Rafael J. Wysocki wrote:
>> >> > > On Wednesday, September 04, 2013 02:36:34 PM Alex Williamson wrote:
>> >> > > > On Thu, 2013-07-18 at 01:32 +0200, Rafael J. Wysocki wrote:
>> >> > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >> > > > >
>> >> > > > > The current implementation of acpiphp_check_bridge() is pretty dumb:
>> >> > > > >  - It enables a slot if it's not enabled and the slot status is
>> >> > > > >    ACPI_STA_ALL.
>> >> > > > >  - It disables a slot if it's enabled and the slot status is not
>> >> > > > >    ACPI_STA_ALL.
>> >> > > > >
>> >> > > > > This behavior is not sufficient to handle the Thunderbolt daisy
>> >> > > > > chaining case properly, however, because in that case the bus
>> >> > > > > behind the already enabled slot needs to be rescanned for new
>> >> > > > > devices.
>> >> > > > >
>> >> > > > > For this reason, modify acpiphp_check_bridge() so that slots are
>> >> > > > > disabled and stopped if they are not in the ACPI_STA_ALL state.
>> >> > > > >
>> >> > > > > For slots in the ACPI_STA_ALL state, devices behind them that don't
>> >> > > > > respond are trimmed using a new function, trim_stale_devices(),
>> >> > > > > introduced specifically for this purpose.  That function walks
>> >> > > > > the given bus and checks each device on it.  If the device doesn't
>> >> > > > > respond, it is assumed to be gone and is removed.
>> >> > > > >
>> >> > > > > Once all of the stale devices directy behind the slot have been
>> >> > > > > removed, acpiphp_check_bridge() will start looking for new devices
>> >> > > > > that might have appeared on the given bus.  It will do that even if
>> >> > > > > the slot is already enabled (SLOT_ENABLED is set for it).
>> >> > > > >
>> >> > > > > In addition to that, make the bus check notification ignore
>> >> > > > > SLOT_ENABLED and go for enable_device() directly if bridge is NULL,
>> >> > > > > so that devices behind the slot are re-enumerated in that case too.
>> >> > > > >
>> >> > > > > This change is based on earlier patches from Kirill A Shutemov
>> >> > > > > and Mika Westerberg.
>> >> > > > >
>> >> > > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >> > > > > Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> >> > > > > ---
>> >> > > >
>> >> > > > FYI, git bisect landed on this patch as the cause of my serial console
>> >> > > > dying on current upstream.  Further debugging to come...  Thanks,
>> >> > >
>> >> > > Well, sorry about that.
>> >> > >
>> >> > > What exactly do you mean by "dying"?
>> >> >
>> >> > Sorry, I was hoping to have more details quickly, but it's been a pain
>> >> > to debug.  By dying I mean serial console output suddenly stops during
>> >> > kernel boot and nothing more comes out of it until after the system is
>> >> > rebooted.  The problem happens when acpiphp_check_bridge() calls
>> >> > enable_slot().  The serial console dies somewhere down in
>> >> > acpiphp_bus_trim().  I think this is happening on the 00:1f ISA bridge,
>> >> > so there's a good chance the serial ports are described as somewhere
>> >> > under there.
>> >>
>> >> Can you please check if that is the acpiphp_bus_trim() called by
>> >> acpiphp_bus_add() or the other one called from trim_stale_devices()?
>> >>
>> >> Just add a dump_stack() or WARN_ON(1) to trim_stale_devices() next to
>> >> the acpiphp_bus_trim() call and see if that triggers.  I *think* it's the one
>> >> in acpiphp_bus_add(), but it won't hurt to verify that.
>> >
>> > Here's the call path:
>> >
>> > [   16.120824]  [<ffffffff81627e6c>] dump_stack+0x55/0x76
>> > [   16.125979]  [<ffffffff8162132e>] enable_slot+0x4ee/0x5e0
>> > [   16.131396]  [<ffffffff813418fb>] ? trim_stale_devices+0x5b/0xf0
>> > [   16.137420]  [<ffffffff81341b35>] acpiphp_check_bridge+0xd5/0x110
>> > [   16.143531]  [<ffffffff81342acb>] hotplug_event+0x16b/0x260
>> > [   16.149115]  [<ffffffff81072cd9>] ? process_one_work+0x189/0x540
>> > [   16.155136]  [<ffffffff81342bf0>] hotplug_event_work+0x30/0x70
>> > [   16.160978]  [<ffffffff81072d3b>] process_one_work+0x1eb/0x540
>> > [   16.166819]  [<ffffffff81072cd9>] ? process_one_work+0x189/0x540
>> > [   16.172836]  [<ffffffff8107353c>] worker_thread+0x11c/0x370
>> > [   16.178426]  [<ffffffff81073420>] ? rescuer_thread+0x350/0x350
>> > [   16.184276]  [<ffffffff8107b0ea>] kthread+0xea/0xf0
>> > [   16.189165]  [<ffffffff8107b000>] ? kthread_create_on_node+0x160/0x160
>> > [   16.195700]  [<ffffffff816395dc>] ret_from_fork+0x7c/0xb0
>> > [   16.201109]  [<ffffffff8107b000>] ? kthread_create_on_node+0x160/0x160
>> >
>> > The actual death of the serial console occurs in acpi_device_set_power()
>> > called from:
>> >
>> > enable_slot()
>> >  acpiphp_bus_add()
>> >   acpiphp_bus_trim()
>> >    acpi_bus_trim()
>> >     acpi_walk_namespace()
>> >      acpi_bus_remove()
>> >       acpi_device_unregister()
>> >        acpi_device_set_power()
>> >
>> > I can't seem to get a path from the acpi devices in question there, so I
>> > have no idea what's getting trimmed here.  It worries me quite a bit by
>> > introducing this trimming that apparently wasn't happening before
>> > though.  Thanks,
>>
>> Hi Alex:
>>            Could you apply the following patch and bootup with kernel param
>> "acpiphp.acpiphp_debug=1"?
>>            I guess the patch can make serial port alive. It will not
>> be put into D3cold
>> during trimming. But I don't know why it doesn't work after being put
>> back to D0.
>
> Do we actually put it into D0 in acpi_bus_scan()?  I don't think so.
>

Hi Rafael:
         I mean the code in the acpiphp_bus_add(). After trimming and acpi
bus scan handle, the device will be put back to D0 if acpi_bus_get_device()
return acpi device. So I thought the serial port is put back to D0.

>> So please attach output of acpidump and the dmesg if it can work. Thanks.
>>
>> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>> index e763651..359b23d 100644
>> --- a/drivers/acpi/scan.c
>> +++ b/drivers/acpi/scan.c
>> @@ -1110,7 +1110,7 @@ static void acpi_device_unregister(struct
>> acpi_device *device)
>>          * power resources the device depends on and turn off the ones that have
>>          * no more references.
>>          */
>> -       acpi_device_set_power(device, ACPI_STATE_D3_COLD);
>> +       //acpi_device_set_power(device, ACPI_STATE_D3_COLD);
>>         device->handle = NULL;
>>         put_device(&device->dev);
>>  }
>
> I don't think we should do the trimming in acpiphp_bus_add() at all.

Yes,  I agree.

>
> Thanks,
> Rafael
>



-- 
Best regards
Tianyu Lan
