Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3COIzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:55:47 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:41463 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3COIzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:55:44 -0400
Message-ID: <5142E20C.40805@web.de>
Date: Fri, 15 Mar 2013 09:55:40 +0100
From: Danny Baumann <dannybaumann@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 3/3] ACPI video: Fix applying indexed initial brightness
 value.
References: <1363257264-15984-1-git-send-email-dannybaumann@web.de> <1363257264-15984-4-git-send-email-dannybaumann@web.de> <5142E04F.1010400@intel.com>
In-Reply-To: <5142E04F.1010400@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1363337741-000004E7-8E4F743B/0-0/0-0
X-Scan-AV: cora.hrz.tu-chemnitz.de;2013-03-15 09:55:41;3a1c82f1db07627c64454a1993685b86
X-Scan-SA: cora.hrz.tu-chemnitz.de;2013-03-15 09:55:41;609ecf75c3100e960252c20b3645cf67
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.0 TVD_RCVD_IP TVD_RCVD_IP
 *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail provider
 *      (dannybaumann[at]web.de)
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 >> +static unsigned long long
>> +acpi_video_index_to_level(struct acpi_video_device *device,
>> +			  unsigned long long index)
>> +{
>> +	if (device->brightness->flags._BCL_reversed)
>> +		index = device->brightness->count - 3 - index;
>> +
>> +	return device->brightness->levels[index + 2];
>> +}
>
> What about making this function also take care of the
> bqc_offset_aml_bug_workaround? so that this function serves more like a
> conversion from raw value to fixed value, the function name can perhaps
> be named as: acpi_video_fix_bqc_value, or whatever you think is more
> appropriate.

Makes sense to me. How about acpi_video_bqc_to_level? I'd suggest 
acpi_video_bqc_value_to_level, but that makes it hard to keep the 80 
char limit in acpi_video_device_lcd_get_level_current.

>> @@ -742,9 +749,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
>>   				}
>>   		}
>>   	} else {
>> -		if (br->flags._BCL_reversed)
>> -			level_old = (br->count - 1) - level_old;
>> -		level = br->levels[level_old];
>> +		level = acpi_video_index_to_level(device, level_old);
>
> And here, that new function should be used, which also takes care of the
> offset_aml_bug problem(though in theory, the two problems may not happen
> on the same BIOS table).

But that new function (whatever it's named) is already used here?

BTW, shouldn't the use_bios_initial_backlight also be respected for the 
BQC-returns-index case? Currently it's only used for the 
BQC-returns-level case.

> And the acpi_video_device_lcd_get_level_current's param init can
> probably be renamed as raw, meaning if raw value is desired or fixed
> value, but it's not a big deal.

Agreed. I'll send a new patch set (this time with signed-off-by) once I 
get opinion on the question above.

Thanks,

Danny
