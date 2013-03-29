Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3C2Mn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 08:43:58 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:34036 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3C2Mn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 08:43:57 -0400
Message-ID: <51558C31.1060605@linux.vnet.ibm.com>
Date: Fri, 29 Mar 2013 18:12:25 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 14/15] sched: power aware load balance
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com> <514AC7B2.7030400@linux.vnet.ibm.com> <514AD26F.9010905@intel.com> <514AE07A.10100@linux.vnet.ibm.com> <514BB452.2070906@intel.com> <514BE8AC.6000607@linux.vnet.ibm.com> <514FD801.8070403@intel.com>
In-Reply-To: <514FD801.8070403@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032912-5564-0000-0000-000007495A82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 03/25/2013 10:22 AM, Alex Shi wrote:
> On 03/22/2013 01:14 PM, Preeti U Murthy wrote:
>>>>
>>>> the value get from decay_load():
>>>>  sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
>>>> in decay_load it is possible to be set zero.
>> Yes you are right, it is possible to be set to 0, but after a very long
>> time, to be more precise, nearly 2 seconds. If you look at decay_load(),
>> if the period between last update and now has crossed (32*63),only then
>> will the runnable_avg_sum become 0, else it will simply decay.
>>
>> This means that for nearly 2seconds,consolidation of loads may not be
>> possible even after the runqueues have finished executing tasks running
>> on them.
> 
> Look into the decay_load(), since the LOAD_AVG_MAX is about 47742, so
> after 16 * 32ms, the maximum avg sum will be decay to zero. 2^16 = 65536
> 
> Yes, compare to accumulate time 345ms, the decay is not symmetry, and
> not precise, seems it has space to tune well. But it is acceptable now.
>>
>> The exact experiment that I performed was running ebizzy, with just two
>> threads. My setup was 2 socket,2 cores each,4 threads each core. So a 16
>> logical cpu machine.When I begin running ebizzy with balance policy, the
>> 2 threads of ebizzy are found one on each socket, while I would expect
>> them to be on the same socket. All other cpus, except the ones running
>> ebizzy threads are idle and not running anything on either socket.
>> I am not running any other processes.
> 
> did you try the simplest benchmark: while true; do :; done

Yeah I tried out this while true; do :; done benchmark on a vm which ran
on 2 socket, 2 cores each socket and 2 threads each core emulation.
I ran two instances of this loop with balance policy on, and it was
found that there was one instance running on each socket, rather than
both instances getting consolidated on one socket.

But when I apply the change where we do not consider rq->util if it has
no nr_running on the rq,the two instances of the above benchmark get
consolidated onto one socket.


> I am writing the v6 version which include rt_util etc. you may test on
> it after I send out. :)

Sure will do so.

Regards
Preeti U Murthy

