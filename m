Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaKKEbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:31:19 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:45275 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaKKEbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:31:17 -0500
MIME-Version: 1.0
In-Reply-To: <1414401857-21121-1-git-send-email-jingchang.lu@freescale.com>
References: <1414401857-21121-1-git-send-email-jingchang.lu@freescale.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 10 Nov 2014 20:30:36 -0800
Message-ID: <CAGVrzcamoYbdPijWtrU=ge+UE+g9zBHAG84PJB7G3EyA09jBWg@mail.gmail.com>
Subject: Re: [RESENDv5] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-27 2:24 GMT-07:00 Jingchang Lu <jingchang.lu@freescale.com>:
> This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
> "serial: of-serial: add PM suspend/resume support", which disables
> the uart clock on suspend, but also causes a hardware hang on register
> access if no_console_suspend command line option is used.
>
> Also, not every of_serial device is an 8250 port, so the serial8250
> suspend/resume functions should only be applied to a real 8250 port.

Greg, can you pick this one and submit it for your next 3.18-rc
submission? This fixes a regression when using "no_console_suspend"
introduced by:

2dea53bf57783f243c892e99c10c6921e956aa7e ("serial: of-serial: add PM
suspend/resume support") which has been merged during 3.18-rc1

Thanks!

>
> Reported-By: Joseph Lo <josephl@nvidia.com>
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> Tested-By: Joseph Lo <josephl@nvidia.com>
> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> ---
> changes in v5:
>  add missing <linux/console.h> include.
>
> changes in v4:
>  separate 8250 port suspend/resume from of_serial_suspend/resume.
>
> changes in v3:
>  fix up point reference and deference.
>
> changes in v2:
>  add switch selection on uart type.
>
>  drivers/tty/serial/of_serial.c | 53 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 46 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index 8bc2563..9c64ad2 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -9,6 +9,7 @@
>   *  2 of the License, or (at your option) any later version.
>   *
>   */
> +#include <linux/console.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> @@ -241,13 +242,48 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
>  }
>
>  #ifdef CONFIG_PM_SLEEP
> -static int of_serial_suspend(struct device *dev)
> +#ifdef CONFIG_SERIAL_8250
> +static void of_serial_suspend_8250(struct of_serial_info *info)
>  {
> -       struct of_serial_info *info = dev_get_drvdata(dev);
> +       struct uart_8250_port *port8250 = serial8250_get_port(info->line);
> +       struct uart_port *port = &port8250->port;
>
>         serial8250_suspend_port(info->line);
> -       if (info->clk)
> +       if (info->clk && (!uart_console(port) || console_suspend_enabled))
>                 clk_disable_unprepare(info->clk);
> +}
> +
> +static void of_serial_resume_8250(struct of_serial_info *info)
> +{
> +       struct uart_8250_port *port8250 = serial8250_get_port(info->line);
> +       struct uart_port *port = &port8250->port;
> +
> +       if (info->clk && (!uart_console(port) || console_suspend_enabled))
> +               clk_prepare_enable(info->clk);
> +
> +       serial8250_resume_port(info->line);
> +}
> +#else
> +static inline void of_serial_suspend_8250(struct of_serial_info *info)
> +{
> +}
> +
> +static inline void of_serial_resume_8250(struct of_serial_info *info)
> +{
> +}
> +#endif
> +
> +static int of_serial_suspend(struct device *dev)
> +{
> +       struct of_serial_info *info = dev_get_drvdata(dev);
> +
> +       switch(info->type) {
> +       case PORT_8250 ... PORT_MAX_8250:
> +               of_serial_suspend_8250(info);
> +               break;
> +       default:
> +               break;
> +       }
>
>         return 0;
>  }
> @@ -256,10 +292,13 @@ static int of_serial_resume(struct device *dev)
>  {
>         struct of_serial_info *info = dev_get_drvdata(dev);
>
> -       if (info->clk)
> -               clk_prepare_enable(info->clk);
> -
> -       serial8250_resume_port(info->line);
> +       switch(info->type) {
> +       case PORT_8250 ... PORT_MAX_8250:
> +               of_serial_resume_8250(info);
> +               break;
> +       default:
> +               break;
> +       }
>
>         return 0;
>  }
> --
> 1.8.0
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Florian
