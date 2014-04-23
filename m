Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaDWQMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:12:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:56087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbaDWQMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,912,1389772800"; 
   d="scan'208";a="498157545"
Message-ID: <5357E651.2040400@intel.com>
Date: Wed, 23 Apr 2014 18:12:01 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for device
 online store callbacks
References: <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com> <20140416151749.GE1257@htj.dyndns.org> <1397717444.4034.15.camel@ThinkPad-T5421> <20140417151728.GK15326@htj.dyndns.org> <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com> <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com> <20140421224606.GE22730@htj.dyndns.org> <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com> <20140422204455.GB3615@mtj.dyndns.org> <5356EB6D.3010102@intel.com> <20140423142346.GB4781@htj.dyndns.org>
In-Reply-To: <20140423142346.GB4781@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/2014 4:23 PM, Tejun Heo wrote:
> Hello, Rafael.

Hi,

> On Wed, Apr 23, 2014 at 12:21:33AM +0200, Rafael J. Wysocki wrote:
>> Can you please elaborate a bit?
> Because it can get involved in larger locking dependency issues by
> joining dependency graphs of two otherwise largely disjoint
> subsystems.  It has potential to create possible deadlocks which don't
> need to exist.

Well, I do my best not to add unnecessary locks if that's what you mean.

>> It is there to protect hotplug operations involving multiple devices
>> (in different subsystems) from racing with each other.  Why exactly
>> is it bad?
> But why would different subsystems, say cpu and memory, use the same
> lock?  Wouldn't those subsystems already have proper locking inside
> their own subsystems?

That locking is not sufficient.

> Why add this additional global lock across multiple subsystems?

That basically is because of how eject works when it is triggered via ACPI.

It is signaled for a device at the top of a subtree.  It may be a 
container of some sort and the eject involves everything below that 
device in the ACPI namespace.  That may involve multiple subsystem 
(CPUs, memory, PCI host bridge, etc.).

We do that in two steps, offline (which can fail) and eject proper 
(which can't fail and makes all of the involved devices go away). All 
that has to be done in one go with respect to the sysfs-triggered 
offline/online and that's why the lock is there.

Thanks,
Rafael

