Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaADFw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 00:52:27 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44394 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaADFwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 00:52:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140104052756.GA32561@core.coreip.homeip.net>
References: <20140104052756.GA32561@core.coreip.homeip.net>
Date: Fri, 3 Jan 2014 21:52:25 -0800
Message-ID: <CAHQ1cqG2=CX6ypONUgVgzjG_3nVJOBLq5LPYwN0BrzwOLCTxzQ@mail.gmail.com>
Subject: Re: [PATCH] Input: ims-pcu - remove unneeded get_unaligned_xxx
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 9:28 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> pcu->cmd_buf[IMS_PCU_DATA_OFFSET] is word aligned so we do not need to use
> get_unaligned_le16 to access it.
>
> Also let's add build time check to make sure it stays aligned.

- AFAIK, there's no guarantee the "pcu" itself is aligned
- This change assumes that aligning data on the 2-byte boundary is
sufficient for all architectures that do not allow unaligned data
access, which I don't think is a good assumption to make
- On x86 or any other architecture that allows unaligned access
get_unaligned_le16() is actually results to call to le16_to_cpup(), so
this change doesn't really save anything while imposing restrictions
on the arrangement of the fields in struct ims_pcu and causing
unnecessary build errors.

So, for what its worth, NACK for this patch from me.

>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/misc/ims-pcu.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
> index 513ecdf..b8f1029 100644
> --- a/drivers/input/misc/ims-pcu.c
> +++ b/drivers/input/misc/ims-pcu.c
> @@ -116,6 +116,8 @@ struct ims_pcu {
>         bool setup_complete; /* Input and LED devices have been created */
>  };
>
> +#define IMS_PCU_CHECK_CMD_BUF_ALIGNMENT(offset, alignment)     \
> +       IS_ALIGNED(offsetof(struct ims_pcu, cmd_buf[offset]), alignment)
>
>  /*********************************************************************
>   *             Buttons Input device support                          *
> @@ -999,8 +1001,10 @@ ims_pcu_backlight_get_brightness(struct led_classdev *cdev)
>                 /* Assume the LED is OFF */
>                 brightness = LED_OFF;
>         } else {
> -               brightness =
> -                       get_unaligned_le16(&pcu->cmd_buf[IMS_PCU_DATA_OFFSET]);
> +               BUILD_BUG_ON(!IMS_PCU_CHECK_CMD_BUF_ALIGNMENT(
> +                               IMS_PCU_DATA_OFFSET, 2));
> +               brightness = le16_to_cpup(
> +                               (__le16 *)&pcu->cmd_buf[IMS_PCU_DATA_OFFSET]);
>         }
>
>         mutex_unlock(&pcu->cmd_mutex);
> --
> 1.8.4.2
>
>
> --
> Dmitry
