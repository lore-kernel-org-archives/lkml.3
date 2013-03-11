Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3CKQer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:34:47 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:55253 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3CKQep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1303111206100.2246-100000@iolanthe.rowland.org>
References: <CACVXFVN6zm2gG4v1jhV=8EwAtKs=bg3urJ7dRiOgPGHtKXHYxA@mail.gmail.com>
	<Pine.LNX.4.44L0.1303111206100.2246-100000@iolanthe.rowland.org>
Date: Tue, 12 Mar 2013 00:34:44 +0800
Message-ID: <CACVXFVOwjHOSd=VeJSKDHOCp5vveLVx8ZnLby4fnW4GeHEnu-g@mail.gmail.com>
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot
 reset a storage device
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 12:08 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 11 Mar 2013, Ming Lei wrote:
>
>> On Mon, Mar 11, 2013 at 11:32 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> >
>> > Of course you have to lock the device before changing its driver.  What
>> > would happen if two different threads tried to change a device's driver
>> > at the same time?
>>
>> Yes, claim/release interface need device lock, but the patch doesn't
>> touch claim/release command handling.
>
> Then why did you ask?  You wrote: "Looks device lock isn't required for
> USB transfer of kernel driver."

Maybe I didn't expressed clearly, sorry. Here the USB transfer means
URBs submitting.

>
>
>> > usbdev_do_ioctl() needs to acquire the device lock in order to prevent
>> > races with driver_disconnect() and usbdev_remove().
>>
>> Looks the patch basically converts the allocation inside URB submit path,
>> and actually I mean why we need to hold device lock in submitting
>> URB path?  Device lock isn't required before submitting URBs
>> in kernel driver.
>
> In general it isn't, no.  But usbfs uses the lock to prevent races with
> driver_disconnect() -- it is invalid to submit URBs after the
> disconnect routine has returned.

If so, we may introduce another lock to avoid the race.

So I think we may figure out to decrease the device lock
scope in devio.c, and most of ioctl commands might not require it
at all, then the problem addressed by the patch can be fixed too.


Thanks,
-- 
Ming Lei
