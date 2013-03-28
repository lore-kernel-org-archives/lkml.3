Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3C1GoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:44:07 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:44925 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3C1GoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:04 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: Subject: [PATCHSET v2 wq/for-3.10] workqueue: NUMA affinity for unbound workqueues
Date: Wed, 27 Mar 2013 23:43:26 -0700
Message-Id: <1364453020-2829-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes from the last take[L] are

* Lai pointed out that the previous implementation was broken in that
  if a workqueue spans over multiple nodes and some of the nodes don't
  have any desired online CPUs, work items queued on those nodes would
  be spread across all CPUs violating the configured cpumask.

  The patchset is updated such that apply_workqueue_attrs() now only
  assigns NUMA-affine pwqs to nodes with desired online CPUs and
  default pwq to all other nodes.  To track CPU online state,
  wq_update_unbound_numa_attrs() is added.  The function is called for
  each workqueue during hot[un]plug and updates pwq association
  accordingly.

* Rolled in updated patches from the previous posting.

* More helper routines are factored out such that
  apply_workqueue_attrs() is easier to follow and can share code paths
  with wq_update_unbound_numa_attrs().

* Various cleanups and fixes.

Patchset description from the original posting follows.

There are two types of workqueues - per-cpu and unbound.  The former
is bound to each CPU and the latter isn't not bound to any by default.
While the recently added attrs support allows unbound workqueues to be
confined to subset of CPUs, it still is quite cumbersome for
applications where CPU affinity is too constricted but NUMA locality
still matters.

This patchset tries to solve that issue by automatically making
unbound workqueues affine to NUMA nodes by default.  A work item
queued to an unbound workqueue is executed on one of the CPUs allowed
by the workqueue in the same node.  If there's none allowed, it may be
executed on any cpu allowed by the workqueue.  It doesn't require any
changes on the user side.  Every interface of workqueues functions the
same as before.

This would be most helpful to subsystems which use some form of async
execution to process significant amount of data - e.g. crypto and
btrfs; however, I wanted to find out whether it would make any dent in
much less favorable use cases.  The following is total run time in
seconds of buliding allmodconfig kernel w/ -j20 on a dual socket
opteron machine with writeback thread pool converted to unbound
workqueue and thus made NUMA-affine.  The file system is ext4 on top
of a WD SSD.

	before conversion		after conversion
	1396.126			1394.763
	1397.621			1394.965
	1399.636			1394.738
	1397.463			1398.162
	1395.543			1393.670

AVG	1397.278			1395.260	DIFF	2.018
STDEV	   1.585			   1.700

And, yes, it actually made things go faster by about 1.2 sigma, which
isn't completely conclusive but is a pretty good indication that it's
actually faster.  Note that this is a workload which is dominated by
CPU time and while there's writeback going on continously it really
isn't touching too much data or a dominating factor, so the gain is
understandably small, 0.14%, but hey it's still a gain and it should
be much more interesting for crypto and btrfs which would actully
access the data or workloads which are more sensitive to NUMA
affinity.

The implementation is fairly simple.  After the recent attrs support
changes, a lot of the differences in pwq (pool_workqueue) handling
between unbound and per-cpu workqueues are gone.  An unbound workqueue
still has one "current" pwq that it uses for queueing any new work
items but can handle multiple pwqs perfectly well while they're
draining, so this patchset adds pwq dispatch table to unbound
workqueues which is indexed by NUMA node and points to the matching
pwq.  Unbound workqueues now simply have multiple "current" pwqs keyed
by NUMA node.

NUMA affinity can be turned off system-wide by workqueue.disable_numa
kernel param or per-workqueue using "numa" sysfs file.

This patchset contains the following fourteen patches.

 0001-workqueue-move-pwq_pool_locking-outside-of-get-put_u.patch
 0002-workqueue-add-wq_numa_tbl_len-and-wq_numa_possible_c.patch
 0003-workqueue-drop-H-from-kworker-names-of-unbound-worke.patch
 0004-workqueue-determine-NUMA-node-of-workers-accourding-.patch
 0005-workqueue-add-workqueue-unbound_attrs.patch
 0006-workqueue-make-workqueue-name-fixed-len.patch
 0007-workqueue-move-hot-fields-of-workqueue_struct-to-the.patch
 0008-workqueue-map-an-unbound-workqueues-to-multiple-per-.patch
 0009-workqueue-break-init_and_link_pwq-into-two-functions.patch
 0010-workqueue-use-NUMA-aware-allocation-for-pool_workque.patch
 0011-workqueue-introduce-numa_pwq_tbl_install.patch
 0012-workqueue-introduce-put_pwq_unlocked.patch
 0013-workqueue-implement-NUMA-affinity-for-unbound-workqu.patch
 0014-workqueue-update-sysfs-interface-to-reflect-NUMA-awa.patch

0001-0009 are prep patches.

0010-0013 implement NUMA affinity.

0014 adds control knobs and updates sysfs interface.

This patchset is on top of

  wq/for-3.10 b59276054 ("workqueue: remove pwq_lock which is no longer used")
+ [1] ("workqueue: fix race condition in unbound workqueue free path") patch
+ [2] ("workqueue: fix unbound workqueue attrs hashing / comparison") patch

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-numa

diffstat follows.

 Documentation/kernel-parameters.txt |    9 
 include/linux/workqueue.h           |    5 
 kernel/workqueue.c                  |  640 ++++++++++++++++++++++++++++++------
 3 files changed, 549 insertions(+), 105 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel.cryptoapi/8501
[1] http://article.gmane.org/gmane.linux.kernel/1465618
[2] http://article.gmane.org/gmane.linux.kernel/1465619
