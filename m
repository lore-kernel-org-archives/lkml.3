Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaG2Pox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:44:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37748 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaG2Pow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:44:52 -0400
Message-ID: <53D7C11D.8050905@oracle.com>
Date: Tue, 29 Jul 2014 11:43:25 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>, Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: vmstat: On demand vmstat workers V8
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <53D31101.8000107@oracle.com> <alpine.DEB.2.11.1407281353450.15405@gentwo.org> <20140729075637.GA19379@twins.programming.kicks-ass.net> <20140729120525.GA28366@mtj.dyndns.org> <20140729122303.GA3935@laptop> <20140729131226.GS7462@htj.dyndns.org> <alpine.DEB.2.11.1407291020470.21102@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1407291020470.21102@gentwo.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 11:22 AM, Christoph Lameter wrote:
> On Tue, 29 Jul 2014, Tejun Heo wrote:
> 
>> I'm not sure that's a viable way forward.  It's not like we can
>> readily trigger the problematic cases which can lead to long pauses
>> during cpu down.  Besides, we need the distinction at the API level,
>> which is the whole point of this.  The best way probably is converting
>> all the correctness ones (these are the minorities) over to
>> queue_work_on() so that the per-cpu requirement is explicit.
> 
> Ok so we would need this fix to avoid the message:
> 
> 
> Subject: vmstat: use schedule_delayed_work_on to avoid false positives
> 
> It seems that schedule_delayed_work_on will check for preemption even
> though none can occur. schedule_delayed_work_on will not do that. So
> use that function to suppress false positives.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/mm/vmstat.c
> ===================================================================
> --- linux.orig/mm/vmstat.c	2014-07-29 10:14:42.356988271 -0500
> +++ linux/mm/vmstat.c	2014-07-29 10:18:28.205920997 -0500
> @@ -1255,7 +1255,8 @@ static void vmstat_update(struct work_st
>  		 * to occur in the future. Keep on running the
>  		 * update worker thread.
>  		 */
> -		schedule_delayed_work(this_cpu_ptr(&vmstat_work),
> +		schedule_delayed_work_on(smp_processor_id(),
> +			this_cpu_ptr(&vmstat_work),
>  			round_jiffies_relative(sysctl_stat_interval));
>  	else {
>  		/*
> 

I've tested, and this patch doesn't fix neither of the bugs reported.


Thanks,
Sasha
