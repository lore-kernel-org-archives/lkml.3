Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaFBJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:26:16 -0400
Received: from srv01.voixit.com ([78.47.68.188]:38923 "EHLO srv01.voixit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbaFBJ0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:26:13 -0400
Subject: Re: [PATCH RFC - TAKE TWO - 11/12] block, bfq: boost the throughput on NCQ-capable flash-based devices
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
From: Paolo Valente <paolo.valente@unimore.it>
In-Reply-To: <20140531115216.GB5057@htj.dyndns.org>
Date: Mon, 2 Jun 2014 11:26:07 +0200
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <36BFDB73-AEC2-4B87-9FD6-205E9431E722@unimore.it>
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <1401354343-5527-12-git-send-email-paolo.valente@unimore.it> <20140531115216.GB5057@htj.dyndns.org>
To: Tejun Heo <tj@kernel.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il giorno 31/mag/2014, alle ore 13:52, Tejun Heo <tj@kernel.org> ha scritto:

> Hello, Paolo.
> 
> So, I've actually looked at the code.  Here are some questions.
> 
> On Thu, May 29, 2014 at 11:05:42AM +0200, Paolo Valente wrote:
>> + * 1) all active queues have the same weight,
>> + * 2) all active groups at the same level in the groups tree have the same
>> + *    weight,
>> + * 3) all active groups at the same level in the groups tree have the same
>> + *    number of children.
> 
> 3) basically disables it whenever blkcg is used.  Might as well just
> skip the whole thing if there are any !root cgroups.  It's only
> theoretically interesting.

It is easier for me to reply to this, and the other related comments, cumulatively below.

> 
>> static inline bool bfq_bfqq_must_not_expire(struct bfq_queue *bfqq)
>> {
>> 	struct bfq_data *bfqd = bfqq->bfqd;
> 
> 	bool symmetric_scenario, expire_non_wr;
> 
>> +#ifdef CONFIG_CGROUP_BFQIO
>> +#define symmetric_scenario	  (!bfqd->active_numerous_groups && \
>> +				   !bfq_differentiated_weights(bfqd))
> 
> 	symmetric_scenario = xxx;
> 
>> +#else
>> +#define symmetric_scenario	  (!bfq_differentiated_weights(bfqd))
> 
> 	symmetric_scenario = yyy;
> 
>> +#endif
>> /*
>>  * Condition for expiring a non-weight-raised queue (and hence not idling
>>  * the device).
>>  */
>> #define cond_for_expiring_non_wr  (bfqd->hw_tag && \
>> -				   bfqd->wr_busy_queues > 0)
>> +				   (bfqd->wr_busy_queues > 0 || \
>> +				    (symmetric_scenario && \
>> +				     blk_queue_nonrot(bfqd->queue))))
> 
> 	expire_non_wr = zzz;
> 

The solution you propose is the first that came to my mind. But then I went for a clumsy macro-based solution because: 1) the whole function is all about evaluating a long logical expression, 2) the macro-based solution allows the short-circuit to be used at best, and the number of steps to be minimized. For example, with async queues, only one condition is evaluated.

Defining three variables entails instead that the value of all the variables is computed every time, even if most of the times there is no need to.

Would this gain be negligible (sorry for my ignorance), or would not it be however enough to justify these unusual macros?

>> 
>> 	return bfq_bfqq_sync(bfqq) && (
>> 		bfqq->wr_coeff > 1 ||
>> /**
>> + * struct bfq_weight_counter - counter of the number of all active entities
>> + *                             with a given weight.
>> + * @weight: weight of the entities that this counter refers to.
>> + * @num_active: number of active entities with this weight.
>> + * @weights_node: weights tree member (see bfq_data's @queue_weights_tree
>> + *                and @group_weights_tree).
>> + */
>> +struct bfq_weight_counter {
>> +	short int weight;
>> +	unsigned int num_active;
>> +	struct rb_node weights_node;
>> +};
> 
> This is way over-engineered.  In most cases, the only time you get the
> same weight on all IO issuers would be when everybody is on the
> default ioprio so might as well simply count the number of non-default
> ioprios.  It'd be one integer instead of a tree of counters.
> 

Reply below.

>> @@ -306,6 +322,22 @@ enum bfq_device_speed {
>>  * @rq_pos_tree: rbtree sorted by next_request position, used when
>>  *               determining if two or more queues have interleaving
>>  *               requests (see bfq_close_cooperator()).
>> + * @active_numerous_groups: number of bfq_groups containing more than one
>> + *                          active @bfq_entity.
> 
> You can safely assume that on any system which uses blkcg, the above
> counter is >1.
> 
> This optimization may be theoretically interesting but doesn't seem
> practical at all and would make the sytem behave distinctively
> differently depending on something which is extremely subtle and seems
> completely unrelated.  Furthermore, on any system which uses blkcg,
> ext4, btrfs or has any task which has non-zero nice value, it won't
> make any difference.  Its value is only theoretical.
> 

Turning on idling unconditionally when blkcg is used, is one of the first solutions we have considered. But there seem to be practical scenarios where this would cause an unjustified loss of throughput. The main example for us was ulatencyd, which AFAIK creates one group for each process and, by default, assigns to all processes the same weight. But the assigned weight is not the one associated to the default ioprio.

I do not know how widespread a mechanism like ulatencyd is precisely, but in the symmetric scenario it creates, the throughput on, e.g., an HDD would drop by half if the workload is mostly random and we removed the more complex mechanism we set up.
Wouldn't this be bad?

> Another thing to consider is that virtually all remotely modern
> devices, rotational or not, are queued. At this point, it's rather
> pointless to design one behavior for !queued and another for queued.
> Things should just be designed for queued devices.

I am sorry for expressing doubts again (mainly because of my ignorance), but a few months ago I had to work with some portable devices for a company specialized in ARM systems. As an HDD, they were using a Toshiba MK6006GAH. If I remember well, this device had no NCQ. Instead of the improvements that we obtained by using bfq with this slow device, removing the differentiated behavior of bfq with respect to queued/!queued devices would have caused just a loss of throughput.

>  I don't know what
> the solution is but given that the benefits of NCQ for rotational
> devices is extremely limited, sticking with single request model in
> most cases and maybe allowing queued operation for specific workloads
> might be a better approach.  As for ssds, just do something simple.
> It's highly likely that most ssds won't travel this code path in the
> near future anyway.

This is the point that worries me mostly. As I pointed out in one of my previous emails, dispatching requests to an SSD  without control causes high latencies, or even complete unresponsiveness (Figure 8 in
http://algogroup.unimore.it/people/paolo/disk_sched/extra_results.php
or Figure 9 in
http://algogroup.unimore.it/people/paolo/disk_sched/results.php).

I am of course aware that efficiency is a critical issue with fast devices, and is probably destined to become more and more critical in the future. But, as a user, I would be definitely unhappy with a system that can, e.g., update itself in one minute instead of five, but, during that minute may become unresponsive. In particular, I would not be pleased to buy a more expensive SSD and get a much less responsive system than that I had with a cheaper HDD and bfq fully working.

Thanks,
Paolo

> 
> Thanks.
> 
> -- 
> tejun


--
Paolo Valente                                                 
Algogroup
Dipartimento di Fisica, Informatica e Matematica		
Via Campi, 213/B
41125 Modena - Italy        				  
homepage:  http://algogroup.unimore.it/people/paolo/

