Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaAGX6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:58:12 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:58560 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbaAGX57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:57:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140107204233.GA22413@amd.pavel.ucw.cz>
References: <20140107204233.GA22413@amd.pavel.ucw.cz>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 7 Jan 2014 15:57:37 -0800
Message-ID: <CAK5ve-Ju70iOXQXG1B1wVpyDRKjAw_cvmBR5YDM=frppA3iu4A@mail.gmail.com>
Subject: Re: Broken locking in leds-lp5523.c
To: Pavel Machek <pavel@ucw.cz>, milo kim <milo.kim@ti.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 12:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> There's some locking weirdness, and few missing comments in lp5523
> driver.
>
> Now, this is untested patch from my reverse-engineering. I hope I
> understood things right...
>
> In particular, there's unbalanced unlock in
> lp5523_update_program_memory, and lp5523_update_program_memory needs
> to be protected by the lock.
>
> Comments? Does someone maintain this?
>

I think Milo Kim is maintaining this driver for the LP55xx chip family.

Thanks,
-Bryan

> Thanks,
>                                                                 Pavel
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index c00f55e4..e8b83e9 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -34,7 +34,15 @@
>
>  #include "leds-lp55xx-common.h"
>
> -#define LP5523_PROGRAM_LENGTH          32
> +#define LP5523_PROGRAM_LENGTH          32      /* bytes */
> +/* Memory is used like this:
> +   0x00 engine 1 program
> +   0x10 engine 2 program
> +   0x20 engine 3 program
> +   0x30 engine 1 muxing info
> +   0x40 engine 2 muxing info
> +   0x50 engine 3 muxing info
> +   ...and offsets are hard-coded all around :-( */
>  #define LP5523_MAX_LEDS                        9
>
>  /* Registers */
> @@ -265,20 +273,25 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)
>         /* one pattern per engine setting LED MUX start and stop addresses */
>         static const u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
>                 { 0x9c, 0x30, 0x9c, 0xb0, 0x9d, 0x80, 0xd8, 0x00, 0},
> +               /* 9c30 -- mux_map_start(0x30)
> +                  9cb0 -- mux_ld_end(0x50)
> +                  9d80 -- mux_sel???(0x00)
> +                  d800 -- invalid?? */
>                 { 0x9c, 0x40, 0x9c, 0xc0, 0x9d, 0x80, 0xd8, 0x00, 0},
>                 { 0x9c, 0x50, 0x9c, 0xd0, 0x9d, 0x80, 0xd8, 0x00, 0},
>         };
>
> -       /* hardcode 32 bytes of memory for each engine from program memory */
> +       /* hardcode LP5523_PROGRAM_LENGTH bytes of memory for each
> +          engine from program memory */
>         ret = lp55xx_write(chip, LP5523_REG_CH1_PROG_START, 0x00);
>         if (ret)
>                 return ret;
>
> -       ret = lp55xx_write(chip, LP5523_REG_CH2_PROG_START, 0x10);
> +       ret = lp55xx_write(chip, LP5523_REG_CH2_PROG_START, LP5523_PROGRAM_LENGTH / 2);
>         if (ret)
>                 return ret;
>
> -       ret = lp55xx_write(chip, LP5523_REG_CH3_PROG_START, 0x20);
> +       ret = lp55xx_write(chip, LP5523_REG_CH3_PROG_START, LP5523_PROGRAM_LENGTH);
>         if (ret)
>                 return ret;
>
> @@ -346,10 +359,8 @@ static int lp5523_update_program_memory(struct lp55xx_chip *chip,
>
>         for (i = 0; i < LP5523_PROGRAM_LENGTH; i++) {
>                 ret = lp55xx_write(chip, LP5523_REG_PROG_MEM + i, pattern[i]);
> -               if (ret) {
> -                       mutex_unlock(&chip->lock);
> +               if (ret)
>                         return -EINVAL;
> -               }
>         }
>
>         return size;
> @@ -551,15 +562,17 @@ static ssize_t store_engine_load(struct device *dev,
>  {
>         struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
>         struct lp55xx_chip *chip = led->chip;
> +       ssize_t res;
>
>         mutex_lock(&chip->lock);
>
>         chip->engine_idx = nr;
>         lp5523_load_engine_and_select_page(chip);
>
> +       res = lp5523_update_program_memory(chip, buf, len);
>         mutex_unlock(&chip->lock);
>
> -       return lp5523_update_program_memory(chip, buf, len);
> +       return res;
>  }
>  store_load(1)
>  store_load(2)
> diff --git a/drivers/leds/leds-lp8501.c b/drivers/leds/leds-lp8501.c
> index 8d55a780..ae5c6fe 100644
> --- a/drivers/leds/leds-lp8501.c
> +++ b/drivers/leds/leds-lp8501.c
> @@ -262,7 +262,7 @@ static void lp8501_firmware_loaded(struct lp55xx_chip *chip)
>         }
>
>         /*
> -        * Program momery sequence
> +        * Program memory sequence
>          *  1) set engine mode to "LOAD"
>          *  2) write firmware data into program memory
>          */
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
