Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaDXJAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:00:11 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:59659 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaDXJAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:00:06 -0400
Message-ID: <1398329996.2805.110.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, toshi.kani@hp.com
Date: Thu, 24 Apr 2014 16:59:56 +0800
In-Reply-To: <5357E651.2040400@intel.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042409-1948-0000-0000-00000890D6CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 18:12 +0200, Rafael J. Wysocki wrote:
> On 4/23/2014 4:23 PM, Tejun Heo wrote:
> > Hello, Rafael.
> 
> Hi,
> 
> > On Wed, Apr 23, 2014 at 12:21:33AM +0200, Rafael J. Wysocki wrote:
> >> Can you please elaborate a bit?
> > Because it can get involved in larger locking dependency issues by
> > joining dependency graphs of two otherwise largely disjoint
> > subsystems.  It has potential to create possible deadlocks which don't
> > need to exist.
> 
> Well, I do my best not to add unnecessary locks if that's what you mean.
> 
> >> It is there to protect hotplug operations involving multiple devices
> >> (in different subsystems) from racing with each other.  Why exactly
> >> is it bad?
> > But why would different subsystems, say cpu and memory, use the same
> > lock?  Wouldn't those subsystems already have proper locking inside
> > their own subsystems?
> 
> That locking is not sufficient.
> 
> > Why add this additional global lock across multiple subsystems?
> 
> That basically is because of how eject works when it is triggered via ACPI.
> 
> It is signaled for a device at the top of a subtree.  It may be a 
> container of some sort and the eject involves everything below that 
> device in the ACPI namespace.  That may involve multiple subsystem 
> (CPUs, memory, PCI host bridge, etc.).
> 
> We do that in two steps, offline (which can fail) and eject proper 
> (which can't fail and makes all of the involved devices go away). All 
> that has to be done in one go with respect to the sysfs-triggered 
> offline/online and that's why the lock is there.

Thank you for the education. It's more clear to me now why we need this
lock. 

I still have some small questions about when this lock is needed:

I could understand sysfs-triggered online is not acceptable when
removing devices in multiple subsystems. But maybe concurrent offline
and remove(with proper per subsystem locks) seems not harmful? 

And if we just want to remove some devices in a specific subsystem, e.g.
like writing /cpu/release, if it just wants to offline and remove some
cpus, then maybe we don't require the device_hotplug_lock to be taken? 

Thanks, Zhong
> 
> Thanks,
> Rafael
> 


