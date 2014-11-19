Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbaKSVOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:14:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186AbaKSVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Dave Chinner <david@fromorbit.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 120/122] fs/superblock: avoid locking counting inodes and dentries before reclaiming them
Date: Wed, 19 Nov 2014 12:52:50 -0800
Message-Id: <20141119205212.823254892@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Chen <tim.c.chen@linux.intel.com>

commit d23da150a37c9fe3cc83dbaf71b3e37fd434ed52 upstream.

We remove the call to grab_super_passive in call to super_cache_count.
This becomes a scalability bottleneck as multiple threads are trying to do
memory reclamation, e.g.  when we are doing large amount of file read and
page cache is under pressure.  The cached objects quickly got reclaimed
down to 0 and we are aborting the cache_scan() reclaim.  But counting
creates a log jam acquiring the sb_lock.

We are holding the shrinker_rwsem which ensures the safety of call to
list_lru_count_node() and s_op->nr_cached_objects.  The shrinker is
unregistered now before ->kill_sb() so the operation is safe when we are
doing unmount.

The impact will depend heavily on the machine and the workload but for a
small machine using postmark tuned to use 4xRAM size the results were

                                  3.15.0-rc5            3.15.0-rc5
                                     vanilla         shrinker-v1r1
Ops/sec Transactions         21.00 (  0.00%)       24.00 ( 14.29%)
Ops/sec FilesCreate          39.00 (  0.00%)       44.00 ( 12.82%)
Ops/sec CreateTransact       10.00 (  0.00%)       12.00 ( 20.00%)
Ops/sec FilesDeleted       6202.00 (  0.00%)     6202.00 (  0.00%)
Ops/sec DeleteTransact       11.00 (  0.00%)       12.00 (  9.09%)
Ops/sec DataRead/MB          25.97 (  0.00%)       29.10 ( 12.05%)
Ops/sec DataWrite/MB         49.99 (  0.00%)       56.02 ( 12.06%)

ffsb running in a configuration that is meant to simulate a mail server showed

                                 3.15.0-rc5             3.15.0-rc5
                                    vanilla          shrinker-v1r1
Ops/sec readall           9402.63 (  0.00%)      9567.97 (  1.76%)
Ops/sec create            4695.45 (  0.00%)      4735.00 (  0.84%)
Ops/sec delete             173.72 (  0.00%)       179.83 (  3.52%)
Ops/sec Transactions     14271.80 (  0.00%)     14482.81 (  1.48%)
Ops/sec Read                37.00 (  0.00%)        37.60 (  1.62%)
Ops/sec Write               18.20 (  0.00%)        18.30 (  0.55%)

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Tested-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/super.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -114,9 +114,14 @@ static unsigned long super_cache_count(s
 
 	sb = container_of(shrink, struct super_block, s_shrink);
 
-	if (!grab_super_passive(sb))
-		return 0;
-
+	/*
+	 * Don't call grab_super_passive as it is a potential
+	 * scalability bottleneck. The counts could get updated
+	 * between super_cache_count and super_cache_scan anyway.
+	 * Call to super_cache_count with shrinker_rwsem held
+	 * ensures the safety of call to list_lru_count_node() and
+	 * s_op->nr_cached_objects().
+	 */
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb,
 						 sc->nid);
@@ -127,7 +132,6 @@ static unsigned long super_cache_count(s
 						 sc->nid);
 
 	total_objects = vfs_pressure_ratio(total_objects);
-	drop_super(sb);
 	return total_objects;
 }
 


