Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422649Ab3AYKCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:02:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:46883 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030181Ab3AYKCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:02:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,537,1355068800"; 
   d="scan'208";a="6646321"
Message-ID: <5102583E.4030109@cn.fujitsu.com>
Date: Fri, 25 Jan 2013 18:02:38 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Lin Feng <linfeng@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, tangchen@cn.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, izumi.taku@jp.fujitsu.com,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH] pci-sysfs: replace mutex_lock with mutex_trylock to avoid
 potential deadlock situation
References: <1356594177-29453-1-git-send-email-linfeng@cn.fujitsu.com> <CAErSpo7EmvDaK11P6r-PKxPBqHQBPaGvZj=zvNZ8w=KFbdFgYA@mail.gmail.com>
In-Reply-To: <CAErSpo7EmvDaK11P6r-PKxPBqHQBPaGvZj=zvNZ8w=KFbdFgYA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/25 18:01:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/25 18:01:39,
	Serialize complete at 2013/01/25 18:01:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,
	Thanks for your review and comments! Please refer to inlined comments below.

On 01/25/2013 07:12 AM, Bjorn Helgaas wrote:

> On Thu, Dec 27, 2012 at 12:42 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
>> There is a potential deadlock situation when we manipulate the pci-sysfs user
>> interfaces from different bus hierarchy simultaneously, described as following:
>>
>> path1: sysfs remove device:             | path2: sysfs rescan device:
>> sysfs_schedule_callback_work()          | sysfs_write_file()
>>   remove_callback()                     |   flush_write_buffer()
>> *1* mutex_lock(&pci_remove_rescan_mutex)|*2*  sysfs_get_active(attr_sd)
>>       ...                               |     dev_attr_store()
>>         device_remove_file()            |       dev_rescan_store()
>>           ...                           |*4*      mutex_lock(&pci_remove_rescan_mutex)
>> *3*       sysfs_deactivate(sd)          |     ...
>>             wait_for_completion()       |*5*  sysfs_put_active(attr_sd)
>> *6* mutex_unlock(&pci_remove_rescan_mutex)
...snip...
>> Reported-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
>> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  drivers/pci/pci-sysfs.c |   42 ++++++++++++++++++++++++++----------------
>>  1 files changed, 26 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>> index 05b78b1..d2efbb0 100644
>> --- a/drivers/pci/pci-sysfs.c
>> +++ b/drivers/pci/pci-sysfs.c
>> @@ -295,10 +295,13 @@ static ssize_t bus_rescan_store(struct bus_type *bus,
const char *buf,
>>                 return -EINVAL;
>>
>>         if (val) {
>> -               mutex_lock(&pci_remove_rescan_mutex);
>> -               while ((b = pci_find_next_bus(b)) != NULL)
>> -                       pci_rescan_bus(b);
>> -               mutex_unlock(&pci_remove_rescan_mutex);
>> +               if (mutex_trylock(&pci_remove_rescan_mutex)) {
>> +                       while ((b = pci_find_next_bus(b)) != NULL)
>> +                               pci_rescan_bus(b);
>> +                       mutex_unlock(&pci_remove_rescan_mutex);
>> +               } else {
>> +                       return 0;
> What are the semantics of returning 0 from a sysfs store function?
> Does the user's write just get dropped?  I would think we'd return
> "count" for that case.

Oh, yes, return "count" seems suitable here, although we did not reach the
user's target goal(rescan the bus), but the user's write has been flushed yet.
But the user still can not judge whether pci_rescan_bus() was successfully done
only by the return value. Shall we return a suitable error here to tell the user
that his write was written, but pci_rescan_bus() was not done ?

> Is there some sort of automatic retry in libc
> or something if we return zero?

No, there is not any extra operations in libc if we return zero indeed.

> Are you relying on the user code to
> notice that nothing was written and do its own retry?
>

Yes, but it seems impractical.

> The last seems most likely, but that seems like it complicates the
> user's life unnecessarily.
>
>> +               }
>>         }
>>         return count;
>>  }
>> @@ -319,9 +322,12 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
>>                 return -EINVAL;
>>
>>         if (val) {
>> -               mutex_lock(&pci_remove_rescan_mutex);
>> -               pci_rescan_bus(pdev->bus);
>> -               mutex_unlock(&pci_remove_rescan_mutex);
>> +               if (mutex_trylock(&pci_remove_rescan_mutex)) {
>> +                       pci_rescan_bus(pdev->bus);
>> +                       mutex_unlock(&pci_remove_rescan_mutex);
>> +               } else {
>> +                       return 0;
>> +               }
>>         }
>>         return count;
>>  }
>> @@ -330,9 +336,10 @@ static void remove_callback(struct device *dev)
>>  {
>>         struct pci_dev *pdev = to_pci_dev(dev);
>>
>> -       mutex_lock(&pci_remove_rescan_mutex);
>> -       pci_stop_and_remove_bus_device(pdev);
>> -       mutex_unlock(&pci_remove_rescan_mutex);
>> +       if (mutex_trylock(&pci_remove_rescan_mutex)) {
>> +               pci_stop_and_remove_bus_device(pdev);
>> +               mutex_unlock(&pci_remove_rescan_mutex);
>> +       }
> In the other cases, I think the user will at least get some
> indication, e.g., a write() that returns zero, when we abort.  But
> here, we silently skip the pci_stop_and_remove_bus_device().  That
> sounds wrong to me.  What actually happens here, and why is it OK to
> skip it?

Yeah, the hasty skip seems not suitable. We should give out some information
here, if we can not do pci_stop_and_remove_bus_device().

> Can we avoid the deadlock by queuing these in a workqueue instead of
> using the mutex_trylock() approach?
>

No, I think use a workqueue to queue the rescan routine into workqueue as the
remove is not suitable. 
After we queue the scan-bus work into workqueue, the rescan routine can
return directly(case1) or wait until work is completed(case2).
case1:
If we return directly after we queue the scan-bus work into workqueue.
Maybe this work will be scheduled some time later. If there is a
user's routine want to use a new-added device before the scan-bus work is
successfully done will fail. It can avoid the deadlock, but the rescan routine
is executed asynchronously. 
case2:
If we wait until work is completed after we queue the scan-bus work into
workqueue. The s_active of the sys_dirent is still hold by us, so this approach
could not avoid the deadlock.
  

>>  }
>>
>>  static ssize_t
>> @@ -366,12 +373,15 @@ dev_bus_rescan_store(struct device *dev, struct
device_attribute *attr,
>>                 return -EINVAL;
>>
>>         if (val) {
>> -               mutex_lock(&pci_remove_rescan_mutex);
>> -               if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
>> -                       pci_rescan_bus_bridge_resize(bus->self);
>> -               else
>> -                       pci_rescan_bus(bus);
>> -               mutex_unlock(&pci_remove_rescan_mutex);
>> +               if (mutex_trylock(&pci_remove_rescan_mutex)) {
>> +                       if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
>> +                               pci_rescan_bus_bridge_resize(bus->self);
>> +                       else
>> +                               pci_rescan_bus(bus);
>> +                       mutex_unlock(&pci_remove_rescan_mutex);
>> +               } else {
>> +                       return 0;
>> +               }
>>         }
>>         return count;
>>  }
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
