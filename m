Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaBCTIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:08:00 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:63295 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaBCTH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:07:58 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4RD0OVTSVOXHPTchop0Y0q0p1_NEZZexSE4kvkp-17TKw@mail.gmail.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-2-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4RD0OVTSVOXHPTchop0Y0q0p1_NEZZexSE4kvkp-17TKw@mail.gmail.com>
Date: Mon, 3 Feb 2014 14:07:56 -0500
Message-ID: <CAN+gG=Hsf1r12mq=b9DutHDOJwcvMgYgDL9o6VOMTY2fjxTobg@mail.gmail.com>
Subject: Re: [PATCH 01/11] HID: uHID: implement .raw_request
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

On Mon, Feb 3, 2014 at 10:26 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> It was missing, so adding it.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/uhid.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
>> index f5a2b19..438c9f1 100644
>> --- a/drivers/hid/uhid.c
>> +++ b/drivers/hid/uhid.c
>> @@ -270,6 +270,22 @@ static int uhid_hid_output_report(struct hid_device *hid, __u8 *buf,
>>         return count;
>>  }
>>
>> +static int uhid_raw_request(struct hid_device *hid, unsigned char reportnum,
>> +                           __u8 *buf, size_t len, unsigned char rtype,
>> +                           int reqtype)
>> +{
>> +       switch (reqtype) {
>> +       case HID_REQ_GET_REPORT:
>> +               return uhid_hid_get_raw(hid, reportnum, buf, len, rtype);
>> +       case HID_REQ_SET_REPORT:
>> +               if (buf[0] != reportnum)
>> +                       return -EINVAL;
>> +               return uhid_hid_output_raw(hid, buf, len, rtype);
>
> But that one looks wrong. UHID does not have any SET_REPORT query in
> the protocol, yet. You turn a SET_REPORT into an OUTPUT_REPORT here.
> So if user-space gets the UHID_OUTPUT event, it doesn't know whether
> to send a SET_REPORT@ctrl to the device, or an async
> OUTPUT_REPORT@intr. This at least matters for low-energy BT in bluez,
> which uses uhid.

right. So we can drop this for now.

>
> So we'd have to add an UHID_SET_REPORT event. Note that currently
> UHID_FEATURE is the equivalent of UHID_GET_REPORT, but just horribly
> named..

ouch. I think this is something which can be fixed quite easily (by
marking UHID_FEATURE obsolete and creating the two events).
However, I don't think I will have the time to make the change and do
proper testings in the next few days/weeks.

Can somebody else take this?

Cheers,
Benjamin

>
> Thanks
> David
>
>> +       default:
>> +               return -EIO;
>> +       }
>> +}
>> +
>>  static struct hid_ll_driver uhid_hid_driver = {
>>         .start = uhid_hid_start,
>>         .stop = uhid_hid_stop,
>> @@ -277,6 +293,7 @@ static struct hid_ll_driver uhid_hid_driver = {
>>         .close = uhid_hid_close,
>>         .parse = uhid_hid_parse,
>>         .output_report = uhid_hid_output_report,
>> +       .raw_request = uhid_raw_request,
>>  };
>>
>>  #ifdef CONFIG_COMPAT
>> --
>> 1.8.3.1
>>
