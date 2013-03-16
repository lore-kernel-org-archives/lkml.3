Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3CPAPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 20:15:19 -0400
Received: from blu0-omc1-s35.blu0.hotmail.com ([65.55.116.46]:41458 "EHLO
	blu0-omc1-s35.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932186Ab3CPAPS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 20:15:18 -0400
X-EIP: [eE/rDjXrb8YW0grRbRuuFAMCTyblJZ09CGJSqaXWI80=]
X-Originating-Email: [emilio@elopez.com.ar]
Message-ID: <BLU0-SMTP4156A39670AA58651B05028AEE0@phx.gbl>
Date: Fri, 15 Mar 2013 21:15:11 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Jiri Slaby <jslaby@suse.cz>, kevin@allwinnertech.com
Subject: Re: [PATCH 1/6] serial: 8250_dw: add support for clk api
References: <1363377988-4966-1-git-send-email-maxime.ripard@free-electrons.com> <1363377988-4966-2-git-send-email-maxime.ripard@free-electrons.com> <20130315223917.GZ4977@n2100.arm.linux.org.uk>
In-Reply-To: <20130315223917.GZ4977@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Mar 2013 00:15:17.0203 (UTC) FILETIME=[566F9230:01CE21DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

El 15/03/13 19:39, Russell King - ARM Linux escribió:
> On Fri, Mar 15, 2013 at 09:06:23PM +0100, Maxime Ripard wrote:
>> +	/* clock got configured through clk api, all done */
>> +	if (p->uartclk)
> 
> 	if (IS_ERR(p->uartclk))
> 

Isn't IS_ERR for pointers? p->uartclk is an unsigned int

>> +		return 0;
>> +
>> +	/* try to find out clock frequency from DT as fallback */
>>  	if (of_property_read_u32(np, "clock-frequency", &val)) {
>> -		dev_err(p->dev, "no clock-frequency property set\n");
>> +		dev_err(p->dev, "clk or clock-frequency not defined\n");
>>  		return -EINVAL;
>>  	}
>>  	p->uartclk = val;
>> @@ -294,9 +301,21 @@ static int dw8250_probe(struct platform_device *pdev)
>>  	if (!uart.port.membase)
>>  		return -ENOMEM;
>>  
>> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	data->clk = devm_clk_get(&pdev->dev, NULL);
>> +	if (IS_ERR(data->clk))
>> +		data->clk = NULL;
>> +	else
>> +		clk_prepare_enable(data->clk);
> 
> 	if (!IS_ERR(data->clk))
> 		clk_prepare_enable(data->clk);
> 

See below

>> +
>>  	uart.port.iotype = UPIO_MEM;
>>  	uart.port.serial_in = dw8250_serial_in;
>>  	uart.port.serial_out = dw8250_serial_out;
>> +	uart.port.private_data = data;
>> +	uart.port.uartclk = clk_get_rate(data->clk);
> 
> What if data->clk is invalid?
> 
> 	if (!IS_ERR(data->clk)
> 		uart.port.uartclk = clk_get_rate(data->clk);
> 

I'm not sure if it is coincidental or the way it is supposed to be, but
when using the common clock framework, if you pass a NULL to
clk_get_rate, the function explicitly checks for it and returns 0. I
relied on that behaviour when implementing this; see the if..else block
above. Is this not always the case on other clock drivers?

>>  
>>  	dw8250_setup_port(&uart);
>>  
>> @@ -312,12 +331,6 @@ static int dw8250_probe(struct platform_device *pdev)
>>  		return -ENODEV;
>>  	}
>>  
>> -	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
>> -	if (!data)
>> -		return -ENOMEM;
>> -
>> -	uart.port.private_data = data;
>> -
>>  	data->line = serial8250_register_8250_port(&uart);
>>  	if (data->line < 0)
>>  		return data->line;
>> @@ -333,6 +346,8 @@ static int dw8250_remove(struct platform_device *pdev)
>>  
>>  	serial8250_unregister_port(data->line);
>>  
> 
> 	if (!IS_ERR(data->clk)
> 

I just double checked and clk_enable/disable, clk_prepare/unprepare also
ignore NULLs passed to them on the CCF.

>> +	clk_disable_unprepare(data->clk);
>> +
>>  	return 0;
>>  }
>>  
>> -- 
>> 1.7.10.4

Thanks for the review,

Emilio
