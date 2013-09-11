Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab3IKGWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:22:49 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:39562 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3IKGWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:22:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130910190901.GA10105@radagast>
References: <20130910190901.GA10105@radagast>
From: Alexey Pelykh <alexey.pelykh@gmail.com>
Date: Wed, 11 Sep 2013 09:22:26 +0300
Message-ID: <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
Subject: Re: commit 5fe212364 causes division by zero with large bauds
To: balbi@ti.com
Cc: Tony Lindgren <tony@atomide.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Thanks for finding this issue. Indeed, there is a bug on 3M+ baud
rates. First patch is close to a complete fix, but still contains
div-by-zero issue. Here is my version:

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 816d1a2..808a880 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port *port,
unsigned int baud)
 {
        unsigned int n13 = port->uartclk / (13 * baud);
        unsigned int n16 = port->uartclk / (16 * baud);
-       int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
-       int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
+       int baudAbsDiff13 = n13 ? (baud - (port->uartclk / (13 *
n13))) : INT_MAX;
+       int baudAbsDiff16 = n16 ? (baud - (port->uartclk / (16 *
n16))) : INT_MAX;
        if(baudAbsDiff13 < 0)
                baudAbsDiff13 = -baudAbsDiff13;
        if(baudAbsDiff16 < 0)


With 48MHz UART clock, it will give
300: divisor = 12307 (13), real rate 300 (0.000000%)
600: divisor = 6153 (13), real rate 600 (0.000000%)
1200: divisor = 3076 (13), real rate 1200 (0.000000%)
2400: divisor = 1538 (13), real rate 2400 (0.000000%)
4800: divisor = 625 (16), real rate 4800 (0.000000%)
9600: divisor = 384 (13), real rate 9615 (0.156250%)
14400: divisor = 256 (13), real rate 14423 (0.159722%)
19200: divisor = 192 (13), real rate 19230 (0.156250%)
28800: divisor = 128 (13), real rate 28846 (0.159722%)
38400: divisor = 96 (13), real rate 38461 (0.158854%)
57600: divisor = 64 (13), real rate 57692 (0.159722%)
115200: divisor = 32 (13), real rate 115384 (0.159722%)
230400: divisor = 16 (13), real rate 230769 (0.160156%)
460800: divisor = 8 (13), real rate 461538 (0.160156%)
921600: divisor = 4 (13), real rate 923076 (0.160156%)
1000000: divisor = 3 (16), real rate 1000000 (0.000000%)
1843200: divisor = 2 (13), real rate 1846153 (0.160211%)
3000000: divisor = 1 (16), real rate 3000000 (0.000000%)
3686400: divisor = 1 (13), real rate 3692307 (0.160238%)

Thanks,
Alexey

On Tue, Sep 10, 2013 at 10:09 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi Alexey,
>
> your commit 5fe212364 causes division by zero with any baud rate larger
> than 3 Mbaud (IP supports up to 3686400).
>
> Maybe this patch is all we need to get it fixed ? (untested)
>
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 816d1a2..b50327f 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -240,8 +240,14 @@ serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
>  {
>         unsigned int n13 = port->uartclk / (13 * baud);
>         unsigned int n16 = port->uartclk / (16 * baud);
> -       int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
> -       int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
> +       int baudAbsDiff13 = 0;
> +       int baudAbsDiff16 = 0;
> +
> +       if (n13)
> +               baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
> +       if (n16)
> +               baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
> +
>         if(baudAbsDiff13 < 0)
>                 baudAbsDiff13 = -baudAbsDiff13;
>         if(baudAbsDiff16 < 0)
>
> Another possibility would be to convert this into a lookup table (also
> untested):
>
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 816d1a2..942d68e 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -224,6 +224,48 @@ static void serial_omap_enable_wakeup(struct uart_omap_port *up, bool enable)
>         pdata->enable_wakeup(up->dev, enable);
>  }
>
> +struct uart_omap_config {
> +       unsigned int baud;
> +       unsigned int oversampling;
> +       unsigned int divisor;
> +};
> +
> +static struct uart_omap_config omap_port_configs[] = {
> +       { .baud = 300,          .oversampling = 16,     .divisor = 10000, },
> +       { .baud = 300,          .oversampling = 16,     .divisor = 10000, },
> +       { .baud = 600,          .oversampling = 16,     .divisor = 5000, },
> +       { .baud = 1200,         .oversampling = 16,     .divisor = 2500, },
> +       { .baud = 2400,         .oversampling = 16,     .divisor = 1250, },
> +       { .baud = 4800,         .oversampling = 16,     .divisor = 625, },
> +       { .baud = 9600,         .oversampling = 16,     .divisor = 312, },
> +       { .baud = 14400,        .oversampling = 16,     .divisor = 208, },
> +       { .baud = 19200,        .oversampling = 16,     .divisor = 156, },
> +       { .baud = 28800,        .oversampling = 16,     .divisor = 704, },
> +       { .baud = 38400,        .oversampling = 16,     .divisor = 78, },
> +       { .baud = 57600,        .oversampling = 16,     .divisor = 52, },
> +       { .baud = 115200,       .oversampling = 16,     .divisor = 26, },
> +       { .baud = 230400,       .oversampling = 16,     .divisor = 13, },
> +       { .baud = 460800,       .oversampling = 13,     .divisor = 8, },
> +       { .baud = 921600,       .oversampling = 13,     .divisor = 4, },
> +       { .baud = 1843200,      .oversampling = 13,     .divisor = 2, },
> +       { .baud = 3000000,      .oversampling = 16,     .divisor = 1, },
> +       { .baud = 3686400,      .oversampling = 13,     .divisor = 1, },
> +       {  } /* Terminating Entry */
> +};
> +
> +static struct uart_omap_config *
> +__serial_omap_get_config(struct uart_port *port, unsigned int baud)
> +{
> +       struct uart_omap_config *cfg = omap_port_configs;
> +
> +       while (cfg++) {
> +               if (cfg->baud == baud)
> +                       return cfg;
> +       }
> +
> +       return NULL;
> +}
> +
>  /*
>   * serial_omap_baud_is_mode16 - check if baud rate is MODE16X
>   * @port: uart port info
> @@ -238,16 +280,12 @@ static void serial_omap_enable_wakeup(struct uart_omap_port *up, bool enable)
>  static bool
>  serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
>  {
> -       unsigned int n13 = port->uartclk / (13 * baud);
> -       unsigned int n16 = port->uartclk / (16 * baud);
> -       int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
> -       int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
> -       if(baudAbsDiff13 < 0)
> -               baudAbsDiff13 = -baudAbsDiff13;
> -       if(baudAbsDiff16 < 0)
> -               baudAbsDiff16 = -baudAbsDiff16;
> -
> -       return (baudAbsDiff13 > baudAbsDiff16);
> +       struct uart_omap_config *cfg = __serial_omap_get_config(port, baud);
> +
> +       if (!cfg)
> +               return -EINVAL;
> +
> +       return (cfg->oversampling == 16);
>  }
>
>  /*
> @@ -258,13 +296,12 @@ serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
>  static unsigned int
>  serial_omap_get_divisor(struct uart_port *port, unsigned int baud)
>  {
> -       unsigned int divisor;
> +       struct uart_omap_config *cfg = __serial_omap_get_config(port, baud);
>
> -       if (!serial_omap_baud_is_mode16(port, baud))
> -               divisor = 13;
> -       else
> -               divisor = 16;
> -       return port->uartclk/(baud * divisor);
> +       if (!cfg)
> +               return -EINVAL;
> +
> +       return cfg->divisor;
>  }
>
>  static void serial_omap_enable_ms(struct uart_port *port)
>
> --
> balbi
