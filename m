Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaDVJzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:55:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59156 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753429AbaDVJze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:55:34 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for device online store callbacks
Date: Tue, 22 Apr 2014 12:11:53 +0200
Message-ID: <24546121.zVbmBfcmRG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>
References: <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com> <20140421224606.GE22730@htj.dyndns.org> <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2014 11:34:39 AM Li Zhong wrote:
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

Well, I haven't been following this closely (I was travelling, sorry), but
there certainly are devices without online/offline.  That currently is only
present for CPUs, memory blocks and ACPI containers (if I remember correctly).

> 
> Maybe we could change the comments above, like:
> 	/* We assume device_hotplug_lock must be acquired before 
> 	 * removing devices, which have online/offline sysfs knob, 
> 	 * and some locks are needed to serialize the online/offline
> 	 * callbacks and device removing. ...
> ? 

Lockdep assertions would be better than this in my opinion.

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

No, please don't remove it.  It is there to explain where the locking requirement
comes from.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
