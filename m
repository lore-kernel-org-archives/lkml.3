Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaJMMBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:01:16 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49319 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753341AbaJMMBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:01:14 -0400
Message-ID: <543BBF02.20302@hurleysoftware.com>
Date: Mon, 13 Oct 2014 08:01:06 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jingchang Lu <jingchang.lu@freescale.com>, gregkh@linuxfoundation.org
CC: josephl@nvidia.com, arnd@arndb.de, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
References: <1413191667-10949-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1413191667-10949-1-git-send-email-jingchang.lu@freescale.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 05:14 AM, Jingchang Lu wrote:
> This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
> "serial: of-serial: add PM suspend/resume support", which disables
> the uart clock on suspend, but also causes a hardware hang on register
> access if no_console_suspend command line option is used.
> 
> Also, not every of_serial device is an 8250 port, so the serial8250
> suspend/resume functions should only be applied to a real 8250 port.
> 
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> ---
> changes in v3:
>  fix up point reference and deference.
> 
> changes in v2:
>  add switch selection on uart type.
> 
>  drivers/tty/serial/of_serial.c | 42 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index 8bc2563..9d747a7 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -245,9 +245,24 @@ static int of_serial_suspend(struct device *dev)
>  {
>  	struct of_serial_info *info = dev_get_drvdata(dev);
>  
> -	serial8250_suspend_port(info->line);
> -	if (info->clk)
> -		clk_disable_unprepare(info->clk);
> +	switch(info->type) {
> +#ifdef CONFIG_SERIAL_8250
> +	case PORT_8250 ... PORT_MAX_8250:
> +	{
> +		struct uart_8250_port *port8250;
> +		port8250 = serial8250_get_port(info->line);
> +
> +		serial8250_suspend_port(info->line);
> +		if (info->clk &&
> +		    (!uart_console(&port8250->port) ||
> +		    (uart_console(&port8250->port) && console_suspend_enabled)))

This conditional is the same as

		if (info->clk && (!uart_console(&port8250->port) || console_suspend_enabled))

> +			clk_disable_unprepare(info->clk);
> +		break;
> +	}
> +#endif
> +	default:
> +		break;
> +	}

I suggest you separate this into a separate function like:

#ifdef CONFIG_SERIAL_8250
static void of_serial_suspend_8250(struct of_serial_info *info)
{
	struct uart_8250_port *uart = serial_8250_get_port(info->line);
	struct uart_port *port = &uart->port;

	serial8250_suspend_port(info->line);
	if (info->clk && (!uart_console(port) || console_suspend_enabled))
		clk_disable_unprepare(info->clk);
}
#else
static inline void of_serial_suspend_8250(struct of_serial_info *info)
{ }
#endif

and call it like:

static int of_serial_suspend(struct device *dev)
{
	struct of_serial_info *info = dev_get_drvdata(dev);

	switch (info->type) {
	case PORT_8250 ... PORT_MAX_8250:
		of_serial_suspend_8250(info);
		break;
	}

	return 0;
}

I did not build-test this, so you should.

Regards,
Peter Hurley

>  
>  	return 0;
>  }
> @@ -256,10 +271,25 @@ static int of_serial_resume(struct device *dev)
>  {
>  	struct of_serial_info *info = dev_get_drvdata(dev);
>  
> -	if (info->clk)
> -		clk_prepare_enable(info->clk);
> +	switch(info->type) {
> +#ifdef CONFIG_SERIAL_8250
> +	case PORT_8250 ... PORT_MAX_8250:
> +	{
> +		struct uart_8250_port *port8250;
> +		port8250 = serial8250_get_port(info->line);
> +
> +		if (info->clk &&
> +		    (!uart_console(&port8250->port) ||
> +		    (uart_console(&port8250->port) && console_suspend_enabled)))
> +			clk_prepare_enable(info->clk);
>  
> -	serial8250_resume_port(info->line);
> +		serial8250_resume_port(info->line);
> +		break;
> +	}
> +#endif
> +	default:
> +		break;
> +	}
>  
>  	return 0;
>  }
> 

