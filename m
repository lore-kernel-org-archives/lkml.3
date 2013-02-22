Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3BVWfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 17:35:07 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50287 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3BVWfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 17:35:05 -0500
MIME-Version: 1.0
In-Reply-To: <1361555907-19840-29-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
	<1361555907-19840-29-git-send-email-nick.dyer@itdev.co.uk>
Date: Fri, 22 Feb 2013 14:35:03 -0800
X-Google-Sender-Auth: BrzjR9U7S0h8pggxHgLE5vGlxcA
Message-ID: <CANLzEktc+YnwtabBZ8zX=OeQD_1GctUu0GaB2uugcWAUmGf=sw@mail.gmail.com>
Subject: Re: [PATCH 28/40] Input: atmel_mxt_ts - Add CHG line handling in
 bootloader code
From: Benson Leung <bleung@chromium.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is very similar to a patch that Daniel and I sent earlier this month.

http://www.spinics.net/lists/linux-input/msg24666.html

The major difference is that your wait_for_chg does a polling read of
chg, while the one we worked on leaves the irq enabled and waits on
completion.

On Fri, Feb 22, 2013 at 9:58 AM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> The bootloader state machine toggles the CHG/Interrupt line to indicate when
> it has transitioned between states. Waiting for this event improves bootloader
> reliability.
>
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index a1f196b..f182228 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -430,6 +430,27 @@ static int mxt_probe_bootloader(struct mxt_data *data)
>         return 0;
>  }
>
> +static int mxt_wait_for_chg(struct mxt_data *data)
> +{
> +       int timeout_counter = 0;
> +       int count = 1E6;
> +
> +       if (data->pdata->read_chg == NULL) {
> +               msleep(20);
> +               return 0;
> +       }
> +
> +       while ((timeout_counter++ <= count) && data->pdata->read_chg())
> +               udelay(20);
> +
> +       if (timeout_counter > count) {
> +               dev_err(&data->client->dev, "mxt_wait_for_chg() timeout!\n");
> +               return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
>  static u8 mxt_get_bootloader_version(struct mxt_data *data, u8 val)
>  {
>         struct device *dev = &data->client->dev;
> @@ -478,9 +499,10 @@ recheck:
>                 val &= ~MXT_BOOT_STATUS_MASK;
>                 break;
>         case MXT_FRAME_CRC_PASS:
> -               if (val == MXT_FRAME_CRC_CHECK)
> +               if (val == MXT_FRAME_CRC_CHECK) {
> +                       mxt_wait_for_chg(data);
>                         goto recheck;
> -               if (val == MXT_FRAME_CRC_FAIL) {
> +               } else if (val == MXT_FRAME_CRC_FAIL) {
>                         dev_err(dev, "Bootloader CRC fail\n");
>                         return -EINVAL;
>                 }
> @@ -1781,6 +1803,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
>
>         ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
>         if (ret) {
> +               mxt_wait_for_chg(data);
>                 /* Bootloader may still be unlocked from previous update
>                  * attempt */
>                 ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
> @@ -1800,6 +1823,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
>         }
>
>         while (pos < fw->size) {
> +               mxt_wait_for_chg(data);
>                 ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
>                 if (ret) {
>                         data->state = FAILED;
> @@ -1818,6 +1842,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
>                         goto release_firmware;
>                 }
>
> +               mxt_wait_for_chg(data);
>                 ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS);
>                 if (ret) {
>                         retry++;
> --
> 1.7.10.4
>



--
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
