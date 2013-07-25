Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3GYEtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:49:33 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39039 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3GYEtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:49:32 -0400
MIME-Version: 1.0
Date: Thu, 25 Jul 2013 10:19:31 +0530
X-Google-Sender-Auth: uTrphlu0fvwhYWwvXsqZxp2sP4w
Message-ID: <CAPV97ydVKFdRuKRkW12KNmoh8ZoN-XoX=vW8CjaBz-u386ZOiA@mail.gmail.com>
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

On Wed, Jul 24, 2013, Greg KH <gregkh@linuxfoundation.org> said:

> On Thu, Jun 27, 2013 at 03:34:52PM +0530, navin patidar wrote:
>> dev_warn() is preferred over pr_warning().
>>
>> container_of() is used to get usb_driver pointer from usbip_device container
>> (stub_device or vhci_device), to get device structure required for dev_warn().
>>
>> Signed-off-by: navin patidar <navinp@cdac.in>
>> ---
>>  drivers/staging/usbip/usbip_event.c |   11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
>> index 82123be..1f3a571 100644
>> --- a/drivers/staging/usbip/usbip_event.c
>> +++ b/drivers/staging/usbip/usbip_event.c
>> @@ -21,6 +21,8 @@
>>  #include <linux/export.h>
>>
>>  #include "usbip_common.h"
>> +#include "stub.h"
>> +#include "vhci.h"
>>
>>  static int event_handler(struct usbip_device *ud)
>>  {
>> @@ -85,7 +87,14 @@ int usbip_start_eh(struct usbip_device *ud)
>>
>>      ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
>>      if (IS_ERR(ud->eh)) {
>> -        pr_warning("Unable to start control thread\n");
>> +        struct device *dev;
>> +
>> +        if (ud->side == USBIP_STUB)
>> +            dev = &container_of(ud, struct stub_device, ud)->udev->dev;
>> +        else
>> +            dev = &container_of(ud, struct vhci_device, ud)->udev->dev;
>
> Putting '&' in front of container_of seems odd, are you sure it's needed
> here?  If ud is a pointer, everything else should "just work" properly
> without that.

Removing '&'   caused following error.
drivers/staging/usbip/usbip_event.c: In function ‘usbip_start_eh’:
drivers/staging/usbip/usbip_event.c:93:8: error: incompatible types
when assigning to type ‘struct device *’ from type ‘struct device’
drivers/staging/usbip/usbip_event.c:95:8: error: incompatible types
when assigning to type ‘struct device *’ from type ‘struct device’

dev needs to be initialized with address of dev (struct device ) which
is member of struct usb_device pointed by the udev.

To make it more clear i can change it to

dev = &(container_of(ud, struct vhci_device, ud)->udev->dev);

 or

struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
dev = &(vdev->udev->dev);

regards,
--navin-patidar
