Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaHGIwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:52:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbaHGIwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:52:40 -0400
Subject: Re: [PATCH 3/5] Add the "verbose" module option.
From: Jean Delvare <jdelvare@suse.de>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
In-Reply-To: <1407359103-6012-4-git-send-email-kreijack@inwind.it>
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
	 <1407359103-6012-4-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Thu, 07 Aug 2014 10:52:35 +0200
Message-ID: <1407401555.4314.14.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wednesday 06 August 2014 à 21:05 +0000, Goffredo Baroncelli a écrit :
> Add a "verbose" option to control the message in the kernel log
> verbose = 0   no message
> verbose = 1   log only the fan speed changes
> verbose = 2   log the fan speed changes and the temperature changes
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  drivers/macintosh/therm_windtunnel.c | 39 +++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 14 deletions(-)

Looks overall good, minor comments inline below.

> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
> index 1e50455..7c512db 100644
> --- a/drivers/macintosh/therm_windtunnel.c
> +++ b/drivers/macintosh/therm_windtunnel.c
> @@ -44,7 +44,9 @@
>  #include <asm/sections.h>
>  #include <asm/macio.h>
>  
> -#define LOG_TEMP		0			/* continuously log temperature */
> +static int verbose = 1;
> +module_param(verbose, int, 0644);
> +MODULE_PARM_DESC(verbose, "Verbosity level: 0=silent, 1=log the fan tuning, 2=log the temperature");
>  
>  static struct {
>  	volatile int		running;
> @@ -157,10 +159,6 @@ tune_fan( int fan_setting )
>  	/* write_reg( x.fan, 0x24, val, 1 ); */
>  	write_reg( x.fan, 0x25, val, 1 );
>  	write_reg( x.fan, 0x20, 0, 1 );
> -	print_temp("CPU-temp: ", x.temp );
> -	if( x.casetemp )
> -		print_temp(", Case: ", x.casetemp );
> -	printk(",  Fan: %d (tuned %+d)\n", 11-fan_setting, x.fan_level-fan_setting );
>  
>  	x.fan_level = fan_setting;
>  }
> @@ -168,7 +166,7 @@ tune_fan( int fan_setting )
>  static void
>  poll_temp( void )
>  {
> -	int temp, i, level, casetemp;
> +	int temp, i, level, casetemp, tempchanged;
>  
>  	temp = read_reg( x.thermostat, 0, 2 );
>  
> @@ -179,14 +177,6 @@ poll_temp( void )
>  	casetemp = read_reg(x.fan, 0x0b, 1) << 8;
>  	casetemp |= (read_reg(x.fan, 0x06, 1) & 0x7) << 5;
>  
> -	if( LOG_TEMP && x.temp != temp ) {
> -		print_temp("CPU-temp: ", temp );
> -		print_temp(", Case: ", casetemp );
> -		printk(",  Fan: %d\n", 11-x.fan_level );
> -	}
> -	x.temp = temp;
> -	x.casetemp = casetemp;
> -
>  	level = -1;
>  	for( i=0; (temp & 0xffff) > fan_table[i].temp ; i++ )
>  		;
> @@ -200,6 +190,27 @@ poll_temp( void )
>  		level = fan_table[i].fan_up_setting;
>  	x.upind = i;
>  
> +	/*
> +	 * if verbose >0 log each fan tuning
> +	 * if verbose >1 log each cpu temperature change

Maybe this is just me but I think "verbose >= 1" and "verbose >= 2"
would be easier to understand. Same in the code below.

> +	 */
> +	tempchanged = x.temp != temp || x.casetemp != casetemp;
> +	if ((verbose > 1 && tempchanged) ||
> +	    (verbose > 0 && level >= 0)) {
> +		printk(KERN_INFO);
> +		print_temp("CPU-temp: ", temp);

This can be written more efficiently as a single statement:

		print_temp(KERN_INFO "CPU-temp: ", temp);

> +		if (casetemp)
> +			print_temp(", Case: ", casetemp);
> +		if (level >= 0)
> +			printk(", Fan: %d (tuned %+d)\n", 11-level,
> +				x.fan_level-level);
> +		else
> +			printk(", Fan: %d\n", 11-x.fan_level);
> +	}
> +
> +	x.temp = temp;
> +	x.casetemp = casetemp;
> +
>  	if( level >= 0 )
>  		tune_fan( level );
>  }

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support

