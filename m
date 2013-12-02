Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3LBTkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:40:42 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:39750 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3LBTkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:40:32 -0500
MIME-Version: 1.0
In-Reply-To: <1385014460-6443-1-git-send-email-milo.kim@ti.com>
References: <1385014460-6443-1-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 2 Dec 2013 11:40:10 -0800
Message-ID: <CAK5ve-JEsBy6gd+oVwpnzkQe7eTmW6qkK-Rb4cM-JkKHPdiC9g@mail.gmail.com>
Subject: Re: [PATCH 2/3] leds: lp5521/5523: Remove duplicate mutex
To: Milo Kim <milo.kim@ti.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:14 PM, Milo Kim <milo.kim@ti.com> wrote:
> It can be a problem when a pattern is loaded via the firmware interface.
> LP55xx common driver has already locked the mutex in 'lp55xx_firmware_loaded()'.
> So it should be deleted.
>

Looks like lp5521_update_program_memory() will be called by
store_engine_load() without holding a lock after this change, is this
correct? I think you need also update store_engine_load() to hold the
lock when calling lp5521_update_program_memory().

Thanks,
-Bryan

> Cc: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5521.c |    4 ----
>  drivers/leds/leds-lp5523.c |    4 ----
>  2 files changed, 8 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 26f89ac..4c45ed9 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -258,8 +258,6 @@ static int lp5521_update_program_memory(struct lp55xx_chip *chip,
>         if (i % 2)
>                 goto err;
>
> -       mutex_lock(&chip->lock);
> -
>         for (i = 0; i < LP5521_PROGRAM_LENGTH; i++) {
>                 ret = lp55xx_write(chip, addr[idx] + i, pattern[i]);
>                 if (ret) {
> @@ -268,8 +266,6 @@ static int lp5521_update_program_memory(struct lp55xx_chip *chip,
>                 }
>         }
>
> -       mutex_unlock(&chip->lock);
> -
>         return size;
>
>  err:
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 2ce1723..7a3b369 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -351,8 +351,6 @@ static int lp5523_update_program_memory(struct lp55xx_chip *chip,
>         if (i % 2)
>                 goto err;
>
> -       mutex_lock(&chip->lock);
> -
>         for (i = 0; i < LP5523_PROGRAM_LENGTH; i++) {
>                 ret = lp55xx_write(chip, LP5523_REG_PROG_MEM + i, pattern[i]);
>                 if (ret) {
> @@ -361,8 +359,6 @@ static int lp5523_update_program_memory(struct lp55xx_chip *chip,
>                 }
>         }
>
> -       mutex_unlock(&chip->lock);
> -
>         return size;
>
>  err:
> --
> 1.7.9.5
>
