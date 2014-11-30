Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaK3WQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 17:16:13 -0500
Received: from ozlabs.org ([103.22.144.67]:43420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbaK3WQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 17:16:12 -0500
Date: Mon, 1 Dec 2014 09:16:07 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] slab: Fix nodeid bounds check for non-contiguous node IDs
Message-ID: <20141130221606.GA25929@iris.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bounds check for nodeid in ____cache_alloc_node gives false
positives on machines where the node IDs are not contiguous, leading
to a panic at boot time.  For example, on a POWER8 machine the node
IDs are typically 0, 1, 16 and 17.  This means that num_online_nodes()
returns 4, so when ____cache_alloc_node is called with nodeid = 16 the
VM_BUG_ON triggers.

To fix this, we instead compare the nodeid with MAX_NUMNODES, and
additionally make sure it isn't negative (since nodeid is an int).
The check is there mainly to protect the array dereference in the
get_node() call in the next line, and the array being dereferenced is
of size MAX_NUMNODES.  If the nodeid is in range but invalid, the
BUG_ON in the next line will catch that.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/mm/slab.c b/mm/slab.c
index eb2b2ea..f34e053 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3076,7 +3076,7 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 	void *obj;
 	int x;
 
-	VM_BUG_ON(nodeid > num_online_nodes());
+	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);
 	n = get_node(cachep, nodeid);
 	BUG_ON(!n);
 
