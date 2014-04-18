Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaDRIeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:34:24 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:45375 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaDRId6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:33:58 -0400
Message-ID: <1397810029.3142.15.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v4] Use kernfs_break_active_protection() for device
 online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Fri, 18 Apr 2014 16:33:49 +0800
In-Reply-To: <20140417151728.GK15326@htj.dyndns.org>
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
	 <20140417151728.GK15326@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041808-3548-0000-0000-000008C9E0E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-17 at 11:17 -0400, Tejun Heo wrote:
> Hello,
> 
> On Thu, Apr 17, 2014 at 02:50:44PM +0800, Li Zhong wrote:
> > This patch tries to solve the device hot remove locking issues in a
> > different way from commit 5e33bc41, as kernfs already has a mechanism 
> > to break active protection. 
> > 
> > The problem here is the order of s_active, and series of hotplug related
> > lock. 
> 
> It prolly deservse more detailed explanation of the deadlock along
> with how 5e33bc41 ("$SUBJ") tried to solve it.  The active protetion
> is there to keep the file alive by blocking deletion while operations
> are on-going in the file.  This blocking creates a dependency loop
> when an operation running off a sysfs knob ends up grabbing a lock
> which may be held while removing the said sysfs knob.

OK, I'll try to add these and something more in next version.

> 
> > +	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
> > +	if (WARN_ON_ONCE(!kn))
> > +		return -ENODEV;
> > +
> > +	/*
> > +	 * Break active protection here to avoid deadlocks with device
> > +	 * removing process, which tries to remove sysfs entries including this
> > +	 * "online" attribute while holding some hotplug related locks.
> > +	 *
> > +	 * @dev needs to be protected here, or it could go away any time after
> > +	 * dropping active protection. But it is still unreasonable/unsafe to
> > +	 * online/offline a device after it being removed. Fortunately, there
> 
> I think this is something driver layer proper should provide
> synchronization for.  It shouldn't be difficult to synchronize this
> function against device_del(), right?  And, please note that @dev is
> guaranteed to have not been removed (at least hasn't gone through attr
> removal) upto this point.

Ok, I think what we need here is the check below, after getting
device_hotplug_lock, and abort this function if device already removed.
We should allow device_del() to remove the device in the other process,
which is why we are breaking the active protection. 

> 
> > +	 * are some checks in online/offline knobs. Like cpu, it checks cpu
> > +	 * present/online mask before doing the real work.
> > +	 */
> > +
> > +	get_device(dev);
> > +	kernfs_break_active_protection(kn);
> > +
> > +	lock_device_hotplug();
> > +
> > +	/*
> > +	 * If we assume device_hotplug_lock must be acquired before removing
> > +	 * device, we may try to find a way to check whether the device has
> > +	 * been removed here, so we don't call device_{on|off}line against
> > +	 * removed device.
> > +	 */
> 
> Yeah, let's please fix this.

OK, I guess we can check whether dev->kobj.sd becomes NULL. If so, it
means the device has already been deleted by device_del().

> 
> >  	ret = val ? device_online(dev) : device_offline(dev);
> >  	unlock_device_hotplug();
> > +
> > +	kernfs_unbreak_active_protection(kn);
> > +	put_device(dev);
> > +
> > +	kernfs_put(kn);
> > +
> >  	return ret < 0 ? ret : count;
> >  }
> >  static DEVICE_ATTR_RW(online);
> > diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> > index bece691..0d2f3a5 100644
> > --- a/drivers/base/memory.c
> > +++ b/drivers/base/memory.c
> > @@ -320,10 +320,17 @@ store_mem_state(struct device *dev,
> >  {
> >  	struct memory_block *mem = to_memory_block(dev);
> >  	int ret, online_type;
> > +	struct kernfs_node *kn;
> >  
> > -	ret = lock_device_hotplug_sysfs();
> > -	if (ret)
> > -		return ret;
> > +	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
> > +	if (WARN_ON_ONCE(!kn))
> > +		return -ENODEV;
> > +
> > +	/* refer to comments in online_store() for more information */
> > +	get_device(dev);
> > +	kernfs_break_active_protection(kn);
> > +
> > +	lock_device_hotplug();
> >  
> >  	if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))
> >  		online_type = ONLINE_KERNEL;
> > @@ -362,6 +369,11 @@ store_mem_state(struct device *dev,
> >  err:
> >  	unlock_device_hotplug();
> >  
> > +	kernfs_unbreak_active_protection(kn);
> > +	put_device(dev);
> > +
> > +	kernfs_put(kn);
> 
> There are other users of lock_device_hotplug_sysfs().  We probably
> want to audit them and convert them too, preferably with helper
> routines so that they don't end up duplicating the complexity?

I see, I guess I could keep lock_device_hotplug_sysfs(), just replace it
with the implementation here; and provide a new
unlock_device_hotplug_sysfs(), which will do the unlock, unbreak, and
puts. 

I'll try to get the code ready sometime next week for your review.

Thanks, Zhong

> 
> Thanks.
> 


