Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaHDEZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:25:19 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:44597 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaHDEZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:25:16 -0400
Message-ID: <1407126313.3216.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/7] locking/rwsem: enable reader opt-spinning & writer
 respin
From: Davidlohr Bueso <davidlohr@hp.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Date: Sun, 03 Aug 2014 21:25:13 -0700
In-Reply-To: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-08-03 at 22:36 -0400, Waiman Long wrote:
> This patch set improves upon the rwsem optimistic spinning patch set
> from Davidlohr to enable better performing rwsem and more aggressive
> use of optimistic spinning.
> 
> By using a microbenchmark running 1 million lock-unlock operations per
> thread on a 4-socket 40-core Westmere-EX x86-64 test machine running
> 3.16-rc7 based kernels, the following table shows the execution times
> with 2/10 threads running on different CPUs on the same socket where
> load is the number of pause instructions in the critical section:
> 
>   lock/r:w ratio # of threads	Load:Execution Time (ms)
>   -------------- ------------	------------------------
>   mutex		      2		1:530.7, 5:406.0, 10:472.7
>   mutex		     10		1:1848 , 5:2046 , 10:4394
> 
> Before patch:
>   rwsem/0:1	      2		1:339.4, 5:368.9, 10:394.0
>   rwsem/1:1	      2		1:2915 , 5:2621 , 10:2764
>   rwsem/10:1	      2		1:891.2, 5:779.2, 10:827.2
>   rwsem/0:1	     10		1:5618 , 5:5722 , 10:5683
>   rwsem/1:1	     10		1:14562, 5:14561, 10:14770
>   rwsem/10:1	     10		1:5914 , 5:5971 , 10:5912
> 
> After patch:
>   rwsem/0:1	     2		1:161.1, 5:244.4, 10:271.4
>   rwsem/1:1	     2		1:188.8, 5:212.4, 10:312.9
>   rwsem/10:1	     2		1:168.8, 5:179.5, 10:209.8
>   rwsem/0:1	    10		1:1306 , 5:1733 , 10:1998
>   rwsem/1:1	    10		1:1512 , 5:1602 , 10:2093
>   rwsem/10:1	    10		1:1267 , 5:1458 , 10:2233
> 
> % Change:
>   rwsem/0:1	     2		1:-52.5%, 5:-33.7%, 10:-31.1%
>   rwsem/1:1	     2		1:-93.5%, 5:-91.9%, 10:-88.7%
>   rwsem/10:1	     2		1:-81.1%, 5:-77.0%, 10:-74.6%
>   rwsem/0:1	    10		1:-76.8%, 5:-69.7%, 10:-64.8%
>   rwsem/1:1	    10		1:-89.6%, 5:-89.0%, 10:-85.8%
>   rwsem/10:1	    10		1:-78.6%, 5:-75.6%, 10:-62.2%

So at a very low level you see nicer results, which aren't really
translating to much of a significant impact at a higher level (aim7).

> It can be seen that there is dramatic reduction in the execution
> times. The new rwsem is now even faster than mutex whether it is all
> writers or a mixture of writers and readers.
> 
> Running the AIM7 benchmarks on the same 40-core system (HT off),
> the performance improvements on some of the workloads were as follows:
> 
>       Workload	     Before Patch	After Patch	% Change
>       --------	     ------------	-----------	--------
>   custom (200-1000)	446135		  477404	 +7.0%
>   custom (1100-2000)	449665		  484734	 +7.8%
>   high_systime		152437		  154217	 +1.2%
>    (200-1000)
>   high_systime		269695		  278942	 +3.4%
>    (1100-2000)

I worry about complicating rwsems even _more_ than they are, specially
for such a marginal gain. You might want to try other workloads -- ie:
postgresql (pgbench), I normally get pretty useful data when dealing
with rwsems.

