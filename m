Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3JaB2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:28:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6342 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab3JaB2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:28:15 -0400
X-IronPort-AV: E=Sophos;i="4.93,605,1378828800"; 
   d="scan'208";a="8905014"
Message-ID: <5271B0C6.6030104@cn.fujitsu.com>
Date: Thu, 31 Oct 2013 09:22:14 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci-sysfs: fix a potential deadlock when concurrent remove&rescan
 pci device via sysfs
References: <5270DB8B.6070600@cn.fujitsu.com> <20131030171949.GB25745@google.com>
In-Reply-To: <20131030171949.GB25745@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/31 09:26:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/31 09:26:31,
	Serialize complete at 2013/10/31 09:26:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 10/31/2013 01:19 AM, Bjorn Helgaas wrote:

> On Wed, Oct 30, 2013 at 06:12:27PM +0800, Gu Zheng wrote:
>> There is a potential deadlock situation when we manipulate pci device 
>> (remove&rescan) via the pci-sysfs user interfaces simultaneously. 
>>
>> Privious patch:
>> https://lkml.org/lkml/2012/12/27/10
>>
>> Related bug reports on bugzilla:
>> https://bugzilla.kernel.org/show_bug.cgi?id=60672
>> https://bugzilla.kernel.org/show_bug.cgi?id=60695
>>
>> deadlock info described as following:
<...>
>>
>> path1: sysfs remove device:             | path2: sysfs rescan device:
>> sysfs_schedule_callback_work()          | sysfs_write_file()
>>   remove_callback()                     |   flush_write_buffer()
>> *1* mutex_lock(&pci_remove_rescan_mutex)|*2*  sysfs_get_active(attr_sd)
>>       ...                               |     dev_attr_store()
>>         device_remove_file()            |       dev_rescan_store()
>>           ...                           |*4*  mutex_lock(&pci_remove_rescan_mutex)
>> *3*       sysfs_deactivate(sd)          |     ...
>>             wait_for_completion()       |*5*  sysfs_put_active(attr_sd)
>> *6* mutex_unlock(&pci_remove_rescan_mutex)
>>
>> If path1 first holds the pci_remove_rescan_mutex at *1*, then another path
>> called path2 actived and runs to *2* before path1 runs to *3*, we now runs
>> to a deadlock situation:
>> Path1 holds the mutex waiting path2 to decrease sysfs_dirent's s_active
>> counter at *5*, but path2 is blocked at *4* when trying to get the
>> pci_remove_rescan_mutex. The mutex won't be put by path1 until it reach
>> *6*, but it's now blocked at *3*.
>>
>> So we use mutex_try_lock to avoid this deadlock, and additional wait/restart_syscall
>> steps are used to make the fail path of try_lock more friendly to user space task.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  drivers/pci/pci-sysfs.c |   48 +++++++++++++++++++++++++++++++++++++++-------
>>  1 files changed, 40 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>> index 7128cfd..0dac6f4 100644
>> --- a/drivers/pci/pci-sysfs.c
>> +++ b/drivers/pci/pci-sysfs.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/vgaarb.h>
>>  #include <linux/pm_runtime.h>
>> +#include <linux/delay.h>
>>  #include "pci.h"
>>  
>>  static int sysfs_initialized;	/* = 0 */
>> @@ -285,6 +286,25 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
>>  }
>>  
>>  static DEFINE_MUTEX(pci_remove_rescan_mutex);
>> +
>> +static void pci_remove_rescan_lock(void)
>> +{
>> +	mutex_lock(&pci_remove_rescan_mutex);
>> +}
>> +
>> +static int pci_remove_rescan_lock_sysfs(void)
>> +{
>> +	if (mutex_trylock(&pci_remove_rescan_mutex))
>> +		return 0;
>> +	/* Avoid busy looping (20 ms of sleep should do). */
>> +	msleep(20);
>> +	return restart_syscall();
> 
> There are very few uses of restart_syscall().  I don't believe this
> situation is so unusual and special that we need to use it here.

What about queuing rescan routines into sysfs wrokqueue just like the
remove ones? I remember that your also mentioned this way in the previous
patch threads.

Regards,
Gu

> 
>> +}
>> +
>> +static void pci_remove_rescan_unlock(void)
>> +{
>> +	mutex_unlock(&pci_remove_rescan_mutex);
>> +}
>>  static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
>>  				size_t count)
>>  {
>> @@ -295,10 +315,14 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
>>  		return -EINVAL;
>>  
>>  	if (val) {
>> -		mutex_lock(&pci_remove_rescan_mutex);
>> +		int ret;
>> +
>> +		ret = pci_remove_rescan_lock_sysfs();
>> +		if (ret)
>> +			return ret;
>>  		while ((b = pci_find_next_bus(b)) != NULL)
>>  			pci_rescan_bus(b);
>> -		mutex_unlock(&pci_remove_rescan_mutex);
>> +		pci_remove_rescan_unlock();
>>  	}
>>  	return count;
>>  }
>> @@ -319,9 +343,13 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
>>  		return -EINVAL;
>>  
>>  	if (val) {
>> -		mutex_lock(&pci_remove_rescan_mutex);
>> +		int ret;
>> +
>> +		ret = pci_remove_rescan_lock_sysfs();
>> +		if (ret)
>> +			return ret;
>>  		pci_rescan_bus(pdev->bus);
>> -		mutex_unlock(&pci_remove_rescan_mutex);
>> +		pci_remove_rescan_unlock();
>>  	}
>>  	return count;
>>  }
>> @@ -332,9 +360,9 @@ static void remove_callback(struct device *dev)
>>  {
>>  	struct pci_dev *pdev = to_pci_dev(dev);
>>  
>> -	mutex_lock(&pci_remove_rescan_mutex);
>> +	pci_remove_rescan_lock();
>>  	pci_stop_and_remove_bus_device(pdev);
>> -	mutex_unlock(&pci_remove_rescan_mutex);
>> +	pci_remove_rescan_unlock();
>>  }
>>  
>>  static ssize_t
>> @@ -370,12 +398,16 @@ dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
>>  		return -EINVAL;
>>  
>>  	if (val) {
>> -		mutex_lock(&pci_remove_rescan_mutex);
>> +		int ret;
>> +
>> +		ret = pci_remove_rescan_lock_sysfs();
>> +		if (ret)
>> +			return ret;
>>  		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
>>  			pci_rescan_bus_bridge_resize(bus->self);
>>  		else
>>  			pci_rescan_bus(bus);
>> -		mutex_unlock(&pci_remove_rescan_mutex);
>> +		pci_remove_rescan_unlock();
>>  	}
>>  	return count;
>>  }
>> -- 
>> 1.7.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


