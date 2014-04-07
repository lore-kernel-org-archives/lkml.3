Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbaDGKuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 06:50:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:57333 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbaDGKuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 06:50:10 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <cl@linux-foundation.org>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH] slub: fix memcg_propagate_slab_attrs
Date: Mon, 7 Apr 2014 14:50:07 +0400
Message-ID: <1396867807-22824-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After creating a cache for a memcg we should initialize its sysfs attrs
with the values from its parent. That's what memcg_propagate_slab_attrs
is for. Currently it's broken - we clearly muddled root-vs-memcg caches
there. Let's fix it up.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slub.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 09660b9ff5bd..9fc144f9a542 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5070,15 +5070,18 @@ static void memcg_propagate_slab_attrs(struct kmem_cache *s)
 #ifdef CONFIG_MEMCG_KMEM
 	int i;
 	char *buffer = NULL;
+	struct kmem_cache *root_cache;
 
-	if (!is_root_cache(s))
+	if (is_root_cache(s))
 		return;
 
+	root_cache = s->memcg_params->root_cache;
+
 	/*
 	 * This mean this cache had no attribute written. Therefore, no point
 	 * in copying default values around
 	 */
-	if (!s->max_attr_size)
+	if (!root_cache->max_attr_size)
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(slab_attrs); i++) {
@@ -5100,7 +5103,7 @@ static void memcg_propagate_slab_attrs(struct kmem_cache *s)
 		 */
 		if (buffer)
 			buf = buffer;
-		else if (s->max_attr_size < ARRAY_SIZE(mbuf))
+		else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf))
 			buf = mbuf;
 		else {
 			buffer = (char *) get_zeroed_page(GFP_KERNEL);
@@ -5109,7 +5112,7 @@ static void memcg_propagate_slab_attrs(struct kmem_cache *s)
 			buf = buffer;
 		}
 
-		attr->show(s->memcg_params->root_cache, buf);
+		attr->show(root_cache, buf);
 		attr->store(s, buf, strlen(buf));
 	}
 
-- 
1.7.10.4

