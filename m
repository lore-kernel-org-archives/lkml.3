Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab3GPDtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:49:11 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:35944 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab3GPDtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:49:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130715165209.GA6000@kroah.com>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
	<20130715165209.GA6000@kroah.com>
Date: Tue, 16 Jul 2013 11:49:07 +0800
Message-ID: <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
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

The USB on our platform can change roles between HOST and GADGET, but
it is not capable of OTG.
When the USB changes between roles the udev will run some scripts
automatically according to the udev rules.
The default role is GADGET, and we bind the g_mass_storage to the USB
GADGET role.

We should secure the back end file storage between the device and the
host PC connecting to our device.
We need to know when the GADGET is really connect to a host PC, then
we can umount the file on the device
and export it to the g_mass_storage.

The question is since we default GADGET, so the g_mass_storage.ko is
installed early but connecting to a host PC
is randomly, But the udev has no idea when a host PC connects our device.

So we consider it's reasonable to let the udev know the GADGET device state.
Is there any alternative to our question?

Thanks!

On Tue, Jul 16, 2013 at 12:52 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jul 15, 2013 at 11:57:24AM +0800, Rong Wang wrote:
>>     usb: udc: add gadget state kobject uevent
>>
>>     Add USB_UDC_STATE environment variable in udc uevent
>>     callback and trigger kobject_uevent in usb_gadget_set_state
>>     to inform the user-space the state of the gadget.
>
> Why?
>
> And what's with the indentation?
>
>>     Signed-off-by: Rong Wang <Rong.Wang@csr.com>
>>
>> diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
>> index ffd8fa5..05715d1 100644
>> --- a/drivers/usb/gadget/udc-core.c
>> +++ b/drivers/usb/gadget/udc-core.c
>> @@ -101,11 +101,32 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
>>
>>  /* ------------------------------------------------------------------------- */
>>
>> +/**
>> + * usb_gadget_set_state - set usb gadget state
>> + * @gadget: gadget device
>> + * @state: state defined in USB specification ch9
>> + * Context: !in_interrupt()
>> + */
>>  void usb_gadget_set_state(struct usb_gadget *gadget,
>>                 enum usb_device_state state)
>>  {
>> +       struct usb_udc          *udc = NULL;
>> +
>>         gadget->state = state;
>>         sysfs_notify(&gadget->dev.kobj, NULL, "status");
>> +
>> +       mutex_lock(&udc_lock);
>> +       list_for_each_entry(udc, &udc_list, list)
>> +               if (udc->gadget == gadget)
>> +                       goto found;
>> +
>> +       dev_err(gadget->dev.parent, "gadget not registered.\n");
>> +       mutex_unlock(&udc_lock);
>> +       return;
>> +
>> +found:
>> +       mutex_unlock(&udc_lock);
>> +       kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
>
> I really don't like adding kobject change events, as they usually never
> get listened to, and there are other ways to get this information from
> userspace, right?
>
> Why do you need/want this?  What is it going to be used for?  What tools
> will use it?  How will they use it?
>
> And why can't the existing notification events for gadget devices work
> for you?
>
> thanks,
>
> greg k-h
