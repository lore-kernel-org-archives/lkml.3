Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3JaIJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:09:17 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60461 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab3JaIJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:09:13 -0400
Message-ID: <52721025.4040901@hitachi.com>
Date: Thu, 31 Oct 2013 17:09:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, yoshihiro.yunomae.ez@hitachi.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: RFC: paravirtualizing perf_clock
References: <526DBD7F.1010807@gmail.com> <20131028131556.GN19466@laptop.lan> <526F2440.9030607@gmail.com> <5270A03F.8020301@hitachi.com> <527111BD.9010803@gmail.com>
In-Reply-To: <527111BD.9010803@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/30 23:03), David Ahern wrote:
> On 10/29/13 11:59 PM, Masami Hiramatsu wrote:
>> (2013/10/29 11:58), David Ahern wrote:
>>> To back out a bit, my end goal is to be able to create and merge
>>> perf-events from any context on a KVM-based host -- guest userspace,
>>> guest kernel space, host userspace and host kernel space (userspace
>>> events with a perf-clock timestamp is another topic ;-)).
>>
>> That is almost same as what we(Yoshihiro and I) are trying on integrated
>> tracing, we are doing it on ftrace and trace-cmd (but perhaps, it eventually
>> works on perf-ftrace).
> 
> I thought at this point (well, once perf-ftrace gets committed) that you 
> can do everything with perf. What feature is missing in perf that you 
> get with trace-cmd or using debugfs directly?

The perftools interface is the best for profiling a process or in a short period.
However, what we'd like to do is monitoring or tracing in background a long
period on the memory, while the system life cycle, as a flight recorder.
This kind of tracing interface is required for mission-critical system for
trouble shooting.

Also, on-the-fly configurability of ftrace such as snapshot, multi-buffer,
event-adding/removing are very useful, since in the flight-recorder
use-case, we can't stop tracing for even a moment.

Moreover, our guest/host integrated tracer can pass event buffers from
guest to host with very small overhead, because it uses ftrace ringbuffer
and virtio-serial with splice (so, zero page copying in the guest).
Note that we need low overhead tracing as small as possible because it
is running always in background.

That's why we're using ftrace for our purpose. But anyway, the time
synchronization is common issue. Let's share the solution :)


>>> And then for the cherry on top a design that works across architectures
>>> (e.g., x86 now, but arm later).
>>
>> I think your proposal is good for the default implementation, it doesn't
>> depends on the arch specific feature. However, since physical timer(clock)
>> interfaces and virtualization interfaces strongly depends on the arch,
>> I guess the optimized implementations will become different on each arch.
>> For example, maybe we can export tsc-offset to the guest to adjust clock
>> on x86, but not on ARM, or other devices. In that case, until implementing
>> optimized one, we can use paravirt perf_clock.
> 
> So this MSR read takes about 1.6usecs (from 'perf stat kvm live') and 
> that is total time between VMEXIT and VMENTRY. The time it takes to run 
> perf_clock in the host should be a very small part of that 1.6 usec. 

Yeah, a hypercall is always heavy operation. So that is not the best
solution, we need a optimized one for each arch.

> I'll take a look at the TSC path to see how it is optimized (suggestions 
> appreciated).

At least on the machine which has stable tsc, we can relay on that.
We just need the tsc-offset to adjust it in the guest. Note that this
offset can change if the guest sleeps/resumes or does a live-migration.
Each time we need to refresh the tsc-offset.

> Another thought is to make the use of pv_perf_clock an option -- user 
> can knowingly decide the additional latency/overhead is worth the feature.

Yeah. BTW, would you see the paravirt_sched_clock(pv_time_ops)?
It seems that such synchronized clock is there.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


