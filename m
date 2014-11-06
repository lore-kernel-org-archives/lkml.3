Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaKFRVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:21:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:55620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaKFRVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:21:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,327,1413270000"; 
   d="scan'208";a="603593137"
Date: Thu, 6 Nov 2014 09:20:59 -0800 (PST)
From: Vikas Shivappa <vikas.shivappa@intel.com>
X-X-Sender: vikas@vshiva-Udesk
To: Matt Fleming <matt@console-pimps.org>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
In-Reply-To: <20141106162713.GI3592@console-pimps.org>
Message-ID: <alpine.DEB.2.10.1411060919030.3494@vshiva-Udesk>
References: <20141029172845.GP12706@worktop.programming.kicks-ass.net> <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk> <20141029182234.GA13393@mtj.dyndns.org> <20141030070725.GG3337@twins.programming.kicks-ass.net> <20141030124333.GA29540@htj.dyndns.org>
 <20141030131845.GI3337@twins.programming.kicks-ass.net> <20141030170331.GB378@htj.dyndns.org> <20141030214353.GB12706@worktop.programming.kicks-ass.net> <20141030222236.GD378@htj.dyndns.org> <20141030224740.GC12706@worktop.programming.kicks-ass.net>
 <20141106162713.GI3592@console-pimps.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Nov 2014, Matt Fleming wrote:

> On Thu, 30 Oct, at 11:47:40PM, Peter Zijlstra wrote:
>>
>> Let me reply to just this one, I'll do the rest tomorrow, need sleeps.
>>
>> On Thu, Oct 30, 2014 at 06:22:36PM -0400, Tejun Heo wrote:
>>
>>>>> This controller might not even require the distinction between
>>>>> configured and effective tho?  Can't a new child just inherit the
>>>>> parent's configuration and never allow the config to become completely
>>>>> empty?
>>>>
>>>> It can do that. But that still has a problem, there is a mapping in
>>>> hardware which restricts the number of active configurations. The total
>>>> configuration space is larger than the supported active configurations.
>>>>
>>>> So _something_ must fail. The initial proposal was mkdir failing when
>>>> there were more than the hardware supported active config cgroup
>>>> directories. The alternative was on-demand activation where we only
>>>> allocate the hardware resource when the first task gets moved into the
>>>> group -- which then clearly can fail.
>>>
>>> Hmmm... why can't it just refuse creating a different configuration
>>> when its config space is full?  Make children inherit the parent's
>>> configuration and refuse config writes which require it to create a
>>> new one if the config space is full.  Seems pretty straight-forward.
>>> What am I missing?
>>
>> We could do that I suppose, there is the one corner case that would not
>> allow, intermediate directories with a restricted config that also have
>> priv restrictions but no actual tasks. Not sure that makes sense though.
>
> Could you elaborate on this configuration?
>
>> Are there any other cases I might have missed?
>
> I don't think so.
>
> So, for the specific CAT case what you're proposing is make the failure
> case happen when writing to the cache bitmask file instead of failing
> mkdir() or echo $tid > tasks ?
>
> I think that's OK. If we've run out of CLOS ids I would expect to see
> -ENOSPC returned, whereas if we try and set an invalid bitmask we'd get
> -EINVAL.
>
> Vikas, Will?

Yes that is correct. You can always create more cgroups and the new cgroup 
just inherits the mask from the parent and uses the same CLOSid as its 
parent , so it wont fail because of lack of CLOSids.

The only case of failure as you said is when user tries to modify a cbm to 
a different one.

  >
> -- 
> Matt Fleming, Intel Open Source Technology Center
>
