Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaHCPWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 11:22:04 -0400
Received: from outrelay07.libero.it ([212.52.84.111]:37323 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaHCPWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 11:22:03 -0400
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0203.53DE5387.0090,ss=1,re=0.000,fgs=0
X-libjamoibt: 1823
Message-ID: <53DE54D5.2050806@inwind.it>
Date: Sun, 03 Aug 2014 17:27:17 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>, Goffredo Baroncelli <kreijack@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, bryan@whatroute.net
Subject: Re: [PATCH 4/4] Return the fan speed via sysfs
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>	<1406901650-20841-5-git-send-email-kreijack@inwind.it> <20140803161738.485f3f60@endymion.delvare>
In-Reply-To: <20140803161738.485f3f60@endymion.delvare>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2014 04:17 PM, Jean Delvare wrote:
> On Fri,  1 Aug 2014 14:00:50 +0000, Goffredo Baroncelli wrote:
>> Return the fan speed via sysfs:
>> /sys/devices/temperature/fan_level
> 
> Good idea. Even better would be if the driver would expose a standard
> hwmon interface for the temperature values. Fan level could go in
> attribute "pwm1" after proper scaling.

I tought the same. But until now the value logged is an integer value
between 1 and 11. So I preferred to leave it as is.

The thing that I can do is to *add* a further attribute called pwm1.
( I have to check how adm1031.c computes its pwm), because is a 
more standard interface.

I even thought to allow to change the fan speed from user space....



> 
> Please follow scripts/checkpatch.pl's advice to fix the coding style.
> 
>> This patch is copied from the Bryan Christianson's patch (see
>> debian bug #741663)
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>> ---
>>  drivers/macintosh/therm_windtunnel.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
>> index 0c4eb85..a2af7db 100644
>> --- a/drivers/macintosh/therm_windtunnel.c
>> +++ b/drivers/macintosh/therm_windtunnel.c
>> @@ -111,9 +111,15 @@ show_case_temperature( struct device *dev, struct device_attribute *attr, char *
>>  	return sprintf(buf, "%d.%d\n", x.casetemp>>8, (x.casetemp & 255)*10/256 );
>>  }
>>  
>> +static ssize_t
>> +show_fan_level( struct device *dev, struct device_attribute *attr, char *buf )
>> +{
>> +	return sprintf(buf, "%d\n", 11 - x.fan_level );
>> +}
>> +
>>  static DEVICE_ATTR(cpu_temperature, S_IRUGO, show_cpu_temperature, NULL );
>>  static DEVICE_ATTR(case_temperature, S_IRUGO, show_case_temperature, NULL );
>> -
>> +static DEVICE_ATTR(fan_level, S_IRUGO, show_fan_level, NULL );
>>  
>>  
>>  /************************************************************************/
>> @@ -265,6 +271,7 @@ setup_hardware( void )
>>  
>>  	err = device_create_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
>>  	err |= device_create_file( &x.of_dev->dev, &dev_attr_case_temperature );
>> +	err |= device_create_file( &x.of_dev->dev, &dev_attr_fan_level );
>>  	if (err)
>>  		printk(KERN_WARNING
>>  			"Failed to create temperature attribute file(s).\n");
> 
> That's not your fault but please note that this construct is broken.
> You can't "or" error codes together, the result if two or more calls
> fail with different error codes is pretty random. Instead, each error
> must be tested individually. I know checkpatch.pl will complain if you
> do that but you can ignore it as is it the right thing to do in that
> case.

The really question is what we should do if the 2nd device_create_file()
would fail: we should fails the driver initialization ? or we should
continue, because even if there aren't some sysfs attributes the driver
work enough ?

> 
>> @@ -275,6 +282,7 @@ restore_regs( void )
>>  {
>>  	device_remove_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
>>  	device_remove_file( &x.of_dev->dev, &dev_attr_case_temperature );
>> +	device_remove_file( &x.of_dev->dev, &dev_attr_fan_level );
>>  
>>  	write_reg( x.fan, 0x01, x.r1, 1 );
>>  	write_reg( x.fan, 0x20, x.r20, 1 );
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
