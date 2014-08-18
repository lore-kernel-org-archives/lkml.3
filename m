Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaHROEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaHROEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:04:08 -0400
Message-ID: <53F207B4.6070908@redhat.com>
Date: Mon, 18 Aug 2014 10:03:32 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>, Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com
Subject: Re: [PATCH v2 2/3] time,signal: protect resource use statistics with
 seqlock
References: <1408133138-22048-1-git-send-email-riel@redhat.com>	 <1408133138-22048-3-git-send-email-riel@redhat.com>	 <20140816141159.GA8709@redhat.com>	 <20140816134010.26a9b572@annuminas.surriel.com>	 <20140816175002.GA24994@redhat.com> <1408337089.5570.16.camel@marge.simpson.net>
In-Reply-To: <1408337089.5570.16.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 12:44 AM, Mike Galbraith wrote:
> On Sat, 2014-08-16 at 19:50 +0200, Oleg Nesterov wrote:
>> On 08/16, Rik van Riel wrote:
>>>
>>> +	do {
>>> +		seq = nextseq;
>>> +		read_seqbegin_or_lock(&sig->stats_lock, &seq);
>>> +		times->utime = sig->utime;
>>> +		times->stime = sig->stime;
>>> +		times->sum_exec_runtime = sig->sum_sched_runtime;
>>> +
>>> +		for_each_thread(tsk, t) {
>>> +			task_cputime(t, &utime, &stime);
>>> +			times->utime += utime;
>>> +			times->stime += stime;
>>> +			times->sum_exec_runtime += task_sched_runtime(t);
>>> +		}
>>> +		/* If lockless access failed, take the lock. */
>>> +		nextseq = 1;
>>
>> Yes, thanks, this answers my concerns.
>>
>> Cough... can't resist, and I still think that we should take rcu_read_lock()
>> only around for_each_thread() and the patch expands the critical section for
>> no reason. But this is minor, I won't insist.
>
> Hm.  Should traversal not also disable preemption to preserve the error
> bound Peter mentioned?

The second traversal takes the spinlock, which automatically
disables preemption.

