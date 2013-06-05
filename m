Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab3FEU6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:58:44 -0400
Received: from mail.candelatech.com ([208.74.158.172]:57201 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3FEU6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:58:39 -0400
Message-ID: <51AFA677.9010605@candelatech.com>
Date: Wed, 05 Jun 2013 13:58:31 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: stop_machine lockup issue in 3.9.y.
References: <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com> <87d2s2to4z.fsf@rustcorp.com.au> <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com> <51AE1B81.20900@candelatech.com> <51AE27D5.7050202@candelatech.com> <87sj0xry1k.fsf@rustcorp.com.au> <20130605071539.GA3429@mtj.dyndns.org> <51AF6E54.3050108@candelatech.com> <20130605184807.GD10693@mtj.dyndns.org> <51AF8D4B.4090407@candelatech.com> <51AF91F5.6090801@candelatech.com>
In-Reply-To: <51AF91F5.6090801@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 12:31 PM, Ben Greear wrote:
> This is no longer really about the module unlink, so changing
> subject.
>
> On 06/05/2013 12:11 PM, Ben Greear wrote:
>> On 06/05/2013 11:48 AM, Tejun Heo wrote:
>>> Hello, Ben.
>>>
>>> On Wed, Jun 05, 2013 at 09:59:00AM -0700, Ben Greear wrote:
>>>> One pattern I notice repeating for at least most of the hangs is that all but one
>>>> CPU thread has irqs disabled and is in state 2.  But, there will be one thread
>>>> in state 1 that still has IRQs enabled and it is reported to be in soft-lockup
>>>> instead of hard-lockup.  In 'sysrq l' it always shows some IRQ processing,
>>>> but typically that of the sysrq itself.  I added printk that would always
>>>> print if the thread notices that smdata->state != curstate, and the soft-lockup
>>>> thread (cpu 2 below) never shows that message.
>>>
>>> It sounds like one of the cpus get live-locked by IRQs.  I can't tell
>>> why the situation is made worse by other CPUs being tied up.  Do you
>>> ever see CPUs being live locked by IRQs during normal operation?

Hmm, wonder if I found it.  I previously saw times where it appears
jiffies does not increment.  __do_softirq has a break-out based on
jiffies timeout.  Maybe that is failing to get us out of __do_softirq
in my lockup case because for whatever reason the system cannot update
jiffies in this case?

I added this (probably whitespace damaged) hack and now I have not been
able to reproduce the problem.

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 14d7758..621ea3b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -212,6 +212,7 @@ asmlinkage void __do_softirq(void)
         unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
         int cpu;
         unsigned long old_flags = current->flags;
+       unsigned long loops = 0;

         /*
          * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -241,6 +242,7 @@ restart:
                         unsigned int vec_nr = h - softirq_vec;
                         int prev_count = preempt_count();

+                       loops++;
                         kstat_incr_softirqs_this_cpu(vec_nr);

                         trace_softirq_entry(vec_nr);
@@ -265,7 +267,7 @@ restart:

         pending = local_softirq_pending();
         if (pending) {
-               if (time_before(jiffies, end) && !need_resched())
+               if (time_before(jiffies, end) && !need_resched() && (loops < 500))
                         goto restart;

                 wakeup_softirqd();

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

