Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3LUPyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 10:54:18 -0500
Received: from relay.parallels.com ([195.214.232.42]:38810 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab3LUPyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 10:54:15 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <mhocko@suse.cz>
CC: <glommer@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: [PATCH 08/11] slab: do not panic if we fail to create memcg cache
Date: Sat, 21 Dec 2013 19:53:59 +0400
Message-ID: <df3fd2e16138e4efd5fcb9547b936c54273d3350.1387640542.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1387640541.git.vdavydov@parallels.com>
References: <cover.1387640541.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.198]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in flooding logs with warnings or especially crashing
the system if we fail to create a cache for a memcg. In this case we
will be accounting the memcg allocation to the root cgroup until we
succeed to create its own cache, but it isn't that critical.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/slab_common.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index f34707e..8e40321 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -233,7 +233,14 @@ out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-	if (err) {
+	/*
+	 * There is no point in flooding logs with warnings or especially
+	 * crashing the system if we fail to create a cache for a memcg. In
+	 * this case we will be accounting the memcg allocation to the root
+	 * cgroup until we succeed to create its own cache, but it isn't that
+	 * critical.
+	 */
+	if (err && !memcg) {
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);
-- 
1.7.10.4

