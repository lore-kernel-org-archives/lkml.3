Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaDPBlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:41:51 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:39810 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaDPBlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:41:49 -0400
Message-ID: <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v3] Use kernfs_break_active_protection() for device
 online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Wed, 16 Apr 2014 09:41:40 +0800
In-Reply-To: <20140415145017.GK1863@htj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140410133116.GB25308@htj.dyndns.org>
	 <1397189445.3649.14.camel@ThinkPad-T5421>
	 <20140411102649.GB26252@mtj.dyndns.org>
	 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140414201315.GD16835@htj.dyndns.org>
	 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140415145017.GK1863@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041601-3548-0000-0000-000008C11A8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 10:50 -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 15, 2014 at 10:44:37AM +0800, Li Zhong wrote:
> > / *
> >   * This process might deadlock with another process trying to 
> >   * remove this device:
> >   * This process holding the s_active of "online" attribute, and tries 
> >   * to online/offline the device with some locks protecting hotplug.
> >   * Device removing process holding some locks protecting hotplug, and 
> >   * tries to remove the "online" attribute, waiting for the s_active to
> >   * be released. 
> >   *
> >   * The deadlock described above should be solved with
> >   * lock_device_hotplug_sysfs(). We temporarily drop the active 
> >   * protection here to avoid some lockdep warnings. 
> >   *
> >   * If device_hotplug_lock is forgotten to be used when removing
> >   * device(possibly some very simple device even don't need this lock?),
> >   * @dev could go away any time after dropping the active protection. 
> >   * So increase its ref count before dropping active protection. 
> >   * Though invoking device_{on|off}line() on a removed device seems
> >   * unreasonable, it should be less disastrous than playing with freed
> >   * @dev. Also, we might be able to have some mechanism abort 
> >   * device_{on|off}line() if @dev already removed.
> >   */
> 
> Hmmm... I'm not sure I fully understand the problem.  Does the code
> ever try to remove "online" while holding cpu_add_remove_lock and,
> when written 0, online knob grabs cpu_add_remove_lock?  

Yes.

In acpi_processor_remove(), cpu_maps_update_begin() is called to hold
cpu_add_remove_lock, and then arch_unregister_cpu calls
unregister_cpu(), which will try to remove dir cpu1 including "online".

while written 0 to online, cpu_down() will also try to grab
cpu_add_remove_lock with cpu_maps_update_begin().

> If so, that is
> an actually possible deadlock, no?

Yes, but it seems to me that it is solved in commit 5e33bc41, which uses
lock_device_hotplug_sysfs() to return a restart syscall error if not
able to try lock the device_hotplug_lock. That also requires the device
removing code path to take the device_hotplug_lock. 

Thanks, Zhong

> 
> Thanks.
> 


