Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaBMPQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:16:17 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:36152 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaBMPQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:16:15 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4RvnReiak20x2HPeZ6evYzDuVnLtbT9-WNeZR9yQbeHXg@mail.gmail.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
	<1392055139-19631-13-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4RvnReiak20x2HPeZ6evYzDuVnLtbT9-WNeZR9yQbeHXg@mail.gmail.com>
Date: Thu, 13 Feb 2014 10:16:13 -0500
Message-ID: <CAN+gG=FU3gY4EBfHde5FfdXY2u+1PTZjM4Ws3KBLNg6PY7MC6Q@mail.gmail.com>
Subject: Re: [PATCH 12/14] HID: hidraw: replace hid_output_raw_report() calls
 by appropriates ones
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

On Wed, Feb 12, 2014 at 5:49 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Mon, Feb 10, 2014 at 6:58 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> Remove hid_output_raw_report() call as it is not a ll_driver callbacj,
>> and switch to the hid_hw_* implementation. USB-HID used to fallback
>> into SET_REPORT when there were no output interrupt endpoint,
>> so emulating this if hid_hw_output_report() returns -ENOSYS.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/hidraw.c | 22 +++++++++++++++++-----
>>  1 file changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
>> index f8708c9..704718b 100644
>> --- a/drivers/hid/hidraw.c
>> +++ b/drivers/hid/hidraw.c
>> @@ -123,10 +123,8 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
>>
>>         dev = hidraw_table[minor]->hid;
>>
>> -       if (!dev->hid_output_raw_report) {
>> -               ret = -ENODEV;
>> -               goto out;
>> -       }
>> +       if (!dev->ll_driver->raw_request || !dev->ll_driver->output_report)
>> +               return -ENODEV;
>
> You still have a "goto out;" above (not visible in the patch). The
> error paths look quite ugly now. I'd prefer consistency here, so
> either keep the jump or fix the error-path above, too. Otherwise looks
> good.

ok, will use "goto out" in the v2 then.

Cheers,
Benjamin

>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>
> Thanks
> David
>
>>
>>         if (count > HID_MAX_BUFFER_SIZE) {
>>                 hid_warn(dev, "pid %d passed too large report\n",
>> @@ -153,7 +151,21 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
>>                 goto out_free;
>>         }
>>
>> -       ret = hid_output_raw_report(dev, buf, count, report_type);
>> +       if (report_type == HID_OUTPUT_REPORT) {
>> +               ret = hid_hw_output_report(dev, buf, count);
>> +               /*
>> +                * compatibility with old implementation of USB-HID and I2C-HID:
>> +                * if the device does not support receiving output reports,
>> +                * on an interrupt endpoint, then fallback to the SET_REPORT
>> +                * HID command.
>> +                */
>> +               if (ret != -ENOSYS)
>> +                       goto out_free;
>> +       }
>> +
>> +       ret = hid_hw_raw_request(dev, buf[0], buf, count, report_type,
>> +                               HID_REQ_SET_REPORT);
>> +
>>  out_free:
>>         kfree(buf);
>>  out:
>> --
>> 1.8.3.1
>>
