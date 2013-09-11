Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3IKUJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:09:13 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42781 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3IKUJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:09:09 -0400
MIME-Version: 1.0
In-Reply-To: <1378929419-6269-10-git-send-email-benjamin.tissoires@redhat.com>
References: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
	<1378929419-6269-10-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 11 Sep 2013 13:09:09 -0700
X-Google-Sender-Auth: hPeETm7RhdsuTxa7F3U5AHc5Cgg
Message-ID: <CAGXu5jK0qTdoVTVRks8EMR3k-1p44aGJGYOBac-ck=8Hb0XVYQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/10] HID: multitouch: validate indexes details
From: Kees Cook <keescook@chromium.org>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 12:56 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> When working on report indexes, always validate that they are in bounds.
> Without this, a HID device could report a malicious feature report that
> could trick the driver into a heap overflow:
>
> [  634.885003] usb 1-1: New USB device found, idVendor=0596, idProduct=0500
> ...
> [  676.469629] BUG kmalloc-192 (Tainted: G        W   ): Redzone overwritten
>
> Note that we need to change the indexes from s8 to s16 as they can
> be between -1 and 255.
>
> CVE-2013-2897
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Kees Cook <keescook@chromium.org>

> ---
> v3:
>  - extract from hid-multitouch the generic checks so that every hid drivers will
>    benefit from them
>  - change __s8 index declarations into __s16
>  - use usage_index for the input_mode index instead of a half working code
>  - check the indexes validities only once
>
>  drivers/hid/hid-multitouch.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index ac28f08..5e5fe1b 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -101,9 +101,9 @@ struct mt_device {
>         unsigned last_slot_field;       /* the last field of a slot */
>         unsigned mt_report_id;  /* the report ID of the multitouch device */
>         unsigned pen_report_id; /* the report ID of the pen device */
> -       __s8 inputmode;         /* InputMode HID feature, -1 if non-existent */
> -       __s8 inputmode_index;   /* InputMode HID feature index in the report */
> -       __s8 maxcontact_report_id;      /* Maximum Contact Number HID feature,
> +       __s16 inputmode;        /* InputMode HID feature, -1 if non-existent */
> +       __s16 inputmode_index;  /* InputMode HID feature index in the report */
> +       __s16 maxcontact_report_id;     /* Maximum Contact Number HID feature,
>                                    -1 if non-existent */
>         __u8 num_received;      /* how many contacts we received */
>         __u8 num_expected;      /* expected last contact index */
> @@ -312,20 +312,18 @@ static void mt_feature_mapping(struct hid_device *hdev,
>                 struct hid_field *field, struct hid_usage *usage)
>  {
>         struct mt_device *td = hid_get_drvdata(hdev);
> -       int i;
>
>         switch (usage->hid) {
>         case HID_DG_INPUTMODE:
> -               td->inputmode = field->report->id;
> -               td->inputmode_index = 0; /* has to be updated below */
> -
> -               for (i=0; i < field->maxusage; i++) {
> -                       if (field->usage[i].hid == usage->hid) {
> -                               td->inputmode_index = i;
> -                               break;
> -                       }
> +               /* Ignore if value index is out of bounds. */
> +               if (usage->usage_index >= field->report_count) {
> +                       dev_err(&hdev->dev, "HID_DG_INPUTMODE out of range\n");
> +                       break;
>                 }
>
> +               td->inputmode = field->report->id;
> +               td->inputmode_index = usage->usage_index;
> +
>                 break;
>         case HID_DG_CONTACTMAX:
>                 td->maxcontact_report_id = field->report->id;
> @@ -511,6 +509,10 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>                         mt_store_field(usage, td, hi);
>                         return 1;
>                 case HID_DG_CONTACTCOUNT:
> +                       /* Ignore if indexes are out of bounds. */
> +                       if (field->index >= field->report->maxfield ||
> +                           usage->usage_index >= field->report_count)
> +                               return 1;
>                         td->cc_index = field->index;
>                         td->cc_value_index = usage->usage_index;
>                         return 1;
> --
> 1.8.3.1
>



-- 
Kees Cook
Chrome OS Security
