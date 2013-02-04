Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3BDJYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:24:51 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53289 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3BDJYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:24:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130203122748.GA2513@polaris.bitmath.org>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
	<1359649351-11092-2-git-send-email-benjamin.tissoires@gmail.com>
	<20130203122748.GA2513@polaris.bitmath.org>
Date: Mon, 4 Feb 2013 10:24:48 +0100
Message-ID: <CAN+gG=H8tTcQ9NNAk-EOxMJsqvrC6X1ZqmQB62eBHnXyG=RRng@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] HID: core: add "report" hook, called once the
 report has been parsed
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sun, Feb 3, 2013 at 1:27 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> This callback is called when the parsing of the report has been done
>> by hid-core (so after the calls to .event). The hid drivers can now
>> have access to the whole report by relying on the values stored in
>> the different fields.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-core.c | 4 ++++
>>  include/linux/hid.h    | 2 ++
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index 5ae2cb1..b671e4e 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -1195,6 +1195,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>>  {
>>       struct hid_report_enum *report_enum = hid->report_enum + type;
>>       struct hid_report *report;
>> +     struct hid_driver *hdrv;
>>       unsigned int a;
>>       int rsize, csize = size;
>>       u8 *cdata = data;
>> @@ -1231,6 +1232,9 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>>       if (hid->claimed != HID_CLAIMED_HIDRAW) {
>>               for (a = 0; a < report->maxfield; a++)
>>                       hid_input_field(hid, report->field[a], cdata, interrupt);
>> +             hdrv = hid->driver;
>> +             if (hdrv && hdrv->report)
>> +                     hdrv->report(hid, report);
>
> I think this is more useful if called before the individual fields. In
> fact, it seems raw_event() is already doing exactly that. No need for
> a new callback, in other words.

I'm afraid this does not work:
- calling it before the individual fields is not possible unless more
intrusive changes to hid-core:
  * "hid_input_field" does the actual parsing of the input report, so
without the call the .value field is still set to the previous one
(not very useful then)
  * the "hid_input_field" requires to know the previous report, due to
Array type reports which send the current keys down, and not the
release.
- the raw_event() callback contains the report _unparsed_, which means
that it's up to the hid specific driver to split the fields depending
on the report descriptor (for instance, get the right bit for
tipswitch in a byte containing tipswitch, inrange, confidence,
contactId).
- the raw_event() mechanism was the one in place in the v1 of the
patch series, in which the new callback was asked.

Cheers,
Benjamin

>
>>       }
>>
>>       if (hid->claimed & HID_CLAIMED_INPUT)
>> diff --git a/include/linux/hid.h b/include/linux/hid.h
>> index 828726c..e14b465 100644
>> --- a/include/linux/hid.h
>> +++ b/include/linux/hid.h
>> @@ -589,6 +589,7 @@ struct hid_usage_id {
>>   * @raw_event: if report in report_table, this hook is called (NULL means nop)
>>   * @usage_table: on which events to call event (NULL means all)
>>   * @event: if usage in usage_table, this hook is called (NULL means nop)
>> + * @report: this hook is called after parsing a report (NULL means nop)
>>   * @report_fixup: called before report descriptor parsing (NULL means nop)
>>   * @input_mapping: invoked on input registering before mapping an usage
>>   * @input_mapped: invoked on input registering after mapping an usage
>> @@ -627,6 +628,7 @@ struct hid_driver {
>>       const struct hid_usage_id *usage_table;
>>       int (*event)(struct hid_device *hdev, struct hid_field *field,
>>                       struct hid_usage *usage, __s32 value);
>> +     void (*report)(struct hid_device *hdev, struct hid_report *report);
>>
>>       __u8 *(*report_fixup)(struct hid_device *hdev, __u8 *buf,
>>                       unsigned int *size);
>> --
>> 1.8.1
>>
>
> Thanks,
> Henrik
