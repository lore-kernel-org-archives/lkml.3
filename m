Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3AYRum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:50:42 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:55762 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3AYRui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:50:38 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 12:50:38 EST
MIME-Version: 1.0
In-Reply-To: <5102583E.4030109@cn.fujitsu.com>
References: <1356594177-29453-1-git-send-email-linfeng@cn.fujitsu.com>
 <CAErSpo7EmvDaK11P6r-PKxPBqHQBPaGvZj=zvNZ8w=KFbdFgYA@mail.gmail.com> <5102583E.4030109@cn.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 25 Jan 2013 10:44:59 -0700
Message-ID: <CAErSpo58qUuwd+8bGMWQHQ6KrfQMvHGb+REVkpJqQdrfAQe3Qw@mail.gmail.com>
Subject: Re: [PATCH] pci-sysfs: replace mutex_lock with mutex_trylock to avoid
 potential deadlock situation
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, tangchen@cn.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, izumi.taku@jp.fujitsu.com,
        Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Yinghai]

On Fri, Jan 25, 2013 at 3:02 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> Hi Bjorn,
>         Thanks for your review and comments! Please refer to inlined comments below.
>
> On 01/25/2013 07:12 AM, Bjorn Helgaas wrote:
>
>> On Thu, Dec 27, 2012 at 12:42 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
>>> There is a potential deadlock situation when we manipulate the pci-sysfs user
>>> interfaces from different bus hierarchy simultaneously, described as following:
>>>
>>> path1: sysfs remove device:             | path2: sysfs rescan device:
>>> sysfs_schedule_callback_work()          | sysfs_write_file()
>>>   remove_callback()                     |   flush_write_buffer()
>>> *1* mutex_lock(&pci_remove_rescan_mutex)|*2*  sysfs_get_active(attr_sd)
>>>       ...                               |     dev_attr_store()
>>>         device_remove_file()            |       dev_rescan_store()
>>>           ...                           |*4*      mutex_lock(&pci_remove_rescan_mutex)
>>> *3*       sysfs_deactivate(sd)          |     ...
>>>             wait_for_completion()       |*5*  sysfs_put_active(attr_sd)
>>> *6* mutex_unlock(&pci_remove_rescan_mutex)
> ...snip...
>>> Reported-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
>>> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
>>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>>> ---
>>>  drivers/pci/pci-sysfs.c |   42 ++++++++++++++++++++++++++----------------
>>>  1 files changed, 26 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>>> index 05b78b1..d2efbb0 100644
>>> --- a/drivers/pci/pci-sysfs.c
>>> +++ b/drivers/pci/pci-sysfs.c
>>> @@ -295,10 +295,13 @@ static ssize_t bus_rescan_store(struct bus_type *bus,
> const char *buf,
>>>                 return -EINVAL;
>>>
>>>         if (val) {
>>> -               mutex_lock(&pci_remove_rescan_mutex);
>>> -               while ((b = pci_find_next_bus(b)) != NULL)
>>> -                       pci_rescan_bus(b);
>>> -               mutex_unlock(&pci_remove_rescan_mutex);
>>> +               if (mutex_trylock(&pci_remove_rescan_mutex)) {
>>> +                       while ((b = pci_find_next_bus(b)) != NULL)
>>> +                               pci_rescan_bus(b);
>>> +                       mutex_unlock(&pci_remove_rescan_mutex);
>>> +               } else {
>>> +                       return 0;
>> What are the semantics of returning 0 from a sysfs store function?
>> Does the user's write just get dropped?  I would think we'd return
>> "count" for that case.
>
> Oh, yes, return "count" seems suitable here, although we did not reach the
> user's target goal(rescan the bus), but the user's write has been flushed yet.
> But the user still can not judge whether pci_rescan_bus() was successfully done
> only by the return value. Shall we return a suitable error here to tell the user
> that his write was written, but pci_rescan_bus() was not done ?
>
>> Is there some sort of automatic retry in libc
>> or something if we return zero?
>
> No, there is not any extra operations in libc if we return zero indeed.
>
>> Are you relying on the user code to
>> notice that nothing was written and do its own retry?
>>
>
> Yes, but it seems impractical.
>
>> The last seems most likely, but that seems like it complicates the
>> user's life unnecessarily.
>>
>>> +               }
>>>         }
>>>         return count;
>>>  }
>>> @@ -319,9 +322,12 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
>>>                 return -EINVAL;
>>>
>>>         if (val) {
>>> -               mutex_lock(&pci_remove_rescan_mutex);
>>> -               pci_rescan_bus(pdev->bus);
>>> -               mutex_unlock(&pci_remove_rescan_mutex);
>>> +               if (mutex_trylock(&pci_remove_rescan_mutex)) {
>>> +                       pci_rescan_bus(pdev->bus);
>>> +                       mutex_unlock(&pci_remove_rescan_mutex);
>>> +               } else {
>>> +                       return 0;
>>> +               }
>>>         }
>>>         return count;
>>>  }
>>> @@ -330,9 +336,10 @@ static void remove_callback(struct device *dev)
>>>  {
>>>         struct pci_dev *pdev = to_pci_dev(dev);
>>>
>>> -       mutex_lock(&pci_remove_rescan_mutex);
>>> -       pci_stop_and_remove_bus_device(pdev);
>>> -       mutex_unlock(&pci_remove_rescan_mutex);
>>> +       if (mutex_trylock(&pci_remove_rescan_mutex)) {
>>> +               pci_stop_and_remove_bus_device(pdev);
>>> +               mutex_unlock(&pci_remove_rescan_mutex);
>>> +       }
>> In the other cases, I think the user will at least get some
>> indication, e.g., a write() that returns zero, when we abort.  But
>> here, we silently skip the pci_stop_and_remove_bus_device().  That
>> sounds wrong to me.  What actually happens here, and why is it OK to
>> skip it?
>
> Yeah, the hasty skip seems not suitable. We should give out some information
> here, if we can not do pci_stop_and_remove_bus_device().
>
>> Can we avoid the deadlock by queuing these in a workqueue instead of
>> using the mutex_trylock() approach?
>>
>
> No, I think use a workqueue to queue the rescan routine into workqueue as the
> remove is not suitable.
> After we queue the scan-bus work into workqueue, the rescan routine can
> return directly(case1) or wait until work is completed(case2).
> case1:
> If we return directly after we queue the scan-bus work into workqueue.
> Maybe this work will be scheduled some time later. If there is a
> user's routine want to use a new-added device before the scan-bus work is
> successfully done will fail. It can avoid the deadlock, but the rescan routine
> is executed asynchronously.
> case2:
> If we wait until work is completed after we queue the scan-bus work into
> workqueue. The s_active of the sys_dirent is still hold by us, so this approach
> could not avoid the deadlock.

I don't think the asynchronous nature of case 1 is a fatal problem.
I'm not sure we can guarantee that a specific device is added and
ready for use when the sysfs write completes, so I'm dubious about
user space making assumptions about a device being ready.  It should
probably use a different mechanism, like udev, to learn about a new
device.

I'm sorry that you tripped over this deadlock, because now I'm worried
about related locking issues outside sysfs :)  The mutex you're
fiddling with is only in sysfs, but the routines *protected* by that
mutex are used in other places, too.  So what happens when a hotplug
driver does a rescan at the same time a user does a rescan or remove
via sysfs?  I don't even know what the rules are for protecting
scan/remove, but I don't have confidence that the issue you're fixing
is the only one.

Bjorn

>>>  }
>>>
>>>  static ssize_t
>>> @@ -366,12 +373,15 @@ dev_bus_rescan_store(struct device *dev, struct
> device_attribute *attr,
>>>                 return -EINVAL;
>>>
>>>         if (val) {
>>> -               mutex_lock(&pci_remove_rescan_mutex);
>>> -               if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
>>> -                       pci_rescan_bus_bridge_resize(bus->self);
>>> -               else
>>> -                       pci_rescan_bus(bus);
>>> -               mutex_unlock(&pci_remove_rescan_mutex);
>>> +               if (mutex_trylock(&pci_remove_rescan_mutex)) {
>>> +                       if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
>>> +                               pci_rescan_bus_bridge_resize(bus->self);
>>> +                       else
>>> +                               pci_rescan_bus(bus);
>>> +                       mutex_unlock(&pci_remove_rescan_mutex);
>>> +               } else {
>>> +                       return 0;
>>> +               }
>>>         }
>>>         return count;
>>>  }
>>> --
>>> 1.7.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
