Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaLASWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:22:07 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:32910 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbaLASWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:22:06 -0500
MIME-Version: 1.0
In-Reply-To: <1417100556-7096-1-git-send-email-mathieu.magnaudet@enac.fr>
References: <1417100556-7096-1-git-send-email-mathieu.magnaudet@enac.fr>
Date: Mon, 1 Dec 2014 13:22:04 -0500
Message-ID: <CAN+gG=GZXNABPzFA=ivfoJDzd-=2X7t7FoQDGfo6g1b4bfwihA@mail.gmail.com>
Subject: Re: [PATCH] hid: export hid_report_len as an inline function in hid.h
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Mathieu Magnaudet <mathieu.magnaudet@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 10:02 AM, Mathieu Magnaudet
<mathieu.magnaudet@gmail.com> wrote:
> in several hid drivers it is necessary to calculate the length
> of an hid_report. This patch exports the existing static function
> hid_report_len of hid-core.c as an inline function in hid.h
>
> Signed-off-by: Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
> ---

IIRC, there are a few more custom report length computations
throughout the HID tree. They are not straightforward to convert, so I
think we have a pretty good start here.

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

Thanks Mathieu!

Cheers,
Benjamin

>  drivers/hid/hid-core.c        |  6 ------
>  drivers/hid/hid-input.c       |  2 +-
>  drivers/hid/hid-multitouch.c  |  2 +-
>  drivers/hid/usbhid/hid-core.c |  3 +--
>  drivers/hid/wacom_sys.c       |  8 +-------
>  include/linux/hid.h           | 11 +++++++++++
>  6 files changed, 15 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 0ad2ac0..c3d0ac1 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1282,12 +1282,6 @@ void hid_output_report(struct hid_report *report, __u8 *data)
>  }
>  EXPORT_SYMBOL_GPL(hid_output_report);
>
> -static int hid_report_len(struct hid_report *report)
> -{
> -       /* equivalent to DIV_ROUND_UP(report->size, 8) + !!(report->id > 0) */
> -       return ((report->size - 1) >> 3) + 1 + (report->id > 0);
> -}
> -
>  /*
>   * Allocator for buffer that is going to be passed to hid_output_report()
>   */
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index be3eba8..e0a0f06 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1215,7 +1215,7 @@ static void hidinput_led_worker(struct work_struct *work)
>                 return hid->ll_driver->request(hid, report, HID_REQ_SET_REPORT);
>
>         /* fall back to generic raw-output-report */
> -       len = ((report->size - 1) >> 3) + 1 + (report->id > 0);
> +       len = hid_report_len(report);
>         buf = hid_alloc_report_buf(report, GFP_KERNEL);
>         if (!buf)
>                 return;
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 683cda6..f65e78b 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -827,7 +827,7 @@ static void mt_set_input_mode(struct hid_device *hdev)
>         r = re->report_id_hash[td->inputmode];
>         if (r) {
>                 if (cls->quirks & MT_QUIRK_FORCE_GET_FEATURE) {
> -                       report_len = ((r->size - 1) >> 3) + 1 + (r->id > 0);
> +                       report_len = hid_report_len(r);
>                         buf = hid_alloc_report_buf(r, GFP_KERNEL);
>                         if (!buf) {
>                                 hid_err(hdev, "failed to allocate buffer for report\n");
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 04e34b9..bfbe1be 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -340,8 +340,7 @@ static int hid_submit_out(struct hid_device *hid)
>         report = usbhid->out[usbhid->outtail].report;
>         raw_report = usbhid->out[usbhid->outtail].raw_report;
>
> -       usbhid->urbout->transfer_buffer_length = ((report->size - 1) >> 3) +
> -                                                1 + (report->id > 0);
> +       usbhid->urbout->transfer_buffer_length = hid_report_len(report);
>         usbhid->urbout->dev = hid_to_usb_dev(hid);
>         if (raw_report) {
>                 memcpy(usbhid->outbuf, raw_report,
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index eb55316..358880b 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -1328,12 +1328,6 @@ static void wacom_calculate_res(struct wacom_features *features)
>                                                     features->unitExpo);
>  }
>
> -static int wacom_hid_report_len(struct hid_report *report)
> -{
> -       /* equivalent to DIV_ROUND_UP(report->size, 8) + !!(report->id > 0) */
> -       return ((report->size - 1) >> 3) + 1 + (report->id > 0);
> -}
> -
>  static size_t wacom_compute_pktlen(struct hid_device *hdev)
>  {
>         struct hid_report_enum *report_enum;
> @@ -1343,7 +1337,7 @@ static size_t wacom_compute_pktlen(struct hid_device *hdev)
>         report_enum = hdev->report_enum + HID_INPUT_REPORT;
>
>         list_for_each_entry(report, &report_enum->report_list, list) {
> -               size_t report_size = wacom_hid_report_len(report);
> +               size_t report_size = hid_report_len(report);
>                 if (report_size > size)
>                         size = report_size;
>         }
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index d585d02..06c4607 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -1087,6 +1087,17 @@ static inline void hid_hw_wait(struct hid_device *hdev)
>                 hdev->ll_driver->wait(hdev);
>  }
>
> +/**
> + * hid_report_len - calculate the report length
> + *
> + * @report: the report we want to know the length
> + */
> +static inline int hid_report_len(struct hid_report *report)
> +{
> +       /* equivalent to DIV_ROUND_UP(report->size, 8) + !!(report->id > 0) */
> +       return ((report->size - 1) >> 3) + 1 + (report->id > 0);
> +}
> +
>  int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>                 int interrupt);
>
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
