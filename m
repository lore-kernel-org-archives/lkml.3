Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbaGaHHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:07:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbaGaHHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:07:49 -0400
Date: Thu, 31 Jul 2014 09:07:46 +0200
From: Jean Delvare <jdelvare@suse.de>
To: kreijack@inwind.it
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] therm_windtunnel doesn't work properly on PowerMac
 G4
Message-ID: <20140731090746.31aad3c9@endymion.delvare>
In-Reply-To: <53D95AB1.70300@inwind.it>
References: <53D95AB1.70300@inwind.it>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Goffredo,

For next time: please give each individual patch an appropriate
subject. Otherwise it is difficult to keep track of what each patch
does exactly.

On Wed, 30 Jul 2014 22:50:57 +0200, Goffredo Baroncelli wrote:
> Add the "log_temp" and "verbose" module parameters.

I think this is a good idea, much better than build-time settings.

> log_temp    enable/disable the temperature logging
> verbose     enable/disable the fan tune logging

These names are not very consistent, both printks are logging both the
temperatures and the fan speed.

Also I'm unsure if you really need 2 parameters for this. I see these
more as two degrees of verbosity of the same logging feature. I would
like to suggest having a single module parameter, with 3 different
values:
  0: log nothing
  1: log fan tuning (default)
  2: log fan tuning + temperature continuously

What do you think?

> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> 
> ---
>  drivers/macintosh/therm_windtunnel.c |   19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
> index fbe4516..7efba5d 100644
> --- a/drivers/macintosh/therm_windtunnel.c
> +++ b/drivers/macintosh/therm_windtunnel.c
> @@ -44,7 +44,13 @@
>  #include <asm/sections.h>
>  #include <asm/macio.h>
>  
> -#define LOG_TEMP		0			/* continuously log temperature */
> +static bool log_temp = 0;
> +module_param(log_temp, bool, 0644);
> +MODULE_PARM_DESC(log_temp, "Enable the temperature logging");
> +
> +static bool verbose = 1;
> +module_param(verbose, bool, 0644);
> +MODULE_PARM_DESC(verbose, "Enable the fan speed logging");
>  
>  static struct {
>  	volatile int		running;
> @@ -157,11 +163,12 @@ tune_fan( int fan_setting )
>  	/* write_reg( x.fan, 0x24, val, 1 ); */
>  	write_reg( x.fan, 0x25, val, 1 );
>  	write_reg( x.fan, 0x20, 0, 1 );
> -	print_temp("CPU-temp: ", x.temp );
> -	if( x.casetemp )
> +	if (verbose) {
> +		print_temp("CPU-temp: ", x.temp );
>  		print_temp(", Case: ", x.casetemp );

In the original code, there was a condition for printing the case
temperature, which you dropped. Is this on purpose? If so it should be
explained in the patch description.

BTW I see that the continuous temperature logging below does not have
such a condition. For consistency I think it should be either always or
never included.

> -	printk(",  Fan: %d (tuned %+d)\n", 11-fan_setting, x.fan_level-fan_setting );
> -
> +		printk(",  Fan: %d (tuned %+d)\n",
> +			11-fan_setting, x.fan_level-fan_setting );
> +	}
>  	x.fan_level = fan_setting;
>  }
>  
> @@ -179,7 +186,7 @@ poll_temp( void )
>  	casetemp = read_reg(x.fan, 0x0b, 1) << 8;
>  	casetemp |= (read_reg(x.fan, 0x06, 1) & 0x7) << 5;
>  
> -	if( LOG_TEMP && x.temp != temp ) {
> +	if( log_temp && x.temp != temp ) {
>  		print_temp("CPU-temp: ", temp );
>  		print_temp(", Case: ", casetemp );
>  		printk(",  Fan: %d\n", 11-x.fan_level );

Thanks,
-- 
Jean Delvare
SUSE L3 Support
