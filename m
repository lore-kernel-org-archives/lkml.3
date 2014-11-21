Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbaKUPhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:37:11 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:46866 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422AbaKUPhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:37:06 -0500
MIME-Version: 1.0
In-Reply-To: <1416422480-3241-1-git-send-email-mathieu.magnaudet@enac.fr>
References: <1416422480-3241-1-git-send-email-mathieu.magnaudet@enac.fr>
Date: Fri, 21 Nov 2014 10:37:05 -0500
Message-ID: <CAN+gG=EBQouDwm3f8ToT_O72tvY6=uPkR20cfsxZs38U86=EkA@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch: Add quirk for VTL touch panels
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

Hi Mathieu,

On Wed, Nov 19, 2014 at 1:41 PM, Mathieu Magnaudet
<mathieu.magnaudet@gmail.com> wrote:
> VTL panels do not switch to the multitouch mode until the input mode
> feature is read by the host. This should normally be done by
> usbhid, but it looks like an other bug prevents usbhid to properly
> retrieve the feature state. As a workaround, we force the reading of
> the feature in mt_set_input_mode for such devices.
>
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
> ---
>  drivers/hid/hid-ids.h        |  3 +++
>  drivers/hid/hid-multitouch.c | 27 +++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
>
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 7c86373..d6cc6a9 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -931,6 +931,9 @@
>  #define USB_DEVICE_ID_VERNIER_CYCLOPS  0x0004
>  #define USB_DEVICE_ID_VERNIER_LCSPEC   0x0006
>
> +#define USB_VENDOR_ID_VTL              0x0306
> +#define USB_DEVICE_ID_VTL_MULTITOUCH_FF3F      0xff3f
> +
>  #define USB_VENDOR_ID_WACOM            0x056a
>  #define USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH 0x81
>  #define USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH   0x00BD
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 51e25b9..a4bc111 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -67,6 +67,7 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_IGNORE_DUPLICATES     (1 << 10)
>  #define MT_QUIRK_HOVERING              (1 << 11)
>  #define MT_QUIRK_CONTACT_CNT_ACCURATE  (1 << 12)
> +#define MT_QUIRK_FORCE_GET_FEATURE     (1 << 13)
>
>  #define MT_INPUTMODE_TOUCHSCREEN       0x02
>  #define MT_INPUTMODE_TOUCHPAD          0x03
> @@ -150,6 +151,7 @@ static void mt_post_parse(struct mt_device *td);
>  #define MT_CLS_FLATFROG                                0x0107
>  #define MT_CLS_GENERALTOUCH_TWOFINGERS         0x0108
>  #define MT_CLS_GENERALTOUCH_PWT_TENFINGERS     0x0109
> +#define MT_CLS_VTL                             0x0110
>
>  #define MT_DEFAULT_MAXCONTACT  10
>  #define MT_MAX_MAXCONTACT      250
> @@ -255,6 +257,11 @@ static struct mt_class mt_classes[] = {
>                 .sn_move = 2048,
>                 .maxcontacts = 40,
>         },
> +       { .name = MT_CLS_VTL,
> +               .quirks = MT_QUIRK_ALWAYS_VALID |
> +                       MT_QUIRK_CONTACT_CNT_ACCURATE |
> +                       MT_QUIRK_FORCE_GET_FEATURE,
> +       },
>         { }
>  };
>
> @@ -809,6 +816,9 @@ static void mt_set_input_mode(struct hid_device *hdev)
>         struct mt_device *td = hid_get_drvdata(hdev);
>         struct hid_report *r;
>         struct hid_report_enum *re;
> +       struct mt_class *cls = &td->mtclass;
> +       char *buf;
> +       int report_len;
>
>         if (td->inputmode < 0)
>                 return;
> @@ -816,6 +826,18 @@ static void mt_set_input_mode(struct hid_device *hdev)
>         re = &(hdev->report_enum[HID_FEATURE_REPORT]);
>         r = re->report_id_hash[td->inputmode];
>         if (r) {
> +               if (cls->quirks & MT_QUIRK_FORCE_GET_FEATURE) {
> +                       report_len = ((r->size - 1) >> 3) + 1 + (r->id > 0);
> +                       buf = kzalloc(report_len, GFP_KERNEL);

Sorry for not spotting this earlier.
These 2 lines can be replaced by a call to hid_alloc_report_buf(r, GFP_KERNEL);

Cheers,
Benjamin

> +                       if (!buf) {
> +                               hid_err(hdev, "failed to allocate buffer for report\n");
> +                               return;
> +                       }
> +                       hid_hw_raw_request(hdev, r->id, buf, report_len,
> +                                          HID_FEATURE_REPORT,
> +                                          HID_REQ_GET_REPORT);
> +                       kfree(buf);
> +               }
>                 r->field[0]->value[td->inputmode_index] = td->inputmode_value;
>                 hid_hw_request(hdev, r, HID_REQ_SET_REPORT);
>         }
> @@ -1281,6 +1303,11 @@ static const struct hid_device_id mt_devices[] = {
>                 MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
>                         USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
>
> +       /* VTL panels */
> +       { .driver_data = MT_CLS_VTL,
> +               MT_USB_DEVICE(USB_VENDOR_ID_VTL,
> +                       USB_DEVICE_ID_VTL_MULTITOUCH_FF3F) },
> +
>         /* Wistron panels */
>         { .driver_data = MT_CLS_NSMU,
>                 MT_USB_DEVICE(USB_VENDOR_ID_WISTRON,
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
