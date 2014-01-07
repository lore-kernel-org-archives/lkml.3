Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaAGC0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:26:38 -0500
Received: from mail.active-venture.com ([67.228.131.205]:54616 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbaAGC0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:26:35 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52CB65DA.2010103@roeck-us.net>
Date: Mon, 06 Jan 2014 18:26:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frodo Looijaard <frodol@dds.nl>,
        lm-sensors@lm-sensors.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
References: <20140106204020.b47e53cc3ead8f90164ef5b7@canb.auug.org.au> <52CB0948.6030702@infradead.org> <20140106203209.GA21630@roeck-us.net> <52CB53DC.4030901@infradead.org>
In-Reply-To: <52CB53DC.4030901@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 05:09 PM, Randy Dunlap wrote:
> On 01/06/14 12:32, Guenter Roeck wrote:
>> On Mon, Jan 06, 2014 at 11:51:36AM -0800, Randy Dunlap wrote:
>>> On 01/06/14 01:40, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> This tree fails (more than usual) the powerpc allyesconfig build.
>>>>
>>>> Changes since 20131224:
>>>>
>>>
>>>
>>> on i386:
>>>
>>> drivers/built-in.o: In function `lm75_remove':
>>> lm75.c:(.text+0x12bd8c): undefined reference to `thermal_zone_of_sensor_unregister'
>>> drivers/built-in.o: In function `lm75_probe':
>>> lm75.c:(.text+0x12c123): undefined reference to `thermal_zone_of_sensor_register'
>>>
>>
>> AFAICS that is a dependency problem in thermal code.
>> CONFIG_THERMAL=m defines the symbols, but CONFIG_SENSORS_LM75=y.
>
> CONFIG_THERMAL_OF defines the symbols.
>
> It looks to me like drivers/hwmon/Kconfig SENSORS_LM75 entry needs a
> 	depends on THERMAL_OF
> line, but that won't fix this build error.
> The problem (once again, not the first time that I have seen this one) is that
> we have a tristate =m that depends on a bool =y.
>
> Hm, I bet a "depends on THERMAL" for SENSORS_LM75 will fix this.
> [test]
> Yes, that restricts (limits) SENSORS_LM75 to n/m; y is not possible.
>
> Patch for your consideration is below.
>
>>
>> Up to the thermal folks to fix; if the code ends up in mainline we'll have to
>> revert the patch introducing the calls to the lm75 driver (and the tmp102 driver
>> which has the same issue).
>>
>> Another oddity is the help text to THERMAL_OF, which states that it supports
>> reading and parsing thermal data definitions out of dt but fails to mention
>> that it also provides the above API functions.
>
> ---
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix SENSORS_LM75 dependencies to eliminate build errors:
>
> drivers/built-in.o: In function `lm75_remove':
> lm75.c:(.text+0x12bd8c): undefined reference to `thermal_zone_of_sensor_unregister'
> drivers/built-in.o: In function `lm75_probe':
> lm75.c:(.text+0x12c123): undefined reference to `thermal_zone_of_sensor_register'
>
> Add depends on THERMAL_OF since that is what provides the
> register/unregister functions above.
>
> Add depends on THERMAL since THERMAL is a tristate (while THERMAL_OF
> is a bool) and SENSORS_LM75 (tristate) needs to be limited to modular
> builds when THERMAL=m.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>   drivers/hwmon/Kconfig |    2 ++
>   1 file changed, 2 insertions(+)
>
> --- linux-next-20140106.orig/drivers/hwmon/Kconfig
> +++ linux-next-20140106/drivers/hwmon/Kconfig
> @@ -650,6 +650,8 @@ config SENSORS_LM73
>   config SENSORS_LM75
>   	tristate "National Semiconductor LM75 and compatibles"
>   	depends on I2C
> +	depends on THERMAL
> +	depends on THERMAL_OF
>   	help
>   	  If you say yes here you get support for one common type of
>   	  temperature sensor chip, with models including:
>
>
NACK. The driver does not and must not depend on THERMAL. This needs to be addressed
in the thermal code, for example with dummy declarations if THERMAL=m but
SENSORS_LM75=y. The functions are already declared as dummies if THERMAL_OF=n.

Guenter

