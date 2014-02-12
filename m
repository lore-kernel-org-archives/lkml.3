Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaBLKfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:35:12 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:61138 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaBLKfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:35:09 -0500
MIME-Version: 1.0
In-Reply-To: <1392055139-19631-8-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
	<1392055139-19631-8-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 12 Feb 2014 11:35:08 +0100
Message-ID: <CANq1E4QvC936A_r6GPgO_gikpXGrD6UwBdBEcwUBwtjxW9iw6Q@mail.gmail.com>
Subject: Re: [PATCH 07/14] HID: input: hid-input remove hid_output_raw_report call
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Feb 10, 2014 at 6:58 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> hid_output_raw_report() is not a ll_driver callback and should not be used.
> To keep the same code path than before, we are forced to play with the
> different hid_hw_* calls: if the usb or i2c device does not support
> direct output reports, then we will rely on the SET_REPORT HID call.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-input.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index eb00a5b..6b7bdca 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1153,7 +1153,7 @@ static void hidinput_led_worker(struct work_struct *work)
>                                               led_work);
>         struct hid_field *field;
>         struct hid_report *report;
> -       int len;
> +       int len, ret;
>         __u8 *buf;
>
>         field = hidinput_get_led_field(hid);
> @@ -1187,7 +1187,10 @@ static void hidinput_led_worker(struct work_struct *work)
>
>         hid_output_report(report, buf);
>         /* synchronous output report */
> -       hid_output_raw_report(hid, buf, len, HID_OUTPUT_REPORT);
> +       ret = hid_hw_output_report(hid, buf, len);
> +       if (ret == -ENOSYS)
> +               hid_hw_raw_request(hid, buf[0], buf, len, HID_OUTPUT_REPORT,
> +                               HID_REQ_SET_REPORT);

Does HID core always set the report-id in buf[0]? Even if none are
used? I know the incoming data may lack the report-id, but I always
thought we do the same for outgoing if it's implicit?

I also already see devices with broken OUTPUT_REPORTs.. I guess at
some point we have to introduce a quirk-flag to choose between both
calls. But lets wait for that to happen, maybe we're lucky.

>         kfree(buf);
>  }
>
> @@ -1266,7 +1269,8 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
>         }
>
>         input_set_drvdata(input_dev, hid);
> -       if (hid->ll_driver->request || hid->hid_output_raw_report)
> +       if (hid->ll_driver->request || hid->ll_driver->output_report ||
> +           hid->ll_driver->raw_request)

Isn't raw_request mandatory? So we could remove that whole if() thing here.

Thanks
David

>                 input_dev->event = hidinput_input_event;
>         input_dev->open = hidinput_open;
>         input_dev->close = hidinput_close;
> --
> 1.8.3.1
>
