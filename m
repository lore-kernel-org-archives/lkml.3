Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3LROov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:44:51 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36310 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3LROot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:44:49 -0500
MIME-Version: 1.0
In-Reply-To: <20131218152731.0222ae3b3807601b7756c937@studenti.unina.it>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
	<1387295334-1744-3-git-send-email-dh.herrmann@gmail.com>
	<20131218152731.0222ae3b3807601b7756c937@studenti.unina.it>
Date: Wed, 18 Dec 2013 15:44:48 +0100
Message-ID: <CANq1E4RNa6XBaUTy=ur7Yig0iJSEaUbLzvi-Dn-hyxS2OLnyPw@mail.gmail.com>
Subject: Re: [PATCH 2/4] Input: introduce ABS_MAX2/CNT2 and friends
From: David Herrmann <dh.herrmann@gmail.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Input Tools <input-tools@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Dec 18, 2013 at 3:27 PM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> Hi David,
>
> thanks for the update.
>
> On Tue, 17 Dec 2013 16:48:52 +0100
> David Herrmann <dh.herrmann@gmail.com> wrote:
>
>> As we painfully noticed during the 3.12 merge-window our
>> EVIOCGABS/EVIOCSABS API is limited to ABS_MAX<=0x3f. We tried several
>> hacks to work around it but if we ever decide to increase ABS_MAX, the
>> EVIOCSABS ioctl ABI might overflow into the next byte causing horrible
>> misinterpretations in the kernel that we cannot catch.
>>
>> Therefore, we decided to go with ABS_MAX2/CNT2 and introduce two new
>> ioctls to get/set abs-params. They no longer encode the ABS code in the
>> ioctl number and thus allow up to 4 billion ABS codes.
>>
>
> Just a question: did you consider the possibility of not exposing _MAX2
> and _CNT2 in a header file at all but let those be queried? Or maybe
> this is not necessary if we assume that userspace programs are supposed
> to know what is the MAX _they_ support?
>
> BTW I was thinking for instance to a program compiled with ABS_MAX2 =
> 0x4f but working with future kernels with an increased value, it still
> won't be able to support values greater than 0x4f.

Why would a program that was compiled with ABS_MAX2=0x4f want to use
ABS_* values greater than 0x4f? It doesn't know of any new values so
even if it could query ABS_MAX2, it could never know anything about
the new constants. The only place where it is useful is for generic
programs that just foward ABS_* codes. But these can just ignore
ABS_MAX2 entirely and use the whole int32_t range for codes.

If there is a specific use-case that'd require a dynamic way to
retrieve ABS_MAX2, I can consider changing the API. But unless there's
such a use-case, I'd like to keep it the same as for KEY_*, SW_*, ...

>> The new API also allows to query multiple ABS values with one call. To
>> allow EVIOCSABS2(code = 0, cnt = ABS_CNT2) we need to silently ignore
>> writes to ABS_MT_SLOT. Furthermore, for better compatibility with
>> newer user-space, we ignore writes to unknown codes. Hence, if we ever
>> increase ABS_MAX2, new user-space will work with code=0,cnt=ABS_CNT2 just
>> fine even on old kernels.
>>
>
> To my inexperienced eye it's not obvious why ABS_MT_SLOT must be handled
> as a special case. Maybe because I don't even know what
> code=0,cnt=ABS_CNT2 is used for.

ABS_MT_SLOT describes the current MT-slot that is reported via
ABS_MT_* bits. It is read-only so we cannot let user-space write to
it.

>> Note that we also need to increase EV_VERSION so user-space can reliably
>> know whether ABS2 is supported. Unfortunately, we return EINVAL instead of
>> ENOSYS for unknown evdev ioctls so it's nearly impossible to catch
>> reliably without EVIOCGVERSION.
>>
>
> I'll check how to use that in evtest.
>
> Just one more comment below.
>
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>> ---
>>  drivers/hid/hid-debug.c                  |  2 +-
>>  drivers/hid/hid-input.c                  |  2 +-
>>  drivers/input/evdev.c                    | 95 +++++++++++++++++++++++++++++++-
>>  drivers/input/input.c                    | 14 ++---
>>  drivers/input/keyboard/goldfish_events.c |  6 +-
>>  drivers/input/keyboard/hil_kbd.c         |  2 +-
>>  drivers/input/misc/uinput.c              |  6 +-
>>  include/linux/hid.h                      |  2 +-
>>  include/linux/input.h                    |  6 +-
>>  include/uapi/linux/input.h               | 42 +++++++++++++-
>>  include/uapi/linux/uinput.h              |  2 +-
>>  11 files changed, 155 insertions(+), 24 deletions(-)
>>
>
> [...]
>> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
>> index bd24470..1856461 100644
>> --- a/include/uapi/linux/input.h
>> +++ b/include/uapi/linux/input.h
> [...]
>>
>>  /*
>> + * Due to API restrictions the legacy evdev API only supports ABS values up to
>> + * ABS_MAX/CNT. Use the extended *ABS2 ioctls to operate on any ABS values in
>> + * between ABS_MAX and ABS_MAX2.
>> + */
>> +#define ABS_MAX2             0x3f
>> +#define ABS_CNT2             (ABS_MAX2+1)
>> +
>
> Maybe it's just my English, but when you say "between ABS_MAX and
> ABS_MAX2" it sounds like the old protocol still _must_ be used for
> values <= ABS_MAX.
>
> IIUC this is true "only" for compatibility with older kernels right?
> If a program decides to support only newer kernels it can check the
> protocol version and use only the new ioctls, right?
>
> Maybe you can be more explicit about that in the comment?

See the comment on "struct input_absinfo2". It describes the API, this
comment just describes the ABS_* values. But if anyone has a better
phrase to use here, I will gladly adjust it.

Thanks
David
