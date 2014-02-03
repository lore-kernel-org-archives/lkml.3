Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaBCP2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:28:21 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:47739 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaBCP2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:28:19 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4S+RLDpDd+zxgBRKsEw0-29un9mzS5jYBcoeJgQf5Upjg@mail.gmail.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-6-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4S+RLDpDd+zxgBRKsEw0-29un9mzS5jYBcoeJgQf5Upjg@mail.gmail.com>
Date: Mon, 3 Feb 2014 10:28:18 -0500
Message-ID: <CAN+gG=GR7kfRYzTW6NQ_anHFpgXOyCWezafMEnJxXqYXkrO1-A@mail.gmail.com>
Subject: Re: [PATCH 05/11] HID: HIDp: remove hidp_hidinput_event
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Frank Praznik <frank.praznik@oh.rr.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 10:10 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> hidp uses its own ->hidinput_input_event() instead of the generic binding
>> in hid-input.
>> Moving the handling of LEDs towards hidp_hidinput_event() allows two things:
>> - remove hidinput_input_event definitively from struct hid_device
>> - hidraw user space programs can also set the LEDs
>
> This one looks good. hid-input uses output_raw_report(), which is on
> INTR for BT-HID, which is equivalent to what hidp_send_report() does.
> So:
>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks

>
> Btw., you might have to keep hidp_send_report() if you drop earlier
> patches (haven't exactly looked at the order), but feel free to keep
> my r-b anyway.

No need to keep it, patches 1 to 4 do not touch HIDp, so no one else
use hidp_send_report().

Cheers,
Benjamin

>
> Thanks
> David
>
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  net/bluetooth/hidp/core.c | 46 ----------------------------------------------
>>  1 file changed, 46 deletions(-)
>>
>> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
>> index b062cee..469e61b 100644
>> --- a/net/bluetooth/hidp/core.c
>> +++ b/net/bluetooth/hidp/core.c
>> @@ -223,51 +223,6 @@ static void hidp_input_report(struct hidp_session *session, struct sk_buff *skb)
>>         input_sync(dev);
>>  }
>>
>> -static int hidp_send_report(struct hidp_session *session, struct hid_report *report)
>> -{
>> -       unsigned char hdr;
>> -       u8 *buf;
>> -       int rsize, ret;
>> -
>> -       buf = hid_alloc_report_buf(report, GFP_ATOMIC);
>> -       if (!buf)
>> -               return -EIO;
>> -
>> -       hid_output_report(report, buf);
>> -       hdr = HIDP_TRANS_DATA | HIDP_DATA_RTYPE_OUPUT;
>> -
>> -       rsize = ((report->size - 1) >> 3) + 1 + (report->id > 0);
>> -       ret = hidp_send_intr_message(session, hdr, buf, rsize);
>> -
>> -       kfree(buf);
>> -       return ret;
>> -}
>> -
>> -static int hidp_hidinput_event(struct input_dev *dev, unsigned int type,
>> -                              unsigned int code, int value)
>> -{
>> -       struct hid_device *hid = input_get_drvdata(dev);
>> -       struct hidp_session *session = hid->driver_data;
>> -       struct hid_field *field;
>> -       int offset;
>> -
>> -       BT_DBG("session %p type %d code %d value %d",
>> -              session, type, code, value);
>> -
>> -       if (type != EV_LED)
>> -               return -1;
>> -
>> -       offset = hidinput_find_field(hid, type, code, &field);
>> -       if (offset == -1) {
>> -               hid_warn(dev, "event field not found\n");
>> -               return -1;
>> -       }
>> -
>> -       hid_set_field(field, offset, value);
>> -
>> -       return hidp_send_report(session, field->report);
>> -}
>> -
>>  static int hidp_get_raw_report(struct hid_device *hid,
>>                 unsigned char report_number,
>>                 unsigned char *data, size_t count,
>> @@ -817,7 +772,6 @@ static struct hid_ll_driver hidp_hid_driver = {
>>         .close = hidp_close,
>>         .raw_request = hidp_raw_request,
>>         .output_report = hidp_output_report,
>> -       .hidinput_input_event = hidp_hidinput_event,
>>  };
>>
>>  /* This function sets up the hid device. It does not add it
>> --
>> 1.8.3.1
>>
