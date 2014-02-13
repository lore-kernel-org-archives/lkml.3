Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaBMPOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:14:35 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:42102 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaBMPOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:14:33 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4SYvLAhH3WqGNCZBrxwd8RiwL-wH90tZP9Je1doDxvhXQ@mail.gmail.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
	<1392055139-19631-6-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4SYvLAhH3WqGNCZBrxwd8RiwL-wH90tZP9Je1doDxvhXQ@mail.gmail.com>
Date: Thu, 13 Feb 2014 10:14:32 -0500
Message-ID: <CAN+gG=HZJ9b7_kw1CGwmhMOpPq+cy8r5vKORs-VXHi69Gbb-+A@mail.gmail.com>
Subject: Re: [PATCH 05/14] HID: i2c-hid: use generic .request() implementation
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

On Wed, Feb 12, 2014 at 5:30 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Mon, Feb 10, 2014 at 6:58 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> Having our own .request() implementation does not give anything,
>> so use the generic binding.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/i2c-hid/i2c-hid.c | 31 -------------------------------
>>  1 file changed, 31 deletions(-)
>>
>> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
>> index 07a054a..925fb8d 100644
>> --- a/drivers/hid/i2c-hid/i2c-hid.c
>> +++ b/drivers/hid/i2c-hid/i2c-hid.c
>> @@ -632,36 +632,6 @@ static int i2c_hid_raw_request(struct hid_device *hid, unsigned char reportnum,
>>         }
>>  }
>>
>> -static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
>> -               int reqtype)
>> -{
>> -       struct i2c_client *client = hid->driver_data;
>> -       char *buf;
>> -       int ret;
>> -       int len = i2c_hid_get_report_length(rep) - 2;
>> -
>> -       buf = kzalloc(len, GFP_KERNEL);
>
> Haven't you recently fixed this to use hid_alloc_buffer()? Anyhow,

yes, it has been fixed. But Jiri carried it through a *-upstream
branch, which is not merged into his for-next currently (or at the
time I sent the patch). hopefully the merge will be easy, or I can
wait for it to be in for-next before resending a smoother v2.

Cheers,
Benjamin

> patch obviously looks good:
>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>
> Thanks
> David
>
>> -       if (!buf)
>> -               return;
>> -
>> -       switch (reqtype) {
>> -       case HID_REQ_GET_REPORT:
>> -               ret = i2c_hid_get_raw_report(hid, rep->id, buf, len, rep->type);
>> -               if (ret < 0)
>> -                       dev_err(&client->dev, "%s: unable to get report: %d\n",
>> -                               __func__, ret);
>> -               else
>> -                       hid_input_report(hid, rep->type, buf, ret, 0);
>> -               break;
>> -       case HID_REQ_SET_REPORT:
>> -               hid_output_report(rep, buf);
>> -               i2c_hid_output_raw_report(hid, buf, len, rep->type, true);
>> -               break;
>> -       }
>> -
>> -       kfree(buf);
>> -}
>> -
>>  static int i2c_hid_parse(struct hid_device *hid)
>>  {
>>         struct i2c_client *client = hid->driver_data;
>> @@ -817,7 +787,6 @@ static struct hid_ll_driver i2c_hid_ll_driver = {
>>         .open = i2c_hid_open,
>>         .close = i2c_hid_close,
>>         .power = i2c_hid_power,
>> -       .request = i2c_hid_request,
>>         .output_report = i2c_hid_output_report,
>>         .raw_request = i2c_hid_raw_request,
>>  };
>> --
>> 1.8.3.1
>>
