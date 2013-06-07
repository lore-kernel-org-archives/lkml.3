Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3FGPXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:23:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:19146 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3FGPXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:23:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,822,1363158000"; 
   d="scan'208";a="252002841"
Message-ID: <51B1FAE4.2070700@linux.intel.com>
Date: Fri, 07 Jun 2013 08:23:16 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, alex.shi@intel.com,
        peterz@infradead.org, vincent.guittot@linaro.org, efault@gmx.de,
        pjt@google.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, len.brown@intel.com, corbet@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <51B177AA.1000600@linux.vnet.ibm.com>
In-Reply-To: <51B177AA.1000600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/2013 11:03 PM, Preeti U Murthy wrote:
> Hi,
>
> On 05/31/2013 04:22 PM, Ingo Molnar wrote:
>> PeterZ and me tried to point out the design requirements previously, but
>> it still does not appear to be clear enough to people, so let me spell it
>> out again, in a hopefully clearer fashion.
>>
>> The scheduler has valuable power saving information available:
>>
>>   - when a CPU is busy: about how long the current task expects to run
>>
>>   - when a CPU is idle: how long the current CPU expects _not_ to run
>>
>>   - topology: it knows how the CPUs and caches interrelate and already
>>     optimizes based on that

and I will argue we do too much of this already; various caches (and tlbs) get flushed
(on x86 at least) much much more than you'd think.

>>
>> so the scheduler is in an _ideal_ position to do a judgement call about
>> the near future

this part I will buy

>> and estimate how deep an idle state a CPU core should
>> enter into and what frequency it should run at.

this part I cannot buy.
First of all, we really need to stop thinking about choosing frequency (at least for x86).
that concept basically died for x86 6 years ago.

Second, the interactions between these two, and the "what does it mean if I chose something"
is highly hardware specific and complex nowadays, and going forward is going to be increasingly so.
If anything, we've been moving AWAY from centralized infrastructure there, going towards
CPU specific drivers/policies. And hardware rules are very different between platforms here.
On Intel, asking for different performance is just an MSR write, and going idle is usually just one instruction.
On some ARM, this might involve a long complex interaction calculations, or even *blocking* operation manipulating VRs and PLLs directly... depending
on the platform and the states you want to pick. (Hence the CPUFREQ design of requiring changes to be
done in a kernel thread)

Now, I would like the scheduler to give some notifications at certain events (like migrations,
starting realtime tasks)...but a few atomic notifier chains will do for that.

The policies will be very hardware specific, and thus will live outside the scheduler, no matter which way you
put it. Now, the scheduler can and should participate more in terms of sharing information in both directions...
that I think we can all agree on.


