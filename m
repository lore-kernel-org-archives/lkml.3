Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbbASSUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:20:22 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:58052 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbbASSUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:20:21 -0500
MIME-Version: 1.0
In-Reply-To: <20150114204635.GD31119@kroah.com>
References: <1421259054-2574-1-git-send-email-a.sangwan@samsung.com>
	<20150114204635.GD31119@kroah.com>
Date: Mon, 19 Jan 2015 23:50:19 +0530
Message-ID: <CAOiN93m74ZqAHdZgsRBNzGJu_zmvmehridhVsiE1eKBZw6aqfg@mail.gmail.com>
Subject: Re: [PATCH] driver core: access dev->driver under dev->mutex in dev_uevent
From: Ashish Sangwan <ashishsangwan2@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 2:16 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 14, 2015 at 11:40:54PM +0530, ashishsangwan2@gmail.com wrote:
>> From: Ashish Sangwan <a.sangwan@samsung.com>
>>
>> We have hit a race condition while parallely accessing device's uevent
>> and rmmoding device's driver.
>
> How are you doing that?  By reading the uevent file and removing the
> device?
uevent file /sys/<device>/uevent is read by udevd while at the same
time driver is removed by rmmod.
>
> Removing a kernel module is not a "normal" thing at all, so this type of
> "error" is very low on anyone's list.
Ours is an embedded device with not much memory and driver occupies a
considerable amount of it. So when the device is not in use, its driver is
removed. Device is a platform device and attached at the boot time.
I understand if the patch is low priority for mainline kernel,
so just want to get views regarding any side effects that can
be caused by this patch as we plan to use this patch in our product.
We have hit this race quite a few times.
>
>> In dev_uevent() first dev->driver is checked if
>> present which becomes true but before calling add_uevent_var
>> dev->driver is set to NULL and driver is freed in __device_release_driver().
>> This results in either NULL pointer derefrence or invalid virtual address
>> access. Fix this race by accessing dev->driver under dev->mutex.
>>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> ---
>>  drivers/base/core.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 97e2baf..f8e854a 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -326,8 +326,15 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
>>       if (dev->type && dev->type->name)
>>               add_uevent_var(env, "DEVTYPE=%s", dev->type->name);
>>
>> +     /*
>> +      * dev->driver is set NULL under dev->mutex so it should be checked
>> +      * after acquiring dev->mutex. This prevents a race between
>> +      * __device_release_driver and dev_uevent.
>> +      */
>> +     device_lock(dev);
>>       if (dev->driver)
>>               add_uevent_var(env, "DRIVER=%s", dev->driver->name);
>> +     device_unlock(dev);
>
> Always run your patches through checkpatch before sending them out so
> you don't get grumpy email responses about how you need to run patches
> through checkpatch before sending them out...
Sure, will do that from next time.

Thanks,
Ashish
>
> thanks,
>
> greg k-h
