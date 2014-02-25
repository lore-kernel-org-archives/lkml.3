Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaBYI7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:59:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:59681 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaBYI7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:59:02 -0500
Message-ID: <530C5AC8.5070806@huawei.com>
Date: Tue, 25 Feb 2014 16:56:40 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.15] cgroup: update task migration path
References: <1392323333-18907-1-git-send-email-tj@kernel.org>
In-Reply-To: <1392323333-18907-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/14 4:28, Tejun Heo wrote:
> Hello,
> 
> This is v2 of update-task-migration-path patchset.  Changes from v1[L]
> are
> 
> * Rebased on top of "[PATCH cgroup/for-3.14-fixes] cgroup: update
>   cgroup_enable_task_cg_lists() to grab siglock"
> 
> * 0005-cgroup-update-how-a-newly-forked-task-gets-associate.patch and
>   0006-cgroup-drop-task_lock-protection-around-task-cgroups.patch
>   added to address the race between migration and fork paths.
> 
> Currently, when migrating a task or process from one cgroup to
> another, a flex_array is used to keep track of the target tasks and
> associated css_sets.  The current implementation has several issues.
> 
> * flex_array size is limited.  Given the current data structure, the
>   limit is ~87k on 64bit, which is pretty high but not impossible to
>   hit.
> 
> * If multiple targets are being migrated, as migrating each target
>   involves memory allocation, it can fail at any point.  cgroup core
>   doesn't keep track of enough state to roll back partial migration
>   either, so it ends up aborting with some targets migrated with no
>   way of finding out which.  While this isn't a big issue now, we're
>   gonna be making more use of multi-target migration.
> 
> * Fork path could race against migration path and it was impossible to
>   implement a mechanism to migrate all tasks of a cgroup to another
>   because migration path can't tell whether there are just forked
>   tasks pointing to the css_set but not linked yet.
> 
> This patchset updates task migration path such that
> 
> * task->cg_list and css_sets are also used to keep track of targets
>   during migration so that no extra memory allocation is necessary to
>   keep track of migration targets.
> 
> * Migration is split into several stages so that all preparations
>   which may fail can be performed for all targets before actually
>   starting migrating tasks.  Ignoring ->can_attach() failure, this can
>   guarantee all-or-nothing semantics of multi-target migration.
> 
> * Newly forked tasks are now atomically associated with and linked to
>   the parent's css_set in cgroup_post_fork().  This guarantees that
>   the new task either is visible in the source cgroup once the
>   parent's migration is complete or ends up in the target cgroup in
>   the first place.  This means that just keeping moving tasks out of a
>   cgroup until it's empty is guaranteed to migrate all tasks.
> 
> This patchset contains the following seven patches.
> 
>  0001-cgroup-add-css_set-mg_tasks.patch
>  0002-cgroup-use-css_set-mg_tasks-to-track-target-tasks-du.patch
>  0003-cgroup-separate-out-cset_group_from_root-from-task_c.patch
>  0004-cgroup-split-process-task-migration-into-four-steps.patch
>  0005-cgroup-update-how-a-newly-forked-task-gets-associate.patch
>  0006-cgroup-drop-task_lock-protection-around-task-cgroups.patch
>  0007-cgroup-update-cgroup_transfer_tasks-to-either-succee.patch
> 

Acked-by: Li Zefan <lizefan@huawei.com>

