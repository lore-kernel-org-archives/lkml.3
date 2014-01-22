Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaAVFFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:05:50 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40299 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaAVFFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:05:48 -0500
MIME-Version: 1.0
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Tue, 21 Jan 2014 23:05:27 -0600
Message-ID: <CA+BWVUQq4UNwSsAUZaimqnV3DZqPRQ==wx+X2XSojhwVzvpUZg@mail.gmail.com>
Subject: RE: [PATCH] Add HID's to hid-microsoft driver of Surface Type/Touch
 Cover 2 to fix bug
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Benjamin,

>>
>> Hi,
>>
>> Thanks for reminding me of hid_have_special_driver[]. I noticed that
>> this device has the HID_DG_CONTACTID and in the comment of the
>> hid_have_sepcial_driver[]
>>
>> * Please note that for multitouch devices (driven by hid-multitouch driver),
>> * there is a proper autodetection and autoloading in place (based on presence
>> * of HID_DG_CONTACTID), so those devices don't need to be added to this list,
>> * as we are doing the right thing in hid_scan_usage().
>>
>> This device should not be driven by hid-multitouch as it does not
>> handle keyboard/mouse input devices.
>> I submitted a new patch below with it added. I believe it should still
>> be part of this array, in case this kind of implementation is
>> fixed/updated.
>
> This implementation is perfectly fine (I am referring to the "fixed/updated"):
> - if your device should be driven by hid-multitouch, then you _don't_
> add it to hid_have_special_driver
> - if your device should not be driven by hid-multitouch, then you
> _need_ to add it to hid_have_special_driver.
>
> Adding the device to hid_have_special_driver prevents the detection of
> the group HID_GRP_MULTITOUCH, so you will not end with a race between
> hid-multitouch and your special hid driver.
>

Thanks for clearing that up. I understand the proper use of this array
now, under this circumstance and am glad to know that there will be no
race when added.

>>
>> From 291742873dcf181faf9657b41279487f31302c73 Mon Sep 17 00:00:00 2001
>> From: Reyad Attiyat <reyad.attiyat@gmail.com>
>> Date: Tue, 21 Jan 2014 01:22:25 -0600
>> Subject: [PATCH 1/1] Added in HID's for Microsoft Surface Type/Touch cover 2.
>>  This is to fix bug 64811 where this device is detected as a multitouch device
>>
>
> You are missing a commit message here (the first message you sent
> would fit perfectly here).
>

Sorry about that, I'm new to submitting patches to these mailing lists.

> Other than that, I played a little with the report descriptor pointed
> in the bugzilla.
>
> I think I will be able to handle this touch cover in hid-multitouch,
> but that would require more testings/debugging. Microsoft seems to
> have implemented an indirect (dual) touchpad here, but until we know
> which mode we should put it into, it's going to be tricky to set it up
> correctly.
>
> One last thing, in the bugzilla, in the comment 2 you say: "I still
> have issues with the type cover 2 even with this fix". Are you still
> experiencing those disconnection? If so, maybe we should switch to
> hid-multitouch at some point.
>
I tried some patches that I think you posted to hid-input about hid-multitouch.
The patches added in support for function callbacks to allow for a
generic protocol.
This worked after I changed mt_input_mapping() to set the protocol to
mt_protocol_generic

851     * such as Mouse that might have the same GenericDesktop usages. */
852     if (field->application != HID_DG_TOUCHSCREEN &&
853         field->application != HID_DG_PEN &&
854         field->application != HID_DG_TOUCHPAD)
855                td->protocols[report_id] = mt_protocol_generic;

I still experience the disconnects with both of these solutions. Do
you have any idea what could cause this?
It seems to happen when I'm typing fast or holding a key. I'm guessing
the only way to fix this properly is
to snoop USB packets in Windows to see how the device is handled there.
Another bug is the device stays on, lit,  in standby mode.

What do you think is the best solution to take? By that I mean should
I keep the patch as part of hid-microsoft?
