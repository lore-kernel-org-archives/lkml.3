Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaDQDGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:06:04 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:40205 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbaDQDGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:06:01 -0400
Message-ID: <1397703953.3415.26.camel@ThinkPad-T5421>
Subject: Re: [RFC PATCH v3] Use kernfs_break_active_protection() for device
 online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Thu, 17 Apr 2014 11:05:53 +0800
In-Reply-To: <20140416151749.GE1257@htj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140410133116.GB25308@htj.dyndns.org>
	 <1397189445.3649.14.camel@ThinkPad-T5421>
	 <20140411102649.GB26252@mtj.dyndns.org>
	 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140414201315.GD16835@htj.dyndns.org>
	 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140415145017.GK1863@htj.dyndns.org>
	 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041703-6892-0000-0000-0000087DFCAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 11:17 -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Apr 16, 2014 at 09:41:40AM +0800, Li Zhong wrote:
> > > If so, that is
> > > an actually possible deadlock, no?
> > 
> > Yes, but it seems to me that it is solved in commit 5e33bc41, which uses
> > lock_device_hotplug_sysfs() to return a restart syscall error if not
> > able to try lock the device_hotplug_lock. That also requires the device
> > removing code path to take the device_hotplug_lock. 
> 
> But that patch only takes out device_hotplug_lock out of the
> dependency graph and does nothing for cpu_add_remove_lock.  It seems
> to be that there still is a deadlock condition involving s_active and
> cpu_add_remove_lock.  Am I missing something here?

It seems to me cpu_add_remove_lock is always taken after
device_hotplug_lock.

So if cpu_add_remove_lock has been acquired by device removing process,
then it means the other online/offline process couldn't successfully try
lock device_hotplug_lock, and will release s_active with a restart
syscall error;

if cpu_add_remove_lock has been acquired by online/offline process, then
it should already hold device_hotlug_lock, and keeps the device removing
process waiting at device_hotplug_lock. So online/offline process could
release the lock, and finally release s_active soon. 

But after some further thinking, I seem to understand your point.
s_active has lock order problem with the other series of hotplug related
locks, so it's better to take s_active out of the dependency chain,
rather than the first of the other series of locks? like you suggested
below.

> 
> Now that kernfs has a proper mechanism to deal with it, wouldn't it
> make more sense to replace 5e33bc41 with prper s_active protection
> breaking?

I'll try this way and send you the code for review.

Thanks,
Zhong

> 
> Thanks.
> 


