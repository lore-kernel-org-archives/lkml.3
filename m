Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaJOBBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 21:01:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13147 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbaJOBBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 21:01:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 14 Oct 2014 18:01:13 -0700
Message-ID: <543DC753.4070304@nvidia.com>
Date: Wed, 15 Oct 2014 09:01:07 +0800
From: Joseph Lo <josephl@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jingchang Lu <jingchang.lu@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
References: <1413276146-20388-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1413276146-20388-1-git-send-email-jingchang.lu@freescale.com>
X-Originating-IP: [10.19.108.115]
X-ClientProxiedBy: DRBGMAIL102.nvidia.com (10.18.16.21) To
 DRBGMAIL101.nvidia.com (10.18.16.20)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 04:42 PM, Jingchang Lu wrote:
> This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
> "serial: of-serial: add PM suspend/resume support", which disables
> the uart clock on suspend, but also causes a hardware hang on register
> access if no_console_suspend command line option is used.
>
> Also, not every of_serial device is an 8250 port, so the serial8250
> suspend/resume functions should only be applied to a real 8250 port.
>
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>

If you can make sure this patch can build without include 
<linux/console.h>, then this patch

Tested-by: Joseph Lo <josephl@nvidia.com>

And thanks for your fix.

> ---
> changes in v4:
>   separate 8250 port suspend/resume from of_serial_suspend/resume.
>
> changes in v3:
>   fix up point reference and deference.
>
> changes in v2:
>   add switch selection on uart type.
>
>   drivers/tty/serial/of_serial.c | 52 ++++++++++++++++++++++++++++++++++++------
>   1 file changed, 45 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index 8bc2563..5281f8f 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -241,13 +241,48 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
>   }
>
>   #ifdef CONFIG_PM_SLEEP
> -static int of_serial_suspend(struct device *dev)
> +#ifdef CONFIG_SERIAL_8250
> +static void of_serial_suspend_8250(struct of_serial_info *info)
>   {
> -	struct of_serial_info *info = dev_get_drvdata(dev);
> +	struct uart_8250_port *port8250 = serial8250_get_port(info->line);
> +	struct uart_port *port = &port8250->port;
>
>   	serial8250_suspend_port(info->line);
> -	if (info->clk)
> +	if (info->clk && (!uart_console(port) || console_suspend_enabled))
>   		clk_disable_unprepare(info->clk);
> +}
> +
> +static void of_serial_resume_8250(struct of_serial_info *info)
> +{
> +	struct uart_8250_port *port8250 = serial8250_get_port(info->line);
> +	struct uart_port *port = &port8250->port;
> +
> +	if (info->clk && (!uart_console(port) || console_suspend_enabled))
> +		clk_prepare_enable(info->clk);
> +
> +	serial8250_resume_port(info->line);
> +}
> +#else
> +static inline void of_serial_suspend_8250(struct of_serial_info *info)
> +{
> +}
> +
> +static inline void of_serial_resume_8250(struct of_serial_info *info)
> +{
> +}
> +#endif
> +
> +static int of_serial_suspend(struct device *dev)
> +{
> +	struct of_serial_info *info = dev_get_drvdata(dev);
> +
> +	switch(info->type) {
> +	case PORT_8250 ... PORT_MAX_8250:
> +		of_serial_suspend_8250(info);
> +		break;
> +	default:
> +		break;
> +	}
>
>   	return 0;
>   }
> @@ -256,10 +291,13 @@ static int of_serial_resume(struct device *dev)
>   {
>   	struct of_serial_info *info = dev_get_drvdata(dev);
>
> -	if (info->clk)
> -		clk_prepare_enable(info->clk);
> -
> -	serial8250_resume_port(info->line);
> +	switch(info->type) {
> +	case PORT_8250 ... PORT_MAX_8250:
> +		of_serial_resume_8250(info);
> +		break;
> +	default:
> +		break;
> +	}
>
>   	return 0;
>   }
>
