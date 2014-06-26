Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaFZQUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:20:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbaFZQUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:20:00 -0400
Date: Thu, 26 Jun 2014 17:19:56 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] cfq: Increase default value of target_latency
Message-ID: <20140626161955.GH10819@suse.de>
References: <1403683129-10814-1-git-send-email-mgorman@suse.de>
 <1403683129-10814-7-git-send-email-mgorman@suse.de>
 <x491tub65t9.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <x491tub65t9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 11:36:50AM -0400, Jeff Moyer wrote:
> Mel Gorman <mgorman@suse.de> writes:
> 
> > The existing CFQ default target_latency results in very poor performance
> > for larger numbers of threads doing sequential reads. While this can be
> > easily described as a tuning problem for users, it is one that is tricky
> > to detect. This patch updates the default to benefit smaller machines.
> > Dave Chinner points out that it is dangerous to assume that people know
> > how to tune their IO scheduler. Jeff Moyer asked what workloads even
> > care about threaded readers but it's reasonable to assume file,
> > media, database and multi-user servers all experience large sequential
> > readers from multiple sources at the same time.
> 
> Right, and I guess I hadn't considered that case as I thought folks used
> more than one spinning disk for such workloads.
> 

They probably are but by and large my IO testing is based on simple
storage. The reasoning is that if we get the simple case wrong then we
probably are getting the complex case wrong too or at least not performing
as well as we should. I also don't use SSD on my own machines for the
same reason.

> My main reservation about this change is that you've only provided
> numbers for one benchmark. 

The other obvious one to run would be pgbench workloads but it's a rathole of
arguing whether the configuration is valid and whether it's inappropriate
to test on simple storage. The tiobench tests alone take a long time to
complete -- 1.5 hours on a simple machine, 7 hours on a low-end NUMA machine.

> To bump the default target_latency, ideally
> we'd know how it affects other workloads.  However, I'm having a hard
> time justifying putting any time into this for a couple of reasons:
> 1) blk-mq pretty much does away with the i/o scheduler, and that is the
>    future
> 2) there is work in progress to convert cfq into bfq, and that will
>    essentially make any effort put into this irrelevant (so it might be
>    interesting to test your workload with bfq)
> 

Ok, you've convinced me and I'll drop this patch. For anyone based on
kernels from around this time they can tune CFQ or buy a better disk.
Hopefully they will find this via Google.

	There are multiple process sequential read regressions that are
	getting progressively worse since 3.0 that are partially explained
	by changes to CFQ. You may have experienced this if you are using
	a kernel somewhere between 3.3 and 3.15. It's not really a bug in
	CFQ but a difference in objectives. CFQ in later kernels is more
	fair to threads and this partially sacrifices overall throughput
	for lower latency experienced by each of the processes.  If you
	see that the problem goes away using a different IO scheduler but
	need to use CFQ for whatever reason then tune target_latency to
	higher values. 600 appears to work reasonable well for a single
	disk but you may need higher. Keep an eye on IO fairness if that
	is something that your workload is sensitive to it. Your other
	option is to disable low_latency in CFQ. As always, check what the
	most recent kernel is particularly if there have been interesting
	things happening in either the blk-mq or with the bfq IO scheduler.

-- 
Mel Gorman
SUSE Labs
