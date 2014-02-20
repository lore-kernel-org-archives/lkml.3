Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaBTHWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:22:20 -0500
Received: from relay.parallels.com ([195.214.232.42]:45673 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaBTHWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:22:18 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <mhocko@suse.cz>, <akpm@linux-foundation.org>
CC: <rientjes@google.com>, <penberg@kernel.org>, <cl@linux.com>,
        <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH -mm v3 6/7] slub: adjust memcg caches when creating cache alias
Date: Thu, 20 Feb 2014 11:22:08 +0400
Message-ID: <0677eab4fd5e0167d799961c95dc68a4df9abc48.1392879001.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1392879001.git.vdavydov@parallels.com>
References: <cover.1392879001.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, kzalloc() called from a memcg won't clear the whole object.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slub.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 2f40e615368f..cac2ff7fd68c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3748,7 +3748,11 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 
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
@@ -3756,6 +3760,15 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 		s->object_size = max(s->object_size, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 
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

