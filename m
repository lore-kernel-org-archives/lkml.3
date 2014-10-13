Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaJMJls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:41:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15538 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaJMJlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:41:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 13 Oct 2014 02:41:26 -0700
Message-ID: <543B9E44.109@nvidia.com>
Date: Mon, 13 Oct 2014 17:41:24 +0800
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
Subject: Re: [PATCHv2] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
References: <1413185820-5920-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1413185820-5920-1-git-send-email-jingchang.lu@freescale.com>
X-Originating-IP: [10.19.108.115]
X-ClientProxiedBy: DRBGMAIL101.nvidia.com (10.18.16.20) To
 DRBGMAIL104.nvidia.com (10.18.16.23)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/13/2014 03:37 PM, Jingchang Lu wrote:
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
> changes in v2:
>   add switch selection on uart type.

After apply this, it can't build for me. I still need to apply the fix 
like something below.

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index e535f9c1563d..14c1ff4e7816 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -9,6 +9,7 @@
   *  2 of the License, or (at your option) any later version.
   *
   */
+#include <linux/console.h>
  #include <linux/module.h>
  #include <linux/slab.h>
  #include <linux/delay.h>
@@ -248,13 +249,13 @@ static int of_serial_suspend(struct device *dev)
  #ifdef CONFIG_SERIAL_8250
         case PORT_8250 ... PORT_MAX_8250:
         {
-               struct uart_8250_port port8250;
+               struct uart_8250_port *port8250;
                 port8250 = serial8250_get_port(info->line);

                 serial8250_suspend_port(info->line);
                 if (info->clk &&
-                   (!uart_console(port8250) ||
-                    (uart_console(port8250) && console_suspend_enabled)))
+                   (!uart_console(&port8250->port) ||
+                    (uart_console(&port8250->port) && 
console_suspend_enabled)))
                         clk_disable_unprepare(info->clk);
                 break;
         }
@@ -274,12 +275,12 @@ static int of_serial_resume(struct device *dev)
  #ifdef CONFIG_SERIAL_8250
         case PORT_8250 ... PORT_MAX_8250:
         {
-               struct uart_8250_port port8250;
+               struct uart_8250_port *port8250;
                 port8250 = serial8250_get_port(info->line);

                 if (info->clk &&
-                   (!uart_console(port8250) ||
-                    (uart_console(port8250) && console_suspend_enabled)))
+                   (!uart_console(&port8250->port) ||
+                    (uart_console(&port8250->port) && 
console_suspend_enabled)))
                         clk_prepare_enable(info->clk);

                 serial8250_resume_port(info->line);

-Joseph

>
>   drivers/tty/serial/of_serial.c | 42 ++++++++++++++++++++++++++++++++++++------
>   1 file changed, 36 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index 8bc2563..b525383 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -245,9 +245,24 @@ static int of_serial_suspend(struct device *dev)
>   {
>   	struct of_serial_info *info = dev_get_drvdata(dev);
>
> -	serial8250_suspend_port(info->line);
> -	if (info->clk)
> -		clk_disable_unprepare(info->clk);
> +	switch(info->type) {
> +#ifdef CONFIG_SERIAL_8250
> +	case PORT_8250 ... PORT_MAX_8250:
> +	{
> +		struct uart_8250_port port8250;
> +		port8250 = serial8250_get_port(info->line);
> +
> +		serial8250_suspend_port(info->line);
> +		if (info->clk &&
> +		    (!uart_console(port8250) ||
> +		     (uart_console(port8250) && console_suspend_enabled)))
> +			clk_disable_unprepare(info->clk);
> +		break;
> +	}
> +#endif
> +	default:
> +		break;
> +	}
>
>   	return 0;
>   }
> @@ -256,10 +271,25 @@ static int of_serial_resume(struct device *dev)
>   {
>   	struct of_serial_info *info = dev_get_drvdata(dev);
>
> -	if (info->clk)
> -		clk_prepare_enable(info->clk);
> +	switch(info->type) {
> +#ifdef CONFIG_SERIAL_8250
> +	case PORT_8250 ... PORT_MAX_8250:
> +	{
> +		struct uart_8250_port port8250;
> +		port8250 = serial8250_get_port(info->line);
> +
> +		if (info->clk &&
> +		    (!uart_console(port8250) ||
> +		     (uart_console(port8250) && console_suspend_enabled)))
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
>   	return 0;
>   }
>
