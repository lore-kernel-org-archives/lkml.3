Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbaITMls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 08:41:48 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:48205 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaITMlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 08:41:46 -0400
MIME-Version: 1.0
In-Reply-To: <1410867163-27962-1-git-send-email-alim.akhtar@samsung.com>
References: <1410867163-27962-1-git-send-email-alim.akhtar@samsung.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Sat, 20 Sep 2014 18:11:04 +0530
Message-ID: <CAGOxZ535gC4cqogQrpgbjqf4qU1NrhJD7oNnReu8OwzjcWTkqg@mail.gmail.com>
Subject: Re: [PATCH] tty/serial: samsung: Add earlycon support
To: gregkh@linuxfoundation.org
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        robh@kernel.org, Thomas P Abraham <thomas.ab@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just realized that linux-arm-kernel email-id was wrongly typed.

CCing the correct linux-arm-kernel email-id now.

Sorry for the noise.


On Tue, Sep 16, 2014 at 5:02 PM, Alim Akhtar <alim.akhtar@samsung.com> wrote:
> Add earlycon support for the samsung serial port. This allows enabling
> the samsung serial port for console when early_params are parse and processed.
>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  Documentation/kernel-parameters.txt |    6 ++++++
>  drivers/tty/serial/Kconfig          |    1 +
>  drivers/tty/serial/samsung.c        |   17 +++++++++++++++++
>  3 files changed, 24 insertions(+)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 5ae8608..e01c0e5 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -936,6 +936,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                         must already be setup and configured. Options are not
>                         yet supported.
>
> +               samsung,<addr>
> +                       Start an early, polled-mode console on a samsung serial
> +                       port at the specified address. The samsung serial port
> +                       must already be setup and configured. Options are not
> +                       yet supported.
> +
>                 smh     Use ARM semihosting calls for early console.
>
>         earlyprintk=    [X86,SH,BLACKFIN,ARM,M68k]
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 249e340..9d42ac8 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -257,6 +257,7 @@ config SERIAL_SAMSUNG_CONSOLE
>         bool "Support for console on Samsung SoC serial port"
>         depends on SERIAL_SAMSUNG=y
>         select SERIAL_CORE_CONSOLE
> +       select SERIAL_EARLYCON
>         help
>           Allow selection of the S3C24XX on-board serial ports for use as
>           an virtual console.
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index c78f43a..f32e9c8 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -917,6 +917,7 @@ s3c24xx_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
>  #ifdef CONFIG_SERIAL_SAMSUNG_CONSOLE
>
>  static struct console s3c24xx_serial_console;
> +static void s3c24xx_serial_console_putchar(struct uart_port *port, int ch);
>
>  static int __init s3c24xx_serial_console_init(void)
>  {
> @@ -926,6 +927,22 @@ static int __init s3c24xx_serial_console_init(void)
>  console_initcall(s3c24xx_serial_console_init);
>
>  #define S3C24XX_SERIAL_CONSOLE &s3c24xx_serial_console
> +static void samsung_early_write(struct console *con, const char *s, unsigned n)
> +{
> +       struct earlycon_device *dev = con->data;
> +
> +       uart_console_write(&dev->port, s, n, s3c24xx_serial_console_putchar);
> +}
> +
> +static int __init samsung_early_console_setup(struct earlycon_device *device,
> +                                             const char *opt)
> +{
> +       if (!device->port.membase)
> +               return -ENODEV;
> +       device->con->write = samsung_early_write;
> +       return 0;
> +}
> +EARLYCON_DECLARE(samsung, samsung_early_console_setup);
>  #else
>  #define S3C24XX_SERIAL_CONSOLE NULL
>  #endif
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
