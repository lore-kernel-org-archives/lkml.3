Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbaFXUfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:35:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34514 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaFXUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:35:39 -0400
Message-ID: <53A9E117.4010704@wwwdotorg.org>
Date: Tue, 24 Jun 2014 14:35:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 2/6] irq_work: Implement remote queueing
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com> <1402413309-3415-3-git-send-email-fweisbec@gmail.com> <53A9E0A5.5040402@wwwdotorg.org>
In-Reply-To: <53A9E0A5.5040402@wwwdotorg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 02:33 PM, Stephen Warren wrote:
> On 06/10/2014 09:15 AM, Frederic Weisbecker wrote:
>> irq work currently only supports local callbacks. However its code
>> is mostly ready to run remote callbacks and we have some potential user.
>>
>> The full nohz subsystem currently open codes its own remote irq work
>> on top of the scheduler ipi when it wants a CPU to reevaluate its next
>> tick. However this ad hoc solution bloats the scheduler IPI.
>>
>> Lets just extend the irq work subsystem to support remote queuing on top
>> of the generic SMP IPI to handle this kind of user. This shouldn't add
>> noticeable overhead.
> 
> I'm running next-20140624 on an ARM system, and this patch causes CPU
> hot(un)plug to Oops for me; the following fires:
> 
> void irq_work_run(void)
> {
> 	BUG_ON(!in_irq());
> 
> I found that Linus's master (8b8f5d971584 "Merge tag 'compress-3.16-rc3'
> of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core")
> works fine. I found that this commit inside the tip(?) tree works fine
> (478850160636 "irq_work: Implement remote queueing"). However, if I
> merge the two together, I hit that BUG_ON.

I forgot to mention that the conflicting commit from Linus' tree is
8d056c48e486 "CPU hotplug, smp: flush any pending IPI callbacks before
CPU offline".

> I think the issue is:
> 
> This commit adds a call from
> generic_smp_call_function_single_interrupt() to irq_work_run().
> 
> Srivatsa's patch adds a call from hotplug_cfd() to
> flush_smp_call_function_queue() to, which I imagine happens in
> non-interrupt context. Note that this patch moves most of the body of
> generic_smp_call_function_single_interrupt() into
> flush_smp_call_function_queue().
