Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3H2CGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:06:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33890 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab3H2CGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:06:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,979,1367942400"; 
   d="scan'208";a="8338283"
Message-ID: <521EABAE.8020801@cn.fujitsu.com>
Date: Thu, 29 Aug 2013 10:02:22 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] driver core / ACPI: Avoid device hot remove locking
 issues
References: <1543475.L7gSB7lLAu@vostro.rjw.lan> <1592448.YZbpON5n7n@vostro.rjw.lan> <26495758.n1zOCiG3iV@vostro.rjw.lan> <1454842.9oJVGeLlzB@vostro.rjw.lan>
In-Reply-To: <1454842.9oJVGeLlzB@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/29 10:04:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/29 10:04:43,
	Serialize complete at 2013/08/29 10:04:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 09:48 PM, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> device_hotplug_lock is held around the acpi_bus_trim() call in
> acpi_scan_hot_remove() which generally removes devices (it removes
> ACPI device objects at least, but it may also remove "physical"
> device objects through .detach() callbacks of ACPI scan handlers).
> Thus, potentially, device sysfs attributes are removed under that
> lock and to remove those attributes it is necessary to hold the
> s_active references of their directory entries for writing.
> 
> On the other hand, the execution of a .show() or .store() callback
> from a sysfs attribute is carried out with that attribute's s_active
> reference held for reading.  Consequently, if any device sysfs
> attribute that may be removed from within acpi_scan_hot_remove()
> through acpi_bus_trim() has a .store() or .show() callback which
> acquires device_hotplug_lock, the execution of that callback may
> deadlock with the removal of the attribute.  [Unfortunately, the
> "online" device attribute of CPUs and memory blocks is one of them.]
> 
> To avoid such deadlocks, make all of the sysfs attribute callbacks
> that need to lock device hotplug, for example store_online(), use
> a special function, lock_device_hotplug_sysfs(), to lock device
> hotplug and return the result of that function immediately if it is
> not zero.  This will cause the s_active reference of the directory
> entry in question to be released and the syscall to be restarted
> if device_hotplug_lock cannot be acquired.
> 
> [show_online() actually doesn't need to lock device hotplug, but
> it is useful to serialize it with respect to device_offline() and
> device_online() for the same device (in case user space attempts to
> run them concurrently) which can be done with the help of
> device_lock().]
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>


Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
>  drivers/acpi/sysfs.c   |    5 ++++-
>  drivers/base/core.c    |   43 ++++++++++++++++++++++++++++---------------
>  drivers/base/memory.c  |    4 +++-
>  include/linux/device.h |    1 +
>  4 files changed, 36 insertions(+), 17 deletions(-)
> 
> Index: linux-pm/drivers/base/core.c
> ===================================================================
> --- linux-pm.orig/drivers/base/core.c
> +++ linux-pm/drivers/base/core.c
> @@ -49,6 +49,28 @@ static struct kobject *dev_kobj;
>  struct kobject *sysfs_dev_char_kobj;
>  struct kobject *sysfs_dev_block_kobj;
>  
> +static DEFINE_MUTEX(device_hotplug_lock);
> +
> +void lock_device_hotplug(void)
> +{
> +	mutex_lock(&device_hotplug_lock);
> +}
> +
> +void unlock_device_hotplug(void)
> +{
> +	mutex_unlock(&device_hotplug_lock);
> +}
> +
> +int lock_device_hotplug_sysfs(void)
> +{
> +	if (mutex_trylock(&device_hotplug_lock))
> +		return 0;
> +
> +	/* Avoid busy looping (5 ms of sleep should do). */
> +	msleep(5);
> +	return restart_syscall();
> +}
> +
>  #ifdef CONFIG_BLOCK
>  static inline int device_is_not_partition(struct device *dev)
>  {
> @@ -408,9 +430,9 @@ static ssize_t show_online(struct device
>  {
>  	bool val;
>  
> -	lock_device_hotplug();
> +	device_lock(dev);
>  	val = !dev->offline;
> -	unlock_device_hotplug();
> +	device_unlock(dev);
>  	return sprintf(buf, "%u\n", val);
>  }
>  
> @@ -424,7 +446,10 @@ static ssize_t store_online(struct devic
>  	if (ret < 0)
>  		return ret;
>  
> -	lock_device_hotplug();
> +	ret = lock_device_hotplug_sysfs();
> +	if (ret)
> +		return ret;
> +
>  	ret = val ? device_online(dev) : device_offline(dev);
>  	unlock_device_hotplug();
>  	return ret < 0 ? ret : count;
> @@ -1479,18 +1504,6 @@ EXPORT_SYMBOL_GPL(put_device);
>  EXPORT_SYMBOL_GPL(device_create_file);
>  EXPORT_SYMBOL_GPL(device_remove_file);
>  
> -static DEFINE_MUTEX(device_hotplug_lock);
> -
> -void lock_device_hotplug(void)
> -{
> -	mutex_lock(&device_hotplug_lock);
> -}
> -
> -void unlock_device_hotplug(void)
> -{
> -	mutex_unlock(&device_hotplug_lock);
> -}
> -
>  static int device_check_offline(struct device *dev, void *not_used)
>  {
>  	int ret;
> Index: linux-pm/drivers/base/memory.c
> ===================================================================
> --- linux-pm.orig/drivers/base/memory.c
> +++ linux-pm/drivers/base/memory.c
> @@ -351,7 +351,9 @@ store_mem_state(struct device *dev,
>  
>  	mem = container_of(dev, struct memory_block, dev);
>  
> -	lock_device_hotplug();
> +	ret = lock_device_hotplug_sysfs();
> +	if (ret)
> +		return ret;
>  
>  	if (!strncmp(buf, "online_kernel", min_t(int, count, 13))) {
>  		offline = false;
> Index: linux-pm/drivers/acpi/sysfs.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/sysfs.c
> +++ linux-pm/drivers/acpi/sysfs.c
> @@ -796,7 +796,10 @@ static ssize_t force_remove_store(struct
>  	if (ret < 0)
>  		return ret;
>  
> -	lock_device_hotplug();
> +	ret = lock_device_hotplug_sysfs();
> +	if (ret)
> +		return ret;
> +
>  	acpi_force_hot_remove = val;
>  	unlock_device_hotplug();
>  	return size;
> Index: linux-pm/include/linux/device.h
> ===================================================================
> --- linux-pm.orig/include/linux/device.h
> +++ linux-pm/include/linux/device.h
> @@ -895,6 +895,7 @@ static inline bool device_supports_offli
>  
>  extern void lock_device_hotplug(void);
>  extern void unlock_device_hotplug(void);
> +extern int lock_device_hotplug_sysfs(void);
>  extern int device_offline(struct device *dev);
>  extern int device_online(struct device *dev);
>  /*
> 
> 


