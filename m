Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbaE3R0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:26:17 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:42843 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239AbaE3R0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:26:13 -0400
Date: Fri, 30 May 2014 13:26:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: paolo <paolo.valente@unimore.it>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC RESEND 00/14] New version of the BFQ I/O Scheduler
Message-ID: <20140530172609.GI24871@htj.dyndns.org>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
 <20140530153228.GE16605@redhat.com>
 <20140530161650.GH24871@htj.dyndns.org>
 <20140530170958.GF16605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530170958.GF16605@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 30, 2014 at 01:09:58PM -0400, Vivek Goyal wrote:
> Are you referring to BFQ paper. I had read one in the past and it was
> all about how to achieve more accurate fairness. At this point of time
> I don't think that smarter algorithm is the problem. Until and unless
> somebody can show me that how algorithm is a problem.

Because cfq rr's with heuristically guessed slices and bfq calculates
where each one is supposed to end and then schedules the slices
accordingly.  With a lot of slices to serve, cfq loses track of which
one should come first to adhere to desired latency guarantees while
bfq doesn't, which in turn allows more latitude in using longer slices
for bfq allowing for better throughput.  It's all in the paper and
backed by numbers.  What more do you want?

> Apart from algorithm, one thing BFQ did different in the past was provide
> fairness based on amount of IO done *and not in terms of time slice*. I
> don't know if that's still the case. If it is the case I am wondering
> why CFQ was converted from amount of IO based fairness to time slice
> based fairness.

Rotating rusts being rotating rusts, either measure isn't perfect.
Bandwidth tracking gets silly with seeky workloads while pure time
slice tracking unfairly treats users of inner and outer tracks.  BFQ
uses bw tracking for sequential workload while basically switches to
time slice tracking for seeky workloads.  These were pretty clearly
discussed in the paper.

> I am all for a better algorithm. I just want to somebody to explain it
> to me that what magic they have done to achieve better throughput as
> well as better latency.

It feels more like you're actively refusing to understand it even when
the algorithm and heristics involved are as clearly presented as it
could be.  This is one of the best documented piece of work in this
area of the kernel.  Just read the papers.

> Do you think that CFQ's problems come from round robin algorithms. No,
> they don't. Most of the time we don't even honor the allocated time

Oh yes, why do you think we bother with preemption at all?  bfq
reportedly achieves sufficient fairness and responsiveness without the
need for preemption.  This is a lot clearer model.

> slice (except sequential IO) and preempt the allocated slice. That's
> why I think implementing a more fair algorithm is probably not the
> solution.

If you actually study what has been presented, you'd immediately
recognize that a lot of what bfq does is clarification and
improvements of the buried heuristics.

Look at it this way: RR + preemption becomes the basic timestamp based
scheduling and other heuristics are extracted and clarified.  That's
what it is.

> CFQ's throughput problems come from idling and driving lower queue depth.
> And CFQ's throughput problems arise due to suppressing buffered write
> very actively in presence of sync IO. 
> 
> I want to know what has BFQ done fundamentally different to take care of
> above issues. 

Yeah, read the paper.  They also analyzed why some things behave
certain ways.  A lot of them are pretty spot-on.

> Remember CFQ had started with a simple algorith. Just start allocating
> time slice in proportion to ioprio. That simple scheme did not work in
> real world and then it became more complicated.

Yes, this is another refinement step.  WTF is that so hard to warp
your head around it?  It doesn't throw away much.  It builds upon cfq
and clarifies and improves what it has been doing.

> What's the guarantee that same thing will not happen to BFQ. There is
> no point in getting fairness if overall performance sucks. That's what
> happens even with block IO cgroups. Create more than 4 cgroups, put some
> workload in that and with CFQ your performance will be so bad that you
> will drop the idea of getting fairness.

Dude, just go read the paper.

> Can you please provide me the link to the paper. I had read one few
> years back. I am not sure if it is still the same paper of a new one.
> And after experimenting with their implementation and playing with 
> CFQ, my impression was that fairness algorithm is not the core problem.

The references are in the frigging head message and in the head
comment of the implementation.  Are you even reading stuff?  You're
just wasting other people's time.

-- 
tejun
