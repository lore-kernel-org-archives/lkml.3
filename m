Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaFXDfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 23:35:08 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37113 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaFXDfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 23:35:06 -0400
Message-ID: <53A8F1DE.2060908@linux.vnet.ibm.com>
Date: Tue, 24 Jun 2014 11:34:54 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com> <20140623094251.GS19860@laptop.programming.kicks-ass.net>
In-Reply-To: <20140623094251.GS19860@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062403-9264-0000-0000-0000065FC2AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 05:42 PM, Peter Zijlstra wrote:
[snip]
>> +}
> 
> Still completely hate this, it doesn't make sense conceptual sense what
> so ever.

Yeah... and now I agree your opinion that this could not address all the
cases after all the testing these days...

Just wondering could we make this another scheduler feature?

I mean by logical, this will make tasks spread on each CPU inside
task-group, meanwhile follow the load-balance decision, the testing show
that the patch achieved that goal well.

Currently the scheduler haven't provide a good way to achieve that, correct?

And it do help a lot in our testing for workload like dbench and
transaction workload when they are fighting with stress likely workload,
combined with GENTLE_FAIR_SLEEPERS, we could make the cpu-shares works
again, here is some real numbers of 'dbench 6 -t 60' in our testing:

Without the patch:

 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 NTCreateX    1281241     0.036    62.872
 Close         941274     0.002    13.298
 Rename         54249     0.120    19.340
 Unlink        258686     0.156    37.155
 Deltree           36     8.514    41.904
 Mkdir             18     0.003     0.003
 Qpathinfo    1161327     0.016    40.130
 Qfileinfo     203648     0.001     7.118
 Qfsinfo       212896     0.004    11.084
 Sfileinfo     104385     0.067    55.990
 Find          448958     0.033    23.150
 WriteX        639464     0.069    55.452
 ReadX        2008086     0.009    24.466
 LockX           4174     0.012    14.127
 UnlockX         4174     0.006     7.357
 Flush          89787     1.533    56.925

Throughput 666.318 MB/sec  6 clients  6 procs  max_latency=62.875 ms


With the patch applied:

 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 NTCreateX    2601876     0.025    52.339
 Close        1911248     0.001     0.133
 Rename        110195     0.080     6.739
 Unlink        525476     0.070    52.359
 Deltree           62     6.143    19.919
 Mkdir             31     0.003     0.003
 Qpathinfo    2358482     0.009    52.355
 Qfileinfo     413190     0.001     0.092
 Qfsinfo       432513     0.003     0.790
 Sfileinfo     211934     0.027    13.830
 Find          911874     0.021     5.969
 WriteX       1296646     0.038    52.348
 ReadX        4079453     0.006    52.247
 LockX           8476     0.003     0.050
 UnlockX         8476     0.001     0.045
 Flush         182342     0.536    55.953

Throughput 1360.74 MB/sec  6 clients  6 procs  max_latency=55.970 ms

And the share works normally, the CPU% resources was managed well again.

So could we provide a feature like:

	SCHED_FEAT(TG_INTERNAL_BALANCE, false)

I do believe there are more cases could benefit from it, for those who
don't want too many wake-affine and want group-tasks more balanced on
each CPU, scheduler could provide this as an option then, shall we?

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

