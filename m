Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbaELK1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:27:17 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:49982 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaELK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:27:16 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1399139966-10625-1-git-send-email-peter@piie.net> <1399139966-10625-5-git-send-email-peter@piie.net> <20140506105029.GC2858@e102654-lin.cambridge.arm.com>
Message-ID: <cone.1399890428.265455.932.1000@mups>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Javi Merino <javi.merino@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v3 4/6] acerhdf: Use bang-bang thermal governor
Date: Mon, 12 May 2014 12:27:08 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javi,

Javi Merino writes:

> Hi Peter,
> 
> On Sat, May 03, 2014 at 06:59:24PM +0100, Peter Feuerer wrote:
>> acerhdf has been doing an on-off fan control using hysteresis by
>> post-manipulating the outcome of thermal subsystem trip point handling.
>> This patch enables acerhdf to use the bang-bang governor, which is
>> intended for on-off controlled fans.
>> 
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> CC: Zhang Rui <rui.zhang@intel.com>
>> Cc: Andreas Mohr <andi@lisas.de>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Javi Merino <javi.merino@arm.com>
>> Signed-off-by: Peter Feuerer <peter@piie.net>
>> ---
>>  drivers/platform/x86/Kconfig   |  2 +-
>>  drivers/platform/x86/acerhdf.c | 34 +++++++++++++++++++++++++++++-----
>>  2 files changed, 30 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
>> index 27df2c5..0c15d89 100644
>> --- a/drivers/platform/x86/Kconfig
>> +++ b/drivers/platform/x86/Kconfig
>> @@ -38,7 +38,7 @@ config ACER_WMI
>>  
>>  config ACERHDF
>>  	tristate "Acer Aspire One temperature and fan driver"
>> -	depends on THERMAL && ACPI
>> +	depends on ACPI && THERMAL_GOV_BANG_BANG
>>  	---help---
>>  	  This is a driver for Acer Aspire One netbooks. It allows to access
>>  	  the temperature sensor and to control the fan.
>> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
>> index 176edbd..afaa849 100644
>> --- a/drivers/platform/x86/acerhdf.c
>> +++ b/drivers/platform/x86/acerhdf.c
>> @@ -50,7 +50,7 @@
>>   */
>>  #undef START_IN_KERNEL_MODE
>>  
>> -#define DRV_VER "0.5.30"
>> +#define DRV_VER "0.5.31"
>>  
>>  /*
>>   * According to the Atom N270 datasheet,
>> @@ -259,6 +259,14 @@ static const struct bios_settings_t bios_tbl[] = {
>>  
>>  static const struct bios_settings_t *bios_cfg __read_mostly;
>>  
>> +/*
>> + * this struct is used to instruct thermal layer to use bang_bang instead of
>> + * default governor for acerhdf
>> + */
>> +static struct thermal_zone_params acerhdf_zone_params = {
>> +	.governor_name = "bang_bang",
>> +};
>> +
>>  static int acerhdf_get_temp(int *temp)
>>  {
>>  	u8 read_temp;
>> @@ -440,6 +448,15 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
>>  	return 0;
>>  }
>>  
>> +static int acerhdf_get_trip_hyst(struct thermal_zone_device *thermal, int trip,
>> +				 unsigned long *temp)
>> +{
>> +	if (trip == 0)
>> +		*temp = fanon - fanoff;
>> +
>> +	return 0;
>> +}
>> +
> 
> I think you should only return 0 if you've updated the temperature.
> Otherwise you're telling the calling function that everything went all
> right but you may be leaving garbage in *temp.  What about
> 
> 	if (trip != 0)
> 		return -EINVAL;
> 
> 	*temp = fanon - fanoff;
> 	return 0;

Yes, sounds good.  What about trip == 1?  This is a valid trip point for 
acerhdf (critical) and one could argue, that it has a valid hysteresis of 
0.  - Thus EINVAL would be wrong here.

thanks and kind regards,
--peter;
