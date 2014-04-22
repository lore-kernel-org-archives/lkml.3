Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbaDVUpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:45:36 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:61998 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120AbaDVUo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:44:58 -0400
Date: Tue, 22 Apr 2014 16:44:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
Message-ID: <20140422204455.GB3615@mtj.dyndns.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 22, 2014 at 11:34:39AM +0800, Li Zhong wrote:
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

I'm confused about the overall locking scheme.  What's the role of
device_hotplug_lock?  Is that solely to prevent the sysfs deadlock
issue?  Or does it serve other synchronization purposes depending on
the specific subsystem?  If the former, the lock no longer needs to
exist.  The only thing necessary would be synchronization between
device_del() deleting the sysfs file and the unbreak helper invoking
device-specific callback.  If the latter, we probably should change
that.  Sharing hotplug lock across multiple subsystems through driver
core sounds like a pretty bad idea.

Thanks.

-- 
tejun
