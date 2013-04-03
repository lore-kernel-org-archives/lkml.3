Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab3DCTYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:24:52 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:60084 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3DCTYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:24:50 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, akpm@linux-foundation.org
Cc: jack@suse.cz, david@fromorbit.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET v2] workqueue, writeback: better worker information in task dumps
Date: Wed,  3 Apr 2013 12:24:29 -0700
Message-Id: <1365017072-32213-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew, this one depends on the debug info unification patch and
should be routed through -mm too.  The writeback folks seem to be okay
with the proposed changes although nobody explicitly acked it yet
(please do so).  Please route these together with the previous set
through -mm.  Thanks.

This is v2.  Changes from v1 are,

* Rebased on top of the v2 of "arch: unify task dump debug info"
  patchset.

One of the problems that arise when converting dedicated custom
threadpool to workqueue is that the shared worker pool used by
workqueue anonimizes each worker making it more difficult to identify
what the worker was doing on which target from the output of sysrq-t
or debug dump from oops, BUG() and friends.

For example, after writeback is converted to use workqueue instead of
priviate thread pool, there's no easy to tell which backing device a
writeback work item was working on at the time of task dump, which,
according to our writeback brethren, is important in tracking down
issues with a lot of mounted file systems on a lot of different
devices.

This patchset implements a way for a work function to mark its
execution instance so that task dump of the worker task includes
information to indicate what the work item was doing.

An example WARN dump would look like the following.

 WARNING: at /work/os/work/fs/fs-writeback.c:1015 bdi_writeback_workfn+0x2b4/0x3c0()
 Modules linked in:
 CPU: 0 Pid: 28 Comm: kworker/u18:0 Not tainted 3.9.0-rc1-work+ #24
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
 Workqueue: writeback bdi_writeback_workfn (flush-8:16)
  ffffffff820a3a98 ffff88015b927cb8 ffffffff81c61855 ffff88015b927cf8
  ffffffff8108f500 0000000000000000 ffff88007a171948 ffff88007a1716b0
  ffff88015b49df00 ffff88015b8d3940 0000000000000000 ffff88015b927d08
 Call Trace:
  [<ffffffff81c61855>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  ...

This patchset contains the following three patches.

 0001-kthread-implement-probe_kthread_data.patch
 0002-workqueue-include-workqueue-info-when-printing-debug.patch
 0003-writeback-set-worker-desc-to-identify-writeback-work.patch

0001 adds a speculative accessor for kthread_data.

0002 implements worker description.

0003 updates writeback to set its flusher name as worker description.

This patchset is on top of

  akpm as of 2013/04/03
+ [PATCHSET v2] arch: unify task dump debug info

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-wb-better-dbg

diffstat follows.  Thanks.

 fs/fs-writeback.c           |    1 
 include/linux/kthread.h     |    1 
 include/linux/workqueue.h   |    5 ++
 kernel/kthread.c            |   19 ++++++++++
 kernel/printk.c             |    2 +
 kernel/sched/core.c         |    1 
 kernel/workqueue.c          |   79 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/workqueue_internal.h |   12 ++++++
 8 files changed, 119 insertions(+), 1 deletion(-)

--
tejun
