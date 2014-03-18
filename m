Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbaCRUFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:05:02 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48177 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbaCRUFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:05:00 -0400
Message-ID: <5328A6D9.1080506@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 01:34:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        patrick.marlier@gmail.com, viresh.kumar@linaro.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH v3 0/2] Add stop callback to the cpufreq_driver interface.
References: <1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com> <1395163361-26380-1-git-send-email-dirk.j.brandewie@intel.com> <532899B2.2060106@linux.vnet.ibm.com> <53289D9A.8070805@gmail.com>
In-Reply-To: <53289D9A.8070805@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031820-5490-0000-0000-000005326B30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 12:55 AM, Dirk Brandewie wrote:
> On 03/18/2014 12:08 PM, Srivatsa S. Bhat wrote:
>> On 03/18/2014 10:52 PM, dirk.brandewie@gmail.com wrote:
>>> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>>>
>>
>> I don't mean to nitpick, but generally its easier to deal with
>> patchsets if you post the subsequent versions in fresh email threads.
>> Otherwise it can get a bit muddled along with too many other email
>> discussions in the same thread :-(
>>
>>> Changes:
>>> v2->v3
>>> Changed the calling of the ->stop() callback to be conditional on the
>>> core being the last core controlled by a given policy.
>>>
>>
>> Wait, why? I'm sorry if I am not catching up with the discussions on
>> this issue quickly enough, but I don't see why we should make it
>> conditional on _that_. I thought we agreed that we should make it
>> conditional in the sense that ->stop() should be invoked only for
>> ->setpolicy drivers, right?
> 
> This was done at Viresh's suggestion since thought there might be value
> for ->target drivers.
> 
> Any of the options work for me
>    called only for set_policy scaling drivers
>    called unconditionally for all scaling drivers
>    called for last core controlled by a given policy
> 
>>
>> The way I look at it, ->stop() gives you a chance to stop managing
>> the CPU going offline. As in "stop this CPU". ->exit() is your chance
>> to cleanup the policy, since all its users have gone offline (or this
>> is the last CPU belonging to that policy which is going offline).
>>
>> With this in mind, we should invoke ->stop() every time we take a
>> CPU offline, and invoke ->exit() only when the last CPU in the policy
>> goes offline.
> 
> This is exactly what will happen for intel_pstate since the policies cover
> a single core.
> 
> I will defer to you and Viresh how policies that affect more that one
> cpu should be handled.
> 
> What intel_pstate needs it to be called during the PREPARE phase of the
> offline process.
>

Sure, so here are my thoughts:

1. ->target() and ->setpolicy() drivers are mutually exclusive. Rafael
   had sent a patch to enforce this, and Viresh acked this patch.

   http://marc.info/?l=linux-pm&m=139458107925911&w=2
   http://marc.info/?l=linux-pm&m=139460177829875&w=2

2. The way I understand, ->target() drivers use one of the defined governors,
   and hence have a way to stop managing the CPUs upon CPU offline events.
   This is done via the GOV_STOP mechanism (in the DOWN_PREPARE stage).

   On the other hand, the ->setpolicy() drivers don't have any equivalent
   mechanism at all, and all they have today is the ->exit() callback which
   is invoked way too late in the offline process, for it to be of any use.

So the goal here is to introduce a new mechanism or callback to help those
->setpolicy drivers to do whatever they wish to do, while taking the CPU
offline. In the case of intel_pstate, the driver wants to set the outgoing
CPU's frequency to the min P state.

With this reasoning, the cpufreq core should invoke the ->stop() callback
only for the ->setpolicy() drivers. Let us not over-generalize interfaces
unless they are actually going to be useful in broader scenarios.


Now let's focus on the second issue - how often should we call ->stop()?
Should we call it on every CPU offline or only upon the last CPU going
offline in a given policy?

If we look back at the ->target() drivers who use the defined governors,
we _effectively_ call GOV_STOP during every CPU offline event. That is,
the policy needs to stop governing the CPU going offline from this point
onwards, hence the GOV_STOP (and subsequent GOV_START without the offline
CPU) makes sense.

Similarly, I believe that we should call ->stop() on every CPU offline.
We already have ->exit() that gets called when the last CPU goes offline
in that policy. With this scheme, we give 2 unique properties to ->stop()
as compared to ->exit():

a. ->stop() gets called during the CPU_DOWN_PREPARE stage, which lets
   the ->setpolicy driver actually take some action on the CPU's frequency.

b. ->stop() gets called for every CPU offline. The driver can use this
   fact if useful. Otherwise, the driver can still ignore some of these
   calls and do the actual work when the last CPU goes offline in that
   policy. From what I know, the former case is much more useful, and
   hence this semantics of invoking it on every CPU offline makes sense.

Thoughts?

Regards,
Srivatsa S. Bhat

