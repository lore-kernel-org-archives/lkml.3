Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3BSAc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 19:32:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22746 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3BSAc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 19:32:58 -0500
Message-ID: <5122C80D.3020206@oracle.com>
Date: Mon, 18 Feb 2013 19:32:13 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sched: circular dependency between sched_domains_mutex and oom_notify_list
References: <51206DAB.7030701@oracle.com> <20130218082639.GA15989@gmail.com>
In-Reply-To: <20130218082639.GA15989@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 03:26 AM, Ingo Molnar wrote:
> 
> * Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> I suspect it's the result of adding the new rcu_oom_notify, but that happened
>> about half a year ago so I'm not sure why this showed up only now.
>>
>> [ 1039.634183] ======================================================
>> [ 1039.635717] [ INFO: possible circular locking dependency detected ]
>> [ 1039.637255] 3.8.0-rc7-next-20130215-sasha-00003-gea816fa #286 Tainted: G        W
>> [ 1039.639104] -------------------------------------------------------
>> [ 1039.640579] init/1 is trying to acquire lock:
>> [ 1039.641224]  ((oom_notify_list).rwsem){.+.+..}, at: [<ffffffff81141c8f>] __blocking_notifier_call_chain+0x7f/0xc0
> 
> We changed (optimized) rwsems via:
> 
>  3a15e0e0cdda rwsem: Implement writer lock-stealing for better scalability
> 
> so maybe it can hit different codepaths and races now?

I don't think that that patch would modify codepaths - it might just cause some
race conditions more probable.

I'm still thinking that the issue is the new rcu oom thingie and since this
codepath is very unlikely (running out of memory while sched_domains_mutex is
held - which is very rare) it's the culprit.


Thanks,
Sasha
