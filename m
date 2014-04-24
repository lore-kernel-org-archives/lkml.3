Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaDXBd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:33:29 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:59106 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaDXBdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:33:25 -0400
Message-ID: <1398303194.2805.64.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        toshi.kani@hp.com
Date: Thu, 24 Apr 2014 09:33:14 +0800
In-Reply-To: <10378860.X4mJXjBVbJ@vostro.rjw.lan>
References: <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140422204455.GB3615@mtj.dyndns.org>
	 <1398229422.2805.49.camel@ThinkPad-T5421.cn.ibm.com>
	 <10378860.X4mJXjBVbJ@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042401-6892-0000-0000-0000088EBB85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 12:58 +0200, Rafael J. Wysocki wrote:
> On Wednesday, April 23, 2014 01:03:42 PM Li Zhong wrote:
> > On Tue, 2014-04-22 at 16:44 -0400, Tejun Heo wrote:
> > > Hello,
> > > 
> > > On Tue, Apr 22, 2014 at 11:34:39AM +0800, Li Zhong wrote:
> > > > > Is this assumption true?  If so, can we add lockdep assertions in
> > > > > places to verify and enforce this?  If not, aren't we just feeling
> > > > > good when the reality is broken?
> > > > 
> > > > It seems not true ... I think there are devices that don't have the
> > > > online/offline concept, we just need to add it, remove it, like ethernet
> > > > cards. 
> > > > 
> > > > Maybe we could change the comments above, like:
> > > > 	/* We assume device_hotplug_lock must be acquired before 
> > > > 	 * removing devices, which have online/offline sysfs knob, 
> > > > 	 * and some locks are needed to serialize the online/offline
> > > > 	 * callbacks and device removing. ...
> > > > ? 
> > > > 
> > > > And we could add lockdep assertions in cpu and memory related code? e.g.
> > > > remove_memory(), unregister_cpu()
> > > > 
> > > > Currently, remove_memory() has comments for the function:
> > > > 
> > > >  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
> > > >  * and online/offline operations before this call, as required by
> > > >  * try_offline_node().
> > > >  */
> > > >     
> > > > maybe it could be removed with the lockdep assertion.
> > > 
> > > I'm confused about the overall locking scheme.  What's the role of
> > > device_hotplug_lock?  Is that solely to prevent the sysfs deadlock
> > > issue?  Or does it serve other synchronization purposes depending on
> > > the specific subsystem?  If the former, the lock no longer needs to
> > > exist.  The only thing necessary would be synchronization between
> > > device_del() deleting the sysfs file and the unbreak helper invoking
> > > device-specific callback.  If the latter, we probably should change
> > > that.  Sharing hotplug lock across multiple subsystems through driver
> > > core sounds like a pretty bad idea.
> > 
> > I think it's the latter.
> 
> Actually, no, this is not the case if I understand you correctly.

Oh, Sorry, I didn't read carefully. Yes, it's not specific subsystem.
After seeing your reply, I understand it is for protecting device hot
remove involving multiple subsystems.

> 
> > I think device_{on|off}line is better to be
> > done in some sort of lock which prevents the device from being removed,
> > including some preparation work that needs be done before device_del().
> 
> Quite frankly, you should be confident that you understand the code you're
> trying to modify or please don't touch it.
> 
> I'll have a deeper look at this issue later today or tomorrow and will get
> back to you then.

Ok, thank you, 
Zhong

> 
> Thanks!
> 


