Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3CTNng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:43:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab3CTNnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:43:35 -0400
Message-ID: <5149BCC5.2030807@redhat.com>
Date: Wed, 20 Mar 2013 14:42:29 +0100
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] HID: multitouch: add handling for pen in dual-sensors
 device
References: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com> <1361984127-912-5-git-send-email-benjamin.tissoires@redhat.com> <20130319213245.GA7877@polaris.bitmath.org>
In-Reply-To: <20130319213245.GA7877@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On 03/19/2013 10:32 PM, Henrik Rydberg wrote:
> Hi Benjamin,
> 
>> Dual sensors devices reports pen and touch on two different reports.
>> Using the quirk HID_QUIRK_MULTI_INPUT allows us to create a new input
>> device to forward pen events.
>>
>> The quirk HID_QUIRK_NO_EMPTY_INPUT avoids the creation of input devices
>> for the not used mouse emulation present on Win7 certified devices.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 55 ++++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 51 insertions(+), 4 deletions(-)
> 
> I like the approach, it is indeed quite simple. Some comment below, though.
> 
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 315500c..77ba751 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -100,6 +100,7 @@ struct mt_device {
>>  	unsigned last_field_index;	/* last field index of the report */
>>  	unsigned last_slot_field;	/* the last field of a slot */
>>  	unsigned mt_report_id;	/* the report ID of the multitouch device */
>> +	unsigned pen_report_id;	/* the report ID of the pen device */
>>  	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
>>  	__s8 inputmode_index;	/* InputMode HID feature index in the report */
>>  	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
>> @@ -365,6 +366,35 @@ static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
>>  	f->usages[f->length++] = usage->hid;
>>  }
>>  
>> +static int mt_pen_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>> +		struct hid_field *field, struct hid_usage *usage,
>> +		unsigned long **bit, int *max)
>> +{
>> +	struct mt_device *td = hid_get_drvdata(hdev);
>> +
>> +	td->pen_report_id = field->report->id;
>> +
>> +	return 0;
>> +}
>> +
>> +static int mt_pen_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>> +		struct hid_field *field, struct hid_usage *usage,
>> +		unsigned long **bit, int *max)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int mt_pen_event(struct hid_device *hid, struct hid_field *field,
>> +				struct hid_usage *usage, __s32 value)
>> +{
>> +	/* let hid-input handle it */
>> +	return 0;
>> +}
>> +
>> +static void mt_pen_report(struct hid_device *hid, struct hid_report *report)
>> +{
>> +}
> 
> Should the next patch not go in here directly?

yes, possibly. Will squash them in v2.

> 
>> +
>>  static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>  		struct hid_field *field, struct hid_usage *usage,
>>  		unsigned long **bit, int *max)
>> @@ -725,14 +755,12 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>  	* We need to ignore fields that belong to other collections
>>  	* such as Mouse that might have the same GenericDesktop usages. */
>>  	if (field->application != HID_DG_TOUCHSCREEN &&
>> +	    field->application != HID_DG_PEN &&
>>  	    field->application != HID_DG_TOUCHPAD)
>>  		return -1;
>>  
>> -	/* eGalax devices provide a Digitizer.Stylus input which overrides
>> -	 * the correct Digitizers.Finger X/Y ranges.
>> -	 * Let's just ignore this input. */
>>  	if (field->physical == HID_DG_STYLUS)
>> -		return -1;
>> +		return mt_pen_input_mapping(hdev, hi, field, usage, bit, max);
>>  
>>  	return mt_touch_input_mapping(hdev, hi, field, usage, bit, max);
>>  }
>> @@ -741,6 +769,9 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>>  		struct hid_field *field, struct hid_usage *usage,
>>  		unsigned long **bit, int *max)
>>  {
>> +	if (field->physical == HID_DG_STYLUS)
>> +		return mt_pen_input_mapped(hdev, hi, field, usage, bit, max);
>> +
>>  	return mt_touch_input_mapped(hdev, hi, field, usage, bit, max);
>>  }
>>  
>> @@ -752,6 +783,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>>  	if (field->report->id == td->mt_report_id)
>>  		return mt_touch_event(hid, field, usage, value);
>>  
>> +	if (field->report->id == td->pen_report_id)
>> +		return mt_pen_event(hid, field, usage, value);
>> +
>>  	/* ignore other reports */
>>  	return 1;
>>  }
>> @@ -765,6 +799,9 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
>>  
>>  	if (report->id == td->mt_report_id)
>>  		mt_touch_report(hid, report);
>> +
>> +	if (report->id == td->pen_report_id)
>> +		mt_pen_report(hid, report);
>>  }
>>  
>>  static void mt_set_input_mode(struct hid_device *hdev)
>> @@ -887,6 +924,14 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>  	 */
>>  	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
>>  
>> +	/*
>> +	 * This allows the driver to handle different input sensors
>> +	 * that emits events through different reports on the same HID
>> +	 * device.
>> +	 */
>> +	hdev->quirks |= HID_QUIRK_MULTI_INPUT;
>> +	hdev->quirks |= HID_QUIRK_NO_EMPTY_INPUT;
> 
> I seem to recall problem with MULTI_INPUT on some devices. Should
> these not be turned on based on the device type?

IIRC, those problems appeared a long time ago, when hid-mt was not
handling properly the different collections. Now, the tests I conducted
show that all the device I know are properly handled this way.
Anyway, if you think it would be safer, we can add a quirk in the
mtclass and set the MULTI_INPUT quirk if requested.

Cheers,
Benjamin

> 
>> +
>>  	td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
>>  	if (!td) {
>>  		dev_err(&hdev->dev, "cannot allocate multitouch data\n");
>> @@ -896,6 +941,8 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>  	td->inputmode = -1;
>>  	td->maxcontact_report_id = -1;
>>  	td->cc_index = -1;
>> +	td->mt_report_id = -1;
>> +	td->pen_report_id = -1;
>>  	hid_set_drvdata(hdev, td);
>>  
>>  	td->fields = kzalloc(sizeof(struct mt_fields), GFP_KERNEL);
>> -- 
>> 1.8.1.2
>>
> 
> Thanks,
> Henrik
> 

