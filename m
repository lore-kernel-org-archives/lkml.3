Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3J3F7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:59:32 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58910 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3J3F7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:59:31 -0400
Message-ID: <5270A03F.8020301@hitachi.com>
Date: Wed, 30 Oct 2013 14:59:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, yoshihiro.yunomae.ez@hitachi.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: RFC: paravirtualizing perf_clock
References: <526DBD7F.1010807@gmail.com> <20131028131556.GN19466@laptop.lan> <526F2440.9030607@gmail.com>
In-Reply-To: <526F2440.9030607@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/29 11:58), David Ahern wrote:
> On 10/28/13 7:15 AM, Peter Zijlstra wrote:
>>> Any suggestions on how to do this and without impacting performance. I
>>> noticed the MSR path seems to take about twice as long as the current
>>> implementation (which I believe results in rdtsc in the VM for x86 with
>>> stable TSC).
>>
>> So assuming all the TSCs are in fact stable; you could implement this by
>> syncing up the guest TSC to the host TSC on guest boot. I don't think
>> anything _should_ rely on the absolute TSC value.
>>
>> Of course you then also need to make sure the host and guest tsc
>> multipliers (cyc2ns) are identical, you can play games with
>> cyc2ns_offset if you're brave.
>>
> 
> This and the method Gleb mentioned both are going to be complex and 
> fragile -- based assumptions on how the perf_clock timestamps are 
> generated. For example, 489223e assumes you have the tracepoint enabled 
> at VM start with some means of capturing the data (e.g., a perf-session 
> active). In both cases the end result requires piecing together and 
> re-generating the VM's timestamp on the events. For perf this means 
> either modifying the tool to take parameters and an algorithm on how to 
> modify the timestamp or a homegrown tool to regenerate the file with 
> updated timestamps.
> 
> To back out a bit, my end goal is to be able to create and merge 
> perf-events from any context on a KVM-based host -- guest userspace, 
> guest kernel space, host userspace and host kernel space (userspace 
> events with a perf-clock timestamp is another topic ;-)).

That is almost same as what we(Yoshihiro and I) are trying on integrated
tracing, we are doing it on ftrace and trace-cmd (but perhaps, it eventually
works on perf-ftrace).

> Having the 
> events generated with the proper timestamp is the simpler approach than 
> trying to collect various tidbits of data, massage timestamps (and 
> hoping the clock source hasn't changed) and then merge events.

Yeah, if possible, we'd like to use it too.

> 
> And then for the cherry on top a design that works across architectures 
> (e.g., x86 now, but arm later).

I think your proposal is good for the default implementation, it doesn't
depends on the arch specific feature. However, since physical timer(clock)
interfaces and virtualization interfaces strongly depends on the arch,
I guess the optimized implementations will become different on each arch.
For example, maybe we can export tsc-offset to the guest to adjust clock
on x86, but not on ARM, or other devices. In that case, until implementing
optimized one, we can use paravirt perf_clock.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


