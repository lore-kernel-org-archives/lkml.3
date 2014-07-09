Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaGIIq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:46:58 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:54498 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaGIIqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:46:54 -0400
Message-ID: <53BD0174.4060002@huawei.com>
Date: Wed, 9 Jul 2014 16:46:44 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v3 00/12] cpuset: separate configured masks and effective
 masks
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patcheset introduces behavior changes, but only for default hierarchy

- We introduce new interfaces cpuset.effective_cpus and cpuset.effective_mems,
  while cpuset.cpus and cpuset.mems will be configured masks.

- The configured masks can be changed by writing cpuset.cpus/mems only. They
  won't be changed when hotplug happens.

- Users can config cpus and mems without restrictions from the parent cpuset.
  effective masks will enforce the hierarchical behavior.

- Users can also config cpus and mems to have already offlined CPU/nodes.

- When a CPU/node is onlined, it will be brought back to the effective masks
  if it's in the configured masks.

- We build sched domains based on effective cpumask but not configured cpumask.

v3:
- rebased against "cgroup: remove sane_behavior support on non-default hierarchies"
- addressed previous review comments
- adjusted some code, comment and changelog slightly

v2:
- fixed two bugs
- made changelogs more verbose
- added more comments
- changed cs->real_{mems,cpus}_allowed to cs->effective_{mems, cpus}
- splitted "cpuset: enable onlined cpu/node in effective masks" into 2 patches
- exported cpuset.effective_{cpus,mems} unconditionally


Li Zefan (12):
  cpuset: add cs->effective_cpus and cs->effective_mems
  cpuset: update cpuset->effective_{cpus,mems} at hotplug
  cpuset: update cs->effective_{cpus,mems} when config changes
  cpuset: inherit ancestor's masks if effective_{cpus,mems} becomes
    empty
  cpuset: use effective cpumask to build sched domains
  cpuset: initialize top_cpuset's configured masks at mount
  cpuset: apply cs->effective_{cpus,mems}
  cpuset: make cs->{cpus,mems}_allowed as user-configured masks
  cpuset: refactor cpuset_hotplug_update_tasks()
  cpuset: enable onlined cpu/node in effective masks
  cpuset: allow writing offlined masks to cpuset.cpus/mems
  cpuset: export effective masks to userspace

 kernel/cpuset.c | 493 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 304 insertions(+), 189 deletions(-)

-- 
1.8.0.2


