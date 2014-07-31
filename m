Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaGaVYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:24:08 -0400
Received: from outrelay07.libero.it ([212.52.84.111]:45342 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaGaVYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:24:06 -0400
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0205.53DAB3E5.00CC,ss=1,re=0.000,fgs=0
X-libjamoibt: 1823
Message-ID: <53DAB52E.4010708@inwind.it>
Date: Thu, 31 Jul 2014 23:29:18 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] therm_windtunnel doesn't work properly on PowerMac
 G4
References: <53D95AB1.70300@inwind.it> <20140731090746.31aad3c9@endymion.delvare>
In-Reply-To: <20140731090746.31aad3c9@endymion.delvare>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 09:07 AM, Jean Delvare wrote:
> Hi Goffredo,
> 
> For next time: please give each individual patch an appropriate
> subject. Otherwise it is difficult to keep track of what each patch
> does exactly.

I had to use the same subject because the email weren't threaded. 
The subject was the only way to group the patches.

The next time I will use git send-email (which I hate !), so this 
problem will disappear.

> 
> On Wed, 30 Jul 2014 22:50:57 +0200, Goffredo Baroncelli wrote:
>> Add the "log_temp" and "verbose" module parameters.
> 
> I think this is a good idea, much better than build-time settings.



>> log_temp    enable/disable the temperature logging
>> verbose     enable/disable the fan tune logging
> 
> These names are not very consistent, both printks are logging both the
> temperatures and the fan speed.
> 
> Also I'm unsure if you really need 2 parameters for this. I see these
> more as two degrees of verbosity of the same logging feature. I would
> like to suggest having a single module parameter, with 3 different
> values:
>   0: log nothing
>   1: log fan tuning (default)
>   2: log fan tuning + temperature continuously
> 
> What do you think?

I definitely agree. I will work on that in the next few days

> 
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>>
>> ---
>>  drivers/macintosh/therm_windtunnel.c |   19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
>> index fbe4516..7efba5d 100644
>> --- a/drivers/macintosh/therm_windtunnel.c
>> +++ b/drivers/macintosh/therm_windtunnel.c
>> @@ -44,7 +44,13 @@
>>  #include <asm/sections.h>
>>  #include <asm/macio.h>
>>  
>> -#define LOG_TEMP		0			/* continuously log temperature */
>> +static bool log_temp = 0;
>> +module_param(log_temp, bool, 0644);
>> +MODULE_PARM_DESC(log_temp, "Enable the temperature logging");
>> +
>> +static bool verbose = 1;
>> +module_param(verbose, bool, 0644);
>> +MODULE_PARM_DESC(verbose, "Enable the fan speed logging");
>>  
>>  static struct {
>>  	volatile int		running;
>> @@ -157,11 +163,12 @@ tune_fan( int fan_setting )
>>  	/* write_reg( x.fan, 0x24, val, 1 ); */
>>  	write_reg( x.fan, 0x25, val, 1 );
>>  	write_reg( x.fan, 0x20, 0, 1 );
>> -	print_temp("CPU-temp: ", x.temp );
>> -	if( x.casetemp )
>> +	if (verbose) {
>> +		print_temp("CPU-temp: ", x.temp );
>>  		print_temp(", Case: ", x.casetemp );
> 
> In the original code, there was a condition for printing the case
> temperature, which you dropped. Is this on purpose? If so it should be
> explained in the patch description.
> 
> BTW I see that the continuous temperature logging below does not have
> such a condition. For consistency I think it should be either always or
> never included.

I removed the "if" because the same printk() happens before (the tune_fan() 
function is called after the 2nd printk() ). 
So remove the "if" is safe.

I agree that a better explanation in the comments helps. Because I have to
update the patch for the log_temp/verbose module parameters, I will enhance 
the patch description.

> 
>> -	printk(",  Fan: %d (tuned %+d)\n", 11-fan_setting, x.fan_level-fan_setting );
>> -
>> +		printk(",  Fan: %d (tuned %+d)\n",
>> +			11-fan_setting, x.fan_level-fan_setting );
>> +	}
>>  	x.fan_level = fan_setting;
>>  }
>>  
>> @@ -179,7 +186,7 @@ poll_temp( void )
>>  	casetemp = read_reg(x.fan, 0x0b, 1) << 8;
>>  	casetemp |= (read_reg(x.fan, 0x06, 1) & 0x7) << 5;
>>  
>> -	if( LOG_TEMP && x.temp != temp ) {
>> +	if( log_temp && x.temp != temp ) {
>>  		print_temp("CPU-temp: ", temp );
>>  		print_temp(", Case: ", casetemp );
>>  		printk(",  Fan: %d\n", 11-x.fan_level );
> 
> Thanks,
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
