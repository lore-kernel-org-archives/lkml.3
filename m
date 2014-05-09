Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaEIIfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:35:19 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:60296 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaEIIfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:35:16 -0400
Message-ID: <1399624508.2630.11.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Fri, 09 May 2014 16:35:08 +0800
In-Reply-To: <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>
References: <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140414201315.GD16835@htj.dyndns.org>
	 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140415145017.GK1863@htj.dyndns.org>
	 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
	 <1397717444.4034.15.camel@ThinkPad-T5421>
	 <20140417151728.GK15326@htj.dyndns.org>
	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
	 <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140421224606.GE22730@htj.dyndns.org>
	 <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050908-1948-0000-0000-000008B9C592
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viOn Tue, 2014-04-22 at 11:34 +0800, Li Zhong wrote:
> On Mon, 2014-04-21 at 18:46 -0400, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Apr 21, 2014 at 05:23:50PM +0800, Li Zhong wrote:
> > 
> > Proper /** function comment would be nice.
> 
> Ok, will try to write some in next version.
> 
> > 
> > > +struct kernfs_node *lock_device_hotplug_sysfs(struct device *dev,
> > > +					       struct device_attribute *attr)
> > 
> > I can see why you did this but let's please not require the user of
> > this function to see how the thing is working internally.  Let's
> > return int and keep track of (or look up again) the kernfs_node
> > internally.
> 
> Ok, it also makes the prototype of lock and unlock look more consistent
> and comfortable. 

When trying to do an new version of the patch, I find that if the device
is really removed, then we couldn't look up using the parent, and
attribute name again in unlock. So I guess maybe I could add one more
argument, e.g. kn_out,:q to track this kernfs node. 

Code will be posted soon for your review. 

Thanks, Zhong

> 
> > 
> > >  {
> > ...
> > > +	/*
> > > +	 * We assume device_hotplug_lock must be acquired before removing
> > 
> > Is this assumption true?  If so, can we add lockdep assertions in
> > places to verify and enforce this?  If not, aren't we just feeling
> > good when the reality is broken?
> 
> It seems not true ... I think there are devices that don't have the
> online/offline concept, we just need to add it, remove it, like ethernet
> cards. 
> 
> Maybe we could change the comments above, like:
> 	/* We assume device_hotplug_lock must be acquired before 
> 	 * removing devices, which have online/offline sysfs knob, 
> 	 * and some locks are needed to serialize the online/offline
> 	 * callbacks and device removing. ...
> ? 
> 
> And we could add lockdep assertions in cpu and memory related code? e.g.
> remove_memory(), unregister_cpu()
> 
> Currently, remove_memory() has comments for the function:
> 
>  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
>  * and online/offline operations before this call, as required by
>  * try_offline_node().
>  */
>     
> maybe it could be removed with the lockdep assertion.
> 
> > ...
> > 
> > Function comment please.
> 
> OK. 
> 
> Thanks, Zhong
> 
> > > +void unlock_device_hotplug_sysfs(struct device *dev,
> > > +				 struct kernfs_node *kn)
> > > +{
> > > +	unlock_device_hotplug();
> > > +	kernfs_unbreak_active_protection(kn);
> > > +	put_device(dev);
> > > +	kernfs_put(kn);
> > >  }
> > 
> > Thanks.
> > 
> 


