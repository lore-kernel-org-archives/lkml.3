Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3DZPPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:15:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab3DZPPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:15:45 -0400
From: atomlin@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cl@linux.com, penberg@kernel.org,
        riel@redhat.com, aquini@redhat.com, rientjes@google.com,
        Aaron Tomlin <atomlin@redhat.com>
Subject: [PATCH v3] mm: slab: Verify the nodeid passed to ____cache_alloc_node
Date: Fri, 26 Apr 2013 16:15:34 +0100
Message-Id: <1366989334-13293-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

Hi,

This patch is in response to BZ#42967 [1].
Using VM_BUG_ON so it's used only when CONFIG_DEBUG_VM is set,
given that ____cache_alloc_node() is a hot code path.

Cheers,
Aaron

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=42967

---8<---
mm: slab: Verify the nodeid passed to ____cache_alloc_node

If the nodeid is > num_online_nodes() this can cause an
Oops and a panic(). The purpose of this patch is to assert
if this condition is true to aid debugging efforts rather
than some random NULL pointer dereference or page fault.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 mm/slab.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/slab.c b/mm/slab.c
index 856e4a1..09b4e20 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3412,6 +3412,7 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 	void *obj;
 	int x;
 
+	VM_BUG_ON(nodeid > num_online_nodes());
 	l3 = cachep->nodelists[nodeid];
 	BUG_ON(!l3);
 
-- 
1.8.1.4

