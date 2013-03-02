Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3CBDYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:24:31 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:48978 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3CBDYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:30 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com
Subject: [PATCHSET wq/for-3.10-tmp] workqueue: implement workqueue with custom worker attributes
Date: Fri,  1 Mar 2013 19:23:51 -0800
Message-Id: <1362194662-2344-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCHSET wq/for-3.10-tmp] workqueue: implement workqueue with custom worker attributes

Hello,

Finally, here's the unbound workqueue with custom worker attributes
patchset I've been talking about.  The goal is simple.  We want
unbound workqueues with custom worker attributes with a mechanism to
expose the knobs to userland.

Currently, the supported attributes are nice level and allowed
cpumask.  It's likely that cgroup association will be added in future.
Attributes are specified via struct workqueue_attrs.

 struct workqueue_attrs {
	int			nice;		/* nice level */
	cpumask_var_t		cpumask;	/* allowed CPUs */
 };

which is allocated, applied and freed using the following functions.

 struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask);
 void free_workqueue_attrs(struct workqueue_attrs *attrs);
 int apply_workqueue_attrs(struct workqueue_struct *wq,
			   const struct workqueue_attrs *attrs);

If the workqueue's knobs should be visible to userland, WQ_SYSFS can
be specified during alloc_workqueue() or workqueue_sysfs_register()
can be called.  The knobs will be accessible under
/sys/bus/workqueue/devices/NAME/.  max_active, nice and cpumask are
all adjustable from userland.

Whenever a new set of attrs is applied, workqueue tries to find the
worker_pool with matching attributes.  If there's one, its refcnt is
bumped and used; otherwise, a new one is created.  A new
pool_workqueue is created to interface with the found or created
worker_pool and the old pwqs (pool_workqueues) stick around until all
in-flight work items finish.  As pwqs retire, the associated
worker_pools are put too.  As a result, workqueue will make all
workqueues with the same attributes share the same pool and only keep
around the pools which are in use.

The interface is simple but the implementation is quite involved
because per-cpu assumption is still very strongly entrenched in the
existing workqueue implementation with unbound workqueue
implementation thrown on top as a hacky extension of the per-cpu
model.  A lot of this patchset deals with decoupling per-cpu
assumptions from various parts.

After per-cpu assumption is removed, unbound workqueue handling is
updated so that it can deal with multiple pwqs.  With the pwq and pool
iterators updated to handle per-cpu and unbound ones equally, it
usually boils down to traveling the same path used by per-cpu
workqueues to deal with multiple per-cpu pwqs.  For example,
non-reentrancy test while queueing and multiple pwq handling in
flush_workqueue() are now shared by both per-cpu and unbound
workqueues.

The result is pretty nice as per-cpu and unbound workqueues behave
almost the same with the only difference being per-cpu's pwqs are
per-cpu and unbound's are for different attributes.  The handling
deviates only in creation and destruction paths.

This patchset doesn't introduce any uses of workqueue_attrs or
WQ_SYSFS.  Writeback and btrfs IO workers are candidates for
conversion and will be done in separate patchsets.

This patchset contains the following 31 patches.

 0001-workqueue-make-sanity-checks-less-punshing-using-WAR.patch
 0002-workqueue-make-workqueue_lock-irq-safe.patch
 0003-workqueue-introduce-kmem_cache-for-pool_workqueues.patch
 0004-workqueue-add-workqueue_struct-pwqs-list.patch
 0005-workqueue-replace-for_each_pwq_cpu-with-for_each_pwq.patch
 0006-workqueue-introduce-for_each_pool.patch
 0007-workqueue-restructure-pool-pool_workqueue-iterations.patch
 0008-workqueue-add-wokrqueue_struct-maydays-list-to-repla.patch
 0009-workqueue-consistently-use-int-for-cpu-variables.patch
 0010-workqueue-remove-workqueue_struct-pool_wq.single.patch
 0011-workqueue-replace-get_pwq-with-explicit-per_cpu_ptr-.patch
 0012-workqueue-update-synchronization-rules-on-workqueue-.patch
 0013-workqueue-update-synchronization-rules-on-worker_poo.patch
 0014-workqueue-replace-POOL_MANAGING_WORKERS-flag-with-wo.patch
 0015-workqueue-separate-out-init_worker_pool-from-init_wo.patch
 0016-workqueue-introduce-workqueue_attrs.patch
 0017-workqueue-implement-attribute-based-unbound-worker_p.patch
 0018-workqueue-remove-unbound_std_worker_pools-and-relate.patch
 0019-workqueue-drop-std-from-cpu_std_worker_pools-and-for.patch
 0020-workqueue-add-pool-ID-to-the-names-of-unbound-kworke.patch
 0021-workqueue-drop-WQ_RESCUER-and-test-workqueue-rescuer.patch
 0022-workqueue-restructure-__alloc_workqueue_key.patch
 0023-workqueue-implement-get-put_pwq.patch
 0024-workqueue-prepare-flush_workqueue-for-dynamic-creati.patch
 0025-workqueue-perform-non-reentrancy-test-when-queueing-.patch
 0026-workqueue-implement-apply_workqueue_attrs.patch
 0027-workqueue-make-it-clear-that-WQ_DRAINING-is-an-inter.patch
 0028-workqueue-reject-increasing-max_active-for-ordered-w.patch
 0029-cpumask-implement-cpumask_parse.patch
 0030-driver-base-implement-subsys_virtual_register.patch
 0031-workqueue-implement-sysfs-interface-for-workqueues.patch

0001-0003 are misc preps.

0004-0008 update various iterators such that they don't operate on cpu
number.

0009-0011 are another set of misc preps / cleanups.

0012-0014 update synchronization rules to prepare for dynamic
management of pwqs and pools.

0015-0022 introduce workqueue_attrs and prepare for dynamic management
of pwqs and pools.

0023-0026 implement dynamic application of workqueue_attrs which
involes creating and destroying unbound pwqs and pools dynamically.

0027-0028 prepare workqueue for sysfs exports.

0029-0030 make cpumask and driver core changes for workqueue sysfs
exports.

0031 implements sysfs exports for workqueues.

This patchset is on top of

[1] wq/for-3.10-tmp 7bceeff75e ("workqueue: better define synchronization rule around rescuer->pool updates")

which is scheduled to be rebased on top of v3.9-rc1 once it comes out.
The changes are also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-attrs

diffstat follows.

 drivers/base/base.h         |    2 
 drivers/base/bus.c          |   73 +
 drivers/base/core.c         |    2 
 include/linux/cpumask.h     |   15 
 include/linux/device.h      |    2 
 include/linux/workqueue.h   |   34 
 kernel/workqueue.c          | 1716 +++++++++++++++++++++++++++++++-------------
 kernel/workqueue_internal.h |    5 
 8 files changed, 1322 insertions(+), 527 deletions(-)

Thanks.

--
tejun

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.10-tmp
