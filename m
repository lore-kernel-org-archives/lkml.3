Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaBPQnF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 11:43:05 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:61214 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaBPQnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 11:43:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAN+gG=EcXQLivrUPXCk8imrY0T2n3Twc9yujxPGmi=LeoOrsCg@mail.gmail.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
	<1392055139-19631-4-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4TjLJUts20nVYE3WT5FXu_eswKrM0CLwQAu25df3GEDig@mail.gmail.com>
	<CAN+gG=EcXQLivrUPXCk8imrY0T2n3Twc9yujxPGmi=LeoOrsCg@mail.gmail.com>
Date: Sun, 16 Feb 2014 17:43:02 +0100
Message-ID: <CANq1E4SyECC2unw9hAxf5Z4Xm82ogvVJZapJTX_DLrO-SqPBag@mail.gmail.com>
Subject: Re: [PATCH 03/14] HID: core: implement generic .request()
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Feb 13, 2014 at 4:21 PM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> On Wed, Feb 12, 2014 at 5:25 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> Hi
>>
>> On Mon, Feb 10, 2014 at 6:58 PM, Benjamin Tissoires
>> <benjamin.tissoires@redhat.com> wrote:
>>> .request() can be emulated through .raw_request()
>>> we can implement this emulation in hid-core, and make .request
>>> not mandatory for transport layer drivers.
>>>
>>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>>> ---
>>>  drivers/hid/hid-core.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
>>>  include/linux/hid.h    |  5 ++++-
>>>  2 files changed, 48 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>>> index 18fe49b..f36778a 100644
>>> --- a/drivers/hid/hid-core.c
>>> +++ b/drivers/hid/hid-core.c
>>> @@ -1248,6 +1248,11 @@ void hid_output_report(struct hid_report *report, __u8 *data)
>>>  }
>>>  EXPORT_SYMBOL_GPL(hid_output_report);
>>>
>>> +static int hid_report_len(struct hid_report *report)
>>> +{
>>> +       return ((report->size - 1) >> 3) + 1 + (report->id > 0) + 7;
>>
>> Just for clarity, this is equivalent to the following, right?
>>
>> return DIV_ROUND_UP(report->size, 8) + !!(report->id > 0) + 7;
>
> yes, it should (at least that's what I understand too :)
>
>>
>> I always have to read that shifting code twice to get it.. Maybe add a
>> comment explaining the different entries here.
>
> good idea.
>
>>
>>> +}
>>> +
>>>  /*
>>>   * Allocator for buffer that is going to be passed to hid_output_report()
>>>   */
>>> @@ -1258,7 +1263,7 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags)
>>>          * of implement() working on 8 byte chunks
>>>          */
>>>
>>> -       int len = ((report->size - 1) >> 3) + 1 + (report->id > 0) + 7;
>>> +       int len = hid_report_len(report);
>>>
>>>         return kmalloc(len, flags);
>>>  }
>>> @@ -1314,6 +1319,44 @@ static struct hid_report *hid_get_report(struct hid_report_enum *report_enum,
>>>         return report;
>>>  }
>>>
>>> +/*
>>> + * Implement a generic .request() callback, using .raw_request()
>>> + * DO NOT USE in hid drivers directly, but through hid_hw_request instead.
>>> + */
>>> +void __hid_request(struct hid_device *hid, struct hid_report *report,
>>> +               int reqtype)
>>> +{
>>> +       char *buf;
>>> +       int ret;
>>> +       int len;
>>> +
>>> +       if (!hid->ll_driver->raw_request)
>>> +               return;
>>> +
>>> +       buf = hid_alloc_report_buf(report, GFP_KERNEL);
>>> +       if (!buf)
>>> +               return;
>>> +
>>> +       len = hid_report_len(report);
>
> actually, after sending the patches, I was wondering if we should use
> the +7 in hid_report_len.
> "len" is used in .raw_request(), and the +7 was only for the implement(), right?
>
> So maybe a device can reject this because the size of the report is too big...
>
> Jiri, David, any ideas?

Yeah, we should allocate the +7 size, but we shouldn't use it as
"length" argument. We should just silently guarantee the buffer is big
enough.

Thanks
David

> Cheers,
> Benjamin
>
>>> +
>>> +       if (reqtype == HID_REQ_SET_REPORT)
>>> +               hid_output_report(report, buf);
>>> +
>>> +       ret = hid->ll_driver->raw_request(hid, report->id, buf, len,
>>> +                                         report->type, reqtype);
>>> +       if (ret < 0) {
>>> +               dbg_hid("unable to complete request: %d\n", ret);
>>> +               goto out;
>>> +       }
>>> +
>>> +       if (reqtype == HID_REQ_GET_REPORT)
>>> +               hid_input_report(hid, report->type, buf, ret, 0);
>>> +
>>> +out:
>>> +       kfree(buf);
>>> +}
>>> +EXPORT_SYMBOL_GPL(__hid_request);
>>> +
>>
>> Looks good to me.
>>
>> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>>
>> Thanks
>> David
>>
>>>  int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>>>                 int interrupt)
>>>  {
>>> diff --git a/include/linux/hid.h b/include/linux/hid.h
>>> index a837ede..09fbbd7 100644
>>> --- a/include/linux/hid.h
>>> +++ b/include/linux/hid.h
>>> @@ -753,6 +753,7 @@ struct hid_field *hidinput_get_led_field(struct hid_device *hid);
>>>  unsigned int hidinput_count_leds(struct hid_device *hid);
>>>  __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code);
>>>  void hid_output_report(struct hid_report *report, __u8 *data);
>>> +void __hid_request(struct hid_device *hid, struct hid_report *rep, int reqtype);
>>>  u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags);
>>>  struct hid_device *hid_allocate_device(void);
>>>  struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
>>> @@ -965,7 +966,9 @@ static inline void hid_hw_request(struct hid_device *hdev,
>>>                                   struct hid_report *report, int reqtype)
>>>  {
>>>         if (hdev->ll_driver->request)
>>> -               hdev->ll_driver->request(hdev, report, reqtype);
>>> +               return hdev->ll_driver->request(hdev, report, reqtype);
>>> +
>>> +       __hid_request(hdev, report, reqtype);
>>>  }
>>>
>>>  /**
>>> --
>>> 1.8.3.1
>>>
