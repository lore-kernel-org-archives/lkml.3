Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaJQMOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:14:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaJQMOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:14:20 -0400
Message-ID: <5441080F.1070900@redhat.com>
Date: Fri, 17 Oct 2014 08:14:07 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>
Subject: Re: Locking issues with cpufreq and sysfs
References: <543BCF9A.1060603@redhat.com> <CAKohpokBpQ9zhSU3bJQ9pVv68s6cFg8TNsqi+sJK8V1OQUTWzA@mail.gmail.com> <543D6A5C.1060809@redhat.com> <CAKohponYvbpaphKCHoPH=6jDCpWop_BH_DKq6HwOx0SEe39sqw@mail.gmail.com>
In-Reply-To: <CAKohponYvbpaphKCHoPH=6jDCpWop_BH_DKq6HwOx0SEe39sqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/16/2014 07:23 AM, Viresh Kumar wrote:
> On 14 October 2014 23:54, Prarit Bhargava <prarit@redhat.com> wrote:
>> Here's what I think we should do.  Taking a step back, the purpose of the
>> cpufreq sysfs files is to allow userspace to read current cpu frequency
>> settings, and to allow userspce to modify the governor and set the max & min
>> ranges for cpu frequencies.  This can be done per device or for all cpus
>> depending on the driver.
> 
> Okay.
> 
>> We have to guarantee that bothing reading and writing will always work and that
>> write operations will always be atomic relative to userspace.  The current
> 
> Ok.
> 
>> implementation of cpufreq does this through the following locks:
>>
>> cpufreq_driver_lock: protects the cpufreq_cpu_data array and cpufreq_driver->boost
>> cpufreq_governor_lock: protects the current governor
> 
> Its just for serialization..
> 
>> cpufreq_governor_mutex: protects the cpufreq_governor_list
>> cpufreq_rwsem: protects the driver from being unloaded
>> global_kobj_lock: protects the "cpufreq" kobject
>> each policy has a rwsem (policy->rwsem): protects the cpufreq_policy struct
>> each policy has a transition_lock (policy->transition): synchronizes
>>                                                         frequency transitions
>>
>> While examining this code I was wondering exactly why we allow multiple readers
>> and writers in cpufreq.  I could understand if we felt that this data was
>> critical; but it really isn't.  A short delay here isn't that big of a deal IMO
>> (if someone can produce a case where a delay would cause a serious problem I'd
>>  like to hear it).  I don't even think it is safe in most cases to allow readers
>> while cpufreq values are changing; if we're changing the governor userspace
>> cannot rely on the value of (for example) cpuinfo_max_freq.
> 
> I don't know how reader writer lock will fail and a normal lock will not.
> There is only benefit of rwlock, that readers can read things while
> there is nobody
> writing..
> 
>> So I'm proposing that we move to a single threaded read/write using, if
> 
> Okay, but how will that benefit us ?

It will greatly simplify the code.  The locking isn't working in this code at
all right now and is causing various reported panics ... you yourself are
pushing a lock patch that serializes operations -- which is causing other
problems during testing.

> 
>> possible, a single policy lock for now.  We might transition this back to a
>> rwsem later on, however, for the first attempt at cleaning this up I think we
>> should just stick with a simple lock.  In doing that, IMO we remove
>>
>> cpufreq_rwsem: protects the driver from being unloaded
>> cpufreq_governor_lock: protects the current governor
>> each policy has a rwsem (policy->rwsem): protects the cpufreq_policy struct
>>
>> and potentially
>>
>> cpufreq_driver_lock: protects the cpufreq_cpu_data array and cpufreq_driver->boost
> 
> Not really sure, but yeah we might be able to club few of them..
> 
>> After looking at the way the code would be structured, I'm wondering if
>>
>> cpufreq_governor_mutex: protects the cpufreq_governor_list
>>
>> is overkill.  The loading of a module should be atomic relative to the cpufreq
>> code, so this lock may not be required.  (Admittedly I haven't tested that...)
>>
>> That would leave:
>>
>> global_kobj_lock: protects the "cpufreq" kobject
>> each policy has a transition_lock (policy->transition): synchronizes
>>                                                         frequency transitions
>>
>> and a new lock, perhaps called policy->lock, to serialize all events.
>>
>> Pros: We clean all this up to a simpler single threaded model.  Bugs and races
>> here would be much easier to handle.  We're currently putting band-aid on
>> band-aids in this code ATM and it looks like we're seeing old races expanded
>> or new races exposed.
>>
>> Cons: We lose the ability to do simultaneous reads and writes ... although
>> I remain unconvinced that this would ever be safe to do.  ie) If I change the
>> governor while at the same time reading, for example, the current cpu
>> frequency I cannot rely on that value to be valid.
>>
>> After that we can add some reference counting to the sysfs file accesses
>> so that we can block after the sysfs removal when we change cpufreq
>> governors.  I think that would be trivial and that it would resolve any races
>> when adding and removing governor's sysfs files.
> 
> Not really sure, but if you solve few things with getting these bugs resolved
> then we might apply your patches without any issues.
> 
