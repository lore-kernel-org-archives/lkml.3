Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab3D3AA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:00:28 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:56094 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab3D3AAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:00:25 -0400
Date: Mon, 29 Apr 2013 17:00:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] workqueue changes for v3.10-rc1
Message-ID: <20130430000019.GJ2395@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

A lot of activities on workqueue side this time.  The changes achieve
the followings.

* WQ_UNBOUND workqueues - the workqueues which are per-cpu - are
  updated to be able to interface with multiple backend worker pools.
  This involved a lot of churning but the end result seems actually
  neater as unbound workqueues are now a lot closer to per-cpu ones.

* The ability to interface with multiple backend worker pools are used
  to implement unbound workqueues with custom attributes.  Currently
  the supported attributes are the nice level and CPU affinity.  It
  may be expanded to include cgroup association in future.  The
  attributes can be specified either by calling
  apply_workqueue_attrs() or through /sys/bus/workqueue/WQ_NAME/* if
  the workqueue in question is exported through sysfs.

  The backend worker pools are keyed by the actual attributes and
  shared by any workqueues which share the same attributes.  When
  attributes of a workqueue are changed, the workqueue binds to the
  worker pool with the specified attributes while leaving the work
  items which are already executing in its previous worker pools
  alone.

  This allows converting custom worker pool implementations which want
  worker attribute tuning to use workqueues.  The writeback pool is
  already converted in block tree and there are a couple others are
  likely to follow including btrfs io workers.

* WQ_UNBOUND's ability to bind to multiple worker pools is also used
  to make it NUMA-aware.  Because there's no association between work
  item issuer and the specific worker assigned to execute it, before
  this change, using unbound workqueue led to unnecessary cross-node
  bouncing and it couldn't be helped by autonuma as it requires tasks
  to have implicit node affinity and workers are assigned randomly.

  After these changes, an unbound workqueue now binds to multiple
  NUMA-affine worker pools so that queued work items are executed in
  the same node.  This is turned on by default but can be disabled
  system-wide or for individual workqueues.

  Crypto was requesting NUMA affinity as encrypting data across
  different nodes can contribute noticeable overhead and doing it
  per-cpu was too limiting for certain cases and IO throughput could
  be bottlenecked by one CPU being fully occupied while others have
  idle cycles.

While the new features required a lot of changes including
restructuring locking, it didn't complicate the execution paths much.
The unbound workqueue handling is now closer to per-cpu ones and the
new features are implemented by simply associating a workqueue with
different sets of backend worker pools without changing queue,
execution or flush paths.

As such, even though the amount of change is very high, I feel
relatively safe in that it isn't likely to cause subtle issues with
basic correctness of work item execution and handling.  If something
is wrong, it's likely to show up as being associated with worker pools
with the wrong attributes or OOPS while workqueue attributes are being
changed or during CPU hotplug.

While this creates more backend worker pools, it doesn't add too many
more workers unless, of course, there are many workqueues with unique
combinations of attributes.  Assuming everything else is the same,
NUMA awareness costs an extra worker pool per NUMA node with online
CPUs.

There are also a couple things which are being routed outside the
workqueue tree.

* block tree pulled in workqueue for-3.10 so that writeback worker
  pool can be converted to unbound workqueue with sysfs control
  exposed.  This simplifies the code, makes writeback workers
  NUMA-aware and allows tuning nice level and CPU affinity via sysfs.

* The conversion to workqueue means that there's no 1:1 association
  between a specific worker, which makes writeback folks unhappy as
  they want to be able to tell which filesystem caused a problem from
  backtrace on systems with many filesystems mounted.  This is
  resolved by allowing work items to set debug info string which is
  printed when the task is dumped.  As this change involves unifying
  implementations of dump_stack() and friends in arch codes, it's
  being routed through Andrew's -mm tree.

Thanks.

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.10

for you to fetch changes up to cece95dfe5aa56ba99e51b4746230ff0b8542abd:

  workqueue: use kmem_cache_free() instead of kfree() (2013-04-09 11:33:40 -0700)

----------------------------------------------------------------
Lai Jiangshan (16):
      workqueue: allow more off-queue flag space
      workqueue: use %current instead of worker->task in worker_maybe_bind_and_lock()
      workqueue: change argument of worker_maybe_bind_and_lock() to @pool
      workqueue: better define synchronization rule around rescuer->pool updates
      workqueue: add missing POOL_FREEZING
      workqueue: simplify current_is_workqueue_rescuer()
      workqueue: kick a worker in pwq_adjust_max_active()
      workqueue: use rcu_read_lock_sched() instead for accessing pwq in RCU
      workqueue: avoid false negative in assert_manager_or_pool_lock()
      workqueue: rename wq_mutex to wq_pool_mutex
      workqueue: rename wq->flush_mutex to wq->mutex
      workqueue: protect wq->nr_drainers and ->flags with wq->mutex
      workqueue: protect wq->pwqs and iteration with wq->mutex
      workqueue: protect wq->saved_max_active with wq->mutex
      workqueue: remove pwq_lock which is no longer used
      workqueue: avoid false negative WARN_ON() in destroy_workqueue()

Tejun Heo (69):
      workqueue: make sanity checks less punshing using WARN_ON[_ONCE]()s
      workqueue: make workqueue_lock irq-safe
      workqueue: introduce kmem_cache for pool_workqueues
      workqueue: add workqueue_struct->pwqs list
      workqueue: replace for_each_pwq_cpu() with for_each_pwq()
      workqueue: introduce for_each_pool()
      workqueue: restructure pool / pool_workqueue iterations in freeze/thaw functions
      workqueue: add wokrqueue_struct->maydays list to replace mayday cpu iterators
      workqueue: consistently use int for @cpu variables
      workqueue: remove workqueue_struct->pool_wq.single
      workqueue: replace get_pwq() with explicit per_cpu_ptr() accesses and first_pwq()
      workqueue: update synchronization rules on workqueue->pwqs
      workqueue: update synchronization rules on worker_pool_idr
      workqueue: replace POOL_MANAGING_WORKERS flag with worker_pool->manager_arb
      workqueue: separate out init_worker_pool() from init_workqueues()
      workqueue: introduce workqueue_attrs
      workqueue: implement attribute-based unbound worker_pool management
      workqueue: remove unbound_std_worker_pools[] and related helpers
      workqueue: drop "std" from cpu_std_worker_pools and for_each_std_worker_pool()
      workqueue: add pool ID to the names of unbound kworkers
      workqueue: drop WQ_RESCUER and test workqueue->rescuer for NULL instead
      workqueue: restructure __alloc_workqueue_key()
      workqueue: implement get/put_pwq()
      workqueue: prepare flush_workqueue() for dynamic creation and destrucion of unbound pool_workqueues
      workqueue: perform non-reentrancy test when queueing to unbound workqueues too
      workqueue: implement apply_workqueue_attrs()
      workqueue: make it clear that WQ_DRAINING is an internal flag
      workqueue: reject adjusting max_active or applying attrs to ordered workqueues
      cpumask: implement cpumask_parse()
      driver/base: implement subsys_virtual_register()
      Merge branch 'for-3.10-subsys_virtual_register' into for-3.10
      workqueue: implement sysfs interface for workqueues
      workqueue: implement current_is_workqueue_rescuer()
      workqueue: relocate pwq_set_max_active()
      workqueue: implement and use pwq_adjust_max_active()
      workqueue: fix max_active handling in init_and_link_pwq()
      workqueue: update comments and a warning message
      workqueue: rename @id to @pi in for_each_each_pool()
      workqueue: inline trivial wrappers
      workqueue: rename worker_pool->assoc_mutex to ->manager_mutex
      workqueue: factor out initial worker creation into create_and_start_worker()
      workqueue: better define locking rules around worker creation / destruction
      workqueue: relocate global variable defs and function decls in workqueue.c
      workqueue: separate out pool and workqueue locking into wq_mutex
      workqueue: separate out pool_workqueue locking into pwq_lock
      workqueue: rename workqueue_lock to wq_mayday_lock
      sched: replace PF_THREAD_BOUND with PF_NO_SETAFFINITY
      workqueue: convert worker_pool->worker_ida to idr and implement for_each_pool_worker()
      workqueue: relocate rebind_workers()
      workqueue: directly restore CPU affinity of workers from CPU_ONLINE
      workqueue: restore CPU affinity of unbound workers on CPU_ONLINE
      workqueue: fix race condition in unbound workqueue free path
      workqueue: fix unbound workqueue attrs hashing / comparison
      workqueue: fix memory leak in apply_workqueue_attrs()
      workqueue: move pwq_pool_locking outside of get/put_unbound_pool()
      workqueue: add wq_numa_tbl_len and wq_numa_possible_cpumask[]
      workqueue: drop 'H' from kworker names of unbound worker pools
      workqueue: determine NUMA node of workers accourding to the allowed cpumask
      workqueue: add workqueue->unbound_attrs
      workqueue: make workqueue->name[] fixed len
      workqueue: move hot fields of workqueue_struct to the end
      workqueue: map an unbound workqueues to multiple per-node pool_workqueues
      workqueue: break init_and_link_pwq() into two functions and introduce alloc_unbound_pwq()
      workqueue: use NUMA-aware allocation for pool_workqueues
      workqueue: introduce numa_pwq_tbl_install()
      workqueue: introduce put_pwq_unlocked()
      workqueue: implement NUMA affinity for unbound workqueues
      workqueue: update sysfs interface to reflect NUMA awareness and a kernel param to disable NUMA affinity
      Merge tag 'v3.9-rc5' into wq/for-3.10

Wei Yongjun (1):
      workqueue: use kmem_cache_free() instead of kfree()

 Documentation/kernel-parameters.txt |    9 +
 drivers/base/base.h                 |    2 +
 drivers/base/bus.c                  |   73 +-
 drivers/base/core.c                 |    2 +-
 include/linux/cpumask.h             |   15 +
 include/linux/device.h              |    2 +
 include/linux/sched.h               |    2 +-
 include/linux/workqueue.h           |  166 +-
 kernel/cgroup.c                     |    4 +-
 kernel/cpuset.c                     |   16 +-
 kernel/kthread.c                    |    2 +-
 kernel/sched/core.c                 |    9 +-
 kernel/workqueue.c                  | 2946 ++++++++++++++++++++++++-----------
 kernel/workqueue_internal.h         |    9 +-
 14 files changed, 2273 insertions(+), 984 deletions(-)

--
tejun
