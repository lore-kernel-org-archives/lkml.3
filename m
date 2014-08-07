Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbaHGQXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:23:54 -0400
Received: from outrelay08.libero.it ([212.52.84.112]:45873 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbaHGQXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:23:53 -0400
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0203.53E3A80E.00F9,ss=1,re=0.000,fgs=0
X-libjamoibt: 1823
Message-ID: <53E3A963.4080807@inwind.it>
Date: Thu, 07 Aug 2014 18:29:23 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>, Goffredo Baroncelli <kreijack@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] Add the "verbose" module option.
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>	 <1407359103-6012-4-git-send-email-kreijack@inwind.it> <1407401555.4314.14.camel@chaos.site>
In-Reply-To: <1407401555.4314.14.camel@chaos.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 10:52 AM, Jean Delvare wrote:
> Le Wednesday 06 August 2014 à 21:05 +0000, Goffredo Baroncelli a écrit :
>> Add a "verbose" option to control the message in the kernel log
>> verbose = 0   no message
>> verbose = 1   log only the fan speed changes
>> verbose = 2   log the fan speed changes and the temperature changes
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>> ---
>>  drivers/macintosh/therm_windtunnel.c | 39 +++++++++++++++++++++++-------------
>>  1 file changed, 25 insertions(+), 14 deletions(-)
> 
> Looks overall good, minor comments inline below.
> 
>> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
>> index 1e50455..7c512db 100644
>> --- a/drivers/macintosh/therm_windtunnel.c
>> +++ b/drivers/macintosh/therm_windtunnel.c
>> @@ -44,7 +44,9 @@
>>  #include <asm/sections.h>
>>  #include <asm/macio.h>
>>  
>> -#define LOG_TEMP		0			/* continuously log temperature */
>> +static int verbose = 1;
>> +module_param(verbose, int, 0644);
>> +MODULE_PARM_DESC(verbose, "Verbosity level: 0=silent, 1=log the fan tuning, 2=log the temperature");
>>  
>>  static struct {
>>  	volatile int		running;
>> @@ -157,10 +159,6 @@ tune_fan( int fan_setting )
>>  	/* write_reg( x.fan, 0x24, val, 1 ); */
>>  	write_reg( x.fan, 0x25, val, 1 );
>>  	write_reg( x.fan, 0x20, 0, 1 );
>> -	print_temp("CPU-temp: ", x.temp );
>> -	if( x.casetemp )
>> -		print_temp(", Case: ", x.casetemp );
>> -	printk(",  Fan: %d (tuned %+d)\n", 11-fan_setting, x.fan_level-fan_setting );
>>  
>>  	x.fan_level = fan_setting;
>>  }
>> @@ -168,7 +166,7 @@ tune_fan( int fan_setting )
>>  static void
>>  poll_temp( void )
>>  {
>> -	int temp, i, level, casetemp;
>> +	int temp, i, level, casetemp, tempchanged;
>>  
>>  	temp = read_reg( x.thermostat, 0, 2 );
>>  
>> @@ -179,14 +177,6 @@ poll_temp( void )
>>  	casetemp = read_reg(x.fan, 0x0b, 1) << 8;
>>  	casetemp |= (read_reg(x.fan, 0x06, 1) & 0x7) << 5;
>>  
>> -	if( LOG_TEMP && x.temp != temp ) {
>> -		print_temp("CPU-temp: ", temp );
>> -		print_temp(", Case: ", casetemp );
>> -		printk(",  Fan: %d\n", 11-x.fan_level );
>> -	}
>> -	x.temp = temp;
>> -	x.casetemp = casetemp;
>> -
>>  	level = -1;
>>  	for( i=0; (temp & 0xffff) > fan_table[i].temp ; i++ )
>>  		;
>> @@ -200,6 +190,27 @@ poll_temp( void )
>>  		level = fan_table[i].fan_up_setting;
>>  	x.upind = i;
>>  
>> +	/*
>> +	 * if verbose >0 log each fan tuning
>> +	 * if verbose >1 log each cpu temperature change
> 
> Maybe this is just me but I think "verbose >= 1" and "verbose >= 2"
> would be easier to understand. Same in the code below.

correct, I am planning another revision due to Guenter concern. So 
I will correct it.
> 
>> +	 */
>> +	tempchanged = x.temp != temp || x.casetemp != casetemp;
>> +	if ((verbose > 1 && tempchanged) ||
>> +	    (verbose > 0 && level >= 0)) {
>> +		printk(KERN_INFO);
>> +		print_temp("CPU-temp: ", temp);
> 
> This can be written more efficiently as a single statement:
> 
> 		print_temp(KERN_INFO "CPU-temp: ", temp);

I suppose that KERN_* has to be in the beginning of the line. 

Because a single line is composed by several prink, KERN_INFO has 
to be only in the first printk. To me it seems more polite to have
one printk for the level, and the others (there are more than one) 
for the message parts.

> 
>> +		if (casetemp)
>> +			print_temp(", Case: ", casetemp);
>> +		if (level >= 0)
>> +			printk(", Fan: %d (tuned %+d)\n", 11-level,
>> +				x.fan_level-level);
>> +		else
>> +			printk(", Fan: %d\n", 11-x.fan_level);
>> +	}
>> +
>> +	x.temp = temp;
>> +	x.casetemp = casetemp;
>> +
>>  	if( level >= 0 )
>>  		tune_fan( level );
>>  }
> 
> Reviewed-by: Jean Delvare <jdelvare@suse.de>
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
