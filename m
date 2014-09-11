Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaIKSIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 14:08:13 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:43847 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaIKSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 14:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAF8JNh+U80vPUQ7263cRGFJCZkzsO7nSAg3KOtfOy5Bsp_Xajw@mail.gmail.com>
References: <1410455644-11732-1-git-send-email-benjamin.tissoires@redhat.com>
	<CAF8JNh+U80vPUQ7263cRGFJCZkzsO7nSAg3KOtfOy5Bsp_Xajw@mail.gmail.com>
Date: Thu, 11 Sep 2014 11:08:04 -0700
Message-ID: <CAF8JNh+uckyW160F8QORrTLNq8GMcLrwA9WpW1AR8SL_nej1nA@mail.gmail.com>
Subject: Fwd: [PATCH] HID: wacom: make the WL connection friendly for the desktop
From: Ping Cheng <pinglinux@gmail.com>
To: linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:14 AM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Currently, tablets connected to the WL receiver all share the same
> VID/PID. There is no way for the user space to know which one is which
> besides parsing the name. We can force the PID to be set to the
> actual hardware. This way, the input device will have the correct PID
> which can be match in libwacom.


Nice job, Benjamin! Thank you, on behalf of wireless tablet users ;-).

>
> With only this trick, the pad input does not inherit the ID_INPUT_TABLET
> udev property from its parent. We can force udev to accept it by declaring
> a BTN_STYLUS which is never used.


BTN_STYLUS can be confusing to userland clients that retrieve it to
decide tool types. But, without it, the client is already confused
with joystick. So, unless we introduce a new tool type, which I
proposed a few years ago and was rejected, we may have to keep clients
confused. With that said, the patch is

>
> This way, tablets connected through WL can be used from the user point of
> view in the same way they are used while connected through wire.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>


Reviewed-by: Ping Cheng <pingc@wacom.com>

Cheers,

Ping

> ---
>
> Hi guys,
>
> to continue on Ping's work regarding the Wireless reciever, here is a patch
> which allows to have the same user experience regardless the transport layer.
> Unfortunately, a libwacom patch is also required, but once both are applied,
> there is no differences between the wired and wireless connections. Yeah!
>
> Cheers,
> Benjamin
>
>  drivers/hid/wacom_sys.c | 2 +-
>  drivers/hid/wacom_wac.c | 3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index 9e4e188..a8b7f16 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -1035,7 +1035,7 @@ static struct input_dev *wacom_allocate_input(struct wacom *wacom)
>         input_dev->uniq = hdev->uniq;
>         input_dev->id.bustype = hdev->bus;
>         input_dev->id.vendor  = hdev->vendor;
> -       input_dev->id.product = hdev->product;
> +       input_dev->id.product = wacom_wac->pid ? wacom_wac->pid : hdev->product;
>         input_dev->id.version = hdev->version;
>         input_set_drvdata(input_dev, wacom);
>
> diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> index c3cbbfb..b8180e4 100644
> --- a/drivers/hid/wacom_wac.c
> +++ b/drivers/hid/wacom_wac.c
> @@ -1990,6 +1990,9 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
>         input_set_abs_params(input_dev, ABS_X, 0, 1, 0, 0);
>         input_set_abs_params(input_dev, ABS_Y, 0, 1, 0, 0);
>
> +       /* kept for making udev and libwacom accepting the pad */
> +       __set_bit(BTN_STYLUS, input_dev->keybit);
> +
>         switch (features->type) {
>         case GRAPHIRE_BT:
>                 __set_bit(BTN_0, input_dev->keybit);
> --
> 2.1.0
>
