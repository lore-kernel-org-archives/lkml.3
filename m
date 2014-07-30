Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaG3DKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:10:24 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:49598 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754698AbaG3DKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:10:23 -0400
X-IronPort-AV: E=Sophos;i="5.00,992,1396972800"; 
   d="scan'208";a="33941400"
Message-ID: <53D8626E.5060900@cn.fujitsu.com>
Date: Wed, 30 Jul 2014 11:11:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <hughd@google.com>, <viresh.kumar@linaro.org>, <hpa@zytor.com>,
        <mingo@kernel.org>
Subject: Re: vmstat: On demand vmstat workers V8
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <53D31101.8000107@oracle.com> <alpine.DEB.2.11.1407281353450.15405@gentwo.org> <20140729075637.GA19379@twins.programming.kicks-ass.net> <20140729120525.GA28366@mtj.dyndns.org> <20140729122303.GA3935@laptop> <20140729131226.GS7462@htj.dyndns.org> <alpine.DEB.2.11.1407291009320.21102@gentwo.org> <20140729151415.GF4791@htj.dyndns.org> <alpine.DEB.2.11.1407291038160.21390@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1407291038160.21390@gentwo.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 11:39 PM, Christoph Lameter wrote:
> On Tue, 29 Jul 2014, Tejun Heo wrote:
> 
>> Hmmm, well, then it's something else.  Either a bug in workqueue or in
>> the caller.  Given the track record, the latter is more likely.
>> e.g. it looks kinda suspicious that the work func is cleared after
>> cancel_delayed_work_sync() is called.  What happens if somebody tries
>> to schedule it inbetween?
> 
> Here is yet another patch to also address this idea:
> 
> Subject: vmstat: Clear the work.func before cancelling delayed work
> 
> Looks strange to me but Tejun thinks this could do some good.
> If this really is the right thing to do then cancel_delayed_work should
> zap the work func itselt I think.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> 
> Index: linux/mm/vmstat.c
> ===================================================================
> --- linux.orig/mm/vmstat.c	2014-07-29 10:22:45.073884943 -0500
> +++ linux/mm/vmstat.c	2014-07-29 10:34:45.083369228 -0500
> @@ -1277,8 +1277,8 @@ static int vmstat_cpuup_callback(struct
>  		break;
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
> -		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
>  		per_cpu(vmstat_work, cpu).work.func = NULL;
> +		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));

I think we should just remove "per_cpu(vmstat_work, cpu).work.func = NULL;"

>  		break;
>  	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
> .
> 

