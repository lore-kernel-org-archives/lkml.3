Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaD2C45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:56:57 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48758 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaD2C4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:56:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKiYmCNGrkiwS7m-OAt3rHZBq_yNGycen-AojbV-7famg@mail.gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
	<CAE9FiQVp5u-jF_xjCu68BgbZ=e0D508tn_-auoiT6cbkYtX8Og@mail.gmail.com>
	<CAL_JsqKiYmCNGrkiwS7m-OAt3rHZBq_yNGycen-AojbV-7famg@mail.gmail.com>
Date: Mon, 28 Apr 2014 19:56:54 -0700
X-Google-Sender-Auth: iFQqiXHF15g6YF4Cc8mwVDc8JRE
Message-ID: <CAE9FiQVdwumX7Dsmt8NJhw4uWsj2sjUKaKS1wJQujW1fn1szLw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
From: Yinghai Lu <yinghai@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 4:24 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Sat, Apr 26, 2014 at 1:29 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> Thanks for finding these. I missed them in my build tests. This should fix them:
>
> diff --git a/drivers/tty/serial/8250/8250_early.c
> b/drivers/tty/serial/8250/8250_early.c
> index e83c9db..2094c3b 100644
> --- a/drivers/tty/serial/8250/8250_early.c
> +++ b/drivers/tty/serial/8250/8250_early.c
> @@ -156,6 +156,11 @@ static int __init early_serial8250_setup(struct
> earlycon_device *device,
>  EARLYCON_DECLARE(uart8250, early_serial8250_setup);
>  EARLYCON_DECLARE(uart, early_serial8250_setup);
>
> +int __init setup_early_serial8250_console(char *cmdline)
> +{
> +       return setup_earlycon(cmdline, "uart8250", early_serial8250_setup);
> +}
> +
>  int serial8250_find_port_for_earlycon(void)
>  {
>         struct earlycon_device *device = early_device;

that only handle "uart8250,", may need to add more lines to handle "uart,"

+int __init setup_early_serial8250_console(char *cmdline)
+{
+       char *options;
+       options = strstr(cmdline, "uart8250,");
+       if (options)
+               return setup_earlycon(cmdline, "uart8250",
early_serial8250_setup);
+
+       options = strstr(cmdline, "uart,");
+       if (options)
+              return setup_earlycon(cmdline, "uart", early_serial8250_setup);
+
+      return 0;
+}
+

Thanks

Yinghai
