Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaFKXow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:44:52 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:54338 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaFKXot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <539898C3.8090903@gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
	<CAE9FiQVrwypK4u5yTCt-AxMuBnOn7jv=V3d4Zb3cd9JDNEUVPw@mail.gmail.com>
	<CAL_JsqKux+BTHeYo6XEzzQMAFJZHVjbURM973oHT=t698GbJbA@mail.gmail.com>
	<20140503220731.GA10927@kroah.com>
	<20140503221658.GA13403@kroah.com>
	<CA+8MBb+7f1bOnJjJWj1vxa0UNuQwz7OGRDR_QFTxOT=9cynabQ@mail.gmail.com>
	<CA+8MBbKE1E2uq9LefiDAV9hv2Z8OTkjx9mkXjE6_--F_emRC8A@mail.gmail.com>
	<CAL_JsqKvoO9acX==-LdD6boO=B3xr=ijra_G0uqRZGzACZZUJg@mail.gmail.com>
	<CA+8MBbLooWm9xys+gYa5uL1eVTH-qzaR+RaZgsrqV-8XkqGadQ@mail.gmail.com>
	<539898C3.8090903@gmail.com>
Date: Wed, 11 Jun 2014 16:44:48 -0700
X-Google-Sender-Auth: uDAnx1E4IRcgpAMj_So3v7T6-8c
Message-ID: <CAE9FiQWxghRU62OwGU6-nvxMdEakPKQY_yGWvcVa6vsQcA=-sg@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
From: Yinghai Lu <yinghai@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:58 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 06/10/2014 03:52 PM, Tony Luck wrote:
> I think I figured it out. The function
> serial8250_find_port_for_earlycon is failing to match 'uart' console to
> 'ttyS' console and transfer the options. It was also failing to create
> an option string when the baud rate is probed. Can you try out the
> below patch?
>
> Rob
>
> 8<-------------------------------------------------------------------
> diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
> index cfef801..4858b8a 100644
> --- a/drivers/tty/serial/8250/8250_early.c
> +++ b/drivers/tty/serial/8250/8250_early.c
> @@ -144,8 +144,11 @@ static int __init early_serial8250_setup(struct earlycon_device *device,
>         if (!(device->port.membase || device->port.iobase))
>                 return 0;
>
> -       if (!device->baud)
> +       if (!device->baud) {
>                 device->baud = probe_baud(&device->port);
> +               snprintf(device->options, sizeof(device->options), "%u",
> +                        device->baud);
> +       }
>
>         init_port(device);
>
> diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
> index 5131b5e..d20e6d8 100644
> --- a/drivers/tty/serial/earlycon.c
> +++ b/drivers/tty/serial/earlycon.c
> @@ -25,7 +25,7 @@
>  #include <asm/serial.h>
>
>  static struct console early_con = {
> -       .name =         "earlycon",
> +       .name =         "uart",
>         .flags =        CON_PRINTBUFFER | CON_BOOT,
>         .index =        -1,
>  };
>

Yes, that is right fix.

For the name in early_con with "uart", please add some comments that
serial8250_find_port_for_earlycon() will look for "uart"...

Thanks

Yinghai
