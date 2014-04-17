Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaDQPRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:17:41 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:62841 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDQPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:17:31 -0400
Date: Thu, 17 Apr 2014 11:17:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v4] Use kernfs_break_active_protection() for device
 online store callbacks
Message-ID: <20140417151728.GK15326@htj.dyndns.org>
References: <20140410133116.GB25308@htj.dyndns.org>
 <1397189445.3649.14.camel@ThinkPad-T5421>
 <20140411102649.GB26252@mtj.dyndns.org>
 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
 <20140414201315.GD16835@htj.dyndns.org>
 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
 <20140415145017.GK1863@htj.dyndns.org>
 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
 <20140416151749.GE1257@htj.dyndns.org>
 <1397717444.4034.15.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397717444.4034.15.camel@ThinkPad-T5421>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 17, 2014 at 02:50:44PM +0800, Li Zhong wrote:
> This patch tries to solve the device hot remove locking issues in a
> different way from commit 5e33bc41, as kernfs already has a mechanism 
> to break active protection. 
> 
> The problem here is the order of s_active, and series of hotplug related
> lock. 

It prolly deservse more detailed explanation of the deadlock along
with how 5e33bc41 ("$SUBJ") tried to solve it.  The active protetion
is there to keep the file alive by blocking deletion while operations
are on-going in the file.  This blocking creates a dependency loop
when an operation running off a sysfs knob ends up grabbing a lock
which may be held while removing the said sysfs knob.

> +	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
> +	if (WARN_ON_ONCE(!kn))
> +		return -ENODEV;
> +
> +	/*
> +	 * Break active protection here to avoid deadlocks with device
> +	 * removing process, which tries to remove sysfs entries including this
> +	 * "online" attribute while holding some hotplug related locks.
> +	 *
> +	 * @dev needs to be protected here, or it could go away any time after
> +	 * dropping active protection. But it is still unreasonable/unsafe to
> +	 * online/offline a device after it being removed. Fortunately, there

I think this is something driver layer proper should provide
synchronization for.  It shouldn't be difficult to synchronize this
function against device_del(), right?  And, please note that @dev is
guaranteed to have not been removed (at least hasn't gone through attr
removal) upto this point.

> +	 * are some checks in online/offline knobs. Like cpu, it checks cpu
> +	 * present/online mask before doing the real work.
> +	 */
> +
> +	get_device(dev);
> +	kernfs_break_active_protection(kn);
> +
> +	lock_device_hotplug();
> +
> +	/*
> +	 * If we assume device_hotplug_lock must be acquired before removing
> +	 * device, we may try to find a way to check whether the device has
> +	 * been removed here, so we don't call device_{on|off}line against
> +	 * removed device.
> +	 */

Yeah, let's please fix this.

>  	ret = val ? device_online(dev) : device_offline(dev);
>  	unlock_device_hotplug();
> +
> +	kernfs_unbreak_active_protection(kn);
> +	put_device(dev);
> +
> +	kernfs_put(kn);
> +
>  	return ret < 0 ? ret : count;
>  }
>  static DEVICE_ATTR_RW(online);
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index bece691..0d2f3a5 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -320,10 +320,17 @@ store_mem_state(struct device *dev,
>  {
>  	struct memory_block *mem = to_memory_block(dev);
>  	int ret, online_type;
> +	struct kernfs_node *kn;
>  
> -	ret = lock_device_hotplug_sysfs();
> -	if (ret)
> -		return ret;
> +	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
> +	if (WARN_ON_ONCE(!kn))
> +		return -ENODEV;
> +
> +	/* refer to comments in online_store() for more information */
> +	get_device(dev);
> +	kernfs_break_active_protection(kn);
> +
> +	lock_device_hotplug();
>  
>  	if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))
>  		online_type = ONLINE_KERNEL;
> @@ -362,6 +369,11 @@ store_mem_state(struct device *dev,
>  err:
>  	unlock_device_hotplug();
>  
> +	kernfs_unbreak_active_protection(kn);
> +	put_device(dev);
> +
> +	kernfs_put(kn);

There are other users of lock_device_hotplug_sysfs().  We probably
want to audit them and convert them too, preferably with helper
routines so that they don't end up duplicating the complexity?

Thanks.

-- 
tejun
