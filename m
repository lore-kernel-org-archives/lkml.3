Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3HUJ64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:58:56 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:36613 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3HUJ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:58:55 -0400
Message-ID: <52148F52.0@huawei.com>
Date: Wed, 21 Aug 2013 17:58:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 00/11] cpuset: separate configured masks and effective masks
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patcheset introduces behavior changes, but only if you mount cgroupfs
with sane_behavior option:

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

Li Zefan (11):
  cgroup: allow subsystems to create files for sane_behavior only
  cpuset: add cs->real_cpus_allowed and cs->real_mems_allowed
  cpuset: update cpuset->real_{cpus,mems}_allowed at hotplug
  cpuset: update cs->real_{cpus,mems}_allowed when config changes
  cpuset: inherite ancestor's masks if real_{cpus,mems}_allowed become empty
  cpuset: apply cs->real_{cpus,mems}_allowed
  cpuset: use effective cpumask to build sched domains
  cpuset: separate configured masks and efffective masks
  cpuset: enable onlined cpu/node in effective masks
  cpuset: allow writing offlined masks to cpuset.cpus/mems
  cpuset: export effective masks to userspace

 include/linux/cgroup.h |   1 +
 kernel/cgroup.c        |   2 +
 kernel/cpuset.c        | 466 ++++++++++++++++++++++++++++---------------------
 3 files changed, 271 insertions(+), 198 deletions(-)

-- 
1.8.0.2

