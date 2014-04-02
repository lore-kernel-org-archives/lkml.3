Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbaDBDwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 23:52:16 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:23694 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757313AbaDBDwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 23:52:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,777,1389715200"; 
   d="scan'208";a="28765117"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <rdunlap@infradead.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <bsingharora@gmail.com>, <kamezawa.hiroyu@jp.fujitsu.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>, <guz.fnst@cn.fujitsu.com>
Subject: [PATCH 1/1] doc, mempolicy: Fix wrong document in numa_memory_policy.txt
Date: Wed, 2 Apr 2014 11:53:02 +0800
Message-ID: <1396410782-26208-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In document numa_memory_policy.txt, the following examples for flag
MPOL_F_RELATIVE_NODES are incorrect.

	For example, consider a task that is attached to a cpuset with
	mems 2-5 that sets an Interleave policy over the same set with
	MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
	interleave now occurs over nodes 3,5-6.  If the cpuset's mems
	then change to 0,2-3,5, then the interleave occurs over nodes
	0,3,5.

According to the comment of the patch adding flag MPOL_F_RELATIVE_NODES,
the nodemasks the user specifies should be considered relative to the
current task's mems_allowed.
(https://lkml.org/lkml/2008/2/29/428)

And according to numa_memory_policy.txt, if the user's nodemask includes
nodes that are outside the range of the new set of allowed nodes, then
the remap wraps around to the beginning of the nodemask and, if not already
set, sets the node in the mempolicy nodemask.

So in the example, if the user specifies 2-5, for a task whose mems_allowed
is 3-7, the nodemasks should be remapped the third, fourth, fifth, sixth
node in mems_allowed.  like the following:

	mems_allowed:       3  4  5  6  7

	relative index:     0  1  2  3  4
	                    5

So the nodemasks should be remapped to 3,5-7, but not 3,5-6.

And for a task whose mems_allowed is 0,2-3,5, the nodemasks should be
remapped to 0,2-3,5, but not 0,3,5.

	mems_allowed:       0  2  3  5

        relative index:     0  1  2  3
                            4  5


Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 Documentation/vm/numa_memory_policy.txt | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
index 4e7da65..badb050 100644
--- a/Documentation/vm/numa_memory_policy.txt
+++ b/Documentation/vm/numa_memory_policy.txt
@@ -174,7 +174,6 @@ Components of Memory Policies
 	allocation fails, the kernel will search other nodes, in order of
 	increasing distance from the preferred node based on information
 	provided by the platform firmware.
-	containing the cpu where the allocation takes place.
 
 	    Internally, the Preferred policy uses a single node--the
 	    preferred_node member of struct mempolicy.  When the internal
@@ -275,9 +274,9 @@ Components of Memory Policies
 	    For example, consider a task that is attached to a cpuset with
 	    mems 2-5 that sets an Interleave policy over the same set with
 	    MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
-	    interleave now occurs over nodes 3,5-6.  If the cpuset's mems
+	    interleave now occurs over nodes 3,5-7.  If the cpuset's mems
 	    then change to 0,2-3,5, then the interleave occurs over nodes
-	    0,3,5.
+	    0,2-3,5.
 
 	    Thanks to the consistent remapping, applications preparing
 	    nodemasks to specify memory policies using this flag should
-- 
1.7.11.7

