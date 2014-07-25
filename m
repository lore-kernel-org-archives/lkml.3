Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbaGYTG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:06:56 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62357 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760913AbaGYTGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:06:55 -0400
MIME-Version: 1.0
In-Reply-To: <1406265181-4009-1-git-send-email-reyad.attiyat@gmail.com>
References: <1406265181-4009-1-git-send-email-reyad.attiyat@gmail.com>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Fri, 25 Jul 2014 14:06:32 -0500
Message-ID: <CA+BWVUSiQak2Sc-H3hAEjgyVwZFVGbGv+3B1z8B3k3vdWm40VA@mail.gmail.com>
Subject: Re: [PATCH] hid: usbhid: Use flag HID_DISCONNECTED when a usb device
 is removed
To: linux-input <linux-input@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel panic happened when the iio sensor hid usb device was
removed. It tries to set the power state by calling hid_hw_request().
This was on kernel 3.16-rc6
https://gist.github.com/soda0289/2ff543d9cfff6f92c360#file-kernel-panic-when-iio-sensor-usb-device-is-removed

On Fri, Jul 25, 2014 at 12:13 AM, Reyad Attiyat <reyad.attiyat@gmail.com> wrote:
> Set disconnected flag in struct usbhid when a usb device
> is removed. Check for disconnected flag before sending urb
> requests. This prevents a kernel panic when a hid driver calls
> hid_hw_request() after removing a usb device.
>
> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> ---
>  drivers/hid/usbhid/hid-core.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 7b88f4c..c8fa957 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -536,7 +536,8 @@ static void __usbhid_submit_report(struct hid_device *hid, struct hid_report *re
>         int head;
>         struct usbhid_device *usbhid = hid->driver_data;
>
> -       if ((hid->quirks & HID_QUIRK_NOGET) && dir == USB_DIR_IN)
> +       if (((hid->quirks & HID_QUIRK_NOGET) && dir == USB_DIR_IN) ||
> +               test_bit(HID_DISCONNECTED, &usbhid->iofl))
>                 return;
>
>         if (usbhid->urbout && dir == USB_DIR_OUT && report->type == HID_OUTPUT_REPORT) {
> @@ -1366,6 +1367,9 @@ static void usbhid_disconnect(struct usb_interface *intf)
>                 return;
>
>         usbhid = hid->driver_data;
> +       spin_lock_irq(&usbhid->lock);   /* Sync with error and led handlers */
> +       set_bit(HID_DISCONNECTED, &usbhid->iofl);
> +       spin_unlock_irq(&usbhid->lock);
>         hid_destroy_device(hid);
>         kfree(usbhid);
>  }
> --
> 1.9.3
>
