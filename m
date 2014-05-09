Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbaEIVbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:31:37 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:36325 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603AbaEIVbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:31:35 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org
Subject: [PATCHSET cgroup/for-3.16] cgroup: iterate cgroup_subsys_states directly
Date: Fri,  9 May 2014 17:31:17 -0400
Message-Id: <1399671091-23867-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently, while csses (cgroup_subsys_states) have ->parent linkage
too, only cgroups form full tree through their ->children and
->sibling fields and css iterations naturally is implemented by
iterating cgroups and then dereferencing the css for the specified
subsystem.

There are now use cases where controllers need to iterate through
csses regardless of their online state as long as they have positive
reference.  This can't easily be achieved by iterating cgroups because
its css pointer array needs to be cleared on offline and there may be
multiple dying csses for a cgroup for the same subsystem and there's
only one pointer per cgroup-subsystem pair.

This patchset moves ->children and ->sibling from cgroup to css and
link all csses in proper trees and then make css iterators walk csses
directly instead of going through cgroups.  This achieves iteration of
all non-released csses while also simplifying the iteration
implementation.  This is also in line with the general direction of
using csses as the primary structural component.

This patchset contains the following fourteen patches.

 0001-cgroup-remove-css_parent.patch
 0002-cgroup-remove-pointless-has-tasks-children-test-from.patch
 0003-memcg-update-memcg_has_children-to-use-css_next_chil.patch
 0004-device_cgroup-remove-direct-access-to-cgroup-childre.patch
 0005-cgroup-remove-cgroup-parent.patch
 0006-cgroup-move-cgroup-sibling-and-children-into-cgroup_.patch
 0007-cgroup-link-all-cgroup_subsys_states-in-their-siblin.patch
 0008-cgroup-move-cgroup-serial_nr-into-cgroup_subsys_stat.patch
 0009-cgroup-introduce-CSS_RELEASED-and-reduce-css-iterati.patch
 0010-cgroup-iterate-cgroup_subsys_states-directly.patch
 0011-cgroup-use-CSS_ONLINE-instead-of-CGRP_DEAD.patch
 0012-cgroup-convert-cgroup_has_live_children-into-css_has.patch
 0013-device_cgroup-use-css_has_online_children-instead-of.patch
 0014-cgroup-implement-css_tryget.patch

0001-0004 are prep patches.

0005-0008 move fields from cgroup to css and link csses in tree
structure instead of cgroups.

0009-0010 implement direct css iteration.

0011-0013 convert a cgroup based interface to a css one, which is now
possible as both are the same in terms of the tree structure, and fix
devcg brekage using it.

0014 implements css_tryget() which is to be used to gain access to
offline but not-yet-released csses.

This pachset is on top of

 b9a63d0116e8 ("Merge branch 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu into for-3.16")
 + [1] [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
 + [2] (REFRESHED) [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
 + [3] (REFRESHED) [PATCHSET cgroup/for-3.16] cgroup: remove cgroup_tree_mutex
 + [4] [PATCHSET cgroup/for-3.16] cgroup: use css->refcnt for cgroup reference counting

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-direct-css-iteration

diffstat follows.  Thanks.

 block/blk-cgroup.h           |    2 
 include/linux/cgroup.h       |  122 +++++++++++---------
 kernel/cgroup.c              |  257 ++++++++++++++++++++++++-------------------
 kernel/cgroup_freezer.c      |    2 
 kernel/cpuset.c              |    2 
 kernel/sched/core.c          |    2 
 kernel/sched/cpuacct.c       |    2 
 mm/hugetlb_cgroup.c          |    2 
 mm/memcontrol.c              |   45 +++----
 net/core/netclassid_cgroup.c |    2 
 net/core/netprio_cgroup.c    |    2 
 security/device_cgroup.c     |   17 --
 12 files changed, 251 insertions(+), 206 deletions(-)

--
tejun

[1] http://lkml.kernel.org/g/1399663975-315-1-git-send-email-tj@kernel.org
[2] http://lkml.kernel.org/g/20140509195059.GE4486@htj.dyndns.org
[3] http://lkml.kernel.org/g/20140509195827.GG4486@htj.dyndns.org
[4] http://lkml.kernel.org/g/1399670015-23463-1-git-send-email-tj@kernel.org
