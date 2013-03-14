Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349Ab3CNC5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:57:35 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:62377 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab3CNC5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:57:33 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com
Subject: [PATCHSET wq/for-3.10] workqueue: break up workqueue_lock into multiple locks
Date: Wed, 13 Mar 2013 19:57:18 -0700
Message-Id: <1363229845-6831-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently, workqueue_lock protects most shared workqueue resources -
the pools, workqueues, pool_workqueues, draining, ID assignments,
mayday handling and so on.  The coverage has grown organically and
there is no identified bottleneck coming from workqueue_lock, but it
has grown a bit too much and scheduled rebinding changes need the
pools and workqueues to be protected by a mutex instead of a spinlock.

The following seven patches break out workqueue_lock into three locks
- wq_mutex, pwq_lock and wq_mayday_lock - so that we get to have a
mutex for pools and workqueues, and the overall locking scheme is
easier to follow.

 0001-workqueue-rename-worker_pool-assoc_mutex-to-manager_.patch
 0002-workqueue-factor-out-initial-worker-creation-into-cr.patch
 0003-workqueue-better-define-locking-rules-around-worker-.patch
 0004-workqueue-relocate-global-variable-defs-and-function.patch
 0005-workqueue-separate-out-pool-and-workqueue-locking-in.patch
 0006-workqueue-separate-out-pool_workqueue-locking-into-p.patch
 0007-workqueue-rename-workqueue_lock-to-wq_mayday_lock.patch

0001-0004 are prep / cleanup patches.

0005 separates out pool and workqueue locking into wq_mutex.

0006 separates out pool_workqueue locking into pwq_lock.

0007 renames workqueue_lock to wq_mayday_lock as that's the only left
user of the lock.

This patchset is on top of

  wq/for-3.10 e626761691 ("workqueue: implement current_is_workqueue_rescuer()")
+ "workqueue: misc cleanups" patchset [1]

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-finer-locking

diffstat follows.  Thanks.

 kernel/workqueue.c |  355 +++++++++++++++++++++++++++++------------------------
 1 file changed, 195 insertions(+), 160 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1456511
