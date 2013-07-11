Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3GKOCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:02:11 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:38461 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab3GKOCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <1373550090-30379-2-git-send-email-benjamin.tissoires@redhat.com>
References: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com>
	<1373550090-30379-2-git-send-email-benjamin.tissoires@redhat.com>
Date: Thu, 11 Jul 2013 16:02:08 +0200
Message-ID: <CANq1E4Tx7cVkWmZHtLvtW4U78uedEUe4Qs40aeyzRORmEBTPBg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Bluetooth: hidp: implement hidinput_input_event callback
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>, Jiri Kosina <jkosina@suse.cz>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jul 11, 2013 at 3:41 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> We can re-enable hidinput_input_event to allow the leds of bluetooth
> keyboards to be set.
> Now the callbacks uses hid core to retrieve the right HID report to
> send, so this version is safer.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  net/bluetooth/hidp/core.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index f13a8da..9c8b50d 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -238,6 +238,31 @@ static int hidp_send_report(struct hidp_session *session, struct hid_report *rep
>         return hidp_send_intr_message(session, hdr, buf, rsize);
>  }
>
> +static int hidp_hidinput_event(struct input_dev *dev, unsigned int type,
> +                              unsigned int code, int value)
> +{
> +       struct hid_device *hid = input_get_drvdata(dev);

I dislike that we have to deal with input_get_drvdata() in a transport
driver. It is not obvious from the transport driver that this gives us
an hid_device. But ok, that's how we do it in usbhid and hid-input so
it's another issue..

> +       struct hidp_session *session = hid->driver_data;
> +       struct hid_field *field;
> +       int offset;
> +
> +       BT_DBG("session %p type %d code %d value %d",
> +              session, type, code, value);
> +
> +       if (type != EV_LED)
> +               return -1;
> +
> +       offset = hidinput_find_field(hid, type, code, &field);
> +       if (offset == -1) {
> +               hid_warn(dev, "event field not found\n");
> +               return -1;
> +       }
> +
> +       hid_set_field(field, offset, value);
> +
> +       return hidp_send_report(session, field->report);
> +}
> +

We had this discussion before (regarding uhid and hidpinput_event), it
would be nice to have a helper in hid-input.c which does this. We copy
the code into every transport driver, which bugs me. But no-one
stepped up to do this, so I am fine.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks!
David

>  static int hidp_get_raw_report(struct hid_device *hid,
>                 unsigned char report_number,
>                 unsigned char *data, size_t count,
> @@ -711,6 +736,7 @@ static struct hid_ll_driver hidp_hid_driver = {
>         .stop = hidp_stop,
>         .open  = hidp_open,
>         .close = hidp_close,
> +       .hidinput_input_event = hidp_hidinput_event,
>  };
>
>  /* This function sets up the hid device. It does not add it
> --
> 1.8.3.1
>
