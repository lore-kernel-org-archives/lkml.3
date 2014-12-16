Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaLPWNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:13:11 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:56149 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLPWNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:13:07 -0500
MIME-Version: 1.0
In-Reply-To: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Tue, 16 Dec 2014 17:13:05 -0500
Message-ID: <CAN+gG=F0HhzXQhsaHTEb5Hy2CVTsoOSopCt4grXFnSKt+tPsWw@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: logitech-hidpp: bail out if wtp_connect fails
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Peter Wu <peter@lekensteyn.nl>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 5:06 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> If wtp_connect() fails, that means most of the time that the device has
> been disconnected. Subsequent attempts to contact the device will fail
> too, so it's simpler to bail out earlier.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---

Jiri, Peter,

the logitech patches are queuing up really fast.
To keep track of them, I made a bundle on patchwork:
https://patchwork.kernel.org/bundle/bentiss/hid-logitech-hidpp/
(/me discovered a new tool to play with)

Right now, the patch "HID: logitech-hidpp: detect HID++ 2.0 errors
too" is waiting for Logitech's approval, and the 2 of this series need
review.

Peter, please tell me if I missed one patch.

Cheers,
Benjamin

>  drivers/hid/hid-logitech-hidpp.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index d008d71..c0fb5fe 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -914,24 +914,24 @@ static int wtp_allocate(struct hid_device *hdev, const struct hid_device_id *id)
>         return 0;
>  };
>
> -static void wtp_connect(struct hid_device *hdev, bool connected)
> +static int wtp_connect(struct hid_device *hdev, bool connected)
>  {
>         struct hidpp_device *hidpp = hid_get_drvdata(hdev);
>         struct wtp_data *wd = hidpp->private_data;
>         int ret;
>
>         if (!connected)
> -               return;
> +               return 0;
>
>         if (!wd->x_size) {
>                 ret = wtp_get_config(hidpp);
>                 if (ret) {
>                         hid_err(hdev, "Can not get wtp config: %d\n", ret);
> -                       return;
> +                       return ret;
>                 }
>         }
>
> -       hidpp_touchpad_set_raw_report_state(hidpp, wd->mt_feature_index,
> +       return hidpp_touchpad_set_raw_report_state(hidpp, wd->mt_feature_index,
>                         true, true);
>  }
>
> @@ -1115,8 +1115,11 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
>         struct input_dev *input;
>         char *name, *devm_name;
>
> -       if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
> -               wtp_connect(hdev, connected);
> +       if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
> +               ret = wtp_connect(hdev, connected);
> +               if (ret)
> +                       return;
> +       }
>
>         if (!connected || hidpp->delayed_input)
>                 return;
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
