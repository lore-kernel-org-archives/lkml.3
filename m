Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaCGJrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:47:51 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61619 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaCGJrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:47:48 -0500
MIME-Version: 1.0
In-Reply-To: <1394054334-20438-2-git-send-email-benjamin.tissoires@redhat.com>
References: <1394054334-20438-1-git-send-email-benjamin.tissoires@redhat.com>
	<1394054334-20438-2-git-send-email-benjamin.tissoires@redhat.com>
Date: Fri, 7 Mar 2014 10:47:47 +0100
Message-ID: <CANq1E4T_Xm7xCb5vGKBsb1EH-h6g4V-L9mrjZxThWa-GdtbPhQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] HID: cp2112: remove various hid_out_raw_report calls
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        David Barksdale <dbarksdale@uplogix.com>, Antonio Ospite <ao2@ao2.it>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Mar 5, 2014 at 10:18 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> hid_out_raw_report is going to be obsoleted as it is not part of the
> unified HID low level transport documentation
> (Documentation/hid/hid-transport.txt)
>
>   hid_output_raw_report(hdev, buf, sizeof(buf), HID_FEATURE_REPORT);
> is strictly equivalent to:
>   hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
>                 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);

This time you might be right that feature-reports always put the
report-id into the first byte, but I'd still prefer if we avoid using
this. Besides, the code is much nicer imho if we pass the ID directly,
see below..

>
> So use the new api.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>
> no changes since v1
>
>  drivers/hid/hid-cp2112.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
> index 1025982..860db694 100644
> --- a/drivers/hid/hid-cp2112.c
> +++ b/drivers/hid/hid-cp2112.c
> @@ -185,8 +185,8 @@ static int cp2112_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
>         buf[1] &= ~(1 << offset);
>         buf[2] = gpio_push_pull;
>
> -       ret = hdev->hid_output_raw_report(hdev, buf, sizeof(buf),
> -                                         HID_FEATURE_REPORT);
> +       ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
> +                                HID_FEATURE_REPORT, HID_REQ_SET_REPORT);

buf[0] => CP2112_GPIO_CONFIG

>         if (ret < 0) {
>                 hid_err(hdev, "error setting GPIO config: %d\n", ret);
>                 return ret;
> @@ -207,8 +207,8 @@ static void cp2112_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>         buf[1] = value ? 0xff : 0;
>         buf[2] = 1 << offset;
>
> -       ret = hdev->hid_output_raw_report(hdev, buf, sizeof(buf),
> -                                         HID_FEATURE_REPORT);
> +       ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
> +                                HID_FEATURE_REPORT, HID_REQ_SET_REPORT);

Here buf[0] seems fine as it is set explicitly just 3 lines above to
CP2112_GPIO_SET.

>         if (ret < 0)
>                 hid_err(hdev, "error setting GPIO values: %d\n", ret);
>  }
> @@ -253,8 +253,8 @@ static int cp2112_gpio_direction_output(struct gpio_chip *chip,
>         buf[1] |= 1 << offset;
>         buf[2] = gpio_push_pull;
>
> -       ret = hdev->hid_output_raw_report(hdev, buf, sizeof(buf),
> -                                         HID_FEATURE_REPORT);
> +       ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
> +                                HID_FEATURE_REPORT, HID_REQ_SET_REPORT);

Here an explicit CP2112_GPIO_CONFIG seems nicer, imho.

Thanks
David

>         if (ret < 0) {
>                 hid_err(hdev, "error setting GPIO config: %d\n", ret);
>                 return ret;
> --
> 1.8.5.3
>
