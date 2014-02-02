Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaBBQep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:34:45 -0500
Received: from relay.parallels.com ([195.214.232.42]:46408 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaBBQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:34:00 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH 5/8] slub: adjust memcg caches when creating cache alias
Date: Sun, 2 Feb 2014 20:33:50 +0400
Message-ID: <d41c465b8d746f575a4a6ae0edf524d391387e02.1391356789.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1391356789.git.vdavydov@parallels.com>
References: <cover.1391356789.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.195]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, kzalloc() called from a memcg won't clear the whole object.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slub.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 962abfdfde06..a33d88afb61d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3737,7 +3737,11 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 
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
@@ -3745,6 +3749,16 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
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

