Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbbA2Pto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:49:44 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:50200 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbA2Ptl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:49:41 -0500
Message-ID: <54CA568E.6080306@hurleysoftware.com>
Date: Thu, 29 Jan 2015 10:49:34 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>,
        Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        gregkh@linuxfoundation.org
CC: robh+dt@kernel.org, mark.rutland@arm.com, arnd@arndb.de,
        gnomes@lxorguk.ukuu.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, jslaby@suse.cz, heiko@sntech.de,
        jason@lakedaemon.net, florian.vaussard@epfl.ch, andrew@lunn.ch,
        hytszk@gmail.com, antonynpavlov@gmail.com, shawn.guo@linaro.org,
        orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
References: <sc9836-serial-v10> <1422443324-25082-1-git-send-email-chunyan.zhang@spreadtrum.com> <1422443324-25082-3-git-send-email-chunyan.zhang@spreadtrum.com> <54CA5128.8050500@gmail.com>
In-Reply-To: <54CA5128.8050500@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,

On 01/29/2015 10:26 AM, Varka Bhadram wrote:
> Hi,
> 
> On Wednesday 28 January 2015 04:38 PM, Chunyan Zhang wrote:
>> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>> spreadtrum sharkl64 platform.
>> This driver also support earlycon.
>>
>> Originally-by: Lanqing Liu <lanqing.liu@spreadtrum.com>
>> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
>> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>   drivers/tty/serial/Kconfig       |   18 +
>>   drivers/tty/serial/Makefile      |    1 +
>>   drivers/tty/serial/sprd_serial.c |  793 ++++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/serial_core.h |    3 +
>>   4 files changed, 815 insertions(+)
>>   create mode 100644 drivers/tty/serial/sprd_serial.c
>>
> (...)
> 
>> +static int sprd_probe(struct platform_device *pdev)
>> +{
>> +    struct resource *res;
>> +    struct uart_port *up;
>> +    struct clk *clk;
>> +    int irq;
>> +    int index;
>> +    int ret;
>> +
>> +    for (index = 0; index < ARRAY_SIZE(sprd_port); index++)
>> +        if (sprd_port[index] == NULL)
>> +            break;
>> +
>> +    if (index == ARRAY_SIZE(sprd_port))
>> +        return -EBUSY;
>> +
>> +    index = sprd_probe_dt_alias(index, &pdev->dev);
>> +
>> +    sprd_port[index] = devm_kzalloc(&pdev->dev,
>> +        sizeof(*sprd_port[index]), GFP_KERNEL);
>> +    if (!sprd_port[index])
>> +        return -ENOMEM;
>> +
>> +    up = &sprd_port[index]->port;
>> +    up->dev = &pdev->dev;
>> +    up->line = index;
>> +    up->type = PORT_SPRD;
>> +    up->iotype = SERIAL_IO_PORT;
>> +    up->uartclk = SPRD_DEF_RATE;
>> +    up->fifosize = SPRD_FIFO_SIZE;
>> +    up->ops = &serial_sprd_ops;
>> +    up->flags = UPF_BOOT_AUTOCONF;
>> +
>> +    clk = devm_clk_get(&pdev->dev, NULL);
>> +    if (!IS_ERR(clk))
>> +        up->uartclk = clk_get_rate(clk);
>> +
>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +    if (!res) {
>> +        dev_err(&pdev->dev, "not provide mem resource\n");
>> +        return -ENODEV;
>> +    }
> 
> This check is not required. It will be done by devm_ioremap_resource()

I disagree. devm_ioremap_resource() interprets the NULL resource as
a bad parameter and returns -EINVAL which is then forwarded as the
return value from the probe.

-ENODEV is the correct return value from the probe if the expected
resource is not available (either because it doesn't exist or was already
claimed by another driver).

Regards,
Peter Hurley

>> +    up->mapbase = res->start;
>> +    up->membase = devm_ioremap_resource(&pdev->dev, res);
>> +    if (IS_ERR(up->membase))
>> +        return PTR_ERR(up->membase);
>> +
>>
> 

