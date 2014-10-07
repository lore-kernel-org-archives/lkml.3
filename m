Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbaJGX04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:26:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbaJGXUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 33/37] mm: vmscan: respect NUMA policy mask when shrinking slab on direct reclaim
Date: Tue,  7 Oct 2014 16:19:50 -0700
Message-Id: <20141007231828.071727354@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Davydov <vdavydov@parallels.com>

commit 99120b772b52853f9a2b829a21dd44d9b20558f1 upstream.

When direct reclaim is executed by a process bound to a set of NUMA
nodes, we should scan only those nodes when possible, but currently we
will scan kmem from all online nodes even if the kmem shrinker is NUMA
aware.  That said, binding a process to a particular NUMA node won't
prevent it from shrinking inode/dentry caches from other nodes, which is
not good.  Fix this.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2424,8 +2424,8 @@ static unsigned long do_try_to_free_page
 			unsigned long lru_pages = 0;
 
 			nodes_clear(shrink->nodes_to_scan);
-			for_each_zone_zonelist(zone, z, zonelist,
-					gfp_zone(sc->gfp_mask)) {
+			for_each_zone_zonelist_nodemask(zone, z, zonelist,
+					gfp_zone(sc->gfp_mask), sc->nodemask) {
 				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 					continue;
 


