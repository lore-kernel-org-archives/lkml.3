Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaDLADB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 20:03:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbaDLAC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 20:02:59 -0400
Message-ID: <53488291.1040501@redhat.com>
Date: Fri, 11 Apr 2014 20:02:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jbenc@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, fweisbec@gmail.com
Subject: Re: [PATCH] softirq: punt to ksoftirqd if __do_softirq recently looped
References: <20140410115706.662fb5e7@annuminas.surriel.com> <20140411.163342.1319748709214614224.davem@davemloft.net>
In-Reply-To: <20140411.163342.1319748709214614224.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 04:33 PM, David Miller wrote:
> From: Rik van Riel <riel@redhat.com>
> Date: Thu, 10 Apr 2014 11:57:06 -0400
> 
>> @@ -330,7 +334,11 @@ void irq_enter(void)
>>  
>>  static inline void invoke_softirq(void)
>>  {
>> -	if (!force_irqthreads) {
>> +	/*
>> +	 * If force_irqthreads is set, or if we looped in __do_softirq this
>> +	 * jiffie, punt to ksoftirqd to prevent userland starvation.
>> +	 */
>> +	if (!force_irqthreads && this_cpu_read(softirq_looped) != jiffies) {
> 
> If we do this, which I'm not convinced of yet, I think we should use two
> jiffies as the cutoff.

I am not fully convinced, either.  This patch mostly just illustrates
the problem, and gives something that solves Jiri's immediate problem.

It is quite likely that there is a better way to solve the problem of:
1) softirq handling starving out userspace processing,
2) which could be solved by moving the userspace process elsewhere, and
3) shifting softirq processing to ksoftirqd

A working patch seems to be one of the better ways to start a
discussion, though.

If anybody has a nicer idea on how to solve the problem, I'd even be
willing to implement your idea, and give Jiri another patch to test :)

-- 
All rights reversed
