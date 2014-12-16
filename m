Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaLPOxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:53:12 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:58463 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaLPOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:53:08 -0500
MIME-Version: 1.0
In-Reply-To: <1418691016-30681-3-git-send-email-peter@lekensteyn.nl>
References: <1418691016-30681-1-git-send-email-peter@lekensteyn.nl>
	<1418691016-30681-3-git-send-email-peter@lekensteyn.nl>
Date: Tue, 16 Dec 2014 09:53:07 -0500
Message-ID: <CAN+gG=HWqpy6MUfWvwBavk+EkmwbBiCCN0L1_i8H61WYRU0yGw@mail.gmail.com>
Subject: Re: [PATCH 2/3] HID: logitech-{dj,hidpp}: check report length
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Dec 15, 2014 at 7:50 PM, Peter Wu <peter@lekensteyn.nl> wrote:
> Malicious USB devices can send bogus reports smaller than the expected
> buffer size. Ensure that the length is valid to avoid reading out of
> bounds.
>
> For the old WTP, I do not have a HID descriptor so just check for the
> minimum length in hidpp_raw_event (this can be changed to an inequality
> later).

Actually you have it :)
All the DJ devices share the same report descriptors as they are
provided by hid-logitech-dj :)

Anyway, the problem here would be with the bluetooth touchpad T651
which sends its raw events over teh mouse (0x02) collection (hint:
there is a "< 21" in wtp_raw_event :-P )

>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
> Hi,
>
> If you know that the WTP report (ID 2) has a length of 2, then you can change
> "<" to "!=" and remove the paragraph from the commit message.

"<" should be kept for the reason above.

>
> Kind regards,
> Peter
> ---
>  drivers/hid/hid-logitech-dj.c    | 16 +++++++++++++++-
>  drivers/hid/hid-logitech-hidpp.c | 12 +++++++++---
>  2 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
> index c917ab6..5bc6d80 100644
> --- a/drivers/hid/hid-logitech-dj.c
> +++ b/drivers/hid/hid-logitech-dj.c
> @@ -962,10 +962,24 @@ static int logi_dj_raw_event(struct hid_device *hdev,
>
>         switch (data[0]) {
>         case REPORT_ID_DJ_SHORT:
> +               if (size != DJREPORT_SHORT_LENGTH) {
> +                       dev_err(&hdev->dev, "DJ report of bad size (%d)", size);
> +                       return false;
> +               }
>                 return logi_dj_dj_event(hdev, report, data, size);
>         case REPORT_ID_HIDPP_SHORT:
> -               /* intentional fallthrough */
> +               if (size != HIDPP_REPORT_SHORT_LENGTH) {
> +                       dev_err(&hdev->dev,
> +                               "Short HID++ report of bad size (%d)", size);
> +                       return false;
> +               }
> +               return logi_dj_hidpp_event(hdev, report, data, size);
>         case REPORT_ID_HIDPP_LONG:
> +               if (size != HIDPP_REPORT_LONG_LENGTH) {
> +                       dev_err(&hdev->dev,
> +                               "Long HID++ report of bad size (%d)", size);
> +                       return false;
> +               }

This hunk is good to me.

>                 return logi_dj_hidpp_event(hdev, report, data, size);
>         }
>
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index ae23dec..2315358 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -992,11 +992,17 @@ static int hidpp_raw_event(struct hid_device *hdev, struct hid_report *report,
>                         return 1;
>                 }
>                 return hidpp_raw_hidpp_event(hidpp, data, size);
> +       case 0x02:
> +               if (size < 2) {
> +                       hid_err(hdev, "Received HID report of bad size (%d)",
> +                               size);
> +                       return 1;
> +               }
> +               if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
> +                       return wtp_raw_event(hdev, data, size);
> +               return 1;
>         }
>
> -       if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
> -               return wtp_raw_event(hdev, data, size);

This one is OK, but I don't like it.

wtp_raw_event also expects long hid++ reports, and I'd prefer having
the raw_event() callback first checking on the generic hid++ reports,
and then addressing the various subclasses of devices.
After a better look at the code, it occurs that the actual code is
already pretty messed up.
wtp_raw_event() is called both in the generic hidpp_raw_event() and in
the specific hidpp_raw_hidpp_event().
This is IMO a design flaw and it should be fixed in a better way.

I'd better have:

- A check on the report size
- A call to the specific hidpp_raw_hidpp_event()
- if the previous does not return 1 (consumed event), then check on
all subclasses and call their specific raw_event.

Does that make sense?

If you agree, you can split the patch in 3, one for the -dj, one for
the -hidpp checks, and one for the redesign. I'd be happy to make the
redesign if you do not want to reshuffle it in a third patch.

Cheers,
Benjamin

> -
>         return 0;
>  }
>
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
