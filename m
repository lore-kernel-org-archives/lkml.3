Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaBCTAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:00:04 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:40249 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaBCTAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:00:02 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4S0WjuqW3coJDKqH9Gm5JWwb_W_CEU8Ety15m0CjhOqZQ@mail.gmail.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-3-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4S0WjuqW3coJDKqH9Gm5JWwb_W_CEU8Ety15m0CjhOqZQ@mail.gmail.com>
Date: Mon, 3 Feb 2014 14:00:00 -0500
Message-ID: <CAN+gG=G7G4Twr6-6cftKXXdfgSRZ54ZmaYzLcOLiQhMhgCX5og@mail.gmail.com>
Subject: Re: [PATCH 02/11] HID: i2c-hid: implement ll_driver transport-layer callbacks
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>,
        Andrew Duggan <aduggan@synaptics.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Frank Praznik <frank.praznik@oh.rr.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 11:04 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> Add output_report and raw_request to i2c-hid.
>> Hopefully, we will manage to have the same transport level between
>> all the transport drivers.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/i2c-hid/i2c-hid.c | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
>> index ce68a12..5099f1f 100644
>> --- a/drivers/hid/i2c-hid/i2c-hid.c
>> +++ b/drivers/hid/i2c-hid/i2c-hid.c
>> @@ -574,6 +574,28 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
>>         return ret;
>>  }
>>
>> +static int i2c_hid_output_report(struct hid_device *hid, __u8 *buf,
>> +               size_t count)
>> +{
>> +       return i2c_hid_output_raw_report(hid, buf, count, HID_OUTPUT_REPORT);
>> +}
>> +
>> +static int i2c_hid_raw_request(struct hid_device *hid, unsigned char reportnum,
>> +                              __u8 *buf, size_t len, unsigned char rtype,
>> +                              int reqtype)
>> +{
>> +       switch (reqtype) {
>> +       case HID_REQ_GET_REPORT:
>> +               return i2c_hid_get_raw_report(hid, reportnum, buf, len, rtype);
>> +       case HID_REQ_SET_REPORT:
>> +               if (buf[0] != reportnum)
>> +                       return -EINVAL;
>> +               return i2c_hid_output_raw_report(hid, buf, len, rtype);
>
> I just skimmed the I2C-HID specs and it defines three methods for
> input/output reports:
>
> 1) Section 6.2:
> raw async output-reports can be sent by writing the data at any time
> to wOutputRegister.
> This should be used as method for hid->output_report().
>
> 2) Section 7.1:
> SET_REPORT can be issued by writing the right OPCODE + report-ID into
> wCommandRegister and the data into wDataRegister.
> This should be used as method for hid->raw_request() + HID_REQ_SET_REPORT.
>
> 3) Section 7.1:
> GET_REPORT can be issued by writing the right OPCODE + report-ID into
> wCommandRegister and then waiting for the device to write the data
> into wDataRegister.
> This should be used for hid->raw_request() + HID_REQ_GET_REPORT
>
>
> The GET_REPORT implementation looks fine to me, but the
> i2c_hid_set_report() seems to support both 1) and 2) depending on the
> passed type and capabilities:
>  - it uses 2) for FEATURE_REPORT reports or if the max OUTPUT_LENGTH is 0
>  - it uses 1) otherwise
>
> I'm not sure whether the i2c-hid-spec mandates this behavior, so I am
> not saying it's wrong. I just wanna understand what we do here. So if
> we use hid->output_report() with HID_FEATURE_REPORT, the current code
> turns this into a SET_REPORT. Likewise, an hid->raw_request() with
> HID_REQ_SET_REPORT but with HID_OUTPUT_REPORT turns into an
> output-report.

Ok, just for the record (I think that you already answered this in the
4/11 review):
this behavior has been added in commit
811adb9622de310efbb661531c3ec0ae5d2b2bc0 for Synaptics so they can
talk to their HID/I2C firmware.
The use they are making is through hdev->hid_output_raw_report(), and
at that time output_report() did not exist.

I guess that with the new API (output_report() and raw_request() ) we
can revert this and it will not bother them given that rmi-hid.c is
still not upstream.

I have no clue if anyone else is using hdev->hid_output_raw_report()
for I2C devices, but we could still try to clean this right now given
that those devices are not well spread (besides some hid-multitouch
touchscreens which do not use OUTPUT reports).

I am still a little bit concerned by hidraw not able to call
set_report in this case, but this could be fixed also by adding an
ioctl.

How does that sound?

Cheers,
Benjamin

>
> I'd rather expect this behavior:
>
> hid->output_report() should always do this:
>   args[index++] = outputRegister & 0xFF;
>   args[index++] = outputRegister >> 8;
>   hidcmd = &hid_no_cmd;
>
> while hid->raw_request() should always do this:
>   args[index++] = dataRegister & 0xFF;
>   args[index++] = dataRegister >> 8;
>
> The special case for maxOutputLength==0 seems fine to me, but the
> "reportType == 0x03" looks weird.
>
>
> Thanks
> David
>
>> +       default:
>> +               return -EIO;
>> +       }
>> +}
>> +
>>  static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
>>                 int reqtype)
>>  {
>> @@ -761,6 +783,8 @@ static struct hid_ll_driver i2c_hid_ll_driver = {
>>         .close = i2c_hid_close,
>>         .power = i2c_hid_power,
>>         .request = i2c_hid_request,
>> +       .output_report = i2c_hid_output_report,
>> +       .raw_request = i2c_hid_raw_request,
>>  };
>>
>>  static int i2c_hid_init_irq(struct i2c_client *client)
>> --
>> 1.8.3.1
>>
