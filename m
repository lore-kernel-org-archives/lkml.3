Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3COTsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:48:13 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56601 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3COTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:48:12 -0400
Message-ID: <51437AF9.2050007@free-electrons.com>
Date: Fri, 15 Mar 2013 20:48:09 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-arm-kernel@lists.infradead.org, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        =?ISO-8859-1?Q?Emilio_?= =?ISO-8859-1?Q?L=F3pez?= 
	<emilio@elopez.com.ar>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] serial: 8250_dw: add support for clocks property
 when using DeviceTree
References: <1362694460-1919-1-git-send-email-maxime.ripard@free-electrons.com> <1362694460-1919-2-git-send-email-maxime.ripard@free-electrons.com> <20130315125615.GA27560@xps8300>
In-Reply-To: <20130315125615.GA27560@xps8300>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki

Le 15/03/2013 13:56, Heikki Krogerus a écrit :
>> @@ -137,8 +140,15 @@ static int dw8250_probe_of(struct uart_port *p)
>>  		p->regshift = val;
>>  
>>  	if (of_property_read_u32(np, "clock-frequency", &val)) {
>> -		dev_err(p->dev, "no clock-frequency property set\n");
>> -		return -EINVAL;
>> +		/* Get clk rate through clk driver if present */
>> +		data->clk = clk_get(p->dev, NULL);
>> +		if (IS_ERR(data->clk)) {
>> +			dev_err(p->dev, "clk or clock-frequency not defined\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		clk_prepare_enable(data->clk);
>> +		val = clk_get_rate(data->clk);
> 
> Don't get the clk here..
> 
>>  	}
>>  	p->uartclk = val;
>>  
>> @@ -300,6 +310,12 @@ static int dw8250_probe(struct platform_device *pdev)
> 
> Get it here so it is then handled for also others besides DT users.
> And prefer devm_clk_get(). Something like this:
> 
>         ...
>         uart.port.membase = ioremap(regs->start, resource_size(regs));
>         if (!uart.port.membase)
>                 return -ENOMEM;
> 
> +       data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +       	return -ENOMEM;
> +        
> +       data->clk = devm_clk_get(&pdev->dev, NULL);
> +       clk_prepare_enable(data->clk);
> +
>         uart.port.iotype = UPIO_MEM;
>         uart.port.serial_in = dw8250_serial_in;
>         uart.port.serial_out = dw8250_serial_out;
> +       uart.port.private_data = data;
> +       uart.port.uartclk = clk_get_rate(data->clk);
> 
>   	dw8250_setup_port(&uart);
>         ... 
> 
> Then in dw8250_probe_of() you need to use the "clock-frequency"
> property only when p->uartclk is 0.

Thanks for your feedback.
Emilio made a new version of this patch, I'll send it soon.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
