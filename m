Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbaF1BDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 21:03:18 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:64602 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaF1BDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 21:03:16 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk
Subject: [PATCHSET cgroup/for-3.17] cgroup, blkcg, memcg: make blkcg depend on memcg on unified hierarchy
Date: Fri, 27 Jun 2014 21:03:06 -0400
Message-Id: <1403917392-32555-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

Currently, the blkio subsystem attributes all of writeback IOs to the
root.  One of the issues is that there's no way to tell who originated
a writeback IO from block layer.  Those IOs are usually issued
asynchronously from a task which didn't have anything to do with
actually generating the dirty pages.  The memory subsystem, when
enabled, already keeps track of the ownership of each dirty page and
it's desirable for blkio to piggyback instead of adding its own
per-page tag.

This can be achieved on the unified hierarchy without too much
difficulty.  This patchset implements a dependency mechanism in the
cgroup such that a subsystem can depends on other subsystems.  If
available, the depended-upon subsystems are enabled together
implicitly when the subsystem is turned on.  Implicitly enabled
subsystems are invisible and the dependencies are transparent to
userland.

This patchset implements the dependency mechanism in cgroup core and
make blkcg depend on memcg.  This doesn't actually solve the writeback
problem yet but is an important step.

This patchset contains the following six patches.

 0001-cgroup-reorganize-cgroup_subtree_control_write.patch
 0002-cgroup-introduce-cgroup-subtree_control.patch
 0003-cgroup-make-interface-files-visible-iff-enabled-on-c.patch
 0004-cgroup-implement-cgroup_subsys-css_reset.patch
 0005-cgroup-implement-cgroup_subsys-depends_on.patch
 0006-blkcg-memcg-make-blkcg-depend-on-memcg-on-the-defaul.patch

0001-0005 gradually implement the dependency mechanism.

0006 makes blkcg depend on memcg.

This patchset is on top of a497c3ba1d97 ("Linux 3.16-rc2") and
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-dependency

diffstat follows.  Thanks.

 Documentation/cgroups/cgroups.txt           |   14 +
 Documentation/cgroups/unified-hierarchy.txt |   23 ++-
 block/blk-cgroup.c                          |    7
 include/linux/cgroup.h                      |   20 ++
 kernel/cgroup.c                             |  201 ++++++++++++++++++++++------
 mm/memcontrol.c                             |   24 +++
 6 files changed, 243 insertions(+), 46 deletions(-)

--
tejun
