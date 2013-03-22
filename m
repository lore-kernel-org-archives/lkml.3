Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3CVFQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 01:16:00 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53078 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3CVFP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 01:15:59 -0400
Message-ID: <514BE8AC.6000607@linux.vnet.ibm.com>
Date: Fri, 22 Mar 2013 10:44:20 +0530
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
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com> <514AC7B2.7030400@linux.vnet.ibm.com> <514AD26F.9010905@intel.com> <514AE07A.10100@linux.vnet.ibm.com> <514BB452.2070906@intel.com>
In-Reply-To: <514BB452.2070906@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032205-5816-0000-0000-000007388420
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/22/2013 07:00 AM, Alex Shi wrote:
> On 03/21/2013 06:27 PM, Preeti U Murthy wrote:
>>>> did you close all of background system services?
>>>> In theory the rq->avg.runnable_avg_sum should be zero if there is no
>>>> task a bit long, otherwise there are some bugs in kernel.
>> Could you explain why rq->avg.runnable_avg_sum should be zero? What if
>> some kernel thread ran on this run queue and is now finished? Its
>> utilisation would be say x.How would that ever drop to 0,even if nothing
>> ran on it later?
> 
> the value get from decay_load():
>  sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
> in decay_load it is possible to be set zero.

Yes you are right, it is possible to be set to 0, but after a very long
time, to be more precise, nearly 2 seconds. If you look at decay_load(),
if the period between last update and now has crossed (32*63),only then
will the runnable_avg_sum become 0, else it will simply decay.

This means that for nearly 2seconds,consolidation of loads may not be
possible even after the runqueues have finished executing tasks running
on them.

The exact experiment that I performed was running ebizzy, with just two
threads. My setup was 2 socket,2 cores each,4 threads each core. So a 16
logical cpu machine.When I begin running ebizzy with balance policy, the
2 threads of ebizzy are found one on each socket, while I would expect
them to be on the same socket. All other cpus, except the ones running
ebizzy threads are idle and not running anything on either socket.
I am not running any other processes.

You could run a similar experiment and let me know if you see otherwise.
I am at a loss to understand why else would such a spreading of load
occur, if not for the rq->util not becoming 0 quickly,when it is not
running anything. I have used trace_printks to keep track of runqueue
util of those runqueues not running anything after maybe some initial
load and it does not become 0 till the end of the run.

Regards
Preeti U Murthy


> 
> and /proc/sched_debug also approve this:
> 
>   .tg_runnable_contrib           : 0
>   .tg->runnable_avg              : 50
>   .avg->runnable_avg_sum         : 0
>   .avg->runnable_avg_period      : 47507
> 
> 

