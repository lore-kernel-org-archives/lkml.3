Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3CRIvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:51:00 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40154 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3CRIu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:50:58 -0400
X-Greylist: delayed 1455 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2013 04:50:57 EDT
Message-ID: <5146CFC0.7090907@web.de>
Date: Mon, 18 Mar 2013 09:26:40 +0100
From: Danny Baumann <dannybaumann@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2 3/3] ACPI video: Fix applying indexed initial brightness
 value.
References: <1363342248-6496-1-git-send-email-dannybaumann@web.de> <1363342248-6496-3-git-send-email-dannybaumann@web.de> <5146CD67.8070203@intel.com>
In-Reply-To: <5146CD67.8070203@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1363595200-000004D6-C9C1C7D1/0-0/0-0
X-Scan-AV: nick.hrz.tu-chemnitz.de;2013-03-18 09:26:40;eefc1eb1382de217081a1148719cd7e0
X-Scan-SA: nick.hrz.tu-chemnitz.de;2013-03-18 09:26:41;04dc3da54547a0adc41ad2d3e1aded01
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
>> +acpi_video_bqc_value_to_level(struct acpi_video_device *device,
>> +			      unsigned long long bqc_value)
>> +{
>> +	unsigned long long level;
>> +
>> +	if (device->brightness->flags._BQC_use_index) {
>> +		if (device->brightness->flags._BCL_reversed)
>> +			bqc_value = device->brightness->count - 3 - bqc_value;
>> +
>> +		level = device->brightness->levels[bqc_value + 2];
>
> I don't understand this, what does the +2 have to do here?
> _BQC returned us an index, and then we should just convert it to level,
> why +2?
>
> The only explanation would be, for BIOS tables that return _BQC as
> index, they are indexing from the 3rd entry. Is it the case? If so, I
> think we need to put a comment here.

Yes, that's the case. The old code did the same thing:

>> -			if (device->brightness->flags._BQC_use_index) {
>> -				if (device->brightness->flags._BCL_reversed)
>> -					*level = device->brightness->count
>> -								 - 3 - (*level);
>> -				*level = device->brightness->levels[*level + 2];
>> +			*level = acpi_video_bqc_value_to_level(device, *level);

That's also the reason for the -3 instead of -1 in the BCL_reversed 
case. I can add a comment, though.

>> +	if (use_bios_initial_backlight) {
>> +		if (!br->flags._BQC_use_index) {
>> +			/*
>> +			 * Set the backlight to the initial state.
>> +			 * On some buggy laptops, _BQC returns an uninitialized
>> +			 * value when invoked for the first time, i.e.
>> +			 * level_old is invalid. Set the backlight to max_level
>> +			 * in this case.
>> +			 */
>>   			for (i = 2; i < br->count; i++)
>>   				if (level_old == br->levels[i]) {
>>   					level = level_old;
>>   					break;
>>   				}
>> +		} else {
>> +			level = acpi_video_bqc_value_to_level(device,
>> +							      level_old);
>
> What about we convert the value to level first?
>
> 	if (use_bios_initial_backlight) {
> 		level = acpi_video_bqc_value_to_level(device, level_old);
> 		/*
> 		 * Set the backlight to the initial state.
> 		 * On some buggy laptops, _BQC returns an uninitialized
> 		 * value when invoked for the first time, i.e.
> 		 * level_old is invalid(no matter it is a level, or an
> 		 * index.) Set the backlight to max_level in this case.
> 		 */
> 		for (i = 2; i < br->count; i++)
> 			if (level == br->levels[i])
> 				break;
> 		if (i == br->count)
> 			level = max_level;
> 	}

That works as well, and looks cleaner to me as well. I'll change that.

Regards,

Danny
