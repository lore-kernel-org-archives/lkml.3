Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaBMU3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:29:01 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:58169 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBMU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:28:57 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET v2 cgroup/for-3.15] cgroup: update task migration path
Date: Thu, 13 Feb 2014 15:28:46 -0500
Message-Id: <1392323333-18907-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is v2 of update-task-migration-path patchset.  Changes from v1[L]
are

* Rebased on top of "[PATCH cgroup/for-3.14-fixes] cgroup: update
  cgroup_enable_task_cg_lists() to grab siglock"

* 0005-cgroup-update-how-a-newly-forked-task-gets-associate.patch and
  0006-cgroup-drop-task_lock-protection-around-task-cgroups.patch
  added to address the race between migration and fork paths.

Currently, when migrating a task or process from one cgroup to
another, a flex_array is used to keep track of the target tasks and
associated css_sets.  The current implementation has several issues.

* flex_array size is limited.  Given the current data structure, the
  limit is ~87k on 64bit, which is pretty high but not impossible to
  hit.

* If multiple targets are being migrated, as migrating each target
  involves memory allocation, it can fail at any point.  cgroup core
  doesn't keep track of enough state to roll back partial migration
  either, so it ends up aborting with some targets migrated with no
  way of finding out which.  While this isn't a big issue now, we're
  gonna be making more use of multi-target migration.

* Fork path could race against migration path and it was impossible to
  implement a mechanism to migrate all tasks of a cgroup to another
  because migration path can't tell whether there are just forked
  tasks pointing to the css_set but not linked yet.

This patchset updates task migration path such that

* task->cg_list and css_sets are also used to keep track of targets
  during migration so that no extra memory allocation is necessary to
  keep track of migration targets.

* Migration is split into several stages so that all preparations
  which may fail can be performed for all targets before actually
  starting migrating tasks.  Ignoring ->can_attach() failure, this can
  guarantee all-or-nothing semantics of multi-target migration.

* Newly forked tasks are now atomically associated with and linked to
  the parent's css_set in cgroup_post_fork().  This guarantees that
  the new task either is visible in the source cgroup once the
  parent's migration is complete or ends up in the target cgroup in
  the first place.  This means that just keeping moving tasks out of a
  cgroup until it's empty is guaranteed to migrate all tasks.

This patchset contains the following seven patches.

 0001-cgroup-add-css_set-mg_tasks.patch
 0002-cgroup-use-css_set-mg_tasks-to-track-target-tasks-du.patch
 0003-cgroup-separate-out-cset_group_from_root-from-task_c.patch
 0004-cgroup-split-process-task-migration-into-four-steps.patch
 0005-cgroup-update-how-a-newly-forked-task-gets-associate.patch
 0006-cgroup-drop-task_lock-protection-around-task-cgroups.patch
 0007-cgroup-update-cgroup_transfer_tasks-to-either-succee.patch

0001-0002 update migration path so that it uses task->cg_list for
keeping track of migration targets.

0003-0004 split migration into multiple steps so that preparation
which may fail can be done up-front.

0005 updates how a newly forked task is associated with the parent's
css_set to address the race between migration and fork paths.

0006 drops task_lock() protection around task->cgroups as it's no
longer necessary after 0005.

0007 updates cgroup_transfer_tasks() to use multi-step migration to
guarantee all-or-nothing behavior as long as ->can_attach() doesn't
fail.

This patch is on top of

  cgroup/for-3.15 32940b0bad26 ("cgroup: update cgroup_transfer_tasks() to either succeed or fail")
+ [1] [PATCH cgroup/for-3.14-fixes] cgroup: update cgroup_enable_task_cg_lists() to grab siglock

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-migration-update-v2

diffstat follows.

 include/linux/cgroup.h |   31 +-
 kernel/cgroup.c        |  677 +++++++++++++++++++++++++++++--------------------
 2 files changed, 438 insertions(+), 270 deletions(-)

Thanks.

--
tejun

[L] http://lkml.kernel.org/g/1392063694-26465-1-git-send-email-tj@kernel.org
[1] http://lkml.kernel.org/g/20140213182931.GB17608@htj.dyndns.org
