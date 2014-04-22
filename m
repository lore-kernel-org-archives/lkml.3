Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbaDVWVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:21:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:15030 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776AbaDVWVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:21:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,906,1389772800"; 
   d="scan'208";a="497673156"
Message-ID: <5356EB6D.3010102@intel.com>
Date: Wed, 23 Apr 2014 00:21:33 +0200
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
References: <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com> <20140415145017.GK1863@htj.dyndns.org> <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com> <20140416151749.GE1257@htj.dyndns.org> <1397717444.4034.15.camel@ThinkPad-T5421> <20140417151728.GK15326@htj.dyndns.org> <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com> <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com> <20140421224606.GE22730@htj.dyndns.org> <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com> <20140422204455.GB3615@mtj.dyndns.org>
In-Reply-To: <20140422204455.GB3615@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/2014 10:44 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Apr 22, 2014 at 11:34:39AM +0800, Li Zhong wrote:
>>> Is this assumption true?  If so, can we add lockdep assertions in
>>> places to verify and enforce this?  If not, aren't we just feeling
>>> good when the reality is broken?
>> It seems not true ... I think there are devices that don't have the
>> online/offline concept, we just need to add it, remove it, like ethernet
>> cards.
>>
>> Maybe we could change the comments above, like:
>> 	/* We assume device_hotplug_lock must be acquired before
>> 	 * removing devices, which have online/offline sysfs knob,
>> 	 * and some locks are needed to serialize the online/offline
>> 	 * callbacks and device removing. ...
>> ?
>>
>> And we could add lockdep assertions in cpu and memory related code? e.g.
>> remove_memory(), unregister_cpu()
>>
>> Currently, remove_memory() has comments for the function:
>>
>>   * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
>>   * and online/offline operations before this call, as required by
>>   * try_offline_node().
>>   */
>>      
>> maybe it could be removed with the lockdep assertion.
> I'm confused about the overall locking scheme.  What's the role of
> device_hotplug_lock?  Is that solely to prevent the sysfs deadlock
> issue?  Or does it serve other synchronization purposes depending on
> the specific subsystem?  If the former, the lock no longer needs to
> exist.  The only thing necessary would be synchronization between
> device_del() deleting the sysfs file and the unbreak helper invoking
> device-specific callback.  If the latter, we probably should change
> that.  Sharing hotplug lock across multiple subsystems through driver
> core sounds like a pretty bad idea.

Can you please elaborate a bit?

It is there to protect hotplug operations involving multiple devices (in 
different subsystems) from racing with each other.  Why exactly is it bad?

Rafael

