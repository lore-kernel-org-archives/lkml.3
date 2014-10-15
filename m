Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaJOJEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:04:32 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10910 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaJOJE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:04:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 15 Oct 2014 02:00:13 -0700
Message-ID: <543E3834.7070308@nvidia.com>
Date: Wed, 15 Oct 2014 17:02:44 +0800
From: Joseph Lo <josephl@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jingchang Lu <jingchang.lu@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
References: <1413353967-27866-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1413353967-27866-1-git-send-email-jingchang.lu@freescale.com>
X-Originating-IP: [10.19.108.115]
X-ClientProxiedBy: DRBGMAIL101.nvidia.com (10.18.16.20) To
 DRBGMAIL102.nvidia.com (10.18.16.21)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 02:19 PM, Jingchang Lu wrote:
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
> changes in v5:
>   add missing <linux/console.h> include.
>
> changes in v4:
>   separate 8250 port suspend/resume from of_serial_suspend/resume.
>
> changes in v3:
>   fix up point reference and deference.
>
> changes in v2:
>   add switch selection on uart type.
>
Hi Jingchang,

Thanks for the fix. This patch
Tested-by: Joseph Lo <josephl@nvidia.com>

>   drivers/tty/serial/of_serial.c | 53 ++++++++++++++++++++++++++++++++++++------
>   1 file changed, 46 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index 8bc2563..9c64ad2 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -9,6 +9,7 @@
>    *  2 of the License, or (at your option) any later version.
>    *
>    */
> +#include <linux/console.h>
>   #include <linux/module.h>
>   #include <linux/slab.h>
>   #include <linux/delay.h>
> @@ -241,13 +242,48 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
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
> @@ -256,10 +292,13 @@ static int of_serial_resume(struct device *dev)
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
