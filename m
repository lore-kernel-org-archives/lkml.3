Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaBCQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:09:59 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34994 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaBCQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:09:57 -0500
MIME-Version: 1.0
In-Reply-To: <1391316630-29541-9-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-9-git-send-email-benjamin.tissoires@redhat.com>
Date: Mon, 3 Feb 2014 17:09:56 +0100
Message-ID: <CANq1E4RkkaHy=_fuYZr74g-=f_2mTWmN94hvq+kLz-GAaTyhFA@mail.gmail.com>
Subject: Re: [PATCH 08/11] HID: usbhid: remove duplicated code
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Frank Praznik <frank.praznik@oh.rr.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Well, no use to keep twice the same code.

Yepp, I actually copied the code from that, so this is fine.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/usbhid/hid-core.c | 64 ++++++++-----------------------------------
>  1 file changed, 11 insertions(+), 53 deletions(-)
>
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index f8ca312..406497b 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -915,59 +915,6 @@ static int usbhid_set_raw_report(struct hid_device *hid, unsigned int reportnum,
>         return ret;
>  }
>
> -
> -static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t count,
> -               unsigned char report_type)
> -{
> -       struct usbhid_device *usbhid = hid->driver_data;
> -       struct usb_device *dev = hid_to_usb_dev(hid);
> -       struct usb_interface *intf = usbhid->intf;
> -       struct usb_host_interface *interface = intf->cur_altsetting;
> -       int ret;
> -
> -       if (usbhid->urbout && report_type != HID_FEATURE_REPORT) {
> -               int actual_length;
> -               int skipped_report_id = 0;
> -
> -               if (buf[0] == 0x0) {
> -                       /* Don't send the Report ID */
> -                       buf++;
> -                       count--;
> -                       skipped_report_id = 1;
> -               }
> -               ret = usb_interrupt_msg(dev, usbhid->urbout->pipe,
> -                       buf, count, &actual_length,
> -                       USB_CTRL_SET_TIMEOUT);
> -               /* return the number of bytes transferred */
> -               if (ret == 0) {
> -                       ret = actual_length;
> -                       /* count also the report id */
> -                       if (skipped_report_id)
> -                               ret++;
> -               }
> -       } else {
> -               int skipped_report_id = 0;
> -               int report_id = buf[0];
> -               if (buf[0] == 0x0) {
> -                       /* Don't send the Report ID */
> -                       buf++;
> -                       count--;
> -                       skipped_report_id = 1;
> -               }
> -               ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> -                       HID_REQ_SET_REPORT,
> -                       USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> -                       ((report_type + 1) << 8) | report_id,
> -                       interface->desc.bInterfaceNumber, buf, count,
> -                       USB_CTRL_SET_TIMEOUT);
> -               /* count also the report id, if this was a numbered report. */
> -               if (ret > 0 && skipped_report_id)
> -                       ret++;
> -       }
> -
> -       return ret;
> -}
> -
>  static int usbhid_output_report(struct hid_device *hid, __u8 *buf, size_t count)
>  {
>         struct usbhid_device *usbhid = hid->driver_data;
> @@ -998,6 +945,17 @@ static int usbhid_output_report(struct hid_device *hid, __u8 *buf, size_t count)
>         return ret;
>  }
>
> +static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf,
> +               size_t count, unsigned char report_type)
> +{
> +       struct usbhid_device *usbhid = hid->driver_data;
> +
> +       if (usbhid->urbout && report_type != HID_FEATURE_REPORT)
> +               return usbhid_output_report(hid, buf, count);
> +
> +       return usbhid_set_raw_report(hid, buf[0], buf, count, report_type);
> +}
> +
>  static void usbhid_restart_queues(struct usbhid_device *usbhid)
>  {
>         if (usbhid->urbout && !test_bit(HID_OUT_RUNNING, &usbhid->iofl))
> --
> 1.8.3.1
>
