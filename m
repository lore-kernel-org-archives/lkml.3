Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbaHHVie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:38:34 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58582 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513AbaHHVi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:38:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] mm: memcontrol: populate unified hierarchy interface v2
Date: Fri,  8 Aug 2014 17:38:10 -0400
Message-Id: <1407533894-25845-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

memory cgroups are fundamentally broken when it comes to partitioning
the machine for many concurrent jobs.  In real life, workloads expand
and contract over time, and the hard limit is too static to reflect
this - it either wastes memory outside of the group, or wastes memory
inside the group.  As a result, the hard limit is mostly just used to
catch extreme consumption peaks, while workload trimming and balancing
is left to global reclaim and global OOM handling.  That in turn
requires more and more cgroup-awareness on the global level to make up
for the lack of useful policy enforcement on the cgroup level itself.

The ongoing versioning of the cgroup user interface gives us a chance
to fix such brokenness, and also clean up the interface and fix a lot
of the inconsistencies and ugliness that crept in over time.

This series adds a minimal set of control files to version 2 of the
memcg interface, implementing a new approach to machine partitioning.

Version 2 of this series is in response to feedback from Michal.  Some
of the changes are in code, but mostly it improves the documentation
and changelogs to describe the fundamental problems with the original
approach to machine partitioning and makes a case for the new model.

 Documentation/cgroups/unified-hierarchy.txt |  65 ++++++++
 include/linux/res_counter.h                 |  29 ++++
 include/linux/swap.h                        |   6 +-
 kernel/res_counter.c                        |   3 +
 mm/memcontrol.c                             | 250 +++++++++++++++++++---------
 mm/vmscan.c                                 |   7 +-
 6 files changed, 277 insertions(+), 83 deletions(-)

