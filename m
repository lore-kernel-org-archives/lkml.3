Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934900AbaE3XeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:34:03 -0400
Received: from srv01.voixit.com ([78.47.68.188]:37953 "EHLO srv01.voixit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699AbaE3XeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:34:01 -0400
Subject: Re: [PATCH RFC RESEND 00/14] New version of the BFQ I/O Scheduler
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
From: Paolo Valente <paolo.valente@unimore.it>
In-Reply-To: <20140530170958.GF16605@redhat.com>
Date: Sat, 31 May 2014 01:33:56 +0200
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1263C136-7F68-465B-8185-C98496E6A73D@unimore.it>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it> <20140530153228.GE16605@redhat.com> <20140530161650.GH24871@htj.dyndns.org> <20140530170958.GF16605@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il giorno 30/mag/2014, alle ore 19:09, Vivek Goyal <vgoyal@redhat.com> ha scritto:

> […]
> Instead of just looking at numbers, I am keen on knowing what's the
> fundamental design change which allows this. What is CFQ doing wrong
> which BFQ gets right.
> 

I think that Tejun has already highlighted the key points and provided many details. To contribute to answer your questions about the reasons why bfq outperforms cfq, here is a summary of the most relevant underlying facts:

1) cfq is based on a round-robin scheme, in which an unlucky queue that should be served immediately may happen instead to wait for all the other busy queues before being served. In this respect, combining round robin with virtual-time-based improvements is likely to lead to not very clear solutions, and probably to sub-optimal results with respect to just using an optimal scheduler with provable deterministic guarantees (as the internal scheduler of bfq).

2) To provide a queue with a higher fraction of the throughput, a round-robin scheduler serves the queue for a longer time slice. Increasing time slices further increases per-request latencies. The problem may be mitigated by using preemption, but the result is a combination of a basic algorithm and a ‘corrective’ heuristic. This is again a more convoluted, and likely less accurate, solution than using directly an optimal algorithm with provable guarantees.

3) In bfq, budgets play a similar role as time slices in cfq, i.e., once a queue has been granted access to the device, the queue is served, in the simplest case, until it finishes its budget. But, under bfq, the fraction of the throughput received by a queue is *independent* of the budget assigned to the queue. I agree that this may seem counterintuitive in the first place, especially if one is accustomed to thinking a la round-robin. Differently from a round-robin algorithm, the internal scheduler of bfq controls throughput distribution by controlling the frequency at which queues are served. The resulting degree of freedom with respect to budget sizes has the following two main advantages:
3.a) bfq can choose for each queue the budget that best fits the requirements or characteristics of the queue. For example, queues corresponding to time-sensitive applications are assigned small budgets, which guarantees that they are served quickly. On the opposite side, queues associated to I/O-bound processes performing mostly sequential I/O are assigned large budgets, which helps boost the throughput.
3.b) bfq does not need to assign large budgets to queues to provide them with large fractions of the throughput; hence bfq does not need to deteriorate per-request latencies to guarantee a differentiated throughput distribution.

3) The internal scheduler of bfq guarantees that a queue that needs to be served quickly may wait, unjustly, for the service of at most one queue. More formally, bfq guarantees that each budget is completed with the smallest possible delay, for a budget-by-budget scheduler, with respect to an ideal, perfectly fair scheduler (i.e., an ideal scheduler that serves all busy queues at the same, providing each with a fraction of the throughput proportional to its weight).

4) Assigning temporarily a large fraction of the throughput is the main mechanism through which bfq provides interactive and soft real-time applications with a low latency. Thanks to fact 3.b, bfq achieves this goal without increasing per-request latencies. As for how applications are deemed as interactive or soft real-time, I have tried to describe both detection heuristics in patches 06 and 07.

Finally, as for adding to cfq the heuristics I have added to bfq, I think that this would probably improve application latencies also with cfq. But, because of the above facts, the result would unavoidably be worse than with bfq.

Paolo

--
Paolo Valente                                                 
Algogroup
Dipartimento di Fisica, Informatica e Matematica		
Via Campi, 213/B
41125 Modena - Italy        				  
homepage:  http://algogroup.unimore.it/people/paolo/

