Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab3BWBpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:45:24 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:46353 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab3BWBpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:45:21 -0500
MIME-Version: 1.0
In-Reply-To: <1361555907-19840-29-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
	<1361555907-19840-29-git-send-email-nick.dyer@itdev.co.uk>
Date: Fri, 22 Feb 2013 17:45:20 -0800
X-Google-Sender-Auth: XBwjMr8IysL9dZfOcDp4V9qq5H0
Message-ID: <CANLzEkuXj3M6phmA2vrOpO9ofiMzLf47RHeN3G1GWdtwJ-FXOQ@mail.gmail.com>
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
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This also assumes the existence of data->pdata. If data->pdata ==
NULL, you're going to have a bad time.

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

> --
> 1.7.10.4
>



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
