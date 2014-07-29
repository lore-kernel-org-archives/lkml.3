Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaG2SMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:12:34 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55656 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaG2SMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <1406375969-4453-2-git-send-email-przemo@firszt.eu>
References: <1406375969-4453-1-git-send-email-przemo@firszt.eu>
	<1406375969-4453-2-git-send-email-przemo@firszt.eu>
Date: Tue, 29 Jul 2014 14:12:31 -0400
Message-ID: <CAN+gG=E37Ao_5gd=T+sRAPRZk5zX-d4-DQLDReH6SMw3TpOWGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input - wacom: Remove passing id for wacom_set_report
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 7:59 AM, Przemo Firszt <przemo@firszt.eu> wrote:
> Every call of wacom_set_report was passing "id" as a separate parameter
> and buffer also passed the same information. We can use first u8 of the
> buffer instead of "id"
>
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> ---

At first, I was not going to take this one without any other
approvers, because we had such a discussion in the hid subsystem about
the same problem with respect to hid_hw_raw_request().
But after a second thought, we control much things here, and this
patch would have saved me 30 min this morning while I was wondering
why your 1/2 fix was not working.

I'll take this through my patch submission to Dmitry.

Cheers,
Benjamin

>  drivers/hid/wacom_sys.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index 51437e2..db17198 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -36,13 +36,13 @@ static int wacom_get_report(struct hid_device *hdev, u8 type, u8 id,
>         return retval;
>  }
>
> -static int wacom_set_report(struct hid_device *hdev, u8 type, u8 id,
> -                           void *buf, size_t size, unsigned int retries)
> +static int wacom_set_report(struct hid_device *hdev, u8 type, u8 *buf,
> +                           size_t size, unsigned int retries)
>  {
>         int retval;
>
>         do {
> -               retval = hid_hw_raw_request(hdev, id, buf, size, type,
> +               retval = hid_hw_raw_request(hdev, buf[0], buf, size, type,
>                                 HID_REQ_SET_REPORT);
>         } while ((retval == -ETIMEDOUT || retval == -EPIPE) && --retries);
>
> @@ -251,8 +251,8 @@ static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
>                 rep_data[0] = report_id;
>                 rep_data[1] = mode;
>
> -               error = wacom_set_report(hdev, HID_FEATURE_REPORT,
> -                                        report_id, rep_data, length, 1);
> +               error = wacom_set_report(hdev, HID_FEATURE_REPORT, rep_data,
> +                                        length, 1);
>                 if (error >= 0)
>                         error = wacom_get_report(hdev, HID_FEATURE_REPORT,
>                                                  report_id, rep_data, length, 1);
> @@ -525,8 +525,8 @@ static int wacom_led_control(struct wacom *wacom)
>                 buf[4] = wacom->led.img_lum;
>         }
>
> -       retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
> -                                 WAC_CMD_LED_CONTROL, buf, 9, WAC_CMD_RETRIES);
> +       retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf, 9,
> +                                 WAC_CMD_RETRIES);
>         kfree(buf);
>
>         return retval;
> @@ -546,8 +546,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id,
>         /* Send 'start' command */
>         buf[0] = WAC_CMD_ICON_START;
>         buf[1] = 1;
> -       retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
> -                                 WAC_CMD_ICON_START, buf, 2, WAC_CMD_RETRIES);
> +       retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf, 2,
> +                                 WAC_CMD_RETRIES);
>         if (retval < 0)
>                 goto out;
>
> @@ -557,9 +557,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id,
>                 buf[2] = i;
>                 memcpy(buf + 3, img + i * chunk_len, chunk_len);
>
> -               retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
> -                                         WAC_CMD_ICON_XFER,
> -                                         buf, chunk_len + 3, WAC_CMD_RETRIES);
> +               retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf,
> +                                         chunk_len + 3, WAC_CMD_RETRIES);
>                 if (retval < 0)
>                         break;
>         }
> @@ -567,8 +566,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id,
>         /* Send 'stop' */
>         buf[0] = WAC_CMD_ICON_START;
>         buf[1] = 0;
> -       wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, WAC_CMD_ICON_START,
> -                        buf, 2, WAC_CMD_RETRIES);
> +       wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf, 2,
> +                        WAC_CMD_RETRIES);
>
>  out:
>         kfree(buf);
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
