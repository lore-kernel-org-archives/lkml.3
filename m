Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab3CPAbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 20:31:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36675 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab3CPAbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 20:31:17 -0400
Date: Sat, 16 Mar 2013 00:29:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Jiri Slaby <jslaby@suse.cz>, kevin@allwinnertech.com
Subject: Re: [PATCH 1/6] serial: 8250_dw: add support for clk api
Message-ID: <20130316002952.GA4977@n2100.arm.linux.org.uk>
References: <1363377988-4966-1-git-send-email-maxime.ripard@free-electrons.com> <1363377988-4966-2-git-send-email-maxime.ripard@free-electrons.com> <20130315223917.GZ4977@n2100.arm.linux.org.uk> <BLU0-SMTP4156A39670AA58651B05028AEE0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BLU0-SMTP4156A39670AA58651B05028AEE0@phx.gbl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 09:15:11PM -0300, Emilio López wrote:
> Hello Russell,
> 
> El 15/03/13 19:39, Russell King - ARM Linux escribió:
> > On Fri, Mar 15, 2013 at 09:06:23PM +0100, Maxime Ripard wrote:
> >> +	/* clock got configured through clk api, all done */
> >> +	if (p->uartclk)
> > 
> > 	if (IS_ERR(p->uartclk))
> > 
> 
> Isn't IS_ERR for pointers? p->uartclk is an unsigned int

Right, sorry, ignore that.

> >> +		return 0;
> >> +
> >> +	/* try to find out clock frequency from DT as fallback */
> >>  	if (of_property_read_u32(np, "clock-frequency", &val)) {
> >> -		dev_err(p->dev, "no clock-frequency property set\n");
> >> +		dev_err(p->dev, "clk or clock-frequency not defined\n");
> >>  		return -EINVAL;
> >>  	}
> >>  	p->uartclk = val;
> >> @@ -294,9 +301,21 @@ static int dw8250_probe(struct platform_device *pdev)
> >>  	if (!uart.port.membase)
> >>  		return -ENOMEM;
> >>  
> >> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> >> +	if (!data)
> >> +		return -ENOMEM;
> >> +
> >> +	data->clk = devm_clk_get(&pdev->dev, NULL);
> >> +	if (IS_ERR(data->clk))
> >> +		data->clk = NULL;
> >> +	else
> >> +		clk_prepare_enable(data->clk);
> > 
> > 	if (!IS_ERR(data->clk))
> > 		clk_prepare_enable(data->clk);
> > 
> 
> See below
> 
> >> +
> >>  	uart.port.iotype = UPIO_MEM;
> >>  	uart.port.serial_in = dw8250_serial_in;
> >>  	uart.port.serial_out = dw8250_serial_out;
> >> +	uart.port.private_data = data;
> >> +	uart.port.uartclk = clk_get_rate(data->clk);
> > 
> > What if data->clk is invalid?
> > 
> > 	if (!IS_ERR(data->clk)
> > 		uart.port.uartclk = clk_get_rate(data->clk);
> > 
> 
> I'm not sure if it is coincidental or the way it is supposed to be, but
> when using the common clock framework, if you pass a NULL to
> clk_get_rate, the function explicitly checks for it and returns 0. I
> relied on that behaviour when implementing this; see the if..else block
> above. Is this not always the case on other clock drivers?

That's something that the common clock framework decided to do.  It's
not a defined part of the API though, so drivers shouldn't rely on
this behaviour meaning anything special.
