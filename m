Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaJTKXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:23:41 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60616 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaJTKXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:23:39 -0400
MIME-Version: 1.0
In-Reply-To: <20141018220615.33643542@alan.etchedpixels.co.uk>
References: <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1413539665-11484-6-git-send-email-chunyan.zhang@spreadtrum.com>
	<20141018220615.33643542@alan.etchedpixels.co.uk>
Date: Mon, 20 Oct 2014 18:23:38 +0800
Message-ID: <CA+H2tpH2dKFHxHUaGtr-vEqxZDtQ_MVTmQTnu5kn-zzUFyXk4Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] tty/serial: Add earlycon support for Spreadtrum
 serial driver
From: Orson Zhai <orsonzhai@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>,
        Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        =?UTF-8?B?R2VuZyBSZW4gKOS7u+i1kyk=?= <geng.ren@spreadtrum.com>,
        =?UTF-8?B?WmhpemhvdSBaaGFuZyAo5byg5rK75rSyKQ==?= 
	<zhizhou.zhang@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sprdlinux <sprdlinux@freelists.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 5:06 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Fri, 17 Oct 2014 17:54:25 +0800
> Chunyan Zhang <chunyan.zhang@spreadtrum.com> wrote:
>
>> Add serial driver for spreadtrum sharkl platform with earlycon
>> support at first.
>
>> +#define UART_TXD     0x0000
>> +#define UART_RXD     0x0004
>> +#define UART_STS0    0x0008
>> +#define UART_STS1    0x000C
>> +#define UART_IEN     0x0010
>> +#define UART_ICLR    0x0014
>> +#define UART_CTL0    0x0018
>> +#define UART_CTL1    0x001C
>> +#define UART_CTL2    0x0020
>> +#define UART_CLKD0   0x0024
>> +#define UART_CLKD1   0x0028
>> +#define UART_STS2    0x002C
>> +
>> +/*line status */
>> +#define UART_LSR_TX_OVER     (0x1<<15)
>
> Given we use UART_ for all the 8250 defines it might be better to use
> something else - SHARK_LSR_TX_OVER etc to avoid future confusion
>

Does it matter if those macro are only used in the specific c file?
>From my point of  view, private register macro could be treated as
static definitions like static variable or functions in C file.
I also noted that many people use a prefix for the other
manufacturers' macro definition in source file .
I have no intention to break the habit of kernel but just for discussion.


>> +static void serial_sprd_putc(struct uart_port *port, int c)
>> +{
>> +     while (!(readl(port->membase + UART_STS0) & UART_LSR_TX_OVER))
>> +             ;
>> +     writeb(c, port->membase + UART_TXD);
>> +}
>> +
>> +static void serial_sprd_early_write(struct console *con, const char *s,
>> +                                 unsigned n)
>> +{
>> +     struct earlycon_device *dev = con->data;
>> +
>> +     uart_console_write(&dev->port, s, n, serial_sprd_putc);
>> +}
>> +
>> +static int __init serial_sprd_early_console_setup(
>> +                             struct earlycon_device *device,
>> +                             const char *opt)
>> +{
>> +     if (!device->port.membase)
>> +             return -ENODEV;
>> +
>> +     device->con->write = serial_sprd_early_write;
>> +     return 0;
>> +}
>
> This seems fine but it would be useful to see both the earlycon and the
> main uart/console driver and how they fit together.
>
> Alan
