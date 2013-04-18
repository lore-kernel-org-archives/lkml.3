Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936677Ab3DRWAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:00:04 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62397 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3DRWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:00:00 -0400
MIME-Version: 1.0
In-Reply-To: <1366322130-19364-1-git-send-email-olof@lixom.net>
References: <1366322130-19364-1-git-send-email-olof@lixom.net>
Date: Thu, 18 Apr 2013 15:00:00 -0700
X-Google-Sender-Auth: UIqD-fTQvr4XIgjiGICpVf4W080
Message-ID: <CANLzEks9ne5eOjQTkZAHSbR+jPGjyw9RPQODi=cB_eOz7zCskA@mail.gmail.com>
Subject: Re: [PATCH] Platform: x86: chromeos_laptop: defer probing if no i2c
 busses found
From: Benson Leung <bleung@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dirk@hohndel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Acked-by: Benson Leung <bleung@chromium.org>

On Thu, Apr 18, 2013 at 2:55 PM, Olof Johansson <olof@lixom.net> wrote:
> If chromeos_laptop is loaded before the DRM driver, the i2c busses will
> not yet be available. Defer probe for that case and try again later.
>
> Trickling the error up to the module init function is unfortuantely a
> little awkward, since the i2c bus lookup and device registration happens
> as a dmi callback.
>
> Reported-by: Dirk Hohndel <dirk@hohndel.org>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/platform/x86/chromeos_laptop.c |   33 ++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
> index 3e5b4497..7ff12fa 100644
> --- a/drivers/platform/x86/chromeos_laptop.c
> +++ b/drivers/platform/x86/chromeos_laptop.c
> @@ -39,6 +39,7 @@
>  static struct i2c_client *als;
>  static struct i2c_client *tp;
>  static struct i2c_client *ts;
> +static int setup_error;
>
>  const char *i2c_adapter_names[] = {
>         "SMBus I801 adapter",
> @@ -191,7 +192,8 @@ static int __init find_i2c_adapter_num(enum i2c_adapter_type type)
>         if (!dev) {
>                 pr_err("%s: i2c adapter %s not found on system.\n", __func__,
>                        name);
> +               setup_error = -EPROBE_DEFER;
>                 return -ENODEV;
>         }
>         adapter = to_i2c_adapter(dev);
>         return adapter->nr;
> @@ -381,23 +383,38 @@ static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
>  };
>  MODULE_DEVICE_TABLE(dmi, chromeos_laptop_dmi_table);
>
> +static void chromeos_laptop_unregister(void)
> +{
> +       if (als)
> +               i2c_unregister_device(als);
> +       if (tp)
> +               i2c_unregister_device(tp);
> +       if (ts)
> +               i2c_unregister_device(ts);
> +
> +       als = NULL;
> +       tp = NULL;
> +       ts = NULL;
> +}
> +
>  static int __init chromeos_laptop_init(void)
>  {
> +       setup_error = 0;
> +
>         if (!dmi_check_system(chromeos_laptop_dmi_table)) {
>                 pr_debug("%s unsupported system.\n", __func__);
>                 return -ENODEV;
>         }
> -       return 0;
> +
> +       if (setup_error)
> +               chromeos_laptop_unregister();
> +
> +       return setup_error;
>  }
>
>  static void __exit chromeos_laptop_exit(void)
>  {
> -       if (als)
> -               i2c_unregister_device(als);
> -       if (tp)
> -               i2c_unregister_device(tp);
> -       if (ts)
> -               i2c_unregister_device(ts);
> +       chromeos_laptop_unregister();
>  }
>
>  module_init(chromeos_laptop_init);
> --
> 1.7.10.4
>



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
