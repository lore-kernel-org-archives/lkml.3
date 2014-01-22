Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaAVWc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:32:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28712 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaAVWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:32:26 -0500
Message-ID: <52E046BA.2060701@oracle.com>
Date: Wed, 22 Jan 2014 17:31:22 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
References: <20131212140835.729222186@infradead.org> <20131212141655.362219382@infradead.org> <52DEF495.2020304@oracle.com> <20140122171454.GR31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140122171454.GR31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 12:14 PM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 05:28:37PM -0500, Sasha Levin wrote:
>> 	[    0.000000] Initmem setup node 30 [mem 0x12ee000000-0x138dffffff]
>> 	[    0.000000]   NODE_DATA [mem 0xcfa42000-0xcfa72fff]
>> 	[    0.000000]     NODE_DATA(30) on node 1
>> 	[    0.000000] Initmem setup node 31 [mem 0x138e000000-0x142fffffff]
>> 	[    0.000000]   NODE_DATA [mem 0xcfa11000-0xcfa41fff]
>> 	[    0.000000]     NODE_DATA(31) on node 1
>> 	[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
>> 	[    0.000000] kvm-clock: cpu 0, msr 0:cf991001, boot clock
>> 	[133538.294040] Zone ranges:
>> 	[133538.294338]   DMA      [mem 0x00001000-0x00ffffff]
>> 	[133538.294804]   DMA32    [mem 0x01000000-0xffffffff]
>> 	[133538.295223]   Normal   [mem 0x100000000-0x142fffffff]
>> 	[133538.295670] Movable zone start for each node
>
> OK, took me a while to fiddle with KVM and all the various muck around
> that to reproduce. But I can confirm the below does fix the issue for
> me.
>
> I'm hoping to not have to re-introcude the kevents_up() check, but I
> need to figure out what hardware triggered that and test again.
>
> ---
> Subject: sched/clock: Fixup early sched_clock initialization
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, 22 Jan 2014 12:59:18 +0100
>
> The code would assume sched_clock_stable() and switch to !stable
> later, this switch brings a discontinuity in time.
>
> The discontinuity on switching from stable to unstable was always
> present, but previously we would set stable/unstable before
> initializing TSC and usually stick to the one we start out with.
>
> So the static_key bits brought an extra switch where there previously
> wasn't one.
>
> Things are further complicated by the fact that we cannot use
> static_key as early as we usually call set_sched_clock_stable().
>
> Fix things by tracking the stable state in a regular variable and only
> set the static_key to the right state on sched_clock_init(), which is
> ran right after late_time_init->tsc_init().
>
> Before this we would not be using the TSC anyway.
>
> Fixes: 35af99e646c7 ("sched/clock, x86: Use a static_key for sched_clock_stable")
> Cc: jacob.jun.pan@linux.intel.com
> Cc: Mike Galbraith <bitbucket@online.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: hpa@zytor.com
> Cc: paulmck@linux.vnet.ibm.com
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: lenb@kernel.org
> Cc: rjw@rjwysocki.net
> Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Cc: rui.zhang@intel.com
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Reported-by: dyoung@redhat.com
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/20140122115918.GG3694@twins.programming.kicks-ass.net

The patch fixes the problem for me.


Thanks,
Sasha

