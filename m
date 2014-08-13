Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaHMS7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaHMS7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:59:12 -0400
Message-ID: <53EBB520.9040807@redhat.com>
Date: Wed, 13 Aug 2014 14:57:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com>
In-Reply-To: <20140813184511.GA9663@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 02:45 PM, Oleg Nesterov wrote:
> On 08/13, Rik van Riel wrote:
>>
>> On 08/13/2014 02:08 PM, Oleg Nesterov wrote:
>>>
>>> Well, I disagree. This is more complex, and this adds yet another lock
>>> which only protects the stats...
>>
>> The other lock is what can tell us that there is a writer active
>> NOW, which may be useful when it comes to guaranteeing forward
>> progress for readers when there are lots of threads exiting...
> 
> I don't really understand why seqcount_t is better in this sense, either
> way we need to to taking the lock if we want to guarantee a forward
> progress. read_seqbegin_or_lock() doesn't even work "automagically",
> and it can't be used in this case anyway.

It allows subsequent readers to fall back into lockless mode,
once the first reader (that got blocked behind writers) takes
the lock, temporarily locking out writers.

This protects forward progress, without the danger of
permanently degrading throughput due to increased contention.

> That said, it is not that I am really sure that seqcount_t in ->signal
> is actually worse, not to mention that this is subjective anyway. IOW,
> I am not going to really fight with your approach ;)

I agree that both approaches have their advantages and
disadvantages.

>>> Whatever we do, we should convert thread_group_cputime() to use
>>> for_each_thread() first().
>>
>> What is the advantage of for_each_thread over while_each_thread,
>> besides getting rid of that t = tsk line?
> 
> It is buggy and should die, see 0c740d0afc3bff0a097ad.

I just got rid of it in the code that I touched.

Thanks for pointing it out.

