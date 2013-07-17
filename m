Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3GQFvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:51:01 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53609 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3GQFu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130716063117.GA30320@kroah.com>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
	<20130715165209.GA6000@kroah.com>
	<CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
	<20130716063117.GA30320@kroah.com>
Date: Wed, 17 Jul 2013 13:50:58 +0800
Message-ID: <CA+k=oDzCUyG-pe9wntV0N3Yp80+=_OikzM9N3dHwETE2VSXsow@mail.gmail.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
From: Rong Wang <wr011235813@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: balbi@ti.com, Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rong.Wang@csr.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Jul 16, 2013 at 2:31 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 16, 2013 at 11:49:07AM +0800, Rong Wang wrote:
>> Hi Greg,
>>
>> The USB on our platform can change roles between HOST and GADGET, but
>> it is not capable of OTG.
>
> That kind of sounds like the definition of OTG :)

Yes. But it just initiates its role according to the ID pin status.

>
>> When the USB changes between roles the udev will run some scripts
>> automatically according to the udev rules.
>
> What exactly does udev/userspace see when the roles change?
>

Take HOST -> GADGET for example, the driver removes the USB hcd first,

ACTION=remove
DEVPATH=/devices/axi.0/uus-iobg.13/b8010000.usbcontroller/ci_hdrc.0/usb1/1-0:1.0
SUBSYSTEM=usb
DEVTYPE=usb_interface
PRODUCT=1d6b/2/310
TYPE=9/0/1
INTERFACE=9/0/0
MODALIAS=usb:v1D6Bp0002d0310dc09dsc00dp01ic09isc00ip00in00
SEQNUM=1843

Then it initiates the GADGET role which will call usb_add_gadget_udc

ACTION=add
DEVPATH=/devices/axi.0/uus-iobg.13/b8010000.usbcontroller/ci_hdrc.0/udc/ci_hdrc.0
SUBSYSTEM=udc
USB_UDC_NAME=ci13xxx_sirf
SEQNUM=1845

At this time, the udev finds this matches the rule and it will install
g_mass_storage.ko. But we are actually not connecting to a PC now, so
we do not umount the back-end file storage on our device.

Currently the udc framework introduces an API usb_gadget_set_state
to report to user-space the USB device state. But it's not compatible with
udev. It needs user-space utility polling the "status" file under /sys.
And it cannot be called in interrupt context but drivers do the state change
in interrupt service routine.

What's more, I grep the USB driver and find few driver apply this API except
the udc core. But it just initiated its state as "NOT ATTACHED" when registering
a new udc.

In my opinion, the USB device state change is a common operation and it
should be implemented by driver framework. The best place to do this is
when composite framework handling standard USB requests. But it's not
implemented yet.

So we are not informed the USB state until the role changes again.
We do not know when to secure the back-end file between our device and the
host PC.

> And what can trigger the change in roles?

The role changes according to the ID pin status.
When we plug in a mini-A (ID pin connects to ground) it will cause a
ID pin interrupt
and we will change to HOST role.
If the ID pin connects to nothing we will act as GADGET.

In a sum, role change takes place when we plug in different USB connectors.

>
>> The default role is GADGET, and we bind the g_mass_storage to the USB
>> GADGET role.
>>
>> We should secure the back end file storage between the device and the
>> host PC connecting to our device.
>> We need to know when the GADGET is really connect to a host PC, then
>> we can umount the file on the device
>> and export it to the g_mass_storage.
>
> I thought you already get an event for this, otherwise no one would be
> able to properly deal with this.

Yes. We install file storage module on this event but we do not get
further notice
as mentioned above.

>
>> The question is since we default GADGET, so the g_mass_storage.ko is
>> installed early but connecting to a host PC
>> is randomly, But the udev has no idea when a host PC connects our device.
>>
>> So we consider it's reasonable to let the udev know the GADGET device state.
>> Is there any alternative to our question?
>
> I thought we already export events for gadget device states, have you
> looked for them?  I can't dig through the code at the moment, but this
> seems like a pretty common issue...
>
> Felipe, any ideas?
>
> greg k-h
