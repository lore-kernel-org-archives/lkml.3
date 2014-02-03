Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaBCQG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:06:56 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:59388 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaBCQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:06:54 -0500
MIME-Version: 1.0
In-Reply-To: <1391316630-29541-5-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-5-git-send-email-benjamin.tissoires@redhat.com>
Date: Mon, 3 Feb 2014 17:06:53 +0100
Message-ID: <CANq1E4Rn=rijG8Xv97okj2k4iv=ZG6wa30xQrxgjhutQovD+dg@mail.gmail.com>
Subject: Re: [PATCH 04/11] HID: logitech-dj: remove hidinput_input_event
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
> hid-logitech-dj uses its own ->hidinput_input_event() instead of
> the generic binding in hid-input.
> Moving the handling of LEDs towards logi_dj_output_hidraw_report()
> allows two things:
> - remove hidinput_input_event in struct hid_device
> - hidraw user space programs can also set the LEDs
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-logitech-dj.c | 99 +++++++++++++++----------------------------
>  1 file changed, 35 insertions(+), 64 deletions(-)
>
> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
> index f45279c..61d2bbf 100644
> --- a/drivers/hid/hid-logitech-dj.c
> +++ b/drivers/hid/hid-logitech-dj.c
> @@ -44,14 +44,6 @@ static const char kbd_descriptor[] = {
>         0x19, 0xE0,             /*   USAGE_MINIMUM (Left Control)   */
>         0x29, 0xE7,             /*   USAGE_MAXIMUM (Right GUI)      */
>         0x81, 0x02,             /*   INPUT (Data,Var,Abs)       */
> -       0x95, 0x05,             /*   REPORT COUNT (5)           */
> -       0x05, 0x08,             /*   USAGE PAGE (LED page)      */
> -       0x19, 0x01,             /*   USAGE MINIMUM (1)          */
> -       0x29, 0x05,             /*   USAGE MAXIMUM (5)          */
> -       0x91, 0x02,             /*   OUTPUT (Data, Variable, Absolute)  */
> -       0x95, 0x01,             /*   REPORT COUNT (1)           */
> -       0x75, 0x03,             /*   REPORT SIZE (3)            */
> -       0x91, 0x01,             /*   OUTPUT (Constant)          */
>         0x95, 0x06,             /*   REPORT_COUNT (6)           */
>         0x75, 0x08,             /*   REPORT_SIZE (8)            */
>         0x15, 0x00,             /*   LOGICAL_MINIMUM (0)        */
> @@ -60,6 +52,18 @@ static const char kbd_descriptor[] = {
>         0x19, 0x00,             /*   USAGE_MINIMUM (no event)       */
>         0x2A, 0xFF, 0x00,       /*   USAGE_MAXIMUM (reserved)       */
>         0x81, 0x00,             /*   INPUT (Data,Ary,Abs)       */
> +       0x85, 0x0e,             /* REPORT_ID (14)               */
> +       0x05, 0x08,             /*   USAGE PAGE (LED page)      */
> +       0x95, 0x05,             /*   REPORT COUNT (5)           */
> +       0x75, 0x01,             /*   REPORT SIZE (1)            */
> +       0x15, 0x00,             /*   LOGICAL_MINIMUM (0)        */
> +       0x25, 0x01,             /*   LOGICAL_MAXIMUM (1)        */
> +       0x19, 0x01,             /*   USAGE MINIMUM (1)          */
> +       0x29, 0x05,             /*   USAGE MAXIMUM (5)          */
> +       0x91, 0x02,             /*   OUTPUT (Data, Variable, Absolute)  */
> +       0x95, 0x01,             /*   REPORT COUNT (1)           */
> +       0x75, 0x03,             /*   REPORT SIZE (3)            */
> +       0x91, 0x01,             /*   OUTPUT (Constant)          */
>         0xC0
>  };
>
> @@ -544,10 +548,30 @@ static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
>                                         size_t count,
>                                         unsigned char report_type)
>  {
> -       /* Called by hid raw to send data */
> -       dbg_hid("%s\n", __func__);
> +       struct dj_device *djdev = hid->driver_data;
> +       struct dj_receiver_dev *djrcv_dev = djdev->dj_receiver_dev;
> +       u8 *out_buf;
> +       int ret;
>
> -       return 0;
> +       if (buf[0] != REPORT_TYPE_LEDS)
> +               return -EINVAL;
> +
> +       out_buf = kzalloc(DJREPORT_SHORT_LENGTH, GFP_ATOMIC);
> +       if (!out_buf)
> +               return -ENOMEM;
> +
> +       if (count < DJREPORT_SHORT_LENGTH - 2)
> +               count = DJREPORT_SHORT_LENGTH - 2;
> +
> +       out_buf[0] = REPORT_ID_DJ_SHORT;
> +       out_buf[1] = djdev->device_index;
> +       memcpy(out_buf + 2, buf, count);
> +
> +       ret = djrcv_dev->hdev->hid_output_raw_report(djrcv_dev->hdev, out_buf,
> +               DJREPORT_SHORT_LENGTH, report_type);

Strictly speaking the code below uses HID_REQ_SET_REPORT and you
replace it with hid_output_raw_report() here (which at least for BTHID
is not equivalent). Anyhow, HID-core uses hid_output_raw_report(),
too, so this should be fine.

Thanks
David

> +
> +       kfree(out_buf);
> +       return ret;
>  }
>
>  static void rdcat(char *rdesc, unsigned int *rsize, const char *data, unsigned int size)
> @@ -613,58 +637,6 @@ static int logi_dj_ll_parse(struct hid_device *hid)
>         return retval;
>  }
>
> -static int logi_dj_ll_input_event(struct input_dev *dev, unsigned int type,
> -                                 unsigned int code, int value)
> -{
> -       /* Sent by the input layer to handle leds and Force Feedback */
> -       struct hid_device *dj_hiddev = input_get_drvdata(dev);
> -       struct dj_device *dj_dev = dj_hiddev->driver_data;
> -
> -       struct dj_receiver_dev *djrcv_dev =
> -           dev_get_drvdata(dj_hiddev->dev.parent);
> -       struct hid_device *dj_rcv_hiddev = djrcv_dev->hdev;
> -       struct hid_report_enum *output_report_enum;
> -
> -       struct hid_field *field;
> -       struct hid_report *report;
> -       unsigned char *data;
> -       int offset;
> -
> -       dbg_hid("%s: %s, type:%d | code:%d | value:%d\n",
> -               __func__, dev->phys, type, code, value);
> -
> -       if (type != EV_LED)
> -               return -1;
> -
> -       offset = hidinput_find_field(dj_hiddev, type, code, &field);
> -
> -       if (offset == -1) {
> -               dev_warn(&dev->dev, "event field not found\n");
> -               return -1;
> -       }
> -       hid_set_field(field, offset, value);
> -
> -       data = hid_alloc_report_buf(field->report, GFP_ATOMIC);
> -       if (!data) {
> -               dev_warn(&dev->dev, "failed to allocate report buf memory\n");
> -               return -1;
> -       }
> -
> -       hid_output_report(field->report, &data[0]);
> -
> -       output_report_enum = &dj_rcv_hiddev->report_enum[HID_OUTPUT_REPORT];
> -       report = output_report_enum->report_id_hash[REPORT_ID_DJ_SHORT];
> -       hid_set_field(report->field[0], 0, dj_dev->device_index);
> -       hid_set_field(report->field[0], 1, REPORT_TYPE_LEDS);
> -       hid_set_field(report->field[0], 2, data[1]);
> -
> -       hid_hw_request(dj_rcv_hiddev, report, HID_REQ_SET_REPORT);
> -
> -       kfree(data);
> -
> -       return 0;
> -}
> -
>  static int logi_dj_ll_start(struct hid_device *hid)
>  {
>         dbg_hid("%s\n", __func__);
> @@ -683,7 +655,6 @@ static struct hid_ll_driver logi_dj_ll_driver = {
>         .stop = logi_dj_ll_stop,
>         .open = logi_dj_ll_open,
>         .close = logi_dj_ll_close,
> -       .hidinput_input_event = logi_dj_ll_input_event,
>  };
>
>
> --
> 1.8.3.1
>
