Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaI2IkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:40:25 -0400
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:36360 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaI2IkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <1411779438-23127-8-git-send-email-linux@roeck-us.net>
References: <1411779438-23127-1-git-send-email-linux@roeck-us.net>
	<1411779438-23127-8-git-send-email-linux@roeck-us.net>
Date: Mon, 29 Sep 2014 10:40:22 +0200
Message-ID: <CAE0=X_3f2ZXpJ6yLJbzhz5yKTAEuh_-Ncq3+P0FTP4rxzwaapw@mail.gmail.com>
Subject: Re: [PATCH 07/10] power/reset: axxia: Register with kernel restart handler
From: Anders Berg <anders.berg@avagotech.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 2:57 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> Register with kernel restart handler instead of setting arm_pm_restart
> directly.
>
> Cc: Anders Berg <anders.berg@lsi.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/power/reset/axxia-reset.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>

Works fine.

Tested-by: Anders Berg <anders.berg@avagotech.com>

/Anders

> diff --git a/drivers/power/reset/axxia-reset.c b/drivers/power/reset/axxia-reset.c
> index 3b1f8d6..2a772d9 100644
> --- a/drivers/power/reset/axxia-reset.c
> +++ b/drivers/power/reset/axxia-reset.c
> @@ -19,14 +19,12 @@
>  #include <linux/kernel.h>
>  #include <linux/mfd/syscon.h>
>  #include <linux/module.h>
> +#include <linux/notifier.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/reboot.h>
>  #include <linux/regmap.h>
>
> -#include <asm/system_misc.h>
> -
> -
>  #define SC_CRIT_WRITE_KEY      0x1000
>  #define SC_LATCH_ON_RESET      0x1004
>  #define SC_RESET_CONTROL       0x1008
> @@ -39,7 +37,8 @@
>
>  static struct regmap *syscon;
>
> -static void do_axxia_restart(enum reboot_mode reboot_mode, const char *cmd)
> +static int axxia_restart_handler(struct notifier_block *this,
> +                                unsigned long mode, void *cmd)
>  {
>         /* Access Key (0xab) */
>         regmap_write(syscon, SC_CRIT_WRITE_KEY, 0xab);
> @@ -50,11 +49,19 @@ static void do_axxia_restart(enum reboot_mode reboot_mode, const char *cmd)
>         /* Assert chip reset */
>         regmap_update_bits(syscon, SC_RESET_CONTROL,
>                            RSTCTL_RST_CHIP, RSTCTL_RST_CHIP);
> +
> +       return NOTIFY_DONE;
>  }
>
> +static struct notifier_block axxia_restart_nb = {
> +       .notifier_call = axxia_restart_handler,
> +       .priority = 128,
> +};
> +
>  static int axxia_reset_probe(struct platform_device *pdev)
>  {
>         struct device *dev = &pdev->dev;
> +       int err;
>
>         syscon = syscon_regmap_lookup_by_phandle(dev->of_node, "syscon");
>         if (IS_ERR(syscon)) {
> @@ -62,7 +69,9 @@ static int axxia_reset_probe(struct platform_device *pdev)
>                 return PTR_ERR(syscon);
>         }
>
> -       arm_pm_restart = do_axxia_restart;
> +       err = register_restart_handler(&axxia_restart_nb);
> +       if (err)
> +               dev_err(dev, "cannot register restart handler (err=%d)\n", err);
>
>         return 0;
>  }
> --
> 1.9.1
>
