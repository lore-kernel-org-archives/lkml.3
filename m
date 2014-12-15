Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaLOTeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:34:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41066 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaLOTeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:34:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 83/96] slab: fix nodeid bounds check for non-contiguous node IDs
Date: Mon, 15 Dec 2014 11:26:43 -0800
Message-Id: <1418671616-25482-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit 7c3fbbdd04a681a1992ad6a3d7a36a63ff668753 upstream.

The bounds check for nodeid in ____cache_alloc_node gives false
positives on machines where the node IDs are not contiguous, leading to
a panic at boot time.  For example, on a POWER8 machine the node IDs are
typically 0, 1, 16 and 17.  This means that num_online_nodes() returns
4, so when ____cache_alloc_node is called with nodeid = 16 the VM_BUG_ON
triggers, like this:

  kernel BUG at /home/paulus/kernel/kvm/mm/slab.c:3079!
  Call Trace:
    .____cache_alloc_node+0x5c/0x270 (unreliable)
    .kmem_cache_alloc_node_trace+0xdc/0x360
    .init_list+0x3c/0x128
    .kmem_cache_init+0x1dc/0x258
    .start_kernel+0x2a0/0x568
    start_here_common+0x20/0xa8

To fix this, we instead compare the nodeid with MAX_NUMNODES, and
additionally make sure it isn't negative (since nodeid is an int).  The
check is there mainly to protect the array dereference in the get_node()
call in the next line, and the array being dereferenced is of size
MAX_NUMNODES.  If the nodeid is in range but invalid (for example if the
node is off-line), the BUG_ON in the next line will catch that.

Fixes: 14e50c6a9bc2 ("mm: slab: Verify the nodeid passed to ____cache_alloc_node")
Signed-off-by: Paul Mackerras <paulus@samba.org>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/slab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index f985e8f..8777f76 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3141,7 +3141,7 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 	void *obj;
 	int x;
 
-	VM_BUG_ON(nodeid > num_online_nodes());
+	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);
 	n = cachep->node[nodeid];
 	BUG_ON(!n);
 
-- 
1.9.1

