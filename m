Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3IFSYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:24:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:32430 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab3IFSY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:24:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,855,1371106800"; 
   d="scan'208";a="399510811"
Subject: [PATCH 2/2] fs/superblock: Avoid locking counting inodes and
 dentries before reclaiming them
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Chinner <dchinner@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
In-Reply-To: <409cc1e38244136e72e97883445187941d1405b8.1378465804.git.tim.c.chen@linux.intel.com>
References: <409cc1e38244136e72e97883445187941d1405b8.1378465804.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Sep 2013 11:24:26 -0700
Message-ID: <1378491866.3467.7.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We remove the call to grab_super_passive in call to super_cache_count.
This becomes a scalability bottleneck as multiple threads are trying
to do memory reclamation, e.g. when we are doing large amount of
file read and page cache is under pressure.  The cached objects
quickly got reclaimed down to 0 and we are aborting the cache_scan()
reclaim.  But counting creates a log jam acquiring the sb_lock.

We are holding the shrinker_rwsem which ensures the safety of
call to list_lru_count_node() and s_op->nr_cached_objects.  The
shrinker is unregistered now before ->kill_sb() so the operation is
safe when we are doing unmount.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 fs/super.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index b724f35..b5c9fdf 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -112,9 +112,14 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 
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
@@ -125,7 +130,6 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 						 sc->nid);
 
 	total_objects = vfs_pressure_ratio(total_objects);
-	drop_super(sb);
 	return total_objects;
 }
 
-- 
1.7.11.7


