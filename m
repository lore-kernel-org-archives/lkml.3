Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3AVFhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:37:03 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65416 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3AVFhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:37:01 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-aa-50fe257bdde8
Date: Tue, 22 Jan 2013 14:37:02 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCHSET] workqueue: remove gcwq and make worker_pool the only
 backend abstraction
Message-ID: <20130122053702.GA10675@lge.com>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tejun.

On Wed, Jan 16, 2013 at 05:42:32PM -0800, Tejun Heo wrote:
> Hello,
> 
> Currently, on the backend side, there are two layers of abstraction.
> For each CPU and the special unbound wq-specific CPU, there's one
> global_cwq.  gcwq in turn hosts two worker_pools - one for normal
> priority, the other for highpri - each of which actually serves the
> work items.
> 
> worker_pool is the later addition to support separate pool of workers
> for highpri workqueues.  Stuff was moved to worker_pool on as-needed
> basis and, as a result, the two pools belonging to the same CPU share
> some stuff in the gcwq - most notably the lock and the hash table for
> work items currently being executed.
> 
> It seems like we'll need to support worker pools with custom
> attributes, which is planned to be implemented as extra worker_pools
> for the unbound CPU.  Removing gcwq and having worker_pool as the top
> level abstraction makes things much simpler for such designs.  Also,
> there's scalability benefit to not sharing locking and busy hash among
> different worker pools as worker pools w/ custom attributes are likely
> to have widely different memory / cpu locality characteristics.

Could you tell me why extra worker_pools with custom attributes are needed?
Or could you give a reference link for this?

Thanks.

> In retrospect, it might have been less churn if we just converted to
> have multiple gcwqs per CPU when we were adding highpri pool support.
> Oh well, such is life and the name worker_pool fits the role much
> better anyway at this point.
> 
> This patchset moves the remaining stuff in gcwq to worker_pool and
> then removes gcwq entirely making worker_pool the top level and the
> only backend abstraction.  In the process, this patchset also prepares
> for later addition of worker_pools with custom attributes.
> 
> This patchset shouldn't introduce any visible differences outside of
> workqueue proper and contains the following 17 patches.
> 
>  0001-workqueue-unexport-work_cpu.patch
>  0002-workqueue-use-std_-prefix-for-the-standard-per-cpu-p.patch
>  0003-workqueue-make-GCWQ_DISASSOCIATED-a-pool-flag.patch
>  0004-workqueue-make-GCWQ_FREEZING-a-pool-flag.patch
>  0005-workqueue-introduce-WORK_OFFQ_CPU_NONE.patch
>  0006-workqueue-add-worker_pool-id.patch
>  0007-workqueue-record-pool-ID-instead-of-CPU-in-work-data.patch
>  0008-workqueue-move-busy_hash-from-global_cwq-to-worker_p.patch
>  0009-workqueue-move-global_cwq-cpu-to-worker_pool.patch
>  0010-workqueue-move-global_cwq-lock-to-worker_pool.patch
>  0011-workqueue-make-hotplug-processing-per-pool.patch
>  0012-workqueue-make-freezing-thawing-per-pool.patch
>  0013-workqueue-replace-for_each_worker_pool-with-for_each.patch
>  0014-workqueue-remove-worker_pool-gcwq.patch
>  0015-workqueue-remove-global_cwq.patch
>  0016-workqueue-rename-nr_running-variables.patch
>  0017-workqueue-post-global_cwq-removal-cleanups.patch
> 
> 0001-0002 are misc preps.
> 
> 0003-0004 move flags from gcwq to pool.
> 
> 0005-0007 make work->data off-queue backlink point to worker_pools
> instead of CPUs, which is necessary to move busy_hash to pool.
> 
> 0008-0010 move busy_hash, cpu and locking to pool.
> 
> 0011-0014 make operations per-pool and remove gcwq usages.
> 
> 0015-0017 remove gcwq and cleanup afterwards.
> 
> This patchset is on top of wq/for-3.9 023f27d3d6f ("workqueue: fix
> find_worker_executing_work() brekage from hashtable conversion") and
> available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.9-remove-gcwq
> 
> Thanks.
> 
>  include/linux/workqueue.h        |   17
>  include/trace/events/workqueue.h |    2
>  kernel/workqueue.c               |  897 +++++++++++++++++++--------------------
>  3 files changed, 461 insertions(+), 455 deletions(-)
> 
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
