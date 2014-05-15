Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaEODqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:46:19 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38666 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaEODqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:46:17 -0400
Message-ID: <5374387E.4080802@linux.vnet.ibm.com>
Date: Thu, 15 May 2014 11:46:06 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <537192D3.5030907@linux.vnet.ibm.com> <20140513094737.GU30445@twins.programming.kicks-ass.net> <53721FD4.6060300@redhat.com> <20140513142328.GE2485@laptop.programming.kicks-ass.net> <53731D12.7040804@linux.vnet.ibm.com> <20140514094426.GF30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140514094426.GF30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051503-0260-0000-0000-000004F2BF56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 05:44 PM, Peter Zijlstra wrote:
[snip]
>> and then:
>> 	echo $$ > /sys/fs/cgroup/cpu/A/tasks ; ./my_tool -l
>> 	echo $$ > /sys/fs/cgroup/cpu/B/tasks ; ./my_tool -l
>> 	echo $$ > /sys/fs/cgroup/cpu/C/tasks ; ./my_tool 50
>>
>> the results in top is around:
>>
>> 		A	B	C
>> 	CPU%	550	550	100
> 
> top doesn't do per-cgroup accounting, so how do you get these numbers,
> per the above all instances of the prog are also called the same,
> further making it error prone and difficult to get sane numbers.

Oh, my bad to make it confusing, I myself was checking the PID of my_tool
instant inside top, like:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
24968 root      20   0 55600  720  648 S 558.1  0.0   2:08.76 my_tool           
24984 root      20   0 55600  720  648 S 536.2  0.0   1:10.29 my_tool           
25001 root      20   0 55600  720  648 S 88.6  0.0   0:04.39 my_tool

By 'cat /sys/fs/cgroup/cpu/C/tasks' I got the PID of './my_tool 50' is
25001, and all it's pthread's %CPU was count in, could we check like
that?

> 
> 
[snip]
>> void consume(int spin, int total)
>> {
>> 	unsigned long long begin, now;
>> 	begin = stamp();
>>
>> 	for (;;) {
>> 		pthread_mutex_lock(&my_mutex);
>> 		now = stamp();
>> 		if ((long long)(now - begin) > spin) {
>> 			pthread_mutex_unlock(&my_mutex);
>> 			usleep(total - spin);
>> 			pthread_mutex_lock(&my_mutex);
>> 			begin += total;
>> 		}
>> 		pthread_mutex_unlock(&my_mutex);
>> 	}
>> }
> 
> Uh,.. that's just insane.. what's the point of having a multi-threaded
> program do busy-wait loops if you then serialize the lot on a global
> mutex such that only 1 thread can run at any one time?
> 
> How can one such prog ever consume more than 100% cpu.

That's a good point... however the top show that when only './my_tool 50'
25001 running, it used around 300%, like below:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
25001 root      20   0 55600  720  648 S 284.3  0.0   5:18.00 my_tool           
 2376 root      20   0  950m  85m  29m S  4.4  0.2 163:47.94 python             
 1658 root      20   0 1013m  19m  11m S  3.0  0.1  97:06.11 libvirtd

IMHO, if pthread-mutex was similar like the kernel one's behaviour, then
it may not going to sleep when it's the only one running on CPU.

Oh, I think we got the reason here, when there are other task running,
mutex will going to sleep and the %CPU dropped to serialized case that is
around 100%.

But for the dbench, stress combination, that's not spin-wasted, dbench
throughput do dropped, how could we explain that one?

Regards,
Michael Wang

> 

