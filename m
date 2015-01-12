Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbbALKU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:20:59 -0500
Received: from mx2.parallels.com ([199.115.105.18]:57251 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbbALKU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:20:58 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] fs: shrinker: always scan at least one object of each type
Date: Mon, 12 Jan 2015 13:20:46 +0300
Message-ID: <1421058046-2434-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In super_cache_scan() we divide the number of objects of particular type
by the total number of objects in order to distribute pressure among
different types of fs objects (inodes, dentries, fs-private objects).
As a result, in some corner cases we can get nr_to_scan=0 even if there
are some objects to reclaim, e.g. dentries=1, inodes=1, fs_objects=1,
nr_to_scan=1/3=0.

This is unacceptable for per memcg kmem accounting, because this means
that some objects may never get reclaimed after memcg death, preventing
it from being freed.

This patch therefore assures that super_cache_scan() will scan at least
one object of each type if any.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 fs/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 482b4071f4de..63136156867e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -92,13 +92,13 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	 * prune the dcache first as the icache is pinned by it, then
 	 * prune the icache, followed by the filesystem specific caches
 	 */
-	sc->nr_to_scan = dentries;
+	sc->nr_to_scan = dentries + 1;
 	freed = prune_dcache_sb(sb, sc);
-	sc->nr_to_scan = inodes;
+	sc->nr_to_scan = inodes + 1;
 	freed += prune_icache_sb(sb, sc);
 
 	if (fs_objects) {
-		sc->nr_to_scan = fs_objects;
+		sc->nr_to_scan = fs_objects + 1;
 		freed += sb->s_op->free_cached_objects(sb, sc);
 	}
 
-- 
1.7.10.4

