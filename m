Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbbAWNct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:32:49 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50788 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbbAWNcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:32:45 -0500
MIME-Version: 1.0
In-Reply-To: <54C248D7.6040901@hurleysoftware.com>
References: <1421933706-4277-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1421933706-4277-3-git-send-email-chunyan.zhang@spreadtrum.com>
	<54C1C69B.6010100@hurleysoftware.com>
	<CAAfSe-s2Y_JSiR+HX4OOF_62q3JYN5k81JZuNe9CP9=shBpZzA@mail.gmail.com>
	<54C248D7.6040901@hurleysoftware.com>
Date: Fri, 23 Jan 2015 21:32:43 +0800
Message-ID: <CAAfSe-vf+3sd6keo21CPbVnu9K6dBpSUUGEMcpbo25V2KPmi7g@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] tty/serial: Add Spreadtrum sc9836-uart driver support
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, "jslaby@suse.cz" <jslaby@suse.cz>,
        Grant Likely <grant.likely@linaro.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>, Hayato Suzuki <hytszk@gmail.com>,
        "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 9:12 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 01/23/2015 02:23 AM, Lyra Zhang wrote:
>> Hi, Peter
>>
>> Many thanks to you for reviewing so carefully and giving us so many
>> suggestions and so clear explanations.
>
> :)
>
>> I'll address all of your comments and send an updated patch soon.
>>
>> On Fri, Jan 23, 2015 at 11:57 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
>
> [...]
>
>>>> +static void sprd_set_termios(struct uart_port *port,
>>>> +                                 struct ktermios *termios,
>>>> +                                 struct ktermios *old)
>>>> +{
>>>> +     unsigned int baud, quot;
>>>> +     unsigned int lcr, fc;
>>>> +     unsigned long flags;
>>>> +
>>>> +     /* ask the core to calculate the divisor for us */
>>>> +     baud = uart_get_baud_rate(port, termios, old, 1200, 3000000);
>>>                                                       ^^^^   ^^^^^^
>>>                                            mabye derive these from uartclk?
>>
>> I'm afraid I can't understand very clearly, Could you explain more
>> details please?
>
> Is the fixed clock divider == 8 and the uartclk == 26000000 ?
> If so,
>         baud = uartclk / 8 = 3250000
>
> I see now this is clamping baud inside the maximum, so this is fine.
> Please disregard my comment.
>
> [...]
>
>
>>>> +static int sprd_probe(struct platform_device *pdev)
>>>> +{
>>>> +     struct resource *res;
>>>> +     struct uart_port *up;
>>>> +     struct clk *clk;
>>>> +     int irq;
>>>> +     int index;
>>>> +     int ret;
>>>> +
>>>> +     for (index = 0; index < ARRAY_SIZE(sprd_port); index++)
>>>> +             if (sprd_port[index] == NULL)
>>>> +                     break;
>>>> +
>>>> +     if (index == ARRAY_SIZE(sprd_port))
>>>> +             return -EBUSY;
>>>> +
>>>> +     index = sprd_probe_dt_alias(index, &pdev->dev);
>>>> +
>>>> +     sprd_port[index] = devm_kzalloc(&pdev->dev,
>>>> +             sizeof(*sprd_port[index]), GFP_KERNEL);
>>>> +     if (!sprd_port[index])
>>>> +             return -ENOMEM;
>>>> +
>>>> +     up = &sprd_port[index]->port;
>>>> +     up->dev = &pdev->dev;
>>>> +     up->line = index;
>>>> +     up->type = PORT_SPRD;
>>>> +     up->iotype = SERIAL_IO_PORT;
>>>> +     up->uartclk = SPRD_DEF_RATE;
>>>> +     up->fifosize = SPRD_FIFO_SIZE;
>>>> +     up->ops = &serial_sprd_ops;
>>>> +     up->flags = ASYNC_BOOT_AUTOCONF;
>>>                     ^^^^^^^^^
>>>                     UPF_BOOT_AUTOCONF
>>>
>>> sparse will catch errors like this. See Documentation/sparse.txt
>>
>> you mean we should use UPF_BOOT_AUTOCONF, right?
>
> Yes. Only UPF_* flag definitions should be used with the uart_port.flags
> field.
>
> My comment regarding the sparse tool and documentation is because the
> flags field and UPF_* definitions use a type mechanism to generate
> warnings using the sparse tool if regular integer values are used
> with the flags field.
>
> The type mechanism was specifically introduced to catch using ASYNC_*
> definitions with the uart_port.flags field.
>
> [...]
>
>>>> +static int sprd_suspend(struct device *dev)
>>>> +{
>>>> +     int id = to_platform_device(dev)->id;
>>>> +     struct uart_port *port = &sprd_port[id]->port;
>>>
>>> I'm a little confused regarding the port indexing;
>>> is platform_device->id == line ?  Where did that happen?
>>>
>>
>> Oh, I'll change to assign platform_device->id with port->line in probe()
>
> I apologize; I should have made my comment clearer.
>
> The ->id should not be assigned.
>
> Replace
>
>         int id = to_platform_device(dev)->id;
>         struct uart_port *port = &sprd_port[id]->port;
>
>         uart_suspend_port(&sprd_uart_driver, port);
>
> with
>
>         struct sprd_uart_port *sup = dev_get_drvdata(dev);
>
>         uart_suspend_port(&sprd_uart_driver, &sup->port);
>
>
> I know it's not obvious but platform_get/set_drvdata() is really
> dev_get/set_drvdata() using the embedded struct device dev.
>

I've just sent the v7 before I saw your this email, but I'll address
this point in the next version.

Thanks a lot,
Chunyan

>>
>>>
>>>> +
>>>> +     uart_suspend_port(&sprd_uart_driver, port);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static int sprd_resume(struct device *dev)
>>>> +{
>>>> +     int id = to_platform_device(dev)->id;
>>>> +     struct uart_port *port = &sprd_port[id]->port;
>>>> +
>>>> +     uart_resume_port(&sprd_uart_driver, port);
>
> same here
>
>>>> +     return 0;
>
