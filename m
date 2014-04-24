Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaDXKC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:02:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:13683 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaDXKCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:02:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,917,1389772800"; 
   d="scan'208";a="518722300"
Message-ID: <5358E12C.2050800@intel.com>
Date: Thu, 24 Apr 2014 12:02:20 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for device
 online store callbacks
References: <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>	 <20140416151749.GE1257@htj.dyndns.org>	 <1397717444.4034.15.camel@ThinkPad-T5421>	 <20140417151728.GK15326@htj.dyndns.org>	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>	 <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com>	 <20140421224606.GE22730@htj.dyndns.org>	 <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>	 <20140422204455.GB3615@mtj.dyndns.org> <5356EB6D.3010102@intel.com>	 <20140423142346.GB4781@htj.dyndns.org> <5357E651.2040400@intel.com> <1398329996.2805.110.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1398329996.2805.110.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2014 10:59 AM, Li Zhong wrote:
> On Wed, 2014-04-23 at 18:12 +0200, Rafael J. Wysocki wrote:
>> On 4/23/2014 4:23 PM, Tejun Heo wrote:
>>> Hello, Rafael.
>> Hi,
>>
>>> On Wed, Apr 23, 2014 at 12:21:33AM +0200, Rafael J. Wysocki wrote:
>>>> Can you please elaborate a bit?
>>> Because it can get involved in larger locking dependency issues by
>>> joining dependency graphs of two otherwise largely disjoint
>>> subsystems.  It has potential to create possible deadlocks which don't
>>> need to exist.
>> Well, I do my best not to add unnecessary locks if that's what you mean.
>>
>>>> It is there to protect hotplug operations involving multiple devices
>>>> (in different subsystems) from racing with each other.  Why exactly
>>>> is it bad?
>>> But why would different subsystems, say cpu and memory, use the same
>>> lock?  Wouldn't those subsystems already have proper locking inside
>>> their own subsystems?
>> That locking is not sufficient.
>>
>>> Why add this additional global lock across multiple subsystems?
>> That basically is because of how eject works when it is triggered via ACPI.
>>
>> It is signaled for a device at the top of a subtree.  It may be a
>> container of some sort and the eject involves everything below that
>> device in the ACPI namespace.  That may involve multiple subsystem
>> (CPUs, memory, PCI host bridge, etc.).
>>
>> We do that in two steps, offline (which can fail) and eject proper
>> (which can't fail and makes all of the involved devices go away). All
>> that has to be done in one go with respect to the sysfs-triggered
>> offline/online and that's why the lock is there.
> Thank you for the education. It's more clear to me now why we need this
> lock.
>
> I still have some small questions about when this lock is needed:
>
> I could understand sysfs-triggered online is not acceptable when
> removing devices in multiple subsystems. But maybe concurrent offline
> and remove(with proper per subsystem locks) seems not harmful?
>
> And if we just want to remove some devices in a specific subsystem, e.g.
> like writing /cpu/release, if it just wants to offline and remove some
> cpus, then maybe we don't require the device_hotplug_lock to be taken?

No and no.

If the offline phase fails for any device in the subtree, we roll back 
the operation
and online devices that have already been offlined by it.  Also the ACPI 
hot-addition
needs to acquire device_hotplug_lock so that it doesn't race with ejects 
and so
that lock needs to be taken by sysfs-triggered offline too.

Thanks,
Rafael

