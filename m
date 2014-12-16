Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaLPWAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:00:09 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:53241 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaLPWAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:00:07 -0500
MIME-Version: 1.0
In-Reply-To: <1418745323-17133-3-git-send-email-peter@lekensteyn.nl>
References: <CAN+gG=EL0kYim=_uaS4yj7c_XC8rKa1eELxpVXaOuvnWgT_eQw@mail.gmail.com>
	<1418745323-17133-1-git-send-email-peter@lekensteyn.nl>
	<1418745323-17133-3-git-send-email-peter@lekensteyn.nl>
Date: Tue, 16 Dec 2014 17:00:06 -0500
Message-ID: <CAN+gG=GhJx38LDwAGoPA1BpYOmjS8r_xnYPXWOgB66VLwmv5kg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] HID: logitech-hidpp: separate HID++ from WTP processing
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:55 AM, Peter Wu <peter@lekensteyn.nl> wrote:
> Previously wtp_raw_event would be called through
> hidpp_raw_hidpp_event (for the touchpad report) and hidpp_raw_event
> (for the mouse report).
>
> This patch removes one calling surface, making a clearer distinction
> between "generic HID++ processing" (matching internal reports) and
> device-specific event processing.
>
> Suggested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  v1: patch 2/3 HID: logitech-{dj,hidpp}: check report length
>  v2: splitted original report length check patch. Restructured code.
> ---

The patch is good per-se (and I tested the whole series BTW).

I just have a minor cosmetic comment.

If you feel like sending a v3, go ahead, otherwise, this patch is
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

>  drivers/hid/hid-logitech-hidpp.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index 2f1b0ac..3dcd59c 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -942,7 +942,7 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
>
>         /*
>          * If the mutex is locked then we have a pending answer from a
> -        * previoulsly sent command
> +        * previously sent command.
>          */
>         if (unlikely(mutex_is_locked(&hidpp->send_mutex))) {
>                 /*
> @@ -973,9 +973,6 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
>                 return 1;
>         }
>
> -       if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
> -               return wtp_raw_event(hidpp->hid_dev, data, size);
> -
>         return 0;
>  }
>
> @@ -983,7 +980,9 @@ static int hidpp_raw_event(struct hid_device *hdev, struct hid_report *report,
>                 u8 *data, int size)
>  {
>         struct hidpp_device *hidpp = hid_get_drvdata(hdev);
> +       int r = 0;

I'd rather have this variable named "ret".
2 reasons: that's how it is across the file, and I dislike variable
names with only one letter (except i, j, k, n, where this is obvious).

Cheers,
Benjamin

>
> +       /* Generic HID++ processing. */
>         switch (data[0]) {
>         case REPORT_ID_HIDPP_LONG:
>                 if (size != HIDPP_REPORT_LONG_LENGTH) {
> @@ -991,16 +990,23 @@ static int hidpp_raw_event(struct hid_device *hdev, struct hid_report *report,
>                                 size);
>                         return 1;
>                 }
> -               return hidpp_raw_hidpp_event(hidpp, data, size);
> +               r = hidpp_raw_hidpp_event(hidpp, data, size);
> +               break;
>         case REPORT_ID_HIDPP_SHORT:
>                 if (size != HIDPP_REPORT_SHORT_LENGTH) {
>                         hid_err(hdev, "received hid++ report of bad size (%d)",
>                                 size);
>                         return 1;
>                 }
> -               return hidpp_raw_hidpp_event(hidpp, data, size);
> +               r = hidpp_raw_hidpp_event(hidpp, data, size);
> +               break;
>         }
>
> +       /* If no report is available for further processing, skip calling
> +        * raw_event of subclasses. */
> +       if (r != 0)
> +               return r;
> +
>         if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
>                 return wtp_raw_event(hdev, data, size);
>
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
