Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbaCED6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:58:43 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47672 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbaCED6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:58:40 -0500
Date: Tue, 4 Mar 2014 19:58:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [patch 00/11] userspace out of memory handling
Message-ID: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements userspace out of memory handling.

It is based on v3.14-rc5.  Individual patches will apply cleanly or you
may pull the entire series from

	git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git mm/oom

When the system or a memcg is oom, processes running on that system or
attached to that memcg cannot allocate memory.  It is impossible for a
process to reliably handle the oom condition from userspace.

First, consider only system oom conditions.  When memory is completely
depleted and nothing may be reclaimed, the kernel is forced to free some
memory; the only way it can do so is to kill a userspace process.  This
will happen instantaneously and userspace can enforce neither its own
policy nor collect information.

On system oom, there may be a hierarchy of memcgs that represent user
jobs, for example.  Each job may have a priority independent of their
current memory usage.  There is no existing kernel interface to kill the
lowest priority job; userspace can now kill the lowest priority job or
allow priorities to change based on whether the job is using more memory
than its pre-defined reservation.

Additionally, users may want to log the condition or debug applications
that are using too much memory.  They may wish to collect heap profiles
or are able to do memory freeing without killing a process by throttling
or ratelimiting.

Interactive users using X window environments may wish to have a dialogue
box appear to determine how to proceed -- it may even allow them shell
access to examine the state of the system while oom.

It's not sufficient to simply restrict all user processes to a subset of
memory and oom handling processes to the remainder via a memcg hierarchy:
kernel memory and other page allocations can easily deplete all memory
that is not charged to a user hierarchy of memory.

This patchset allows userspace to do all of these things by defining a
small memory reserve that is accessible only by processes that are
handling the notification.

Second, consider memcg oom conditions.  Processes need no special
knowledge of whether they are attached to the root memcg, where memcg
charging will always succeed, or a child memcg where charging will fail
when the limit has been reached.  This allows those processes handling
memcg oom conditions to overcharge the memcg by the amount of reserved
memory.  They need not create child memcgs with smaller limits and
attach the userspace oom handler only to the parent; such support would
not allow userspace to handle system oom conditions anyway.

This patchset introduces a standard interface through memcg that allows
both of these conditions to be handled in the same clean way: users
define memory.oom_reserve_in_bytes to define the reserve and this
amount is allowed to be overcharged to the process handling the oom
condition's memcg.  If used with the root memcg, this amount is allowed
to be allocated below the per-zone watermarks for root processes that
are handling such conditions (only root may write to
cgroup.event_control for the root memcg).
---
 Documentation/cgroups/memory.txt           |  46 ++++++++-
 Documentation/cgroups/resource_counter.txt |  12 +--
 Documentation/sysctl/vm.txt                |   5 +
 arch/m32r/mm/discontig.c                   |   1 +
 include/linux/memcontrol.h                 |  24 +++++
 include/linux/mempolicy.h                  |   3 +-
 include/linux/mmzone.h                     |   2 +
 include/linux/res_counter.h                |  16 ++--
 include/linux/sched.h                      |   2 +-
 kernel/fork.c                              |  13 +--
 kernel/res_counter.c                       |  42 ++++++---
 mm/memcontrol.c                            | 144 ++++++++++++++++++++++++++++-
 mm/mempolicy.c                             |  46 ++-------
 mm/oom_kill.c                              |   7 ++
 mm/page_alloc.c                            |  17 +++-
 mm/slab.c                                  |   8 +-
 mm/slub.c                                  |   2 +-
 17 files changed, 292 insertions(+), 98 deletions(-)
