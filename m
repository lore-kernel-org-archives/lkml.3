Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3E0L4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:56:25 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57239 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3E0L4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:56:23 -0400
MIME-Version: 1.0
In-Reply-To: <1369650604-27941-2-git-send-email-ming.lei@canonical.com>
References: <1369650604-27941-1-git-send-email-ming.lei@canonical.com>
	<1369650604-27941-2-git-send-email-ming.lei@canonical.com>
Date: Mon, 27 May 2013 17:26:22 +0530
Message-ID: <CAK7N6vozJ-dNDCj4QEo_nO=Tb_nEq3h6bmSF0rvaJ5NYgyK3fw@mail.gmail.com>
Subject: Re: [PATCH 1/2] driver core: firmware loader: don't cache
 FW_ACTION_NOHOTPLUG firmware
From: anish singh <anish198519851985@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 4:00 PM, Ming Lei <ming.lei@canonical.com> wrote:
> Generally there are only two drivers which don't need uevent to
> handle firmware loading, so don't cache these firmwares during
Sorry but this statement confuses me i.e. "drivers which don't need
uevent to handle firmware loading". Does this mean that driver is
dependent on uevent to load the firmware?or does this mean
that driver generates uevent to userspace and userpace in turn
provides the firmware?
> suspend for these drivers since doing that may block firmware
> loading forever.
Explanation about why would it block would really help me or
for that matter anyone who reads this commit. Or may be
a url which discussed this problem.
>
> Both the two drivers are involved in private firmware images, so
> they don't hit in direct loading too.
>
> Cc: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/firmware_class.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index e650c25..64e7870 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -993,7 +993,8 @@ _request_firmware_prepare(struct firmware **firmware_p, const char *name,
>         return 1; /* need to load */
>  }
>
> -static int assign_firmware_buf(struct firmware *fw, struct device *device)
> +static int assign_firmware_buf(struct firmware *fw, struct device *device,
> +                               bool skip_cache)
>  {
>         struct firmware_buf *buf = fw->priv;
>
> @@ -1010,7 +1011,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device)
>          * device may has been deleted already, but the problem
>          * should be fixed in devres or driver core.
>          */
> -       if (device)
> +       if (device && !skip_cache)
>                 fw_add_devm_name(device, buf->fw_id);
>
>         /*
> @@ -1066,8 +1067,10 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>         if (!fw_get_filesystem_firmware(device, fw->priv))
>                 ret = fw_load_from_user_helper(fw, name, device,
>                                                uevent, nowait, timeout);
> +
> +       /* don't cache firmware handled without uevent */
>         if (!ret)
> -               ret = assign_firmware_buf(fw, device);
> +               ret = assign_firmware_buf(fw, device, !uevent);
>
>         usermodehelper_read_unlock();
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
