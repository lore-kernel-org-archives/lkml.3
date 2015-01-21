Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbbAUOzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:55:04 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:62297 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbbAUOzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:55:01 -0500
MIME-Version: 1.0
In-Reply-To: <0000014b0ce57b01-4b49f79e-984b-43dd-b81d-01664133976f-000000@email.amazonses.com>
References: <54BBD8BA.7090906@yahoo.co.uk>
	<0000014afdcc643d-a943b494-4c10-4fa0-a85b-d36e89d6b09a-000000@email.amazonses.com>
	<CAN+gG=FObhPrQcnWCaqH059NfhQSB6CZzs7Wv4tAb4zLOD5qUw@mail.gmail.com>
	<0000014b0ce57b01-4b49f79e-984b-43dd-b81d-01664133976f-000000@email.amazonses.com>
Date: Wed, 21 Jan 2015 09:55:00 -0500
Message-ID: <CAN+gG=Gn4+oaerDrfm2cs3QQ3m1AnXgwAr=pRALKBg-xPJ3jSQ@mail.gmail.com>
Subject: Re: [PATCHv2 001/002] usbhid: Fix initialisation for the Microsoft
 Sidewinder Force Feedback Pro 2 joystick
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jim Keir <jimkeir@oracledbadirect.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Jim,

On Wed, Jan 21, 2015 at 9:29 AM, Jim Keir <jimkeir@oracledbadirect.com> wrote:
> Hi,
>
> Thanks for the feedback. I've included a replacement patch here for the
> first issue, and will send a separate message with a patch for the third
> issue. I've removed the second as per Alan's request. This diff is against
> the latest version of the hid branch rather than the 3.13 branch I was using
> before. Apologies for the mistakes, I'm still feeling my way around here.

No worries.

>
> ---
>
> Allow the Microsoft Sidewinder Force Feedback 2 joystick to perform the
> required communication with the device during initialisation.

Hmm weird, your mailer did not cut this line... It's better to have it
on 2 separate lines for the actual commit message (no more than 72 or
80 columns).

>
> Signed-off-by: Jim Keir <jimkeir@oracledbadirect.com>
>
> ---

This time the order of the various elements is nearly good :)

Git consider that the Subject and the first part of the message (until
the first '---') are to be included in the commit (so the commit title
and the commit message). Then, between the first '---' and the first
diff, you can put whatever comments you like. and then a second '---'
terminates the patch (and you can add garbage like thanks, or the list
footer).
Anyway, I am unable to double check what I just said because your
mailer corrupted the patch.
It converted the tabs in spaces and broke the lines when it should not have.

Please resend the two patches using git send-email.

Just use git format-patch. Then edit the file in an editor to add the
greetings and a short difference between v1 and v2 after the first ---
(your explanations before the first --- should be sufficient), then
use git send-email to send it. No need to link the thread with this
mail or the previous thread.

>
> diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
> index 10b6167..1b3fa70 100644
> --- a/drivers/hid/usbhid/hid-pidff.c
> +++ b/drivers/hid/usbhid/hid-pidff.c
> @@ -1252,6 +1258,8 @@ int hid_pidff_init(struct hid_device *hid)
>
>      pidff->hid = hid;
>
> +    hid_device_io_start(hid);
> +

I *think* we should be able to move this later a little bit. Not a
biggie however.

>      pidff_find_reports(hid, HID_OUTPUT_REPORT, pidff);
>      pidff_find_reports(hid, HID_FEATURE_REPORT, pidff);
>
> @@ -1315,9 +1323,13 @@ int hid_pidff_init(struct hid_device *hid)
>
>      hid_info(dev, "Force feedback for USB HID PID devices by Anssi Hannula
> <anssi.hannula@gmail.com>\n");
>
> +    hid_device_io_stop(hid);
> +
>      return 0;
>
>   fail:
> +    hid_device_io_stop(hid);
> +

For the record, we need to close the IO when leaving or the whole IO
mutex will be moot.

Cheers,
Benjamin

>      kfree(pidff);
>      return error;
>  }
>
> ---
>
> On 20/01/2015 14:09, Benjamin Tissoires wrote:
>>
>> Hi,
>>
>> Jim, in addition to what Alan said, here are some comments that I
>> would like to be fixed in the v2.
>>
>> On Sun, Jan 18, 2015 at 11:07 AM, Jim Keir <jimkeir@oracledbadirect.com>
>> wrote:
>>>
>>> From: Jim Keir <jimkeir@yahoo.co.uk>
>>> Signed-off-by: Jim Keir <jimkeir@yahoo.co.uk>
>>>
>> The Signed-off-by line is generally at the end of the commit message.
>> This way, if someone else adds new changes to the patch, we can trace
>> which modifications belongs to which.
>>
>>> Currently the SWFF2 driver fails during initialisation, making the force
>>> capability of the joystick unusable. Further, there is a long-standing
>>> bug in the same driver where commands to update force parameters are
>>> addressed to the last-created force effect instead of the specified one,
>>> making it impossible to modify effects after their creation.
>>>
>>> Three bugs are addressed:
>>>
>>> 1) The FF2 driver (usbhid/hid-pidff.c) sends commands to the stick
>>> during ff_init. However, this is called inside a block where
>>> driver_input_lock is locked, so the results of these initial commands
>>> are discarded. This one is the "killer", without this nothing else works.
>>>
>>> ff_init issues commands using "hid_hw_request". This eventually goes to
>>> hid_input_report, which returns -EBUSY because driver_input_lock is
>>> locked. The change is to delay the ff_init call in hid-core.c until
>>> after this lock has been released.
>>>
>>> 2) The usbhid driver ignores an endpoint stall when sending control
>>> commands, causing the first few commands of the hid-pidff.c
>>> initialisation to get lost.
>>>
>>> usbhid/hid-core.c has been modified by copying lines into "hid_ctrl"
>>> from the "hid_irq_in" function in the same file.
>>>
>>> 3) The FF2 driver (usbhid/hid-pidff.c) does not set the effect ID when
>>> uploading an effect. The result is that the initial upload works but
>>> subsequent uploads to modify effect parameters are all directed at the
>>> last-created effect.
>>>
>> Fully agree that you should split the commit in 3 if there are 3
>> issues (and to the rest Alan said also, but this is the most important
>> I think).
>>
>>
>>> The targeted effect ID must be passed back to the device when effect
>>> parameters are changed. This is done at the start of
>>> "pidff_set_condition_report", "pidff_set_periodic_report" etc. based on
>>> the value of "pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0]".
>>> However, this value is only ever set during pidff_request_effect_upload.
>>> The result is stored in "pidff->pid_id[effect->id]" at the end of
>>> pid_upload_effect, for later use. However, if an effect is modified and
>>> re-sent then this identifier is not being copied back from
>>> pidff->pid_id[effect->id] before sending the command to the device. The
>>> fix is to do this at the start of pidff_upload_effect.
>>>
>>> This patch taken against kernel 3.13.0
>>>
>>> ---
>>>
>>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>>> index 905e40a..a608ee6 100644
>>> --- a/drivers/hid/hid-core.c
>>> +++ b/drivers/hid/hid-core.c
>>> @@ -1546,9 +1546,8 @@ int hid_connect(struct hid_device *hdev, unsigned
>>> int
>>> connect_mask)
>>
>> On my local tree, hid_connect is at 1562. Is your patch based on the
>> for-next branch of the HID tree?
>> https://git.kernel.org/cgit/linux/kernel/git/jikos/hid.git
>>
>>
>>>           return -ENODEV;
>>>       }
>>>
>>> -    if ((hdev->claimed & HID_CLAIMED_INPUT) &&
>>> -            (connect_mask & HID_CONNECT_FF) && hdev->ff_init)
>>> -        hdev->ff_init(hdev);
>>> +    /* Removed ff_init() call from here. It does device I/O but this
>>> +     * is blocked because driver_input_lock is currently locked. */
>>
>> Please don't. If the feedback driver needs to have access to the IO
>> earlier, it needs to call hid_device_io_start() (and eventually
>> hid_device_io_stop() if some other initialization are required).
>>
>>>       len = 0;
>>>       if (hdev->claimed & HID_CLAIMED_INPUT)
>>> @@ -2029,6 +2028,13 @@ static int hid_device_probe(struct device *dev)
>>>   unlock:
>>>       if (!hdev->io_started)
>>>           up(&hdev->driver_input_lock);
>>> +
>>> +    if ((hdev->claimed & HID_CLAIMED_INPUT) && hdev->ff_init) {
>>> +        /* Late init of PID force-feedback drivers moved to after
>>> +         * unlock of driver_input_lock */
>>> +        hdev->ff_init(hdev);
>>> +    }
>>> +
>>
>> Same comment as above.
>>
>>>   unlock_driver_lock:
>>>       up(&hdev->driver_lock);
>>>       return ret;
>>> diff --git a/drivers/hid/usbhid/hid-core.c
>>> b/drivers/hid/usbhid/hid-core.c
>>> index 029965e..5d34dd7 100644
>>> --- a/drivers/hid/usbhid/hid-core.c
>>> +++ b/drivers/hid/usbhid/hid-core.c
>>> @@ -505,7 +505,12 @@ static void hid_ctrl(struct urb *urb)
>>>       case -EPROTO:        /* protocol error or unplug */
>>>       case -ECONNRESET:    /* unlink */
>>>       case -ENOENT:
>>> +        break;
>>>       case -EPIPE:        /* report not available */
>>> +        usbhid_mark_busy(usbhid);
>>> +        clear_bit(HID_IN_RUNNING, &usbhid->iofl);
>>> +        set_bit(HID_CLEAR_HALT, &usbhid->iofl);
>>> +        schedule_work(&usbhid->reset_work);
>>>           break;
>>>       default:        /* error */
>>>           hid_warn(urb->dev, "ctrl urb status %d received\n", status);
>>> diff --git a/drivers/hid/usbhid/hid-pidff.c
>>> b/drivers/hid/usbhid/hid-pidff.c
>>> index 10b6167..3f8ea63 100644
>>> --- a/drivers/hid/usbhid/hid-pidff.c
>>> +++ b/drivers/hid/usbhid/hid-pidff.c
>>> @@ -568,6 +568,13 @@ static int pidff_upload_effect(struct input_dev
>>> *dev,
>>> struct ff_effect *effect,
>>>       int type_id;
>>>       int error;
>>>
>>> +    pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] = 0;
>>> +
>>> +    if (old && effect) {
>>> +        pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] =
>>> +            pidff->pid_id[effect->id];
>>> +    }
>>> +
>>>       switch (effect->type) {
>>>       case FF_CONSTANT:
>>>           if (!old) {
>>> @@ -701,10 +708,14 @@ static int pidff_upload_effect(struct input_dev
>>> *dev,
>>> struct ff_effect *effect,
>>>           return -EINVAL;
>>>       }
>>>
>>> -    if (!old)
>>> +    if (!old) {
>>>           pidff->pid_id[effect->id] =
>>>               pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0];
>>>
>>> +        hid_dbg(pidff->hid, "Created new effect of type 0x%02x with h/w
>>> ID
>>> %d, driver ID %d\n",
>>> +            effect->type, pidff->pid_id[effect->id], effect->id);
>>> +    }
>>> +
>>
>> Not sure this is absolutely required, but it shouldn't hurt so you can
>> keep it I guess.
>>
>> Cheers,
>> Benjamin
>>
>>>       hid_dbg(pidff->hid, "uploaded\n");
>>>
>>>       return 0;
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
