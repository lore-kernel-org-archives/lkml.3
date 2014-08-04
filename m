Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaHDVPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:15:11 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58305 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbaHDVPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:15:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/4] mm: memcontrol: populate unified hierarchy interface
Date: Mon,  4 Aug 2014 17:14:53 -0400
Message-Id: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the ongoing versioning of the cgroup user interface gives us a chance
to clean up the memcg control interface and fix a lot of
inconsistencies and ugliness that crept in over time.

This series adds a minimal set of control files to the new memcg
interface to get basic memcg functionality going in unified hierarchy:

- memory.current: a read-only file that shows current memory usage.

- memory.high: a file that allows setting a high limit on the memory
  usage.  This is an elastic limit, which is enforced via direct
  reclaim, so allocators are throttled once it's reached, but it can
  be exceeded and does not trigger OOM kills.  This should be a much
  more suitable default upper boundary for the majority of use cases
  that are better off with some elasticity than with sudden OOM kills.

- memory.max: a file that allows setting a maximum limit on memory
  usage which is ultimately enforced by OOM killing tasks in the
  group.  This is for setups that want strict isolation at the cost of
  task death above a certain point.  However, even those can still
  combine the max limit with the high limit to approach OOM situations
  gracefully and with time to intervene.

- memory.vmstat: vmstat-style per-memcg statistics.  Very minimal for
  now (lru stats, allocations and frees, faults), but fixing
  fundamental issues of the old memory.stat file, including gross
  misnomers like pgpgin/pgpgout for pages charged/uncharged etc.

 Documentation/cgroups/unified-hierarchy.txt |  18 +++
 include/linux/res_counter.h                 |  29 +++++
 include/linux/swap.h                        |   3 +-
 kernel/res_counter.c                        |   3 +
 mm/memcontrol.c                             | 177 +++++++++++++++++++++++++---
 mm/vmscan.c                                 |   3 +-
 6 files changed, 216 insertions(+), 17 deletions(-)

