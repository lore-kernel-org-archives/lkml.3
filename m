Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3ANJUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:20:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45913 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3ANJUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:20:22 -0500
Date: Mon, 14 Jan 2013 09:20:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] serial: vt8500: UART uses gated clock rather than
	24Mhz reference
Message-ID: <20130114092007.GW23505@n2100.arm.linux.org.uk>
References: <1358129060-9399-1-git-send-email-linux@prisktech.co.nz> <1358129060-9399-4-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358129060-9399-4-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 03:04:18PM +1300, Tony Prisk wrote:
> -	if (vt8500_port->clk) {
> -		vt8500_port->uart.uartclk = clk_get_rate(vt8500_port->clk);
> -	} else {
> -		/* use the default of 24Mhz if not specified and warn */
> -		pr_warn("%s: serial clock source not specified\n", __func__);
> -		vt8500_port->uart.uartclk = 24000000;
> +	if (IS_ERR(vt8500_port->clk)) {
> +		dev_err(&pdev->dev, "failed to get clock\n");
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	ret = clk_prepare_enable(vt8500_port->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to enable clock\n");
> +		goto err;

Looks like you get rid of the initialization of vt8500_port->uart.uartclk
here.  Was that intentional?
