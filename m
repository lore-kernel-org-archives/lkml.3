Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaDWFDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:03:52 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:54414 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaDWFDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:03:50 -0400
Message-ID: <1398229422.2805.49.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Wed, 23 Apr 2014 13:03:42 +0800
In-Reply-To: <20140422204455.GB3615@mtj.dyndns.org>
References: <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140415145017.GK1863@htj.dyndns.org>
	 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
	 <1397717444.4034.15.camel@ThinkPad-T5421>
	 <20140417151728.GK15326@htj.dyndns.org>
	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
	 <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140421224606.GE22730@htj.dyndns.org>
	 <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140422204455.GB3615@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042305-1948-0000-0000-0000088C9665
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 16:44 -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 22, 2014 at 11:34:39AM +0800, Li Zhong wrote:
> > > Is this assumption true?  If so, can we add lockdep assertions in
> > > places to verify and enforce this?  If not, aren't we just feeling
> > > good when the reality is broken?
> > 
> > It seems not true ... I think there are devices that don't have the
> > online/offline concept, we just need to add it, remove it, like ethernet
> > cards. 
> > 
> > Maybe we could change the comments above, like:
> > 	/* We assume device_hotplug_lock must be acquired before 
> > 	 * removing devices, which have online/offline sysfs knob, 
> > 	 * and some locks are needed to serialize the online/offline
> > 	 * callbacks and device removing. ...
> > ? 
> > 
> > And we could add lockdep assertions in cpu and memory related code? e.g.
> > remove_memory(), unregister_cpu()
> > 
> > Currently, remove_memory() has comments for the function:
> > 
> >  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
> >  * and online/offline operations before this call, as required by
> >  * try_offline_node().
> >  */
> >     
> > maybe it could be removed with the lockdep assertion.
> 
> I'm confused about the overall locking scheme.  What's the role of
> device_hotplug_lock?  Is that solely to prevent the sysfs deadlock
> issue?  Or does it serve other synchronization purposes depending on
> the specific subsystem?  If the former, the lock no longer needs to
> exist.  The only thing necessary would be synchronization between
> device_del() deleting the sysfs file and the unbreak helper invoking
> device-specific callback.  If the latter, we probably should change
> that.  Sharing hotplug lock across multiple subsystems through driver
> core sounds like a pretty bad idea.

I think it's the latter. I think device_{on|off}line is better to be
done in some sort of lock which prevents the device from being removed,
including some preparation work that needs be done before device_del().

Thanks, Zhong

> 
> Thanks.
> 


