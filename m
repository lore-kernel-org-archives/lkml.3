Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3HBIP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:15:29 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:64088 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3HBIPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:15:23 -0400
Message-ID: <51FB6A55.8080306@huawei.com>
Date: Fri, 2 Aug 2013 16:14:13 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>,
        Tom Herbert <therbert@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Ben Greear <greearb@candelatech.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [ 146/184] softirq: reduce latencies
References: <20130604172136.354293911@1wt.eu>
In-Reply-To: <20130604172136.354293911@1wt.eu>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ben Greear
Cc: Tejun

Hi Willy,

This patch introduced a bug, which was then fixed by commit 34376a50fb1f
("Fix lockup related to stop_machine being stuck in __do_softirq."),
do we need this fix for 2.6.32 ?

On 2013/6/5 1:23, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> In various network workloads, __do_softirq() latencies can be up
> to 20 ms if HZ=1000, and 200 ms if HZ=100.
> 
> This is because we iterate 10 times in the softirq dispatcher,
> and some actions can consume a lot of cycles.
> 
> This patch changes the fallback to ksoftirqd condition to :
> 
> - A time limit of 2 ms.
> - need_resched() being set on current task
> 
> When one of this condition is met, we wakeup ksoftirqd for further
> softirq processing if we still have pending softirqs.
> 
> Using need_resched() as the only condition can trigger RCU stalls,
> as we can keep BH disabled for too long.
> 
> I ran several benchmarks and got no significant difference in
> throughput, but a very significant reduction of latencies (one order
> of magnitude) :
> 
> In following bench, 200 antagonist "netperf -t TCP_RR" are started in
> background, using all available cpus.
> 
> Then we start one "netperf -t TCP_RR", bound to the cpu handling the NIC
> IRQ (hard+soft)
> 
> Before patch :
> 
> RT_LATENCY,MIN_LATENCY,MAX_LATENCY,P50_LATENCY,P90_LATENCY,P99_LATENCY,MEAN_LATENCY,STDDEV_LATENCY
> MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET
> to 7.7.7.84 () port 0 AF_INET : first burst 0 : cpu bind
> RT_LATENCY=550110.424
> MIN_LATENCY=146858
> MAX_LATENCY=997109
> P50_LATENCY=305000
> P90_LATENCY=550000
> P99_LATENCY=710000
> MEAN_LATENCY=376989.12
> STDDEV_LATENCY=184046.92
> 
> After patch :
> 
> RT_LATENCY,MIN_LATENCY,MAX_LATENCY,P50_LATENCY,P90_LATENCY,P99_LATENCY,MEAN_LATENCY,STDDEV_LATENCY
> MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET
> to 7.7.7.84 () port 0 AF_INET : first burst 0 : cpu bind
> RT_LATENCY=40545.492
> MIN_LATENCY=9834
> MAX_LATENCY=78366
> P50_LATENCY=33583
> P90_LATENCY=59000
> P99_LATENCY=69000
> MEAN_LATENCY=38364.67
> STDDEV_LATENCY=12865.26
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Tom Herbert <therbert@google.com>
> Cc: Ben Hutchings <bhutchings@solarflare.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> (cherry picked from commit c10d73671ad30f54692f7f69f0e09e75d3a8926a)
> Signed-off-by: Willy Tarreau <w@1wt.eu>

