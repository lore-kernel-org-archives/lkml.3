Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3FEJQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:16:32 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:16401 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3FEJQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:16:29 -0400
Message-ID: <51AF0183.8070602@huawei.com>
Date: Wed, 5 Jun 2013 17:14:43 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH v2 00/10] cpuset: implement sane hierarchy behaviors
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2:

- add documentation in include/linux/cgroup.h
- drop rcu_read_lock() before calling update_task_nodemask() when iterating
cpuset hierarchy

======================================

Currently some cpuset behaviors are not friendly when cpuset is co-mounted
with other cgroup controllers.

Now with this patchset if cpuset is mounted with sane_behavior option, it
behaves differently:

- Tasks will be kept in empty cpusets when hotplug happens and take masks
of ancestors with non-empty cpus/mems, instead of being moved to an ancestor.

- A task can be moved into an empty cpuset, and again it takes masks of
ancestors, so the user can drop a task into a newly created cgroup without
having to do anything for it.

As tasks can reside in empy cpusets, here're some rules:

- They can be moved to another cpuset, regardless it's empty or not.

- Though it takes masks from ancestors, it takes other configs from the
empty cpuset.

- If the ancestors' masks are changed, those tasks will also be updated
to take new masks.

Li Zefan (10):
      cpuset: remove redundant check in cpuset_cpus_allowed_fallback()
      cpuset: cleanup guarantee_online_{cpus|mems}()
      cpuset: remove unnecessary variable in cpuset_attach()
      cpuset: remove cpuset_test_cpumask()
      cpuset: re-structure update_cpumask() a bit
      cpuset: record old_mems_allowed in struct cpuset
      cpuset: introduce effective_{cpumask|nodemask}_cpuset()
      cpuset: allow to keep tasks in empty cpusets
      cpuset: allow to move tasks to empty cpusets
      cpuset: fix to migrate mm correctly in a corner case

--
 include/linux/cgroup.h |   7 +
 kernel/cpuset.c        | 342 ++++++++++++++++++++++++++++++++++---------------
 2 files changed, 247 insertions(+), 102 deletions(-)
