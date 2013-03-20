Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563Ab3CTJbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933981Ab3CTJb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:31:28 -0400
Message-ID: <514981BA.7070406@redhat.com>
Date: Wed, 20 Mar 2013 10:30:34 +0100
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] HID: input: don't register unmapped input devices
References: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com> <1361984127-912-2-git-send-email-benjamin.tissoires@redhat.com> <20130319212511.GA7821@polaris.bitmath.org>
In-Reply-To: <20130319212511.GA7821@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

first, thanks for the review of the series.

On 03/19/2013 10:25 PM, Henrik Rydberg wrote:
> Hi Benjamin,
> 
>> There is no need to register an input device containing no events.
>> This allows drivers using the quirk MULTI_INPUT to register one input
>> per report effectively used.
>>
>> For backward compatibility, we need to add a quirk to request
>> this behavior.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/hid-input.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/hid.h     |  1 +
>>  2 files changed, 78 insertions(+)
>>
>> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
>> index 21b196c..7aaf7d3 100644
>> --- a/drivers/hid/hid-input.c
>> +++ b/drivers/hid/hid-input.c
>> @@ -1198,6 +1198,67 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
>>  	return hidinput;
>>  }
>>  
>> +static bool hidinput_has_been_populated(struct hid_input *hidinput)
>> +{
>> +	int i;
>> +	bool r = 0;
>> +
>> +	for (i = 0; i < BITS_TO_LONGS(EV_CNT); i++)
>> +		r = r || hidinput->input->evbit[i];
> 
> I believe there is a bit count method that will do this for you (weight).

thanks for that. Will change it in v2.

> 
>> +
>> +	for (i = 0; i < BITS_TO_LONGS(KEY_CNT); i++)
>> +		r = r || hidinput->input->keybit[i];
>> +
>> +	for (i = 0; i < BITS_TO_LONGS(REL_CNT); i++)
>> +		r = r || hidinput->input->relbit[i];
>> +
>> +	for (i = 0; i < BITS_TO_LONGS(ABS_CNT); i++)
>> +		r = r || hidinput->input->absbit[i];
>> +
>> +	for (i = 0; i < BITS_TO_LONGS(MSC_CNT); i++)
>> +		r = r || hidinput->input->mscbit[i];
>> +
>> +	for (i = 0; i < BITS_TO_LONGS(LED_CNT); i++)
>> +		r = r || hidinput->input->ledbit[i];
>> +
>> +	for (i = 0; i < BITS_TO_LONGS(SND_CNT); i++)
>> +		r = r || hidinput->input->sndbit[i];
>> +
>> +	for (i = 0; i < BITS_TO_LONGS(FF_CNT); i++)
>> +		r = r || hidinput->input->ffbit[i];
>> +
>> +	for (i = 0; i < BITS_TO_LONGS(SW_CNT); i++)
>> +		r = r || hidinput->input->swbit[i];
>> +
>> +	return !!r;
>> +}
>> +
>> +static void hidinput_cleanup_hidinput(struct hid_device *hid,
>> +		struct hid_input *hidinput)
>> +{
>> +	struct hid_report *report;
>> +	int i, k;
>> +
>> +	list_del(&hidinput->list);
>> +	input_free_device(hidinput->input);
>> +
>> +	for (k = HID_INPUT_REPORT; k <= HID_OUTPUT_REPORT; k++) {
>> +		if (k == HID_OUTPUT_REPORT &&
>> +			hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
>> +			continue;
>> +
>> +		list_for_each_entry(report, &hid->report_enum[k].report_list,
>> +				    list) {
>> +
>> +			for (i = 0; i < report->maxfield; i++)
>> +				if (report->field[i]->hidinput == hidinput)
>> +					report->field[i]->hidinput = NULL;
> 
> Why test before clearing?

Well, the idea is to remove blank hidinput from the hid device, keeping
the populated ones. Thus, the argument "struct hid_input *".
In many cases, blanks hidinput and populated ones are set on the same
hid device:
Let's take a win7 device. hid-mt will populate the multitouch report,
discarding the mouse emulation report. Thus, we need to only remove the
hidinput created from the mouse emulation report, keeping the multitouch
one.

Does that makes sense?

> 
>> +		}
>> +	}
>> +
>> +	kfree(hidinput);
>> +}
>> +
>>  /*
>>   * Register the input device; print a message.
>>   * Configure the input layer interface
>> @@ -1249,6 +1310,10 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>>  					hidinput_configure_usage(hidinput, report->field[i],
>>  								 report->field[i]->usage + j);
>>  
>> +			if ((hid->quirks & HID_QUIRK_NO_EMPTY_INPUT) &&
>> +			    !hidinput_has_been_populated(hidinput))
>> +				continue;
>> +
> 
> Is there possibly a subset of input properties that may be populated
> but still not duplicated? Or the other way around?

Not sure I understand your point here.
The hid spec says that reports are independent. Thus, you can have
several devices presenting different semantic (absolute, relative,
touch, pen, 3d, gyros, etc...) within the same hid interface. If you
activate both the quirks NO_EMPTY_INPUT and MULTI_INPUT, you have this
behavior correctly handled as per the spec IMO.

The thing is that it was not the default before. For instance,
hid-magicmouse for magic trackpads use the hid-input core functionality
to create its input device, but it does not populate it: input_mapping()
returns -1. The declaration of the axes is done later, once the
hid_hw_start() has returned.
Besides the fact that there may be a race with udev checking for the
device and assigning it to the touchpad class, the input is not
populated here (no matter the MULTI_INPUT quirk in place or not).
Thus, the need to specifically introduce this quirk.

So I would say that if the driver is using NO_EMPTY_INPUT, then it's its
responsability to check that its inputs are correctly configured (which
I do in hid-multitouch).

Cheers,
Benjamin

> 
>>  			if (hid->quirks & HID_QUIRK_MULTI_INPUT) {
>>  				/* This will leave hidinput NULL, so that it
>>  				 * allocates another one if we have more inputs on
>> @@ -1265,6 +1330,18 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>>  		}
>>  	}
>>  
>> +	if (hidinput && (hid->quirks & HID_QUIRK_NO_EMPTY_INPUT) &&
>> +	    !hidinput_has_been_populated(hidinput)) {
>> +		/* no need to register an input device not populated */
>> +		hidinput_cleanup_hidinput(hid, hidinput);
>> +		hidinput = NULL;
>> +	}
>> +
>> +	if (list_empty(&hid->inputs)) {
>> +		hid_err(hid, "No inputs registered, leaving\n");
>> +		goto out_unwind;
>> +	}
>> +
>>  	if (hidinput) {
>>  		if (drv->input_configured)
>>  			drv->input_configured(hid, hidinput);
>> diff --git a/include/linux/hid.h b/include/linux/hid.h
>> index 7071eb3..15b98a6 100644
>> --- a/include/linux/hid.h
>> +++ b/include/linux/hid.h
>> @@ -282,6 +282,7 @@ struct hid_item {
>>  #define HID_QUIRK_BADPAD			0x00000020
>>  #define HID_QUIRK_MULTI_INPUT			0x00000040
>>  #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
>> +#define HID_QUIRK_NO_EMPTY_INPUT		0x00000100
>>  #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
>>  #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
>>  #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
>> -- 
>> 1.8.1.2
>>

