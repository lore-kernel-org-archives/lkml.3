Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab3ILMjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:39:17 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:58509 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3ILMjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:39:15 -0400
MIME-Version: 1.0
In-Reply-To: <1378929419-6269-4-git-send-email-benjamin.tissoires@redhat.com>
References: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
	<1378929419-6269-4-git-send-email-benjamin.tissoires@redhat.com>
Date: Thu, 12 Sep 2013 08:39:14 -0400
X-Google-Sender-Auth: HyVz9qcZw9Jfb_1Bt3JhTqHqNBQ
Message-ID: <CA+5PVA5LAzseeqv_OGPX57tnq+16smZRv72fZ=H_GN9BegDXcQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/10] HID: sony: validate HID output report details
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 3:56 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> From: Kees Cook <keescook@chromium.org>
>
> This driver must validate the availability of the HID output report and
> its size before it can write LED states via buzz_set_leds(). This stops
> a heap overflow that is possible if a device provides a malicious HID
> output report:
>
> [  108.171280] usb 1-1: New USB device found, idVendor=054c, idProduct=0002
> ...
> [  117.507877] BUG kmalloc-192 (Not tainted): Redzone overwritten
>
> CVE-2013-2890
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

As far as I know, this should be Cc: stable@vger.kernel.org #3.11, correct?

josh

> ---
> v3:
>  - no changes
>
>  drivers/hid/hid-sony.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
> index 30dbb6b..b18320d 100644
> --- a/drivers/hid/hid-sony.c
> +++ b/drivers/hid/hid-sony.c
> @@ -537,6 +537,10 @@ static int buzz_init(struct hid_device *hdev)
>         drv_data = hid_get_drvdata(hdev);
>         BUG_ON(!(drv_data->quirks & BUZZ_CONTROLLER));
>
> +       /* Validate expected report characteristics. */
> +       if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, 0, 0, 7))
> +               return -ENODEV;
> +
>         buzz = kzalloc(sizeof(*buzz), GFP_KERNEL);
>         if (!buzz) {
>                 hid_err(hdev, "Insufficient memory, cannot allocate driver data\n");
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
