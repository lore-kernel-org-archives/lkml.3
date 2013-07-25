Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3GYHBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:01:37 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:61235 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3GYHBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:01:35 -0400
MIME-Version: 1.0
Date: Thu, 25 Jul 2013 12:31:34 +0530
X-Google-Sender-Auth: q8gqA4Of78N8FXUOQcOfml-qkbk
Message-ID: <CAPV97ycT=WF0Fy_+EZhwvCbFWvsdc1oWmHW_9iRL9xHtLhe5nQ@mail.gmail.com>
Subject: Re: [PATCH v4] staging: usbip: replace pr_warning() with dev_warn().
From: navin patidar <navinp@cdac.in>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: mfm@muteddisk.com, sergei.shtylyov@cogentembedded.com, joe@perches.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013, Greg KH <gregkh@linuxfoundation.org> said:

> On Thu, Jul 25, 2013 at 10:19:31AM +0530, navin patidar wrote:
>> >> -        pr_warning("Unable to start control thread\n");
>> >> +        struct device *dev;
>> >> +
>> >> +        if (ud->side == USBIP_STUB)
>> >> +            dev = &container_of(ud, struct stub_device, ud)->udev->dev;
>> >> +        else
>> >> +            dev = &container_of(ud, struct vhci_device, ud)->udev->dev;
>> >
>> > Putting '&' in front of container_of seems odd, are you sure it's needed
>> > here?  If ud is a pointer, everything else should "just work" properly
>> > without that.
>>
>> Removing '&'   caused following error.
>> drivers/staging/usbip/usbip_event.c: In function ‘usbip_start_eh’:
>> drivers/staging/usbip/usbip_event.c:93:8: error: incompatible types
>> when assigning to type ‘struct device *’ from type ‘struct device’
>> drivers/staging/usbip/usbip_event.c:95:8: error: incompatible types
>> when assigning to type ‘struct device *’ from type ‘struct device’
>>
>> dev needs to be initialized with address of dev (struct device ) which
>> is member of struct usb_device pointed by the udev.
>>
>> To make it more clear i can change it to
>>
>> dev = &(container_of(ud, struct vhci_device, ud)->udev->dev);
>>
>>  or
>>
>> struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
>> dev = &(vdev->udev->dev);
>
> Or perhaps:
>     dev = container_of(ud, struct stub_device, ud).udev->dev;

 container_of() returns stub_device pointer so "container_of(ud,
struct stub_device, ud).udev->dev"  won't  work.

> or ->udev.dev; I don't remember which, but that should work, right?
udev is also a pointer to usb_device structure inside  stub_device structure.
    ->udev->dev   only will work.

v4 patch gets compiled without any error or warning.
and actually Joe Perches reviewed v3 of the patch and suggested changes.
https://lkml.org/lkml/2013/6/27/15

regards,
--navin-patidar
