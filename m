Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaD1Btd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:49:33 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:49303 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbaD1Bt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:49:26 -0400
Message-ID: <1398649757.3046.59.camel@ThinkPad-T5421>
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, toshi.kani@hp.com
Date: Mon, 28 Apr 2014 09:49:17 +0800
In-Reply-To: <535A594F.2010604@intel.com>
References: <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
	 <1397717444.4034.15.camel@ThinkPad-T5421>
	 <20140417151728.GK15326@htj.dyndns.org>
	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
	 <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140421224606.GE22730@htj.dyndns.org>
	 <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140422204455.GB3615@mtj.dyndns.org> <5356EB6D.3010102@intel.com>
	 <20140423142346.GB4781@htj.dyndns.org> <5357E651.2040400@intel.com>
	 <1398329996.2805.110.camel@ThinkPad-T5421.cn.ibm.com>
	 <5358E12C.2050800@intel.com>
	 <1398390415.2805.129.camel@ThinkPad-T5421.cn.ibm.com>
	 <535A594F.2010604@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042801-6892-0000-0000-00000897DBA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 14:47 +0200, Rafael J. Wysocki wrote:
> On 4/25/2014 3:46 AM, Li Zhong wrote:
> > On Thu, 2014-04-24 at 12:02 +0200, Rafael J. Wysocki wrote:
> >> On 4/24/2014 10:59 AM, Li Zhong wrote:
> >>> On Wed, 2014-04-23 at 18:12 +0200, Rafael J. Wysocki wrote:
> >>>> On 4/23/2014 4:23 PM, Tejun Heo wrote:
> >>>>> Hello, Rafael.
> >>>> Hi,
> >>>>
> >>>>> On Wed, Apr 23, 2014 at 12:21:33AM +0200, Rafael J. Wysocki wrote:
> >>>>>> Can you please elaborate a bit?
> >>>>> Because it can get involved in larger locking dependency issues by
> >>>>> joining dependency graphs of two otherwise largely disjoint
> >>>>> subsystems.  It has potential to create possible deadlocks which don't
> >>>>> need to exist.
> >>>> Well, I do my best not to add unnecessary locks if that's what you mean.
> >>>>
> >>>>>> It is there to protect hotplug operations involving multiple devices
> >>>>>> (in different subsystems) from racing with each other.  Why exactly
> >>>>>> is it bad?
> >>>>> But why would different subsystems, say cpu and memory, use the same
> >>>>> lock?  Wouldn't those subsystems already have proper locking inside
> >>>>> their own subsystems?
> >>>> That locking is not sufficient.
> >>>>
> >>>>> Why add this additional global lock across multiple subsystems?
> >>>> That basically is because of how eject works when it is triggered via ACPI.
> >>>>
> >>>> It is signaled for a device at the top of a subtree.  It may be a
> >>>> container of some sort and the eject involves everything below that
> >>>> device in the ACPI namespace.  That may involve multiple subsystem
> >>>> (CPUs, memory, PCI host bridge, etc.).
> >>>>
> >>>> We do that in two steps, offline (which can fail) and eject proper
> >>>> (which can't fail and makes all of the involved devices go away). All
> >>>> that has to be done in one go with respect to the sysfs-triggered
> >>>> offline/online and that's why the lock is there.
> >>> Thank you for the education. It's more clear to me now why we need this
> >>> lock.
> >>>
> >>> I still have some small questions about when this lock is needed:
> >>>
> >>> I could understand sysfs-triggered online is not acceptable when
> >>> removing devices in multiple subsystems. But maybe concurrent offline
> >>> and remove(with proper per subsystem locks) seems not harmful?
> >>>
> >>> And if we just want to remove some devices in a specific subsystem, e.g.
> >>> like writing /cpu/release, if it just wants to offline and remove some
> >>> cpus, then maybe we don't require the device_hotplug_lock to be taken?
> >> No and no.
> >>
> >> If the offline phase fails for any device in the subtree, we roll back
> >> the operation
> >> and online devices that have already been offlined by it.  Also the ACPI
> >> hot-addition
> >> needs to acquire device_hotplug_lock so that it doesn't race with ejects
> >> and so
> >> that lock needs to be taken by sysfs-triggered offline too.
> > I can understand that hot-addition needs the device_hotplug lock, but
> > still not very clear about the offline.
> >
> > I guess your are describing following scenario:
> >
> > user A: (trying remove cpu 1 and memory 1-10)
> >
> > lock_device_hotplug
> > offline cpu with cpu locks          -- successful
> > offline memories with memory locks  -- failed, e.g. for memory8
> > online cpu and memory with their locks
> > unlock_device_hotplug
> 
> What about if all is successful and CPU1 is gone before 
> device_hotplug_lock is released?

You mean user B will try to offline an already removed cpu1? But I think
the cpu subsys locks should be able to handle such situation?

> 
> > user B: (trying offline cpu 1)
> >
> > offline cpu with cpu locks
> >
> > But I don't see any problem for user B not taking the device_hotplug
> > lock. The result may be different for user B to take or not take the
> > lock. But I think it could be seen as concurrent online/offline for cpu1
> > under cpu hotplug locks, which just depends on which is executed last?
> >
> > Or did I miss something here?
> 
> Yes, you could do offline in parallel with user A without taking 
> device_hotplug_lock, but the result may be surprising to user B then.
> 
> With device _hotplug_lock user B will always see CPU1 off line (or gone) 
> after his offline in this scenario, while without taking the lock user B 
> may sometimes see CPU1 on line after his offline.  I don't think that's 
> a good thing.

That seems complicated after some more thinking. 

I think I missed something when describing the steps for A. I think the
initial online/offline state needs to be recorded by offline operations
in A, so the rollback could be done based on the initial state. 

If adding the above, then 
1) B offline cpu 1 before A offline cpu 1 
A could see the initial state of cpu1 as offline, and the rollback would
not put cpu1 online again. 

In the code, I think the check is done at 
        if (!cpu_online(cpu))
                return -EINVAL;
So the pn->put_online is kept as false. 

So the result is cpu1 offline.

2) B offline cpu 1 after A offline cpu1 
then the rollback would online cpu1 

2.1) B offline cpu1 after A rollback
The result is cpu1 offline, good.

2.2) B offline cpu1 before A rollback

B would see a -EINVAL error, and the result is cpu1 online. 

I guess this is the case you mentioned. 

I agree it is not a good thing, though B still gets some sort of errors
while do the offlining. 

I think now I get some better understandings of the lock, will try to
give an updated version of the patches some time later. 

Thanks, Zhong

> 
> Rafael
> 


