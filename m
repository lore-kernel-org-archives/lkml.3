Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaLOPhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:37:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11331 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbaLOPho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:37:44 -0500
Message-ID: <548F0025.4040203@fb.com>
Date: Mon, 15 Dec 2014 10:37:09 -0500
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <bmaurer@fb.com>, <rkroll@fb.com>, <kernel-team@fb.com>,
        <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH] sched/fair: change where we report sched stats V2
References: <1418313595-14286-1-git-send-email-jbacik@fb.com> <20141215101625.GW29390@twins.programming.kicks-ass.net>
In-Reply-To: <20141215101625.GW29390@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-15_03:2014-12-15,2014-12-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=142.157825103555
 compositescore=0.140620555742602 urlsuspect_oldscore=0.140620555742602
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=8 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412150149
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 05:16 AM, Peter Zijlstra wrote:
> On Thu, Dec 11, 2014 at 10:59:55AM -0500, Josef Bacik wrote:
>> The schedule stats currently spit out once the entity is being queued, which
>> means if we have stack traces enabled we will get the stack trace of the waker,
>> not of the task being woken.  This makes the backtrace completely useless when
>> trying to track down latency spikes, as we want to know why we were put to sleep
>> for as long as we were.
>>
>> This patch moves the trace_sched_stat* calls to after the task has been put back
>> on the CPU so that the backtrace we get is the one that put us to sleep.  Mike
>> Galbraith suggested that I leave the actual stat collection stuff where it is so
>> that we don't add the scheduler latency to the sleep stats, so I've added 3 new
>> fields in the scheduler stats to keep track of the last sleep time so that if
>> any of these are set we know to trigger the trace points.  Thanks,
>>
>
> Yeah, so I don't like this, it adds overhead for everyone.
>

Only if SCHEDSTATS is enabled tho, and it's no more overhead in the 
SCHEDSTATS case than before.  Would it be more acceptable to move the 
entire callback under SCHEDSTATS?

> Also, I'm very sure this issue has been raised before, and I'm pretty
> sure the answer back then was why don't you look at the
> trace_sched_switch() site matching this wakeup?
>

This is fine for discrete problems, but when trying to find a random 
latency spike in a production workload it's impossible. If I do

trace-cmd record -e sched:sched_switch -T sleep 5

on just one of our random web servers I end up with this

du -h trace.dat
62M     trace.dat

thats 62 megs in 5 seconds.  I ran the following command for almost 2 
hours when searching for a latency spike

trace-cmd record -B latency -e sched:sched_stat_blocked -f \"delay >= 
100000\" -T -o /root/latency.dat

and got the following .dat file

du -h latency.dat
48M     latency.dat

That right there is a huge reason for this change, so I'd really like to 
do whatever it takes to get this fixed.  I'd be happy to move the 
callback under CONFIG_SCHEDSTATS to reduce any possible overhead you 
would be concerned about.  Thanks,

Josef
