Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab3EIF33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:29:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:7995 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3EIF32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:29:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,638,1363158000"; 
   d="scan'208";a="334120510"
Message-ID: <518B342C.4030808@intel.com>
Date: Thu, 09 May 2013 13:29:16 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 6/7] sched: consider runnable load average in move_tasks
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-7-git-send-email-alex.shi@intel.com> <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com> <20130506150428.GD15446@dyad.programming.kicks-ass.net> <CAPM31RKqMGAvFh1JmUjCjBo4EJWqA39i8=YPiUw8GUkG9dj7Fw@mail.gmail.com> <51888E87.2090506@intel.com> <5189ACD2.1080105@intel.com>
In-Reply-To: <5189ACD2.1080105@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 09:39 AM, Alex Shi wrote:
> On 05/07/2013 01:17 PM, Alex Shi wrote:
>>>> >> > Sorry, what I meant to say here is:
>>>> >> > If we're going to be using a runnable average based load here the
>>>> >> > fraction we take (currently instantaneous) in tg_load_down should be
>>>> >> > consistent.
>> > yes. I think so.
>> > 
>> > So, here is the patch, could you like take a look?
> The new patchset till to this patch has a bad results on kbuild. So,
> will do testing and drop some of them or all.

After added cfs_rq->blocked_load_avg consideration in balance:
kbuild decrease 6% on my all machines, core2, nhm, snb 2P/4P boxes.
aim7 dropped 2~10% on 4P boxes.
oltp also drop much on 4P box, but it is not very stable.
hackbench dropped 20% on SNB, but increase about 15% on NHM EX box.


Kbuild vmstat show without blocked_load_avg, system has much less CS.

vmstat average values on SNB 4P machine,the box has 4P * 8cores * HT.
without bloacked_load_avg
r  b  swpd free buff cache  si so   bi    bo   in  cs us sy id wa st
52 0 0 60820216 30578 2708963 0 0 2404 27841 49176 33642 61 8 29 0 0 

with blocked_load_avg:
r  b  swpd free buff cache  si so   bi    bo   in  cs us sy id wa st
52 0 0 61045626 32428 2714190 0 0 2272 26943 48923 49661 50 6 42 0 0 

aim7 with default workfile, also show less CS.
alexs@debian-alexs:~/tiptest$ cat aim7.vmstat.good
 0  0      0 64971976  11316  61352    0    0     0     9  285  589  0  0 100  0  0	
 0  0      0 64921204  11344  61452    0    0     0    16 36438 97399 15  7 78  0  0	
 1  0      0 64824712  11368  65452    0    0     0    21 71543 190097 31 15 54  0  0	
461  0      0 64569296  11384  77620    0    0     0     2 4164 2113  4  1 94  0  0	
 1  0      0 64724120  11400  66872    0    0     0    28 107881 296017 42 22 35  0  0	
124  0      0 64437332  11416  84248    0    0     0     2 9784 6339 10  4 86  0  0	
87  0      0 64224904  11424  63868    0    0     0     1 148456 462921 41 28 31  0  0	
 1  0      0 64706668  11448  62100    0    0     0    59 33134 41977 30 10 60  0  0	
32  0      0 64104320  13064  65836    0    0   324    14 75769 217348 25 16 59  0  0	
88  0      0 64444028  13080  66648    0    0     0     4 121466 338645 50 27 22  0  0	
 2  0      0 64664168  13096  64384    0    0     0    79 20383 22746 20  6 75  0  0	
40  0      0 63940308  13104  65020    0    0     0     1 103459 307360 31 20 49  0  0	
58  0      0 64197384  13124  67316    0    0     1     2 121445 317690 52 28 20  0  0	
average value:
r  b  swpd free buff cache  si so   bi    bo   in  cs us sy id wa st
68 0 0 64517724 12043 67089 0 0 25 18 65708 177018 27 14 58 0 0

alexs@debian-alexs:~/tiptest$ cat aim7.vmstat.bad 
193  1      0 64701572   8776  67604    0    0     0     2 42509 157649 11  8 81  0  0	
 0  0      0 64897084   8796  62056    0    0     0    17 15819 21496 11  3 85  0  0	
316  0      0 64451460   8812  68488    0    0     0     3 86321 292694 27 17 56  0  0	
 0  0      0 64853132   8828  61880    0    0     0    32 28989 44443 20  6 73  0  0	
82  0      0 64394268   9020  63984    0    0   174    14 74398 280771 18 14 67  0  0	
 0  0      0 64776500   9036  63752    0    0     0    47 69966 153509 39 16 45  0  0	
292  0      0 64347432   9052  74428    0    0     0     2 16542 25876 11  4 85  0  0	
340  0      0 64054336   9068  72020    0    0     0     2 132096 524224 28 26 46  0  0	
 1  0      0 64715984   9084  64440    0    0     0    62 47487 51573 41 13 46  0  0	
156  0      0 64124992   9100  73888    0    0     0     2 27755 38801 19  8 73  0  0	
326  0      0 63795768   9116  74624    0    0     0     2 138341 560004 25 26 49  0  0	
 0  0      0 64661592   9140  68796    0    0     0    96 77724 113395 58 20 22  0  0	
1951  2      0 64605544   9148  71664    0    0     0     1 1530 2094  1  0 99  0  0	
188  0      0 63856212   9164  68536    0    0     0     2 106011 361647 33 23 44  0  0	
393  0      0 63941972   9180  76520    0    0     0     3 115553 360168 41 25 34  0  0	
average value:
r  b  swpd free buff cache  si so   bi    bo   in  cs us sy id wa st
282 0 0 64411856 9021 68845 0 0 11 19 65402 199222 25 13 60 0 0 


I reviewed the cfs_rq->blocked_load_avg code path, no clear abnormal found.
Seems the blocked load avg is fit current balance rules.
Sometime the blocked load far bigger than runnable load. The blocked_load_avg 
has a long time effect(more than half weight in 32ms), that drives wakeup task to other
cpus not locate, and give unnecessary load in periodic balance, isn't it?

-- 
Thanks
    Alex
