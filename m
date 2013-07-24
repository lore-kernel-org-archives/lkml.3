Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3GXJLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 05:11:33 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:36749 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3GXJLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130717163548.GA14999@kroah.com>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
 <20130715165209.GA6000@kroah.com> <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
 <20130716063117.GA30320@kroah.com> <20130717075706.GC5291@arwen.pp.htv.fi> <20130717163548.GA14999@kroah.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 24 Jul 2013 17:11:09 +0800
Message-ID: <CAGsJ_4zQ_mAAHhM6Lb+4VxAMuJowxpoh8edNBhzxCP2Z_C_g+A@mail.gmail.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, Rong Wang <wr011235813@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rong.Wang@csr.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/18 Greg KH <gregkh@linuxfoundation.org>:
> On Wed, Jul 17, 2013 at 10:57:06AM +0300, Felipe Balbi wrote:
>> Hi,
>>
>> On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
>> > > The question is since we default GADGET, so the g_mass_storage.ko is
>> > > installed early but connecting to a host PC
>> > > is randomly, But the udev has no idea when a host PC connects our device.
>> > >
>> > > So we consider it's reasonable to let the udev know the GADGET device state.
>> > > Is there any alternative to our question?
>> >
>> > I thought we already export events for gadget device states, have you
>> > looked for them?  I can't dig through the code at the moment, but this
>> > seems like a pretty common issue...
>> >
>> > Felipe, any ideas?
>>
>> we already expose that in sysfs. IIRC udev can act on sysfs changes,
>> no ?
>
> If something is polling the sysfs file, yes.  If not, a change event
> should be sent to notify people that they need to go re-read it as
> something major happened (laptop docked, disk got removed, device
> changed state, etc.)

sysfs_notify() should be a mechinism to permit userspace to
poll()/select() the sysfs file if users want to . for example, if an
user cares about sysfs changes, he can do:

res = select(sysfd+1,
             NULL,               // readfds - not needed
             NULL,               // writefds - not needed
             &exceptfds,
             NULL);              // timeout (never)

if (res > 0 && FD_ISSET(sysfd, &exceptfds))
{

}

i didn't see udev can poll sysfs node which will change value
dynamically. it depends on 3rd applications to do that. and i also
didn't find we can define a udev rule to monitor sysfs change.

so the benefit of this patch here is that if we send uevent, we can
easily define a rule in udev to switch the file_storage partition to
target board or PC dynamically. this is a very popular user scenerios
actually, considering a phone, the SD card is mounted to mobilephone
at first, then after we connect the phone to PC, the SD is given to
PC, after we disconnect, the partition will be given back to phone.

we did see Android have done similar patch in its tree. so i would
suggest we continue to work on rong's patch and make it visible in
mainline.

>
> thanks,
>
> greg k-h

-barry
