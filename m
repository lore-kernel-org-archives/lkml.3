Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaBCRHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:07:36 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:61572 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaBCRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:07:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAN+gG=EesWpKiz-M4LrLTM0ne+o8=XE3vdQnwBPuHOyEgwEJKw@mail.gmail.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-5-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4Rn=rijG8Xv97okj2k4iv=ZG6wa30xQrxgjhutQovD+dg@mail.gmail.com>
	<CAN+gG=EesWpKiz-M4LrLTM0ne+o8=XE3vdQnwBPuHOyEgwEJKw@mail.gmail.com>
Date: Mon, 3 Feb 2014 18:07:34 +0100
Message-ID: <CANq1E4SMp6080REEbHriy6gE6pivoLbr9KzmpzJiFffK7QyJ2w@mail.gmail.com>
Subject: Re: [PATCH 04/11] HID: logitech-dj: remove hidinput_input_event
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Frank Praznik <frank.praznik@oh.rr.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Feb 3, 2014 at 5:21 PM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> On Mon, Feb 3, 2014 at 11:06 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> Hi
>>
>> On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
>> <benjamin.tissoires@redhat.com> wrote:
>>> hid-logitech-dj uses its own ->hidinput_input_event() instead of
>>> the generic binding in hid-input.
>>> Moving the handling of LEDs towards logi_dj_output_hidraw_report()
>>> allows two things:
>>> - remove hidinput_input_event in struct hid_device
>>> - hidraw user space programs can also set the LEDs
>>>
>>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>>> ---
>>>  drivers/hid/hid-logitech-dj.c | 99 +++++++++++++++----------------------------
>>>  1 file changed, 35 insertions(+), 64 deletions(-)
>>>
>>> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
>>> index f45279c..61d2bbf 100644
>>> --- a/drivers/hid/hid-logitech-dj.c
>>> +++ b/drivers/hid/hid-logitech-dj.c
>>> @@ -44,14 +44,6 @@ static const char kbd_descriptor[] = {
>>>         0x19, 0xE0,             /*   USAGE_MINIMUM (Left Control)   */
>>>         0x29, 0xE7,             /*   USAGE_MAXIMUM (Right GUI)      */
>>>         0x81, 0x02,             /*   INPUT (Data,Var,Abs)       */
>>> -       0x95, 0x05,             /*   REPORT COUNT (5)           */
>>> -       0x05, 0x08,             /*   USAGE PAGE (LED page)      */
>>> -       0x19, 0x01,             /*   USAGE MINIMUM (1)          */
>>> -       0x29, 0x05,             /*   USAGE MAXIMUM (5)          */
>>> -       0x91, 0x02,             /*   OUTPUT (Data, Variable, Absolute)  */
>>> -       0x95, 0x01,             /*   REPORT COUNT (1)           */
>>> -       0x75, 0x03,             /*   REPORT SIZE (3)            */
>>> -       0x91, 0x01,             /*   OUTPUT (Constant)          */
>>>         0x95, 0x06,             /*   REPORT_COUNT (6)           */
>>>         0x75, 0x08,             /*   REPORT_SIZE (8)            */
>>>         0x15, 0x00,             /*   LOGICAL_MINIMUM (0)        */
>>> @@ -60,6 +52,18 @@ static const char kbd_descriptor[] = {
>>>         0x19, 0x00,             /*   USAGE_MINIMUM (no event)       */
>>>         0x2A, 0xFF, 0x00,       /*   USAGE_MAXIMUM (reserved)       */
>>>         0x81, 0x00,             /*   INPUT (Data,Ary,Abs)       */
>>> +       0x85, 0x0e,             /* REPORT_ID (14)               */
>>> +       0x05, 0x08,             /*   USAGE PAGE (LED page)      */
>>> +       0x95, 0x05,             /*   REPORT COUNT (5)           */
>>> +       0x75, 0x01,             /*   REPORT SIZE (1)            */
>>> +       0x15, 0x00,             /*   LOGICAL_MINIMUM (0)        */
>>> +       0x25, 0x01,             /*   LOGICAL_MAXIMUM (1)        */
>>> +       0x19, 0x01,             /*   USAGE MINIMUM (1)          */
>>> +       0x29, 0x05,             /*   USAGE MAXIMUM (5)          */
>>> +       0x91, 0x02,             /*   OUTPUT (Data, Variable, Absolute)  */
>>> +       0x95, 0x01,             /*   REPORT COUNT (1)           */
>>> +       0x75, 0x03,             /*   REPORT SIZE (3)            */
>>> +       0x91, 0x01,             /*   OUTPUT (Constant)          */
>>>         0xC0
>>>  };
>>>
>>> @@ -544,10 +548,30 @@ static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
>>>                                         size_t count,
>>>                                         unsigned char report_type)
>>>  {
>>> -       /* Called by hid raw to send data */
>>> -       dbg_hid("%s\n", __func__);
>>> +       struct dj_device *djdev = hid->driver_data;
>>> +       struct dj_receiver_dev *djrcv_dev = djdev->dj_receiver_dev;
>>> +       u8 *out_buf;
>>> +       int ret;
>>>
>>> -       return 0;
>>> +       if (buf[0] != REPORT_TYPE_LEDS)
>>> +               return -EINVAL;
>>> +
>>> +       out_buf = kzalloc(DJREPORT_SHORT_LENGTH, GFP_ATOMIC);
>>> +       if (!out_buf)
>>> +               return -ENOMEM;
>>> +
>>> +       if (count < DJREPORT_SHORT_LENGTH - 2)
>>> +               count = DJREPORT_SHORT_LENGTH - 2;
>>> +
>>> +       out_buf[0] = REPORT_ID_DJ_SHORT;
>>> +       out_buf[1] = djdev->device_index;
>>> +       memcpy(out_buf + 2, buf, count);
>>> +
>>> +       ret = djrcv_dev->hdev->hid_output_raw_report(djrcv_dev->hdev, out_buf,
>>> +               DJREPORT_SHORT_LENGTH, report_type);
>>
>> Strictly speaking the code below uses HID_REQ_SET_REPORT and you
>> replace it with hid_output_raw_report() here (which at least for BTHID
>> is not equivalent). Anyhow, HID-core uses hid_output_raw_report(),
>> too, so this should be fine.
>
> Yes, you are right. This fires back on me yesterday when I tried to
> remove the hid_output_raw_report() calls.
> It occurs it works because usbhid_out_raw_report() uses set_report
> when there is no urbout, which is the case with logitech receivers.
> So I guess an ideal solution would be to implement a hid_hw_request call.
>
> However, the only concern I have with hid_hw_request is that it does
> not allow hidraw to play with the LEDs given that hidraw does not have
> an ioctl for SET_REPORT (or GET_REPORT). I already seen this issue
> regarding i2c_hid at some point, but it was "solved" in i2c_hid by
> using the same ugly trick that we have in USB-hid.

Hah! That's why it worked all the years, USB-HID checks for !urbout..
and yeah, that's what I just criticized in your i2c-hid patch.. Ok,
I'm fine if we make output_report() fall back to SET_REPORT if not
output-channel is supported. But we it gets ugly if we rely on that
from the upper stack... hmm, don't know how to make that work but
adding a hid quirk to use SET_REPORT for hidinput_input_report().

Thanks
David
