Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbbAWNjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:39:16 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59907 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbbAWNjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:39:13 -0500
MIME-Version: 1.0
In-Reply-To: <54C24D39.1080607@hurleysoftware.com>
References: <1422018066-24997-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1422018066-24997-3-git-send-email-chunyan.zhang@spreadtrum.com>
	<54C24D39.1080607@hurleysoftware.com>
Date: Fri, 23 Jan 2015 21:39:11 +0800
Message-ID: <CAAfSe-scYsf-dDiHUufhWaHngCxjXpdqUWWs76Cdp0kRbBZ_aQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] tty/serial: Add Spreadtrum sc9836-uart driver support
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>, Hayato Suzuki <hytszk@gmail.com>,
        "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Orson Zhai <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 9:31 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> Hi Chunyan,
>
> Just the minor fix to zeroing the stack local in sprd_set_termios()
> and using dev_get_drvdata() in sprd_suspend()/sprd_resume().
>

ok, I see.

> Regards,
> Peter Hurley
>
> On 01/23/2015 08:01 AM, Chunyan Zhang wrote:
>> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>> spreadtrum sharkl64 platform.
>> This driver also support earlycon.
>
> [...]
>
>> +static void sprd_set_termios(struct uart_port *port,
>> +                                 struct ktermios *termios,
>> +                                 struct ktermios *old)
>> +{
>> +     unsigned int baud, quot;
>> +     unsigned int lcr, fc;
>
>         unsigned int lcr = 0, fc;
>
>> +     unsigned long flags;
>> +
>> +     /* ask the core to calculate the divisor for us */
>> +     baud = uart_get_baud_rate(port, termios, old, 0, SPRD_BAUD_IO_LIMIT);
>> +
>> +     quot = (unsigned int)((port->uartclk + baud / 2) / baud);
>> +
>> +     /* set data length */
>> +     switch (termios->c_cflag & CSIZE) {
>> +     case CS5:
>> +             lcr |= SPRD_LCR_DATA_LEN5;
>> +             break;
>> +     case CS6:
>> +             lcr |= SPRD_LCR_DATA_LEN6;
>> +             break;
>> +     case CS7:
>> +             lcr |= SPRD_LCR_DATA_LEN7;
>> +             break;
>> +     case CS8:
>> +     default:
>> +             lcr |= SPRD_LCR_DATA_LEN8;
>> +             break;
>> +     }
>> +
>> +     /* calculate stop bits */
>> +     lcr &= ~(SPRD_LCR_STOP_1BIT | SPRD_LCR_STOP_2BIT);
>> +     if (termios->c_cflag & CSTOPB)
>> +             lcr |= SPRD_LCR_STOP_2BIT;
>> +     else
>> +             lcr |= SPRD_LCR_STOP_1BIT;
>> +
>> +     /* calculate parity */
>> +     lcr &= ~SPRD_LCR_PARITY;
>> +     termios->c_cflag &= ~CMSPAR;    /* no support mark/space */
>> +     if (termios->c_cflag & PARENB) {
>> +             lcr |= SPRD_LCR_PARITY_EN;
>> +             if (termios->c_cflag & PARODD)
>> +                     lcr |= SPRD_LCR_ODD_PAR;
>> +             else
>> +                     lcr |= SPRD_LCR_EVEN_PAR;
>> +     }
>
> [...]
>
>> +static int sprd_probe(struct platform_device *pdev)
>> +{
>> +     struct resource *res;
>> +     struct uart_port *up;
>> +     struct clk *clk;
>> +     int irq;
>> +     int index;
>> +     int ret;
>> +
>> +     for (index = 0; index < ARRAY_SIZE(sprd_port); index++)
>> +             if (sprd_port[index] == NULL)
>> +                     break;
>> +
>> +     if (index == ARRAY_SIZE(sprd_port))
>> +             return -EBUSY;
>> +
>> +     index = sprd_probe_dt_alias(index, &pdev->dev);
>> +
>> +     sprd_port[index] = devm_kzalloc(&pdev->dev,
>> +             sizeof(*sprd_port[index]), GFP_KERNEL);
>> +     if (!sprd_port[index])
>> +             return -ENOMEM;
>> +
>> +     pdev->id = index;
>
> see my recent reply regarding this and sprd_suspend/sprd_resume.
>
>> +
>> +     up = &sprd_port[index]->port;
>> +     up->dev = &pdev->dev;
>> +     up->line = index;
>> +     up->type = PORT_SPRD;
>> +     up->iotype = SERIAL_IO_PORT;
>> +     up->uartclk = SPRD_DEF_RATE;
>> +     up->fifosize = SPRD_FIFO_SIZE;
>> +     up->ops = &serial_sprd_ops;
>> +     up->flags = UPF_BOOT_AUTOCONF;
>> +
>> +     clk = devm_clk_get(&pdev->dev, NULL);
>> +     if (!IS_ERR(clk))
>> +             up->uartclk = clk_get_rate(clk);
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (!res) {
>> +             dev_err(&pdev->dev, "not provide mem resource\n");
>> +             return -ENODEV;
>> +     }
>> +     up->mapbase = res->start;
>> +     up->membase = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(up->membase))
>> +             return PTR_ERR(up->membase);
>> +
>> +     irq = platform_get_irq(pdev, 0);
>> +     if (irq < 0) {
>> +             dev_err(&pdev->dev, "not provide irq resource\n");
>> +             return -ENODEV;
>> +     }
>> +     up->irq = irq;
>> +
>> +     if (!sprd_ports_num) {
>> +             ret = uart_register_driver(&sprd_uart_driver);
>> +             if (ret < 0) {
>> +                     pr_err("Failed to register SPRD-UART driver\n");
>> +                     return ret;
>> +             }
>> +     }
>> +     sprd_ports_num++;
>> +
>> +     ret = uart_add_one_port(&sprd_uart_driver, up);
>> +     if (ret) {
>> +             sprd_port[index] = NULL;
>> +             sprd_remove(pdev);
>> +     }
>> +
>> +     platform_set_drvdata(pdev, up);
>> +
>> +     return ret;
>> +}
>> +
>> +static int sprd_suspend(struct device *dev)
>> +{
>> +     int id = to_platform_device(dev)->id;
>> +     struct uart_port *port = &sprd_port[id]->port;
>> +
>> +     uart_suspend_port(&sprd_uart_driver, port);
>
> same comment: see my recent reply using dev_get_drvdata().
>

ok, i see. thanks!

Chunyan

>> +
>> +     return 0;
>> +}
>> +
>> +static int sprd_resume(struct device *dev)
>> +{
>> +     int id = to_platform_device(dev)->id;
>> +     struct uart_port *port = &sprd_port[id]->port;
>> +
>> +     uart_resume_port(&sprd_uart_driver, port);
>> +
>> +     return 0;
>> +}
>> +
>
>
