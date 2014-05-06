Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbaEFMof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:44:35 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41411 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaEFMod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:44:33 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz,
        arozansk@redhat.com
Subject: [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
Date: Tue,  6 May 2014 08:44:21 -0400
Message-Id: <1399380266-3324-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset implements a new cftype operation ->write() and replace
->write_string() and ->trigger() with it.  ->write() is similar to
->write_string() but maps directly to the kernfs write operation and
has access to all available context information including the
associated kernfs_open_file, which will make things like implementing
kernfs active protection manipulation easier.

->write_string() becomes redundant and ->trigger() has always been
spurious.  This patch replaces all users of the two methods to
->write() and remove them.

This patchset contains the following five patches.

 0001-cgroup-implement-cftype-write.patch
 0002-cgroup-replace-cftype-write_string-with-cftype-write.patch
 0003-cgroup-replace-cftype-trigger-with-cftype-write.patch
 0004-cgroup-convert-tasks-and-cgroup.procs-handle-to-use-.patch
 0005-cgroup-remove-cgroup-control_kn.patch

0001 implements cftype->write().

0002-0003 replace cftype->write_string() and ->trigger() with it.

0004 convert "tasks" and "cgroup.procs" handler too.

0005 removes cgroup->control_kn as the kernfs_node is now directly
accessible from kernfs_open_file.

This patchset is on top of

  cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
+ [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates

and available on the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates

diffstat follows.

 block/blk-throttle.c      |   32 ++++++++---------
 block/cfq-iosched.c       |   28 +++++++--------
 include/linux/cgroup.h    |   40 +++++++++++----------
 kernel/cgroup.c           |   85 +++++++++++++++++++++++-----------------------
 kernel/cgroup_freezer.c   |   20 ++++------
 kernel/cpuset.c           |   16 ++++----
 mm/hugetlb_cgroup.c       |   33 +++++++++--------
 mm/memcontrol.c           |   80 +++++++++++++++++++++++--------------------
 net/ipv4/tcp_memcontrol.c |   31 +++++++++-------
 security/device_cgroup.c  |   14 +++----
 10 files changed, 197 insertions(+), 182 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/1399377044-29873-1-git-send-email-tj@kernel.org
