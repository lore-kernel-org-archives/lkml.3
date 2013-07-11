Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3GKOKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:10:50 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59734 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab3GKOKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:10:48 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4Tx7cVkWmZHtLvtW4U78uedEUe4Qs40aeyzRORmEBTPBg@mail.gmail.com>
References: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com>
	<1373550090-30379-2-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4Tx7cVkWmZHtLvtW4U78uedEUe4Qs40aeyzRORmEBTPBg@mail.gmail.com>
Date: Thu, 11 Jul 2013 16:10:46 +0200
Message-ID: <CAN+gG=HsR3uQDF-U+jAd5Ap_+GQqLG2xOe-waLBNq3D6Righnw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Bluetooth: hidp: implement hidinput_input_event callback
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>, Jiri Kosina <jkosina@suse.cz>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Jul 11, 2013 at 4:02 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
>> +static int hidp_hidinput_event(struct input_dev *dev, unsigned int type,
>> +                              unsigned int code, int value)
>> +{
>> +       struct hid_device *hid = input_get_drvdata(dev);
>
> I dislike that we have to deal with input_get_drvdata() in a transport
> driver. It is not obvious from the transport driver that this gives us
> an hid_device. But ok, that's how we do it in usbhid and hid-input so
> it's another issue..

right. So we should definitively change the callback signature here.

>
>> +       struct hidp_session *session = hid->driver_data;
>> +       struct hid_field *field;
>> +       int offset;
>> +
>> +       BT_DBG("session %p type %d code %d value %d",
>> +              session, type, code, value);
>> +
>> +       if (type != EV_LED)
>> +               return -1;
>> +
>> +       offset = hidinput_find_field(hid, type, code, &field);
>> +       if (offset == -1) {
>> +               hid_warn(dev, "event field not found\n");
>> +               return -1;
>> +       }
>> +
>> +       hid_set_field(field, offset, value);
>> +
>> +       return hidp_send_report(session, field->report);
>> +}
>> +
>
> We had this discussion before (regarding uhid and hidpinput_event), it
> would be nice to have a helper in hid-input.c which does this. We copy
> the code into every transport driver, which bugs me. But no-one
> stepped up to do this, so I am fine.

oh, yes, you are right. I'll add it to my todo list (now that I am
responsible of 2/4 code duplication :-S )

>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks for the review!

Cheers,
Benjamin

>
> Thanks!
> David
>
>>  static int hidp_get_raw_report(struct hid_device *hid,
>>                 unsigned char report_number,
>>                 unsigned char *data, size_t count,
>> @@ -711,6 +736,7 @@ static struct hid_ll_driver hidp_hid_driver = {
>>         .stop = hidp_stop,
>>         .open  = hidp_open,
>>         .close = hidp_close,
>> +       .hidinput_input_event = hidp_hidinput_event,
>>  };
>>
>>  /* This function sets up the hid device. It does not add it
>> --
>> 1.8.3.1
>>
