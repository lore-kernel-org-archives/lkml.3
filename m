Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaFDFfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 01:35:33 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:2928 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101AbaFDFfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 01:35:32 -0400
X-IronPort-AV: E=Sophos;i="4.98,970,1392134400"; 
   d="scan'208";a="31422189"
Message-ID: <538EAD90.9000706@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 13:24:32 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
CC: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, <linux-aio@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hanging aio process
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett> <20140519180851.GD2915@kvack.org> <alpine.LFD.2.11.1405200950480.1606@denkbrett> <alpine.LFD.2.11.1405201508450.1606@denkbrett> <CAOMFOmWfQ2naF+1BE0wSQXpBoyxV6MPm021hY77B4sDpZNZ-Dw@mail.gmail.com> <alpine.LFD.2.11.1405201945280.1631@denkbrett> <CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com> <alpine.LFD.2.11.1405210954110.1579@denkbrett> <alpine.LFD.2.11.1405211042350.1579@denkbrett>  <CAOMFOmXXHBicH38onWgVAWhEXe2sE_RMiJXi=iMjJB15o7mOLQ@mail.gmail.com> <alpine.LFD.2.11.1405211643180.1579@denkbrett>
In-Reply-To: <alpine.LFD.2.11.1405211643180.1579@denkbrett>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,
What's the status of this issue? Has it been fixed?

Thanks,
Gu

On 05/21/2014 10:57 PM, Sebastian Ott wrote:

> On Wed, 21 May 2014, Anatol Pomozov wrote:
>> On Wed, May 21, 2014 at 1:48 AM, Sebastian Ott
>> <sebott@linux.vnet.ibm.com> wrote:
>>> On Wed, 21 May 2014, Sebastian Ott wrote:
>>>> On Tue, 20 May 2014, Anatol Pomozov wrote:
>>>>> On Tue, May 20, 2014 at 11:09 AM, Sebastian Ott
>>>>> <sebott@linux.vnet.ibm.com> wrote:
>>>>>> On Tue, 20 May 2014, Anatol Pomozov wrote:
>>>>>>> On Tue, May 20, 2014 at 6:16 AM, Sebastian Ott
>>>>>>> <sebott@linux.vnet.ibm.com> wrote:
>>>>>>>> On Tue, 20 May 2014, Sebastian Ott wrote:
>>>>>>>>> On Mon, 19 May 2014, Benjamin LaHaise wrote:
>>>>>>>>>> It is entirely possible the bug isn't
>>>>>>>>>> caused by the referenced commit, as the commit you're pointing to merely
>>>>>>>>>> makes io_destroy() syscall wait for all aio outstanding to complete
>>>>>>>>>> before returning.
>>>>>>>>>
>>>>>>>>> I cannot reproduce this when I revert said commit (on top of 14186fe). If
>>>>>>>>> that matters - the arch is s390.
>>>>>>>>
>>>>>>>> Hm, ok - maybe that commit is really just highlighting a refcounting bug.
>>>>>>>> I just compared traces for a good and a few bad cases. The good case:
>>>>>>>> # tracer: function
>>>>>>>> #
>>>>>>>> # entries-in-buffer/entries-written: 16/16   #P:4
>>>>>>>> #
>>>>>>>> #                              _-----=> irqs-off
>>>>>>>> #                             / _----=> need-resched
>>>>>>>> #                            | / _---=> hardirq/softirq
>>>>>>>> #                            || / _--=> preempt-depth
>>>>>>>> #                            ||| /     delay
>>>>>>>> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>>>>>>>> #              | |       |   ||||       |         |
>>>>>>>>              fio-732   [003] ....    17.989315: kill_ioctx <-SyS_io_destroy
>>>>>>>>              fio-739   [003] ....    18.000563: kill_ioctx <-SyS_io_destroy
>>>>>>>>      ksoftirqd/3-19    [003] ..s.    18.031673: free_ioctx_users <-percpu_ref_kill_rcu
>>>>>>>>      ksoftirqd/3-19    [003] ..s.    18.031679: free_ioctx_users <-percpu_ref_kill_rcu
>>>>>>>>              fio-737   [003] ....    18.038765: kill_ioctx <-SyS_io_destroy
>>>>>>>>      ksoftirqd/3-19    [003] ..s.    18.062488: free_ioctx_reqs <-percpu_ref_kill_rcu
>>>>>>>>      ksoftirqd/3-19    [003] ..s.    18.062494: free_ioctx_reqs <-percpu_ref_kill_rcu
>>>>>>>>      kworker/3:1-57    [003] ....    18.062499: free_ioctx <-process_one_work
>>>>>>>>      kworker/3:1-57    [003] ....    18.062506: free_ioctx <-process_one_work
>>>>>>>>      ksoftirqd/3-19    [003] ..s.    18.072275: free_ioctx_users <-percpu_ref_kill_rcu
>>>>>>>>              fio-738   [003] ....    18.102419: kill_ioctx <-SyS_io_destroy
>>>>>>>>           <idle>-0     [003] .ns.    18.111668: free_ioctx_reqs <-percpu_ref_kill_rcu
>>>>>>>>      kworker/3:1-57    [003] ....    18.111675: free_ioctx <-process_one_work
>>>>>>>>      ksoftirqd/3-19    [003] ..s.    18.138035: free_ioctx_users <-percpu_ref_kill_rcu
>>>>>>>>           <idle>-0     [003] .ns.    18.191665: free_ioctx_reqs <-percpu_ref_kill_rcu
>>>>>>>>      kworker/3:1-57    [003] ....    18.191671: free_ioctx <-process_one_work
>>>>>>>>
>>>>>>>> (4 fio workers, free_ioctx_reqs is called 4 times)
>>>>>>>>
>>>>>>>> One of the bad cases:
>>>>>>>> # tracer: function
>>>>>>>> #
>>>>>>>> # entries-in-buffer/entries-written: 14/14   #P:4
>>>>>>>> #
>>>>>>>> #                              _-----=> irqs-off
>>>>>>>> #                             / _----=> need-resched
>>>>>>>> #                            | / _---=> hardirq/softirq
>>>>>>>> #                            || / _--=> preempt-depth
>>>>>>>> #                            ||| /     delay
>>>>>>>> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>>>>>>>> #              | |       |   ||||       |         |
>>>>>>>>              fio-834   [000] ....    51.127359: kill_ioctx <-SyS_io_destroy
>>>>>>>>           <idle>-0     [000] ..s.    51.170237: free_ioctx_users <-percpu_ref_kill_rcu
>>>>>>>>              fio-828   [001] ....    51.189717: kill_ioctx <-SyS_io_destroy
>>>>>>>>              fio-833   [001] ..s.    51.220178: free_ioctx_users <-percpu_ref_kill_rcu
>>>>>>>>           <idle>-0     [000] .ns.    51.220230: free_ioctx_reqs <-percpu_ref_kill_rcu
>>>>>>>>      kworker/0:3-661   [000] ....    51.220238: free_ioctx <-process_one_work
>>>>>>>>           <idle>-0     [001] .ns.    51.260188: free_ioctx_reqs <-percpu_ref_kill_rcu
>>>>>>>>      kworker/1:2-103   [001] ....    51.260198: free_ioctx <-process_one_work
>>>>>>>>              fio-833   [002] ....    51.287602: kill_ioctx <-SyS_io_destroy
>>>>>>>>            udevd-868   [002] ..s1    51.332519: free_ioctx_users <-percpu_ref_kill_rcu
>>>>>>>>           <idle>-0     [002] .ns.    51.450180: free_ioctx_reqs <-percpu_ref_kill_rcu
>>>>>>>>      kworker/2:2-191   [002] ....    51.450191: free_ioctx <-process_one_work
>>>>>>>>              fio-835   [003] ....    51.907530: kill_ioctx <-SyS_io_destroy
>>>>>>>>      ksoftirqd/3-19    [003] ..s.    52.000232: free_ioctx_users <-percpu_ref_kill_rcu
>>>>>>>>
>>>>>>>> (1 fio worker in D state, free_ioctx_reqs is called 3 times)
>>>>>>>
>>>>>>>
>>>>>>> Looking at the second trace: the first 3 io_destroy() calls cause
>>>>>>> free_ioctx_reqs(), but the last one does not call free_ioctx_reqs().
>>>>>>> Do you have more logs after the last line?
>>>>>>
>>>>>> Nope that was all.
>>>>>>
>>>>>>> If there is no more
>>>>>>> free_ioctx_reqs() then it means something keeps ctx->reqs refcounter.
>>>>>>> I suggest to add some logging to kernel to figure out what is the
>>>>>>> refcount value at this moment.
>>>>>>
>>>>>> Jep, I did that this morning (via atomic_read(&ctx->reqs.count) in
>>>>>> free_ioctx_users before percpu_ref_kill(&ctx->reqs); is called) and
>>>>>> the value was always the same
>>>>>>         1 + (1UL << 31)
>>>>>> even for the free_ioctx_users invocations that were not followed by
>>>>>> free_ioctx_reqs.
>>>>>
>>>>> Could you add atomic_read(&ctx->reqs.count) *after* the
>>>>> percpu_ref_kill(&ctx->reqs)?
>>>>
>>>> I already did that and it didn't change, always 1 + (1UL << 31) in all
>>>> cases, before and after percpu_ref_kill(&ctx->reqs). I'm not really
>>>> familiar with this percpu_ref stuff but it looks like the initial
>>>> reference is dropped asynchronous.
>>>
>>>
>>> cat /sys/kernel/debug/tracing/trace
>>> # tracer: function
>>> #
>>> # entries-in-buffer/entries-written: 25/25   #P:4
>>> #
>>> #                              _-----=> irqs-off
>>> #                             / _----=> need-resched
>>> #                            | / _---=> hardirq/softirq
>>> #                            || / _--=> preempt-depth
>>> #                            ||| /     delay
>>> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>>> #              | |       |   ||||       |         |
>>>              fio-856   [001] ....   160.876428: SyS_io_destroy: 0000000074a18000
>>>              fio-856   [001] ....   160.876430: kill_ioctx <-SyS_io_destroy
>>>              fio-855   [000] ....   160.887737: SyS_io_destroy: 0000000074f40600
>>>              fio-855   [000] ....   160.887738: kill_ioctx <-SyS_io_destroy
>>>              fio-849   [001] ..s.   160.911948: free_ioctx_users <-percpu_ref_kill_rcu
>>>      ksoftirqd/0-3     [000] ..s.   160.932488: free_ioctx_users <-percpu_ref_kill_rcu
>>>              fio-854   [001] ....   160.938881: SyS_io_destroy: 0000000074ac0600
>>>              fio-854   [001] ....   160.938881: kill_ioctx <-SyS_io_destroy
>>>      ksoftirqd/1-11    [001] ..s.   160.942016: aio_confirm_reqs: 0000000074a18000 reqs=1
>>>      ksoftirqd/1-11    [001] ..s.   160.942016: free_ioctx_reqs <-percpu_ref_kill_rcu
>>>      kworker/1:2-465   [001] ....   160.942021: free_ioctx <-process_one_work
>>>              fio-856   [002] ....   160.942033: SyS_io_destroy: 0000000074a18000 done
>>>              fio-849   [002] ....   160.942641: SyS_io_destroy: 0000000074f28600
>>>              fio-849   [002] ....   160.942641: kill_ioctx <-SyS_io_destroy
>>>      ksoftirqd/1-11    [001] ..s.   160.961981: free_ioctx_users <-percpu_ref_kill_rcu
>>>           <idle>-0     [000] .ns.   160.962010: aio_confirm_reqs: 0000000074f40600 reqs=1
>>>           <idle>-0     [000] .ns.   160.962011: free_ioctx_reqs <-percpu_ref_kill_rcu
>>>      kworker/0:0-4     [000] ....   160.962016: free_ioctx <-process_one_work
>>>              fio-855   [001] ....   160.962017: SyS_io_destroy: 0000000074f40600 done
>>>      ksoftirqd/2-15    [002] ..s.   160.971998: free_ioctx_users <-percpu_ref_kill_rcu
>>>      ksoftirqd/1-11    [001] ..s.   160.994552: aio_confirm_reqs: 0000000074ac0600 reqs=2
>>
>> Here it is. aio context 0000000074ac0600 has refcount == 2 (one for
>> initial refcount and one grabbed by someone). You need to find the one
>> who grabbed the refcount and figure out why it does not drop it.
> 
> I (hopefully) traced all gets and puts (of ctx->reqs). Hm gets and puts
> are equal in numbers:
> 
> cat /sys/kernel/debug/tracing/trace | grep aio_complete | wc
>   49120  294720 3487520
> cat /sys/kernel/debug/tracing/trace | grep do_io_submit | wc
>   49120  294720 3487520
> 
> cat /sys/kernel/debug/tracing/trace | grep -v aio_complete | grep -v do_io_submit
> # tracer: function
> #
> # entries-in-buffer/entries-written: 98273/98273   #P:4
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>              fio-793   [002] ....    86.697232: SyS_io_setup: get_reqs
>              fio-794   [000] ....    86.697232: SyS_io_setup: get_reqs
>              fio-788   [003] ....    86.697235: SyS_io_setup: get_reqs
>              fio-795   [001] ....    86.697237: SyS_io_setup: get_reqs
>              fio-793   [000] ....    87.217093: SyS_io_destroy: 00000000796d0000
>              fio-793   [000] ....    87.217095: kill_ioctx <-SyS_io_destroy
>              fio-795   [003] ....    87.221408: SyS_io_destroy: 000000007a038000
>              fio-795   [003] ....    87.221409: kill_ioctx <-SyS_io_destroy
>              fio-788   [003] ....    87.226725: SyS_io_destroy: 00000000796c8000
>              fio-788   [003] ....    87.226726: kill_ioctx <-SyS_io_destroy
>              fio-794   [000] ....    87.227840: SyS_io_destroy: 0000000079420000
>              fio-794   [000] ....    87.227841: kill_ioctx <-SyS_io_destroy
>      ksoftirqd/3-19    [003] ..s.    87.244201: free_ioctx_users <-percpu_ref_kill_rcu
>      ksoftirqd/3-19    [003] ..s.    87.244201: free_ioctx_users: put_reqs
>      ksoftirqd/3-19    [003] ..s.    87.244205: free_ioctx_users <-percpu_ref_kill_rcu
>      ksoftirqd/3-19    [003] ..s.    87.244205: free_ioctx_users: put_reqs
>      ksoftirqd/0-3     [000] ..s.    87.251898: free_ioctx_users <-percpu_ref_kill_rcu
>      ksoftirqd/0-3     [000] ..s.    87.251898: free_ioctx_users: put_reqs
>      ksoftirqd/0-3     [000] ..s.    87.251903: free_ioctx_users <-percpu_ref_kill_rcu
>      ksoftirqd/0-3     [000] ..s.    87.251903: free_ioctx_users: put_reqs
>      ksoftirqd/0-3     [000] ..s.    87.271868: aio_confirm_reqs: 00000000796d0000 reqs=1
>      ksoftirqd/0-3     [000] ..s.    87.271868: free_ioctx_reqs <-percpu_ref_kill_rcu
>      ksoftirqd/0-3     [000] ..s.    87.271874: aio_confirm_reqs: 0000000079420000 reqs=6
>      kworker/0:1-53    [000] ....    87.271875: free_ioctx <-process_one_work
>              fio-793   [001] ....    87.271879: SyS_io_destroy: 00000000796d0000 done
>      ksoftirqd/3-19    [003] ..s.    87.271899: aio_confirm_reqs: 000000007a038000 reqs=1
>      ksoftirqd/3-19    [003] ..s.    87.271899: free_ioctx_reqs <-percpu_ref_kill_rcu
>              fio-795   [000] ....    87.271904: SyS_io_destroy: 000000007a038000 done
>      ksoftirqd/3-19    [003] ..s.    87.271905: aio_confirm_reqs: 00000000796c8000 reqs=1
>      ksoftirqd/3-19    [003] ..s.    87.271905: free_ioctx_reqs <-percpu_ref_kill_rcu
>      kworker/3:2-222   [003] ....    87.271909: free_ioctx <-process_one_work
>      kworker/3:2-222   [003] ....    87.271912: free_ioctx <-process_one_work
>              fio-788   [003] ....    87.271920: SyS_io_destroy: 00000000796c8000 done
> 
> Hm..this time 5 additional refs. Again I've never worked with these percpu
> refs but would it make sense to look for gets after kills (or is this
> valid)?
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index a0ed6c7..6f83c11 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -521,6 +521,13 @@ static void free_ioctx_reqs(struct percpu_ref *ref)
>  	schedule_work(&ctx->free_work);
>  }
>  
> +void aio_confirm_reqs(struct percpu_ref *ref)
> +{
> +	struct kioctx *ctx = container_of(ref, struct kioctx, reqs);
> +
> +	trace_printk("%p reqs=%d\n", ctx, atomic_read(&ref->count));
> +}
> +
>  /*
>   * When this function runs, the kioctx has been removed from the "hash table"
>   * and ctx->users has dropped to 0, so we know no more kiocbs can be submitted -
> @@ -543,7 +550,8 @@ static void free_ioctx_users(struct percpu_ref *ref)
>  
>  	spin_unlock_irq(&ctx->ctx_lock);
>  
> -	percpu_ref_kill(&ctx->reqs);
> +	percpu_ref_kill_and_confirm(&ctx->reqs, aio_confirm_reqs);
> +	trace_printk("put_reqs\n");
>  	percpu_ref_put(&ctx->reqs);
>  }
>  
> @@ -695,6 +703,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
>  	spin_unlock(&aio_nr_lock);
>  
>  	percpu_ref_get(&ctx->users);	/* io_setup() will drop this ref */
> +	trace_printk("get_reqs\n");
>  	percpu_ref_get(&ctx->reqs);	/* free_ioctx_users() will drop this */
>  
>  	err = ioctx_add_table(ctx, mm);
> @@ -888,6 +897,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
>  	if (unlikely(!req))
>  		goto out_put;
>  
> +	trace_printk("get_reqs\n");
>  	percpu_ref_get(&ctx->reqs);
>  
>  	req->ki_ctx = ctx;
> @@ -1033,6 +1043,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
>  	if (waitqueue_active(&ctx->wait))
>  		wake_up(&ctx->wait);
>  
> +	trace_printk("put_reqs\n");
>  	percpu_ref_put(&ctx->reqs);
>  }
>  EXPORT_SYMBOL(aio_complete);
> @@ -1220,6 +1231,8 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
>  		struct completion requests_done =
>  			COMPLETION_INITIALIZER_ONSTACK(requests_done);
>  
> +		trace_printk("%p\n", ioctx);
> +
>  		/* Pass requests_done to kill_ioctx() where it can be set
>  		 * in a thread-safe way. If we try to set it here then we have
>  		 * a race condition if two io_destroy() called simultaneously.
> @@ -1232,6 +1245,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
>  		 * is destroyed.
>  		 */
>  		wait_for_completion(&requests_done);
> +		trace_printk("%p done\n", ioctx);
>  
>  		return 0;
>  	}
> @@ -1457,6 +1471,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  	return 0;
>  out_put_req:
>  	put_reqs_available(ctx, 1);
> +	trace_printk("put_reqs\n");
>  	percpu_ref_put(&ctx->reqs);
>  	kiocb_free(req);
>  	return ret;
> @@ -1512,6 +1527,10 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>  	blk_finish_plug(&plug);
>  
>  	percpu_ref_put(&ctx->users);
> +
> +	if (i != nr)
> +		pr_warn("nr=%d i=%d\n", nr, i);
> +
>  	return i ? i : ret;
>  }
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
> .
> 


