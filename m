Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3LSIv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:51:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:35293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab3LSIvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:51:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="454741184"
Date: Thu, 19 Dec 2013 10:51:45 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        James Cameron <quozl@laptop.org>, Zhou Zhu <zzhu3@marvell.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 01/21 resend] serial: rewrite pxa2xx-uart to use
 8250_core
Message-ID: <20131219085145.GB20686@xps8300>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-2-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387309071-22382-2-git-send-email-ynvich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

I noticed one more thing. I'm sorry about commenting this late.

On Tue, Dec 17, 2013 at 11:37:31PM +0400, Sergei Ianovich wrote:
> +static int serial_pxa_probe(struct platform_device *pdev)
> +{
> +	struct uart_8250_port uart = {};
> +	struct pxa8250_data *data;
> +	struct resource *mmres, *irqres;
> +	int ret;
> +
> +	mmres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	irqres = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!mmres || !irqres)
> +		return -ENODEV;
> +
> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(data->clk))
> +		return PTR_ERR(data->clk);
> +
> +	ret = clk_prepare(data->clk);
> +	if (ret)
> +		return ret;
> +
> +	uart.port.type = PORT_XSCALE;
> +	uart.port.iotype = UPIO_MEM32;
> +	uart.port.mapbase = mmres->start;
> +	uart.port.regshift = 2;
> +	uart.port.irq = irqres->start;
> +	uart.port.fifosize = 64;
> +	uart.port.flags = UPF_IOREMAP | UPF_SKIP_TEST;

Since you set the type PORT_XSCALE, don's you want to use
UPF_FIXED_TYPE flag instead of the UPF_SKIP_TEST here? Otherwise the
type will just get overridden and autoconfig() will be executed.

I'm guessing you also want to prevent things like the irq and the
uartclk from being changed by anybody by using the flag
UPF_FIXED_PORT, right?

> +	uart.port.dev = &pdev->dev;
> +	uart.port.uartclk = clk_get_rate(data->clk);
> +	uart.port.pm = serial_pxa_pm;
> +	uart.port.private_data = data;
> +	uart.dl_write = serial_pxa_dl_write;
> +
> +	ret = serial8250_register_8250_port(&uart);
> +	if (ret < 0)
> +		goto err_clk;
> +
> +	data->line = ret;
> +
> +	platform_set_drvdata(pdev, data);
> +
> +	return 0;
> +
> + err_clk:
> +	clk_unprepare(data->clk);
> +	return ret;
> +}

-- 
heikki
