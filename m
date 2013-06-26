Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab3FZGng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:43:36 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34379 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3FZGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:43:34 -0400
Message-ID: <51CA8D91.6000708@suse.cz>
Date: Wed, 26 Jun 2013 08:43:29 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/8] pch_uart: Add uart_clk selection for the MinnowBoard
References: <cover.1372211451.git.dvhart@linux.intel.com>  <6cc125b9eb85dd3cae4a2496fdb7f0d17b18f930.1372211451.git.dvhart@linux.intel.com>  <20130626023143.GB23320@kroah.com> <1372216578.8177.9.camel@envy.home>  <20130626033926.GA27165@kroah.com> <1372219125.8177.12.camel@envy.home>
In-Reply-To: <1372219125.8177.12.camel@envy.home>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 05:58 AM, Darren Hart wrote:
> Subject: [PATCH] pch_uart: Use DMI interface for board detection
> 
> Use the DMI interface rather than manually matching DMI strings.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> ---
>  drivers/tty/serial/pch_uart.c | 71
> +++++++++++++++++++++++++++++--------------
>  1 file changed, 49 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/tty/serial/pch_uart.c
> b/drivers/tty/serial/pch_uart.c
> index 572d481..271cc73 100644
> --- a/drivers/tty/serial/pch_uart.c
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -373,35 +373,62 @@ static const struct file_operations port_regs_ops
> = {
>  };
>  #endif	/* CONFIG_DEBUG_FS */
>  
> +static struct dmi_system_id __initdata pch_uart_dmi_table[] = {
> +	{
> +		.ident = "CM-iTC",
> +		{
> +			DMI_MATCH(DMI_BOARD_NAME, "CM-iTC"),
> +		},
> +		(void *)CMITC_UARTCLK,
> +	},
> +	{
> +		.ident = "FRI2",
> +		{
> +			DMI_MATCH(DMI_BIOS_VERSION, "FRI2"),
> +		},
> +		(void *)FRI2_64_UARTCLK,
> +	},
> +	{
> +		.ident = "Fish River Island II",
> +		{
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Fish River Island II"),
> +		},
> +		(void *)FRI2_48_UARTCLK,
> +	},
> +	{
> +		.ident = "COMe-mTT",
> +		{
> +			DMI_MATCH(DMI_BOARD_NAME, "COMe-mTT"),
> +		},
> +		(void *)NTC1_UARTCLK,
> +	},
> +	{
> +		.ident = "nanoETXexpress-TT",
> +		{
> +			DMI_MATCH(DMI_BOARD_NAME, "nanoETXexpress-TT"),
> +		},
> +		(void *)NTC1_UARTCLK,
> +	},
> +	{
> +		.ident = "MinnowBoard",
> +		{
> +			DMI_MATCH(DMI_BOARD_NAME, "MinnowBoard"),
> +		},
> +		(void *)MINNOW_UARTCLK,
> +	},
> +};
> +
>  /* Return UART clock, checking for board specific clocks. */
>  static int pch_uart_get_uartclk(void)
>  {
> -	const char *cmp;
> +	const struct dmi_system_id *d;
>  
>  	if (user_uartclk)
>  		return user_uartclk;
>  
> -	cmp = dmi_get_system_info(DMI_BOARD_NAME);
> -	if (cmp && strstr(cmp, "CM-iTC"))
> -		return CMITC_UARTCLK;
> -
> -	cmp = dmi_get_system_info(DMI_BIOS_VERSION);
> -	if (cmp && strnstr(cmp, "FRI2", 4))
> -		return FRI2_64_UARTCLK;
> -
> -	cmp = dmi_get_system_info(DMI_PRODUCT_NAME);
> -	if (cmp && strstr(cmp, "Fish River Island II"))
> -		return FRI2_48_UARTCLK;
> -
> -	/* Kontron COMe-mTT10 (nanoETXexpress-TT) */
> -	cmp = dmi_get_system_info(DMI_BOARD_NAME);
> -	if (cmp && (strstr(cmp, "COMe-mTT") ||
> -		    strstr(cmp, "nanoETXexpress-TT")))
> -		return NTC1_UARTCLK;
> -
> -	cmp = dmi_get_system_info(DMI_BOARD_NAME);
> -	if (cmp && strstr(cmp, "MinnowBoard"))
> -		return MINNOW_UARTCLK;
> +	d = dmi_first_match(pch_uart_dmi_table);
> +	if (d)
> +		return (int)d->driver_data;

This and the (void *) casts above will generate a warning on 64bit,
right? We need to go through long here...

-- 
js
suse labs
