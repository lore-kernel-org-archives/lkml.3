Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3G2JQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:16:14 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62259 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3G2JQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:16:11 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4RfTLtDz1RYixg4qdkNxrU22rSaZxFss4++A-0hYM0bEQ@mail.gmail.com>
References: <1373895429-8846-1-git-send-email-benjamin.tissoires@redhat.com>
	<1373895429-8846-2-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4RfTLtDz1RYixg4qdkNxrU22rSaZxFss4++A-0hYM0bEQ@mail.gmail.com>
Date: Mon, 29 Jul 2013 11:16:09 +0200
Message-ID: <CAN+gG=Hdcv7-9iZUePcDCe2W2-+6YiMscMRtHLJ4W8-CiBF6Ew@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] input/uinput: add UI_GET_SYSPATH ioctl to retrieve
 the sysfs path
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sat, Jul 27, 2013 at 3:07 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Mon, Jul 15, 2013 at 3:37 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> Evemu [1] uses uinput to replay devices traces it has recorded. However,
>> the way evemu uses uinput is slightly different from how uinput is
>> supposed to be used.
>> Evemu creates the device node through uinput, bu inject events through
>> the input device node directly (and skipping the uinput node).
>>
>> Currently, evemu relies on an heuristic to guess which input node was
>> created. The problem is that is heuristic is subjected to races between
>> different uinput devices or even with physical devices. Having a way
>> to retrieve the sysfs path allows us to find the event node without
>> having to rely on this heuristic.
>
> It would actually be enough to return the "input_no" from
> input_register_device() (which is currently local but we could save it
> in "dev"). Or only the device-name. I don't know why you want the full
> syspath. It's just overhead in the kernel that we could easily let
> user-space do. And the path /sys/class/input/<devname> can be put
> together by user-space.

I agree that the "input_no" is enough, but that would infer a change
in the input struct. However, we (Peter and I) want to be able to use
it in RHEL, or any other legacy distribution, where it is not
acceptable to ask to recompile a new kernel to do regressions tests.
For those distributions, I have set up a backport of uinput [2] and
with this backport, you only need to recompile the uinput module (not
the whole kernel tree).
Anyway, returning the input name seems enough too. It will remove the
path retrieval and a free :)

I agree this is not the kind of argument we usually like in the kernel
tree, but as this feature (resolution and input retrieval) seems to be
only valuable for regression tests (Xorg or Wayland), I think it is
valuable.

>
> Anyway, Dmitry has to decide on that. Apart from some style-issues I
> mentioned below:
>   Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

thanks!

>
> Cheers
> David
>
>> [1] http://www.freedesktop.org/wiki/Evemu/

[2] https://github.com/bentiss/uinput

>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/input/misc/uinput.c | 37 ++++++++++++++++++++++++++++++++++++-
>>  include/linux/uinput.h      |  1 +
>>  include/uapi/linux/uinput.h |  3 +++
>>  3 files changed, 40 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
>> index 7d518b4..49a9f7d 100644
>> --- a/drivers/input/misc/uinput.c
>> +++ b/drivers/input/misc/uinput.c
>> @@ -22,6 +22,7 @@
>>   * Changes/Revisions:
>>   *     0.4     12/07/2013 (Peter Hutterer <peter.hutterer@redhat.com>)
>>   *             - update uinput_user_dev struct to allow abs resolution
>> + *             - add UI_GET_SYSPATH ioctl
>
> What tree is that patch against? I cannot see an "0.4" entry in:
> http://git.kernel.org/cgit/linux/kernel/git/dtor/input.git/tree/drivers/input/misc/uinput.c?h=next

looks like you miss the msg title: 2/2. It is part of a series where
the first patch was done by Peter here:
https://patchwork.kernel.org/patch/2827521/

>
>>   *     0.3     09/04/2006 (Anssi Hannula <anssi.hannula@gmail.com>)
>>   *             - updated ff support for the changes in kernel interface
>>   *             - added MODULE_VERSION
>> @@ -667,6 +668,21 @@ static int uinput_ff_upload_from_user(const char __user *buffer,
>>         __ret;                                          \
>>  })
>>
>> +static int uinput_str_to_user(const char *str, unsigned int maxlen,
>> +                             void __user *p)
>
> As Peter mentioned, I'd move "maxlen" to the end.

right. I just copied/pasted the code in evdev.c, but this can be easily changed.

>
>> +{
>> +       int len;
>> +
>> +       if (!str)
>> +               return -ENOENT;
>> +
>> +       len = strlen(str) + 1;
>> +       if (len > maxlen)
>> +               len = maxlen;
>> +
>> +       return copy_to_user(p, str, len) ? -EFAULT : len;
>
> I'd prefer a "strlcpy()" so we guarantee a terminating 0 for
> user-space, but I guess that'd be rather complex to do here. I
> couldn't find any strlcpy_to_user()...

Definitively, adding a terminating 0 seems a good idea to prevent
leaking of information from the kernel.

>
>> +}
>> +
>>  static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>>                                  unsigned long arg, void __user *p)
>>  {
>> @@ -676,6 +692,8 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>>         struct uinput_ff_erase  ff_erase;
>>         struct uinput_request   *req;
>>         char                    *phys;
>> +       const char              *path;
>> +       unsigned int            size;
>>
>>         retval = mutex_lock_interruptible(&udev->mutex);
>>         if (retval)
>> @@ -828,7 +846,24 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>>                         break;
>>
>>                 default:
>> -                       retval = -EINVAL;
>> +                       retval = -EAGAIN;
>> +       }
>> +
>> +       if (retval == -EAGAIN) {
>> +               size = _IOC_SIZE(cmd);
>> +
>> +               /* Now check variable-length commands */
>> +               switch (cmd & ~IOCSIZE_MASK) {
>> +                       case UI_GET_SYSPATH(0):
>> +                               path = kobject_get_path(&udev->dev->dev.kobj,
>> +                                                       GFP_KERNEL);
>
> I know, device registration is protected by udev->mutex but I'd still prefer:
>   if (udev->state != UIST_CREATED)
>     return -ENOENT;

oops. Definitively, this should be added.

>
> But that's probably a matter of taste.

I think it is a mistake not adding this. Without it (in the current
implementation), the user-space can call it before the device is
created, leading to some garbage (or even oopses) depending on how
kobject_get_path() handles the queries for non added devices.

Cheers,
Benjamin

>
>> +                               retval = uinput_str_to_user(path, size, p);
>> +                               kfree(path);
>> +                               break;
>> +
>> +                       default:
>> +                               retval = -EINVAL;
>> +               }
>>         }
>>
>>   out:
>> diff --git a/include/linux/uinput.h b/include/linux/uinput.h
>> index 6291a22..64fab81 100644
>> --- a/include/linux/uinput.h
>> +++ b/include/linux/uinput.h
>> @@ -22,6 +22,7 @@
>>   * Changes/Revisions:
>>   *     0.4     12/07/2013 (Peter Hutterer <peter.hutterer@redhat.com>)
>>   *             - update uinput_user_dev struct to allow abs resolution
>> + *             - add UI_GET_SYSPATH ioctl
>>   *     0.3     24/05/2006 (Anssi Hannula <anssi.hannulagmail.com>)
>>   *             - update ff support for the changes in kernel interface
>>   *             - add UINPUT_VERSION
>> diff --git a/include/uapi/linux/uinput.h b/include/uapi/linux/uinput.h
>> index f6a393b..d826409 100644
>> --- a/include/uapi/linux/uinput.h
>> +++ b/include/uapi/linux/uinput.h
>> @@ -22,6 +22,7 @@
>>   * Changes/Revisions:
>>   *     0.4     12/07/2013 (Peter Hutterer <peter.hutterer@redhat.com>)
>>   *             - update uinput_user_dev struct to allow abs resolution
>> + *             - add UI_GET_SYSPATH ioctl
>>   *     0.3     24/05/2006 (Anssi Hannula <anssi.hannulagmail.com>)
>>   *             - update ff support for the changes in kernel interface
>>   *             - add UINPUT_VERSION
>> @@ -75,6 +76,8 @@ struct uinput_ff_erase {
>>  #define UI_BEGIN_FF_ERASE      _IOWR(UINPUT_IOCTL_BASE, 202, struct uinput_ff_erase)
>>  #define UI_END_FF_ERASE                _IOW(UINPUT_IOCTL_BASE, 203, struct uinput_ff_erase)
>>
>> +#define UI_GET_SYSPATH(len)    _IOC(_IOC_READ, UINPUT_IOCTL_BASE, 300, len)
>> +
>>  /*
>>   * To write a force-feedback-capable driver, the upload_effect
>>   * and erase_effect callbacks in input_dev must be implemented.
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
