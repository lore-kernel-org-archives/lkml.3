Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbaBJUVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:21:44 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:61129 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaBJUVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:21:39 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.15] cgroup: update task migration path
Date: Mon, 10 Feb 2014 15:21:29 -0500
Message-Id: <1392063694-26465-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently, when migrating a task or process from one cgroup to
another, a flex_array is used to keep track of the target tasks and
associated css_sets.  This has a couple issues.

* flex_array size is limited.  Given the current data structure, the
  limit is ~87k on 64bit, which is pretty high but not impossible to
  hit.

* If multiple targets are being migrated, as migrating each target
  involves memory allocation, it can fail at any point.  cgroup core
  doesn't keep track of enough state to roll back partial migration
  either, so it ends up aborting with some targets migrated with no
  way of finding out which.  While this isn't a big issue now, we're
  gonna be making more use of multi-target migration.

This patchset updates task migration path such that

* task->cg_list and css_sets are also used to keep track of targets
  during migration so that no extra memory allocation is necessary to
  keep track of migration targets.

* Migration is split into several stages so that all preparations
  which may fail can be performed for all targets before actually
  starting migrating tasks.  Ignoring ->can_attach() failure, this can
  guarantee all-or-nothing semantics of multi-target migration.

This patchset contains the following five patches.

 0001-cgroup-add-css_set-mg_tasks.patch
 0002-cgroup-use-css_set-mg_tasks-to-track-target-tasks-du.patch
 0003-cgroup-separate-out-cset_group_from_root-from-task_c.patch
 0004-cgroup-split-process-task-migration-into-four-steps.patch
 0005-cgroup-update-cgroup_transfer_tasks-to-either-succee.patch

0001-0002 update migration path so that it uses task->cg_list for
keeping track of migration targets.

0003-0004 split migration into multiple steps so that preparation
which may fail can be done up-front.

0005 updates cgroup_transfer_tasks() to use multi-step migration to
guarantee all-or-nothing behavior as long as ->can_attach() doesn't
fail.

This patch is on top of

  cgroup/for-3.15 f7cef064aa01 ("Merge branch 'driver-core-next' into cgroup/for-3.15")
+ [1] [PATCHSET v2 cgroup/for-3.15] cgroup: convert to kernfs
+ [2] [PATCHSET v2 cgroup/for-3.15] cgroup: cleanups after kernfs conversion
+ [3] [PATCHSET cgroup/for-3.15] cgroup: more cleanups

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-migration-update

diffstat follows.

 include/linux/cgroup.h |   25 ++
 kernel/cgroup.c        |  510 ++++++++++++++++++++++++++++++++-----------------
 2 files changed, 363 insertions(+), 172 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/1391876127-7134-1-git-send-email-tj@kernel.org
[2] http://lkml.kernel.org/g/1391877509-10855-1-git-send-email-tj@kernel.org
[3] http://lkml.kernel.org/g/1391953964-22088-1-git-send-email-tj@kernel.org
