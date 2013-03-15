Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3COWon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:44:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36646 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3COWom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:44:42 -0400
Date: Fri, 15 Mar 2013 22:39:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Jiri Slaby <jslaby@suse.cz>, kevin@allwinnertech.com
Subject: Re: [PATCH 1/6] serial: 8250_dw: add support for clk api
Message-ID: <20130315223917.GZ4977@n2100.arm.linux.org.uk>
References: <1363377988-4966-1-git-send-email-maxime.ripard@free-electrons.com> <1363377988-4966-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363377988-4966-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 09:06:23PM +0100, Maxime Ripard wrote:
> +	/* clock got configured through clk api, all done */
> +	if (p->uartclk)

	if (IS_ERR(p->uartclk))

> +		return 0;
> +
> +	/* try to find out clock frequency from DT as fallback */
>  	if (of_property_read_u32(np, "clock-frequency", &val)) {
> -		dev_err(p->dev, "no clock-frequency property set\n");
> +		dev_err(p->dev, "clk or clock-frequency not defined\n");
>  		return -EINVAL;
>  	}
>  	p->uartclk = val;
> @@ -294,9 +301,21 @@ static int dw8250_probe(struct platform_device *pdev)
>  	if (!uart.port.membase)
>  		return -ENOMEM;
>  
> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(data->clk))
> +		data->clk = NULL;
> +	else
> +		clk_prepare_enable(data->clk);

	if (!IS_ERR(data->clk))
		clk_prepare_enable(data->clk);

> +
>  	uart.port.iotype = UPIO_MEM;
>  	uart.port.serial_in = dw8250_serial_in;
>  	uart.port.serial_out = dw8250_serial_out;
> +	uart.port.private_data = data;
> +	uart.port.uartclk = clk_get_rate(data->clk);

What if data->clk is invalid?

	if (!IS_ERR(data->clk)
		uart.port.uartclk = clk_get_rate(data->clk);

>  
>  	dw8250_setup_port(&uart);
>  
> @@ -312,12 +331,6 @@ static int dw8250_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> -	if (!data)
> -		return -ENOMEM;
> -
> -	uart.port.private_data = data;
> -
>  	data->line = serial8250_register_8250_port(&uart);
>  	if (data->line < 0)
>  		return data->line;
> @@ -333,6 +346,8 @@ static int dw8250_remove(struct platform_device *pdev)
>  
>  	serial8250_unregister_port(data->line);
>  

	if (!IS_ERR(data->clk)

> +	clk_disable_unprepare(data->clk);
> +
>  	return 0;
>  }
>  
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
