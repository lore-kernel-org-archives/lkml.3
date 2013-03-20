Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab3CTHb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 03:31:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:9597 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3CTHbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 03:31:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,876,1355126400"; 
   d="scan'208";a="282110815"
Message-ID: <51496616.8080901@intel.com>
Date: Wed, 20 Mar 2013 15:32:38 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Danny Baumann <dannybaumann@web.de>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v4 1/3] ACPI video: Fix brightness control initialization
 for some laptops.
References: <1363710172-2906-1-git-send-email-dannybaumann@web.de> <5148913D.5080309@web.de>
In-Reply-To: <5148913D.5080309@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 12:24 AM, Danny Baumann wrote:
> v3 incorporates Aaron's feedback, v4 fixes my inability to use git 
> send-email properly. Sorry for that.

For the 3 patches, Reviewed-by: Aaron Lu <aaron.lu@intel.com>

BTW, you can put things like what has been changed in a new series in
patch 0.

Thanks,
Aaron

> 
> Regards,
> 
> Danny
> 
> Am 19.03.2013 17:22, schrieb Danny Baumann:
>> In particular, this fixes brightness control initialization for all
>> devices that return index values from _BQC and don't happen to have the
>> initial index set by the BIOS in their _BCL table. One example for that
>> is the Dell Inspiron 15R SE (model number 7520).
>>
>> What happened for those devices is that acpi_init_brightness queried the
>> initial brightness by calling acpi_video_device_lcd_get_level_current.
>> This called _BQC, which returned e.g. 13. As _BQC_use_index isn't
>> determined at this point (and thus has its initial value of 0), the
>> index isn't converted into the actual level. As '13' isn't present in
>> the _BCL list, *level is later overwritten with brightness->curr, which
>> was initialized to max_level (100) before. Later in
>> acpi_init_brightness, level_old (with the value 100) is used as an index
>> into the _BCL table, which causes a value outside of the actual table to
>> be used as input into acpi_video_device_lcd_set_level(). Depending on
>> the (undefined) value of that location, this call will fail, causing the
>> brightness control for the device in question not to be enabled.
>>
>> Fix that by returning the raw value returned by the _BQC call in the
>> initialization case.
>>
>> Signed-off-by: Danny Baumann <dannybaumann@web.de>
>> ---
>>   drivers/acpi/video.c | 43 ++++++++++++++++++++++++++-----------------
>>   1 file changed, 26 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
>> index 313f959..09e4722 100644
>> --- a/drivers/acpi/video.c
>> +++ b/drivers/acpi/video.c
>> @@ -222,7 +222,7 @@ static int acpi_video_device_lcd_set_level(struct acpi_video_device *device,
>>   			int level);
>>   static int acpi_video_device_lcd_get_level_current(
>>   			struct acpi_video_device *device,
>> -			unsigned long long *level, int init);
>> +			unsigned long long *level, bool raw);
>>   static int acpi_video_get_next_level(struct acpi_video_device *device,
>>   				     u32 level_current, u32 event);
>>   static int acpi_video_switch_brightness(struct acpi_video_device *device,
>> @@ -236,7 +236,7 @@ static int acpi_video_get_brightness(struct backlight_device *bd)
>>   	struct acpi_video_device *vd =
>>   		(struct acpi_video_device *)bl_get_data(bd);
>>
>> -	if (acpi_video_device_lcd_get_level_current(vd, &cur_level, 0))
>> +	if (acpi_video_device_lcd_get_level_current(vd, &cur_level, false))
>>   		return -EINVAL;
>>   	for (i = 2; i < vd->brightness->count; i++) {
>>   		if (vd->brightness->levels[i] == cur_level)
>> @@ -281,7 +281,7 @@ static int video_get_cur_state(struct thermal_cooling_device *cooling_dev, unsig
>>   	unsigned long long level;
>>   	int offset;
>>
>> -	if (acpi_video_device_lcd_get_level_current(video, &level, 0))
>> +	if (acpi_video_device_lcd_get_level_current(video, &level, false))
>>   		return -EINVAL;
>>   	for (offset = 2; offset < video->brightness->count; offset++)
>>   		if (level == video->brightness->levels[offset]) {
>> @@ -452,7 +452,7 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
>>
>>   static int
>>   acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>> -					unsigned long long *level, int init)
>> +					unsigned long long *level, bool raw)
>>   {
>>   	acpi_status status = AE_OK;
>>   	int i;
>> @@ -463,6 +463,15 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>>   		status = acpi_evaluate_integer(device->dev->handle, buf,
>>   						NULL, level);
>>   		if (ACPI_SUCCESS(status)) {
>> +			if (raw) {
>> +				/*
>> +				 * Caller has indicated he wants the raw
>> +				 * value returned by _BQC, so don't furtherly
>> +				 * mess with the value.
>> +				 */
>> +				return 0;
>> +			}
>> +
>>   			if (device->brightness->flags._BQC_use_index) {
>>   				if (device->brightness->flags._BCL_reversed)
>>   					*level = device->brightness->count
>> @@ -476,16 +485,14 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>>   					device->brightness->curr = *level;
>>   					return 0;
>>   			}
>> -			if (!init) {
>> -				/*
>> -				 * BQC returned an invalid level.
>> -				 * Stop using it.
>> -				 */
>> -				ACPI_WARNING((AE_INFO,
>> -					      "%s returned an invalid level",
>> -					      buf));
>> -				device->cap._BQC = device->cap._BCQ = 0;
>> -			}
>> +			/*
>> +			 * BQC returned an invalid level.
>> +			 * Stop using it.
>> +			 */
>> +			ACPI_WARNING((AE_INFO,
>> +				      "%s returned an invalid level",
>> +				      buf));
>> +			device->cap._BQC = device->cap._BCQ = 0;
>>   		} else {
>>   			/* Fixme:
>>   			 * should we return an error or ignore this failure?
>> @@ -703,7 +710,8 @@ acpi_video_init_brightness(struct acpi_video_device *device)
>>   	if (!device->cap._BQC)
>>   		goto set_level;
>>
>> -	result = acpi_video_device_lcd_get_level_current(device, &level_old, 1);
>> +	result = acpi_video_device_lcd_get_level_current(device,
>> +							 &level_old, true);
>>   	if (result)
>>   		goto out_free_levels;
>>
>> @@ -714,7 +722,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
>>   	if (result)
>>   		goto out_free_levels;
>>
>> -	result = acpi_video_device_lcd_get_level_current(device, &level, 0);
>> +	result = acpi_video_device_lcd_get_level_current(device, &level, true);
>>   	if (result)
>>   		goto out_free_levels;
>>
>> @@ -1268,7 +1276,8 @@ acpi_video_switch_brightness(struct acpi_video_device *device, int event)
>>   		goto out;
>>
>>   	result = acpi_video_device_lcd_get_level_current(device,
>> -							 &level_current, 0);
>> +							 &level_current,
>> +							 false);
>>   	if (result)
>>   		goto out;
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

