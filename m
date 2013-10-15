Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab3JOKAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:00:40 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:38628 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758500Ab3JOKAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:00:38 -0400
Message-ID: <525D1191.8090207@linux.vnet.ibm.com>
Date: Tue, 15 Oct 2013 15:27:37 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, corbet@lwn.net, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/7] Power-aware scheduling v2
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com> <20131014133234.GM3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014133234.GM3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101510-3864-0000-0000-00000A8A7566
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/14/2013 07:02 PM, Peter Zijlstra wrote:
> On Fri, Oct 11, 2013 at 06:19:10PM +0100, Morten Rasmussen wrote:
>> Hi,
>>
>> I have revised the previous power scheduler proposal[1] trying to address as
>> many of the comments as possible. The overall idea was discussed at LPC[2,3].
>> The revised design has removed the power scheduler and replaced it with a high
>> level power driver interface. An interface that allows the scheduler to query
>> the power driver for information and provide hints to guide power management
>> decisions in the power driver.
>>
>> The power driver is going to be a unified platform power driver that can
>> replace cpufreq and cpuidle drivers. Generic power policies will be optional
>> helper functions called from the power driver. Platforms may choose to
>> implement their own policies as part of their power driver.
>>
>> This RFC series prototypes a part of the power driver interface (cpu capacity
>> hints) and shows how they can be used from the scheduler. More extensive use of
>> the power driver hints and queries is left for later. The focus for now is the
>> power driver interface. The patch series includes a power driver/cpufreq
>> governor that can use existing cpufreq drivers as backend. It has been tested
>> (not thoroughly) on ARM TC2. The cpufreq governor power driver implementation
>> is rather horrible, but it illustrates how the power driver interface can be
>> used. Native power drivers is on the todo list.
>>
>> The power driver interface is still missing quite a few calls to handle: Idle,
>> adding extra information to the sched_domain hierarchy to guide scheduling
>> decisions (packing), and possibly scaling of tracked load to compensate for
>> frequency changes and asymmetric systems (big.LITTLE).
>>
>> This set is based on 3.11. I have done ARM TC2 testing based on linux-linaro
>> 2013.08[4] to get cpufreq support for TC2.
> 
> What I'm missing is a general overview of why what and how.

I agree that the "why" needs to be mentioned very clearly since the
patchset revolves around it. As far as I understand we need a single
controller for deciding the power efficiency of the kernel, who is
exposed to all the user policies and the frequency+idle states stats of
the CPU to begin with. These stats are being supplied by the power driver.

Having these details and decision making in multiple places like we do
today in cpuidle, cpu-frequency and scheduler will probably cause
problems. For example, when the power efficiency of the kernel goes
wrong we have trouble point out the reason behind it. Where did the
problem arise from among the above three power policy decision makers?
This is a maintainability concern.
   Another reason is the power saving decisions made by say cpuidle may
not complement the power saving decisions made by cpufreq. This can lead
to inconsistent results across different workloads.

Thus having a single policy maker for power savings we are hoping to
solve the primary concerns of consistent behaviour from the kernel in
terms of power efficiency and improved maintainability.

> 
> In particular; how does this proposal lead to power savings. Is there a
> mathematical model that supports this framework? Something where if you
> give it a task set with global utilisation < 1 (ie. there's idle time),
> it results in less power used.

AFAIK, this patchset is an attempt to achieve consistency in the power
efficiency of the kernel across workloads with the existing algorithms,
in addition to a cleanup involving integration of the power policy
making in one place as explained above. In an attempt to do so, *maybe*
better power numbers can be obtained or at-least the default power
efficiency of the kernel will show up.

However adding the new patchsets like packing small tasks, heterogeneous
scheduling, power aware scheduling etc.. *should* then yield good and
consistent power savings since they now stand on top of an integrated
stable power driver.

Regards
Preeti U Murthy
> 
> Also, how does this proposal deal with cpufreq's fundamental broken
> approach to SMP? Afaict nothing considers the effect of one cpu upon
> another -- something which isn't true at all.
> 
> In fact, I don't see anything except a random bunch of hooks without an
> over-all picture of how to get less power used.
> 

