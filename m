Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaJTLvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:51:12 -0400
Received: from mx2.parallels.com ([199.115.105.18]:37134 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaJTLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:50:57 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Zefan Li <lizefan@huawei.com>, Christoph Lameter <cl@linux.com>,
        "Pekka Enberg" <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        "Joonsoo Kim" <iamjoonsoo.kim@lge.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH RESEND 4/4] slub: fix cpuset check in get_any_partial
Date: Mon, 20 Oct 2014 15:50:32 +0400
Message-ID: <0b246d9b370c21fd2223e996b514be55b80a4637.1413804554.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1413804554.git.vdavydov@parallels.com>
References: <cover.1413804554.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to allocate from the current node's stock, we look for free
objects on other nodes before calling the page allocator (see
get_any_partial). While checking other nodes we respect cpuset
constraints by calling cpuset_zone_allowed. We enforce hardwall check.
As a result, we will fallback to the page allocator even if there are
some pages cached on other nodes, but the current cpuset doesn't have
them set. However, the page allocator uses softwall check for kernel
allocations, so it may allocate from one of the other nodes in this
case.

Therefore we should use softwall cpuset check in get_any_partial to
conform with the cpuset check in the page allocator.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Zefan Li <lizefan@huawei.com>
---
 mm/slub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7d12f51d9bac..32ec8fd91bb3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1662,8 +1662,7 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 
 			n = get_node(s, zone_to_nid(zone));
 
-			if (n && cpuset_zone_allowed(zone,
-						     flags | __GFP_HARDWALL) &&
+			if (n && cpuset_zone_allowed(zone, flags) &&
 					n->nr_partial > s->min_partial) {
 				object = get_partial_node(s, n, c, flags);
 				if (object) {
-- 
1.7.10.4

