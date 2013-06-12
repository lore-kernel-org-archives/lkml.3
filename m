Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3FLJyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:54:35 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:54180 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab3FLJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <51B7D38A.7050204@linux.intel.com>
References: <20130530134718.GB32728@e103034-lin>
	<51B221AF.9070906@linux.vnet.ibm.com>
	<20130608112801.GA8120@MacBook-Pro.local>
	<1834293.MlyIaiESPL@vostro.rjw.lan>
	<51B3F99A.4000101@linux.vnet.ibm.com>
	<51B5FE02.7040607@linaro.org>
	<alpine.DEB.2.02.1306111722470.24968@nftneq.ynat.uz>
	<51B7D38A.7050204@linux.intel.com>
Date: Wed, 12 Jun 2013 15:18:39 +0530
Message-ID: <CAP245DUbGe5yp4-XoTg-imkAFNQzQrrX_UV3RRqr1dq_2GSPhg@mail.gmail.com>
Subject: Re: power-efficient scheduling design
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Lang <david@lang.hm>, "len.brown@intel.com" <len.brown@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Mike Galbraith <efault@gmx.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "pjt@google.com" <pjt@google.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 7:18 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 6/11/2013 5:27 PM, David Lang wrote:
>>
>>
>> Nobody is saying that this sort of thing should be in the fastpath of the
>> scheduler.
>>
>> But if the scheduler has a table that tells it the possible states, and
>> the cost to get from the current state to each of these states (and to get
>> back and/or wake up to
>> full power), then the scheduler can make the decision on what to do,
>> invoke a routine to make the change (and in the meantime, not be fighting
>> the change by trying to
>> schedule processes on a core that's about to be powered off), and then
>> when the change happens, the scheduler will have a new version of the table
>> of possible states and costs
>>
>> This isn't in the fastpath, it's in the rebalancing logic.
>
>
> the reality is much more complex unfortunately.
> C and P states hang together tightly, and even C state on
> one core impacts other cores' performance, just like P state selection
> on one core impacts other cores.
>
> (at least for x86, we should really stop talking as if the OS picks the
> "frequency",
> that's just not the case anymore)

This is true of ARM platforms too. As Daniel pointed out in an earlier
email, the operating point (frequency, voltage) has a bearing on the
c-state latency too.

An additional complexity is thermal constraints. E.g. On a quad-core
Cortex-A15 processor capable of say 1.5GHz, you won't be able to run
all 4 cores at that speed for very long w/o exceeding the thermal
envelope. These overdrive frequencies (turbo in x86-speak) impact the
rest of the system by either constraining the frequency of other cores
or requiring aggresive thermal management.

Do we really want to track these details in the scheduler or just let
the scheduler provide notifications to the existing subsystems
(cpufreq, cpuidle, thermal, etc.) with some sort of feedback going
back to the scheduler to influence future decisions?

Feeback to the scheduler could be something like the following (pardon
the names):

1. ISOLATE_CORE: Don't schedule anything on this core - cpuidle might
use this to synchronise cores for a cluster shutdown, thermal
framework could use this as idle injection to reduce temperature
2. CAP_CAPACITY: Don't expect cpufreq to raise the frequency on this
core - cpufreq might use this to cap overall energy since overdrive
operating points are very expensive, thermal might use this to slow
down rate of increase of die temperature

Regards,
Amit
