Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab3CTQiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:38:19 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61063 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3CTQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:38:18 -0400
MIME-Version: 1.0
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
Date: Thu, 21 Mar 2013 00:38:17 +0800
Message-ID: <CACvQF5117ZW_7jBLt+rK5ZbFdghDqP8SgbwTSMzismvsO-f2WQ@mail.gmail.com>
Subject: Re: [PATCH 00/21] workqueue: cleanups and better locking for recent changes
From: Lai Jiangshan <eag0628@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun

I am sorry for replying so late and replied with so huge patchset.

But problem happened now, my patches and your patches are conflict.
Which patchset should be rebased?

I think my patches need be merged at first. Thus workqueue code is
in a better base, then your patchset will be rebased on this base.

Since you are maintainer, your choice will be much reasonable.
If you do any choice, please let me know earlier.

I should write patches after you are done, even cleanups.

Thanks,
Lai



On Wed, Mar 20, 2013 at 3:28 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> Hi, TJ
>
> After reviewing(long time review!) for recent 3 patchset:
> tj/review-misc-cleanups
> tj/review-finer-locking
> tj/review-restore-affinity
>
> I did not find anything wrong for the patchset. You can add my Reviewed-by
> for every patch.
>
> Although I always tried hard to review, but I found a possible problem of my
> reviewed patch: 29c91e9912bed7060df6116af90286500f5a700d. I think I should
> print the patch and eat the paper. it is fixed by patch1 here.
>
> In review, I like the patch "replace PF_THREAD_BOUND with PF_NO_SETAFFINITY"
> which moves the PF_NO_SETAFFINITY test out from set_cpus_allowed_ptr().
> the patch make workqueue.c much simpler.
>
> In review, I did not like the full design of some aspects, or I found the patch
> needs add some additional cleanup. but there is nothing wrongs. so I wrote
> this patchset instead to reply to every original patch.
>
> In review, I considered more about finer-locking.
>
> wq_mutex:
> * worker_pool_idr and unbound_pool_hash
> * pool->refcnt
> * workqueues list
> * workqueue->flags, ->nr_drainers
> * workqueue_freezing
>
> pwq_lock:
> * workqueue->pwqs
> * workqueue->saved_max_active
>
> wq->flush_mutex:
> * workqueue->pwqs
> * flushers and flushing fields
>
> In this list, we can find that:
> 1) wq_mutex protects too much different kind of things.
> 2) workqueue->pwqs are protected by both wq->flush_mutex and pwq_lock,
>    but in many read sites, they are protected by both wq->flush_mutex and pwq_lock,
>    in some other read sites, they are protected by pwq_lock, but can be converted
>    to wq->flush_mutex. it means pwq_lock and wq->flush_mutex are redundancy here.
> 3) pwq_lock is global lock, but it protects only workqueue instance fields.
> 4) several workqueue instance fields are protected by different locks.
>
> To make locking better, this patchset changes a little the design as:
> pools_mutex protects the set of pools:
> * worker_pool_idr and unbound_pool_hash
> * pool->refcnt
>
> wqs_mutex(renamed from wq_mutex) protects the set of workqueues and workqueue_freezing:
> * workqueues list
> * workqueue_freezing
>
> workqueue instance mutex(wq->mutex, renamed from wq->flush_mutex) protects
> workqueue instance:
> * workqueue->pwqs
> * flushers and workqueue's flushing fields
> * workqueue->saved_max_active
> * workqueue->freezing
>   (if we access the above fields, we access ->pwqs at the same time)
> * workqueue->flags, ->nr_drainers (doing flush at the same time)
>
> Any thought?
>
> Patch1: fix problem of new pool's POOL_FREEZING bit.
> Patch5-14: better locking.
> Patch1,4,5,10,12,14,20: fix/cleanup/dev for freezing and max_active adjusting
>
> others are single cleanup patches
>
> Thanks,
> Lai
>
> Lai Jiangshan (21):
>   workqueue: add missing POOL_FREEZING
>   workqueue: don't free pool->worker_idr by RCU
>   workqueue: simplify current_is_workqueue_rescuer()
>   workqueue: swap the two branches in pwq_adjust_max_active() to get
>     better readability
>   workqueue: kick workers in pwq_adjust_max_active()
>   workqueue: separate out pools locking into pools_mutex
>   workqueue: rename wq_mutex to wqs_mutex
>   workqueue: rename wq->flush_mutex to wq->mutex
>   workqueue: use wq->mutex to protects ->nr_drainers and __WQ_DRAINING
>   workqueue: use rcu_read_lock_sched() instead for accessing pwq in RCU
>   workqueue: also allowed wq->mutex protect for_each_pwq()
>   workqueue: use wq->mutex to protect saved_max_active
>   workqueue: remove unused pwq_lock
>   workqueue: add wq->freezing and remove POOL_FREEZING
>   workqueue: remove worker_maybe_bind_and_lock()
>   workqueue: rename rebind_workers() to associate_cpu_pool()
>   workqueue: simplify workqueue_cpu_up_callback(CPU_ONLINE)
>   workqueue: read POOL_DISASSOCIATED bit under pool->lock
>   workqueue: remove @p_last_pwq from init_and_link_pwq()
>   workqueue: modify wq->freezing only when freezable
>   workqueue: avoid false negative in assert_manager_or_pool_lock()
>
>  kernel/workqueue.c |  465 ++++++++++++++++++++--------------------------------
>  1 files changed, 179 insertions(+), 286 deletions(-)
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
