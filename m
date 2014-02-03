Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaBCPz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:55:27 -0500
Received: from relay.parallels.com ([195.214.232.42]:35597 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaBCPys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:54:48 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH v2 6/7] slub: adjust memcg caches when creating cache alias
Date: Mon, 3 Feb 2014 19:54:41 +0400
Message-ID: <83029acb31807645496a6ccb826a6af7bb56e259.1391441746.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1391441746.git.vdavydov@parallels.com>
References: <cover.1391441746.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, kzalloc() called from a memcg won't clear the whole object.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slub.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 8659e7184338..f3d2ef725ed6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3743,7 +3743,11 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
+		int i;
+		struct kmem_cache *c;
+
 		s->refcount++;
+
 		/*
 		 * Adjust the object sizes so that we clear
 		 * the complete object on kzalloc.
@@ -3751,6 +3755,16 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 		s->object_size = max(s->object_size, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 
+		BUG_ON(!is_root_cache(s));
+		for_each_memcg_cache_index(i) {
+			c = cache_from_memcg_idx(s, i);
+			if (!c)
+				continue;
+			c->object_size = s->object_size;
+			c->inuse = max_t(int, c->inuse,
+					 ALIGN(size, sizeof(void *)));
+		}
+
 		if (sysfs_slab_alias(s, name)) {
 			s->refcount--;
 			s = NULL;
-- 
1.7.10.4

