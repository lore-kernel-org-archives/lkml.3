Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3ISSV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:21:28 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49952 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3ISSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:21:27 -0400
Message-ID: <523B3FB2.80307@linux.vnet.ibm.com>
Date: Thu, 19 Sep 2013 23:47:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: Regression on cpufreq in v3.12-rc1
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com> <45987104.t6r4hvPgQn@vostro.rjw.lan>	<523AF22F.1010909@linux.vnet.ibm.com> <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com> <523AF50E.1040502@linux.vnet.ibm.com> <523B3E4B.6080003@linux.vnet.ibm.com>
In-Reply-To: <523B3E4B.6080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091918-4790-0000-0000-00000A68F760
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 11:41 PM, Srivatsa S. Bhat wrote:
> On 09/19/2013 06:28 PM, Srivatsa S. Bhat wrote:
>> On 09/19/2013 06:25 PM, Linus Walleij wrote:
>>> On Thu, Sep 19, 2013 at 2:46 PM, Srivatsa S. Bhat
>>> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>>
>>>>>> I don't really know if this is the right solution at all, so please
>>>>>> help me out here... if you want that patch I can send it once
>>>>>> I understand this properly.
>>>>
>>>> IIRC, recent kernels didn't return 0 or any error code when the !policy
>>>> condition was matched. So can you check whether this problem occurs with
>>>> 3.11 or 3.10 as well?
>>>
>>> v3.11 works fine.
>>>
> 
> Ok, now that I got a chance to look at the code and the git logs, I think
> I have a clearer idea of what is happening.
> 
> Basically commit 474deff74 (cpufreq: remove cpufreq_policy_cpu per-cpu
> variable) exposed a hidden issue. Before that commit, the code looked like
> this:
> 
> static DEFINE_PER_CPU(int, cpufreq_policy_cpu);
> 
> [...]
> 
> static int lock_policy_rwsem_##mode(int cpu)                            \
> {                                                                       \
>         int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);              \
>         BUG_ON(policy_cpu == -1);                                       \
>         down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));            \
>                                                                         \
>         return 0;                                                       \
> }
> 
> But there was no code to set the per-cpu values to -1 to begin with. Since
> the per-cpu variable was defined as static, it would have been initialized
> to zero. Thus, we would never actually hit the BUG_ON() condition, since
> policy_cpu didn't turn out to be -1.
> 
> (The per-cpu variable was set to -1 only during error in __cpufreq_add_dev
> and during cpufreq_remove_dev, both of which are irrelevant to the scenario
> we are dealing with here).
> 
> So, code ended up accessing and locking CPU 0's rwsemaphore. But how was
> its initialization taken care of? The answer is the initcall sequence.
> Cpufreq core code initialized itself at the core_initcall stage, and the
> sa1100 cpufreq driver initialized itself at the arch_initcall stage, like
> Viresh mentioned. And core-initcall comes before arch-initcall. So the
> cpufreq core would have finished initializing the per-cpu rwsemaphores,
> so that locking/unlocking them wouldn't crash the system or get complaints
> from lockdep.
> 
> To summarize, I think before commit 474deff74, we were accessing CPU0's
> rwsems (perhaps incorrectly) and due to the lacking initialization of the
> per-cpu vars, the BUG_ON() would never fire.
> 
> To confirm this, you can perhaps try out one commit before 474deff74 and see
> if it works for you. Or equivalently, you can apply the following patch
> (revert of 474deff74) over mainline and see if it works.

Just before sending, I rebased that patch on top of Rafael's linux-next
branch, but forgot to update the above sentence. However I think the same
patch might apply cleanly over mainline as well.

Regards,
Srivatsa S. Bhat

