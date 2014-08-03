Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaHCOMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 10:12:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaHCOMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 10:12:31 -0400
Date: Sun, 3 Aug 2014 16:12:23 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, jdelvare@suse.de,
        linux-kernel@vger.kernel.org, bryan@whatroute.net,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 3/4] Add the "verbose" module option.
Message-ID: <20140803161223.0b26e4bc@endymion.delvare>
In-Reply-To: <1406901650-20841-4-git-send-email-kreijack@inwind.it>
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
	<1406901650-20841-4-git-send-email-kreijack@inwind.it>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Goffredo,

You messed up your Cc's ;-)

On Fri,  1 Aug 2014 14:00:49 +0000, Goffredo Baroncelli wrote:
> The "verbose" option controls the message in the kernel log
> verbose = 0   no message
> verbose = 1   log only the fan speed changes
> verbose = 2   log the fan speed changes and the temperature changes
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  drivers/macintosh/therm_windtunnel.c | 37 +++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
> index 1e50455..0c4eb85 100644
> --- a/drivers/macintosh/therm_windtunnel.c
> +++ b/drivers/macintosh/therm_windtunnel.c
> @@ -44,7 +44,11 @@
>  #include <asm/sections.h>
>  #include <asm/macio.h>
>  
> -#define LOG_TEMP		0			/* continuously log temperature */
> +static int verbose = 1;	  /* see description below */

This comment seems useless.

> +module_param(verbose, int, 0644);
> +MODULE_PARM_DESC(verbose, "Vebosity level: 0=silent, "

Typo: Verbosity

> +				"1=log the fan tuning, "
> +				"2=log the temperature.");

Trailing dot is not needed.

>  
>  static struct {
>  	volatile int		running;
> @@ -157,10 +161,6 @@ tune_fan( int fan_setting )
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
> @@ -179,14 +179,6 @@ poll_temp( void )
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
> @@ -200,6 +192,25 @@ poll_temp( void )
>  		level = fan_table[i].fan_up_setting;
>  	x.upind = i;
>  
> +	/*
> +	 * if verbose >0 log each fan tuning
> +	 * if verbose >1 log each cpu temperature change
> +	 */

I think it is a good idea to have all the printing in a single place.

> +	if ((verbose > 1 && x.temp != temp ) ||

No space before closing parenthesis. I know the original code did not
follow the standard coding style but you have the opportunity to make
it better. Same many times below. scripts/checkpatch.pl tells you about
that and many other style issues, most of which are easily fixable.

Also don't you want to log changes of case temperature too?

> +	    (verbose > 0 && level >= 0)) {
> +		print_temp("CPU-temp: ", temp );
> +		if (casetemp)
> +			print_temp(", Case: ", casetemp );
> +		if (level >= 0)
> +			printk(", Fan: %d (tuned %+d)\n", 11-level,
> +				x.fan_level-level );
> +		else
> +			printk(", Fan: %d (tuned +0)\n",x.fan_level);

I think you can do without the "tuned +0" which doesn't add much value.

> +	}
> +
> +	x.temp = temp;
> +	x.casetemp = casetemp;
> +
>  	if( level >= 0 )
>  		tune_fan( level );
>  }


-- 
Jean Delvare
SUSE L3 Support
