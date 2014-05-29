Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510AbaE2Or7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:47:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20308 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbaE2Or5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:47:57 -0400
Message-ID: <5387486D.20108@oracle.com>
Date: Thu, 29 May 2014 10:47:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
References: <5370EBE9.6@oracle.com> <20140514162943.GR30445@twins.programming.kicks-ass.net> <53739A9A.5010703@oracle.com> <20140514163535.GS30445@twins.programming.kicks-ass.net> <538676A7.6090306@oracle.com> <20140529075723.GA30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140529075723.GA30445@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 03:57 AM, Peter Zijlstra wrote:
> On Wed, May 28, 2014 at 07:52:07PM -0400, Sasha Levin wrote:
>> On 05/14/2014 12:35 PM, Peter Zijlstra wrote:
>>> On Wed, May 14, 2014 at 12:32:26PM -0400, Sasha Levin wrote:
>>>>> -----BEGIN PGP SIGNED MESSAGE-----
>>>>> Hash: SHA1
>>>>>
>>>>> On 05/14/2014 12:29 PM, Peter Zijlstra wrote:
>>>>>>> On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
>>>>>>>>> Hi all,
>>>>>>>>>
>>>>>>>>> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel I've stumbled on the following spew. Maybe related to the very recent change in freeing on task exit?
>>>>>>>>>
>>>>>>>>> [ 2509.827261] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC [ 2509.830379] Dumping ftrace buffer: [ 2509.830379]    (ftrace buffer empty) [ 2509.830379] Modules linked in: [ 2509.830379] CPU: 47 PID: 43306 Comm: trinity-c126 Tainted: G        W     3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
>>>>>>>
>>>>>>> Any particular trinity setup? And would you happen to have the seed of that run?
>>>>>
>>>>> Nothing special about trinity options. 400 threads and blacklisting some of the
>>>>> destructive syscalls (umount, reboot, etc).
>>>>>
>>>>> I don't have the seed, but that problem did reproduce again tonight so I can test
>>>>> out debug code if you have something in mind.
>>> Nah, I drew a pretty big blank, which is why I wanted to see if I could
>>> reproduce. If you could share your trinity cmdline I'd be much obliged.
>>> While I did manage to clone (the repo moved since last time) and build
>>> it, I'm not really that handy with it and want to avoid destroying my
>>> machine if possible ;-)
>>
>> Anything I could do to help out with this? It reproduces pretty easily on my
>> configuration so I'd be happy to test out whatever might help.
> 
> Yeah, it takes me days to test anything, and my last guess panned out to
> nothing, at which point I decided I needed to look at the things I'd
> neglected for a bit :/
> 
> Could you see if the below makes any difference? I'll try and get back
> to tracking this.
> 
> ---
>  kernel/events/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 9efb1e7858ac..851dc9dc5643 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7497,8 +7497,10 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
>  	 */
>  	mutex_lock(&child_ctx->mutex);
>  
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(child_event, &child_ctx->event_list, event_entry)
>  		__perf_event_exit_task(child_event, child_ctx, child);
> +	rcu_read_unlock();
>  
>  	mutex_unlock(&child_ctx->mutex);
>  
> 

It doesn't work out well because we later lock a mutex in sync_child_event().


Thanks,
Sasha
