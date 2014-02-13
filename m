Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaBMPjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:39:05 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:51277 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaBMPjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:39:03 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4QvC936A_r6GPgO_gikpXGrD6UwBdBEcwUBwtjxW9iw6Q@mail.gmail.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
	<1392055139-19631-8-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4QvC936A_r6GPgO_gikpXGrD6UwBdBEcwUBwtjxW9iw6Q@mail.gmail.com>
Date: Thu, 13 Feb 2014 10:38:59 -0500
Message-ID: <CAN+gG=GFOMJ_ud3p=pzyBcpnuWJn8rhtJLXHR5kfadfWL0v+Og@mail.gmail.com>
Subject: Re: [PATCH 07/14] HID: input: hid-input remove hid_output_raw_report call
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 5:35 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Mon, Feb 10, 2014 at 6:58 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> hid_output_raw_report() is not a ll_driver callback and should not be used.
>> To keep the same code path than before, we are forced to play with the
>> different hid_hw_* calls: if the usb or i2c device does not support
>> direct output reports, then we will rely on the SET_REPORT HID call.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/hid-input.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
>> index eb00a5b..6b7bdca 100644
>> --- a/drivers/hid/hid-input.c
>> +++ b/drivers/hid/hid-input.c
>> @@ -1153,7 +1153,7 @@ static void hidinput_led_worker(struct work_struct *work)
>>                                               led_work);
>>         struct hid_field *field;
>>         struct hid_report *report;
>> -       int len;
>> +       int len, ret;
>>         __u8 *buf;
>>
>>         field = hidinput_get_led_field(hid);
>> @@ -1187,7 +1187,10 @@ static void hidinput_led_worker(struct work_struct *work)
>>
>>         hid_output_report(report, buf);
>>         /* synchronous output report */
>> -       hid_output_raw_report(hid, buf, len, HID_OUTPUT_REPORT);
>> +       ret = hid_hw_output_report(hid, buf, len);
>> +       if (ret == -ENOSYS)
>> +               hid_hw_raw_request(hid, buf[0], buf, len, HID_OUTPUT_REPORT,
>> +                               HID_REQ_SET_REPORT);
>
> Does HID core always set the report-id in buf[0]? Even if none are
> used? I know the incoming data may lack the report-id, but I always
> thought we do the same for outgoing if it's implicit?

oh, yes, you are right. The HID spec says: "The meaning of the request
fields for the Set_Report request is the same as for the Get_Report
request, however the data direction is reversed and the Report Data is
sent from host to device. "

So this is wrong... We should use (report->id) instead of buf[0].

Will fix in v2.

>
> I also already see devices with broken OUTPUT_REPORTs.. I guess at
> some point we have to introduce a quirk-flag to choose between both
> calls. But lets wait for that to happen, maybe we're lucky.
>
>>         kfree(buf);
>>  }
>>
>> @@ -1266,7 +1269,8 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
>>         }
>>
>>         input_set_drvdata(input_dev, hid);
>> -       if (hid->ll_driver->request || hid->hid_output_raw_report)
>> +       if (hid->ll_driver->request || hid->ll_driver->output_report ||
>> +           hid->ll_driver->raw_request)
>
> Isn't raw_request mandatory? So we could remove that whole if() thing here.

Currently, it's not (see hid_hw_raw_request). However, all the
upstream hid transport drivers implement it.

We can make it mandatory, but we should check it while adding the
device in hid_add_device.

will do for v2 too.

Cheers,
Benjamin

>
> Thanks
> David
>
>>                 input_dev->event = hidinput_input_event;
>>         input_dev->open = hidinput_open;
>>         input_dev->close = hidinput_close;
>> --
>> 1.8.3.1
>>
