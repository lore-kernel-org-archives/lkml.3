Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3DZS3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:29:05 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:58534 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3DZS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:29:03 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCHv4 2/5] driver: serial: omap: prevent runtime PM for "no_console_suspend"
References: <1366980168-30566-1-git-send-email-sourav.poddar@ti.com>
	<1366980168-30566-3-git-send-email-sourav.poddar@ti.com>
Date: Fri, 26 Apr 2013 11:28:58 -0700
In-Reply-To: <1366980168-30566-3-git-send-email-sourav.poddar@ti.com> (Sourav
	Poddar's message of "Fri, 26 Apr 2013 18:12:45 +0530")
Message-ID: <87mwslw3h1.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav Poddar <sourav.poddar@ti.com> writes:

> The driver manages "no_console_suspend" by preventing runtime PM
> during the suspend path, which forces the console UART to stay awake.
>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/tty/serial/omap-serial.c |   28 +++++++++++++++++++++++++++-
>  1 files changed, 27 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 30d4f7a..eddff3c 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -161,6 +161,7 @@ struct uart_omap_port {
>  	u32			calc_latency;
>  	struct work_struct	qos_work;
>  	struct pinctrl		*pins;
> +	bool			is_suspending;
>  };
>  
>  #define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
> @@ -1312,6 +1313,22 @@ static struct uart_driver serial_omap_reg = {
>  };
>  
>  #ifdef CONFIG_PM_SLEEP
> +static int serial_omap_prepare(struct device *dev)
> +{
> +	struct uart_omap_port *up = dev_get_drvdata(dev);
> +
> +	up->is_suspending = true;
> +
> +	return 0;
> +}
> +
> +static void serial_omap_complete(struct device *dev)
> +{
> +	struct uart_omap_port *up = dev_get_drvdata(dev);
> +
> +	up->is_suspending = false;
> +}
> +
>  static int serial_omap_suspend(struct device *dev)
>  {
>  	struct uart_omap_port *up = dev_get_drvdata(dev);
> @@ -1330,7 +1347,10 @@ static int serial_omap_resume(struct device *dev)
>  
>  	return 0;
>  }
> -#endif
> +#else
> +#define serial_omap_prepare NULL
> +#define serial_omap_prepare NULL
> +#endif /* CONFIG_PM_SLEEP */
>  
>  static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
>  {
> @@ -1616,6 +1636,10 @@ static int serial_omap_runtime_suspend(struct device *dev)
>  	struct uart_omap_port *up = dev_get_drvdata(dev);
>  	struct omap_uart_port_info *pdata = dev->platform_data;
>  

I'd like to see a comment here about why we return error.  It's written
in the changelog, but it deserves a comment here as well.  Something like:

When using 'no_console_suspend', the console UART must not be suspended.
Since driver suspend is managed by runtime suspend, preventing runtime
suspend (by returning error) will keep device active during suspend.


> +	if (up->is_suspending && !console_suspend_enabled
> +			&& uart_console(&up->port))

nit: can you put the '&&' at the end of the first line, and have the
2nd line line up with the start of the first line?

See other examples of similiar multi-line checks elsewhere in the
driver.

Other than those minor things, this patch is good.

Then, can you repost and break this into 2 series since they can go
independently.

Patches 1-2 need to go through the serial tree (Greg), and I will queue
up the OMAP specific changes once Greg has queued the serial core changes.

Kevin
