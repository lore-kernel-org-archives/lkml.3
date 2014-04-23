Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaDWKmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:42:21 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52959 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751206AbaDWKmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:42:19 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for device online store callbacks
Date: Wed, 23 Apr 2014 12:58:40 +0200
Message-ID: <10378860.X4mJXjBVbJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398229422.2805.49.camel@ThinkPad-T5421.cn.ibm.com>
References: <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com> <20140422204455.GB3615@mtj.dyndns.org> <1398229422.2805.49.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 01:03:42 PM Li Zhong wrote:
> On Tue, 2014-04-22 at 16:44 -0400, Tejun Heo wrote:
> > Hello,
> > 
> > On Tue, Apr 22, 2014 at 11:34:39AM +0800, Li Zhong wrote:
> > > > Is this assumption true?  If so, can we add lockdep assertions in
> > > > places to verify and enforce this?  If not, aren't we just feeling
> > > > good when the reality is broken?
> > > 
> > > It seems not true ... I think there are devices that don't have the
> > > online/offline concept, we just need to add it, remove it, like ethernet
> > > cards. 
> > > 
> > > Maybe we could change the comments above, like:
> > > 	/* We assume device_hotplug_lock must be acquired before 
> > > 	 * removing devices, which have online/offline sysfs knob, 
> > > 	 * and some locks are needed to serialize the online/offline
> > > 	 * callbacks and device removing. ...
> > > ? 
> > > 
> > > And we could add lockdep assertions in cpu and memory related code? e.g.
> > > remove_memory(), unregister_cpu()
> > > 
> > > Currently, remove_memory() has comments for the function:
> > > 
> > >  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
> > >  * and online/offline operations before this call, as required by
> > >  * try_offline_node().
> > >  */
> > >     
> > > maybe it could be removed with the lockdep assertion.
> > 
> > I'm confused about the overall locking scheme.  What's the role of
> > device_hotplug_lock?  Is that solely to prevent the sysfs deadlock
> > issue?  Or does it serve other synchronization purposes depending on
> > the specific subsystem?  If the former, the lock no longer needs to
> > exist.  The only thing necessary would be synchronization between
> > device_del() deleting the sysfs file and the unbreak helper invoking
> > device-specific callback.  If the latter, we probably should change
> > that.  Sharing hotplug lock across multiple subsystems through driver
> > core sounds like a pretty bad idea.
> 
> I think it's the latter.

Actually, no, this is not the case if I understand you correctly.

> I think device_{on|off}line is better to be
> done in some sort of lock which prevents the device from being removed,
> including some preparation work that needs be done before device_del().

Quite frankly, you should be confident that you understand the code you're
trying to modify or please don't touch it.

I'll have a deeper look at this issue later today or tomorrow and will get
back to you then.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
