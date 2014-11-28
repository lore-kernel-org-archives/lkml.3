Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaK1Mal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:30:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:2500 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbaK1Mah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:30:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,476,1413270000"; 
   d="scan'208";a="629640000"
Message-ID: <1417177832.17201.12.camel@linux.intel.com>
Subject: Re: [PATCH] serial: 8250_dw: Handle no_console_suspend when uart
 loses state
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Stuebner <heiko@sntech.de>, Jiri Slaby <jslaby@suse.cz>,
        Chris Zhong <zyw@rock-chips.com>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Bresticker <abrestic@chromium.org>,
        mika.westerberg@linux.intel.com, heikki.krogerus@linux.intel.com,
        wens@csie.org, alan@linux.intel.com, loic.poulain@intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Nov 2014 14:30:32 +0200
In-Reply-To: <1416011556-23422-1-git-send-email-dianders@chromium.org>
References: <1416011556-23422-1-git-send-email-dianders@chromium.org>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 16:32 -0800, Doug Anderson wrote:
> In certain suspend modes on certain boards the 8250 UART may lose
> state when the device goes to suspend.  If we're using
> no_console_suspend this can cause lots of problems during resume.
> 
> Let's cache the basic UART config registers at suspend time and if we
> notice that the UART loses state (by looking at a canary stored in the
> scratch register) we'll restore it.
> 

Few comments below.

> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Note that I don't have a board that properly suspends and resumes from
> the deepest sleep state that runs atop mainline, so this is tested on
> a local tree that is based on 3.14 with backports (specifically on
> rk3288-pinky).  It is compile tested atop mainline.
> 
>  drivers/tty/serial/8250/8250_dw.c | 67 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 
> diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
> index 0bfdccc..444ff540 100644
> --- a/drivers/tty/serial/8250/8250_dw.c
> +++ b/drivers/tty/serial/8250/8250_dw.c
> @@ -38,6 +38,9 @@
>  #define DW_UART_CPR	0xf4 /* Component Parameter Register */
>  #define DW_UART_UCV	0xf8 /* UART Component Version */
>  
> +/* We'll place this canary in SCR while suspending; if gone we've lost state */
> +#define DW_UART_SCR_STATE		0x22
> +
>  /* Component Parameter Register bits */
>  #define DW_UART_CPR_ABP_DATA_WIDTH	(3 << 0)
>  #define DW_UART_CPR_AFCE_MODE		(1 << 4)
> @@ -63,6 +66,13 @@ struct dw8250_data {
>  	struct clk		*pclk;
>  	struct reset_control	*rst;
>  	struct uart_8250_dma	dma;
> +
> +	int			suspending;

> +	int			saved_lcr;

Why not u32?

> +	int			saved_dll;
> +	int			saved_dlm;
> +	int			saved_ier;
> +	int			saved_fcr;

Could it be separate structure (struct reg_context, for example)?

>  };
>  
>  #define BYT_PRV_CLK			0x800
> @@ -92,10 +102,35 @@ static void dw8250_force_idle(struct uart_port *p)
>  	(void)p->serial_in(p, UART_RX);
>  }
>  
> +static void dw8250_serial_restore(struct uart_port *p)
> +{
> +	struct dw8250_data *data = p->private_data;
> +	struct uart_8250_port *port8250 = serial8250_get_port(data->line);
> +
> +	data->suspending = 0;
> +
> +	serial_out(port8250, UART_LCR, data->saved_lcr | UART_LCR_DLAB);
> +	serial_out(port8250, UART_DLL, data->saved_dll);
> +	serial_out(port8250, UART_DLM, data->saved_dlm);
> +	serial_out(port8250, UART_LCR, data->saved_lcr);
> +
> +	serial_out(port8250, UART_IER, data->saved_ier);
> +	serial_out(port8250, UART_FCR, data->saved_fcr);
> +	serial_out(port8250, UART_MCR, data->last_mcr);
> +}
> +
>  static void dw8250_serial_out(struct uart_port *p, int offset, int value)
>  {
>  	struct dw8250_data *d = p->private_data;
>  
> +	/*
> +	 * If we started suspending and we see SCR went back to 0, assume we've
> +	 * suspended and resumed and lost state.  Restore it now.
> +	 */
> +	if (d->suspending &&
> +	    readb(p->membase + (UART_SCR << p->regshift)) != DW_UART_SCR_STATE)
> +		dw8250_serial_restore(p);
> +
>  	if (offset == UART_MCR)
>  		d->last_mcr = value;
>  
> @@ -133,6 +168,14 @@ static void dw8250_serial_out32(struct uart_port *p, int offset, int value)
>  {
>  	struct dw8250_data *d = p->private_data;
>  
> +	/*
> +	 * If we started suspending and we see SCR went back to 0, assume we've
> +	 * suspended and resumed and lost state.  Restore it now.
> +	 */
> +	if (d->suspending &&
> +	    readb(p->membase + (UART_SCR << p->regshift)) != DW_UART_SCR_STATE)
> +		dw8250_serial_restore(p);
> +
>  	if (offset == UART_MCR)
>  		d->last_mcr = value;
>  
> @@ -487,9 +530,29 @@ static int dw8250_remove(struct platform_device *pdev)
>  static int dw8250_suspend(struct device *dev)
>  {
>  	struct dw8250_data *data = dev_get_drvdata(dev);
> +	struct uart_8250_port *port8250 = serial8250_get_port(data->line);
> +	struct uart_port *port = &port8250->port;
>  
>  	serial8250_suspend_port(data->line);
>  
> +	/* We only deal with ports that were left on (no_console_suspend) */
> +	if (port->suspended)
> +		return 0;
> +
> +	/* We'll save our registers in case we lose state in suspend */
> +	data->saved_fcr = serial_in(port8250, UART_FCR);
> +	data->saved_ier = serial_in(port8250, UART_IER);
> +	data->saved_lcr = serial_in(port8250, UART_LCR);
> +
> +	serial_out(port8250, UART_LCR, data->saved_lcr | UART_LCR_DLAB);
> +	data->saved_dlm = serial_in(port8250, UART_DLM);
> +	data->saved_dll = serial_in(port8250, UART_DLL);
> +	serial_out(port8250, UART_LCR, data->saved_lcr);
> +
> +	/* Put a special canary in the scratch so we tell when state is lost */
> +	serial_out(port8250, UART_SCR, DW_UART_SCR_STATE);
> +	data->suspending = 1;
> +

Could it be dw8250_serial_save() in analogue with _restore()?

>  	return 0;
>  }
>  
> @@ -497,6 +560,10 @@ static int dw8250_resume(struct device *dev)
>  {
>  	struct dw8250_data *data = dev_get_drvdata(dev);
>  
> +	/* We never lost state; stop checking for canary */
> +	if (data->suspending)
> +		data->suspending = 0;
> +
>  	serial8250_resume_port(data->line);
>  
>  	return 0;


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

