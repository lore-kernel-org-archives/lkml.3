Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3KMDgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:36:15 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40910 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab3KMDgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:36:04 -0500
Message-ID: <5282F39E.80401@linaro.org>
Date: Tue, 12 Nov 2013 19:35:58 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [seqcount] INFO: trying to register non-static key.
References: <20131111012927.GA404@localhost> <20131111154551.GJ19203@twins.programming.kicks-ass.net> <20131112094147.GA32441@localhost> <20131112100140.GM5056@laptop.programming.kicks-ass.net> <20131112151541.GD24980@redhat.com> <20131112152956.GY5056@laptop.programming.kicks-ass.net>
In-Reply-To: <20131112152956.GY5056@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 07:29 AM, Peter Zijlstra wrote:
> On Tue, Nov 12, 2013 at 10:15:41AM -0500, Vivek Goyal wrote:
>> I see that we allocate per cpu stats but don't do any initializations.
>>
>> static void tg_stats_alloc_fn(struct work_struct *work)
>> {
>>         static struct tg_stats_cpu *stats_cpu;  /* this fn is non-reentrant */
>>         struct delayed_work *dwork = to_delayed_work(work);
>>         bool empty = false;
>>
>> alloc_stats:
>>         if (!stats_cpu) {
>>                 stats_cpu = alloc_percpu(struct tg_stats_cpu);
>>                 if (!stats_cpu) {
>>                         /* allocation failed, try again after some time */
>>                         schedule_delayed_work(dwork, msecs_to_jiffies(10));
>>                         return;
>>                 }
>>         }
>>
>>         spin_lock_irq(&tg_stats_alloc_lock);
> Absolutely!
>
> Something like this perhaps? Did I miss more blkg_[rw]stats? If I read
> the git grep output right, this was the last one.

Hey Peter,
    Thanks for chasing these issues down so fast! And sorry for my slow
response here (power outage for a chunk of the day :P) I finally got the
issue reproduced and gave your two patches a whirl, but unfortunately I
get the following bug:

[    0.728658] BUG: unable to handle kernel NULL pointer dereference at
00000008
[    0.729351] IP: [<78287084>] lockdep_init_map+0xd/0x544
[    0.729351] *pde = 00000000
[    0.729351] Oops: 0002 [#1] SMP
[    0.729351] CPU: 0 PID: 18 Comm: kworker/0:1 Not tainted
3.12.0-00185-g838cc7b-dirty #13
[    0.729351] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.729351] Workqueue: events tg_stats_alloc_fn
[    0.729351] task: 7e9e0230 ti: 7e9e6000 task.ti: 7e9e6000
[    0.729351] EIP: 0060:[<78287084>] EFLAGS: 00010216 CPU: 0
[    0.729351] EIP is at lockdep_init_map+0xd/0x544
[    0.729351] EAX: 00000004 EBX: 79d554b0 ECX: 79d554b0 EDX: 793f682a
[    0.729351] ESI: 00000004 EDI: 79d554b8 EBP: 7e9e7e90 ESP: 7e9e7e78
[    0.729351]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.729351] CR0: 8005003b CR2: 00000008 CR3: 01898000 CR4: 000006d0
[    0.729351] Stack:
[    0.729351]  0000014a 0000014b 7e9b7340 00000000 00000000 79d554b8
7e9e7eac 785fae1d
[    0.729351]  00000000 795a2a60 7e9b7340 00000000 00000000 7e9e7ef8
7826bae8 00000000
[    0.729351]  00000001 00000000 7826ba8f 7e806c00 7f08d700 795a2a60
7f08c380 795a2a60
[    0.729351] Call Trace:
[    0.729351]  [<785fae1d>] tg_stats_alloc_fn+0xe3/0x155
...

>
> ---
>  block/blk-throttle.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 8331aba9426f..fd743d98c41d 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -256,6 +256,12 @@ static struct throtl_data *sq_to_td(struct throtl_service_queue *sq)
>  	}								\
>  } while (0)
>  
> +static void tg_stats_init(struct tg_stats_cpu *tg_stats)
> +{
> +	blkg_rwstat_init(&tg_stats->service_bytes);
> +	blkg_rwstat_init(&tg_stats->serviced);
> +}
> +
>  /*
>   * Worker for allocating per cpu stat for tgs. This is scheduled on the
>   * system_wq once there are some groups on the alloc_list waiting for
> @@ -269,12 +275,16 @@ static void tg_stats_alloc_fn(struct work_struct *work)
>  
>  alloc_stats:
>  	if (!stats_cpu) {
> +		int cpu;
> +
>  		stats_cpu = alloc_percpu(struct tg_stats_cpu);
>  		if (!stats_cpu) {
>  			/* allocation failed, try again after some time */
>  			schedule_delayed_work(dwork, msecs_to_jiffies(10));
>  			return;
>  		}
> +		for_each_possible_cpu(cpu)
> +			tg_stats_init(per_cpu(stats_cpu, cpu));
It looks like this line should be per_cpu_*ptr*

With that line changed I don't trigger either the BUG or the warning
Fengguang found (btw, great work again Fengguang!).

I'll send out a net patch here that includes all the fixes in a second.

thanks
-john



