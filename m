Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3DWObn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:31:43 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:58951 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab3DWObl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:31:41 -0400
Date: Tue, 23 Apr 2013 10:31:36 -0400 (EDT)
From: Aaron Tomlin <atomlin@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cl@linux.com, penberg@kernel.org,
        Rik <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>
Message-ID: <1014891011.990074.1366727496599.JavaMail.root@redhat.com>
In-Reply-To: <1081382531.982691.1366726661820.JavaMail.root@redhat.com>
Subject: [Patch v2] mm: slab: Verify the nodeid passed to
 ____cache_alloc_node
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC26 (Linux)/8.0.3_GA_5664)
Thread-Topic: slab: Verify the nodeid passed to ____cache_alloc_node
Thread-Index: E1uUKNmdgrejplje+FRlUAAEnw7pXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


 slab.c |    1 +
 1 file changed, 1 insertion(+)
 
diff --git a/mm/slab.c b/mm/slab.c
index e7667a3..735e8bd 100644
--- a/mm/slab.c
+++ b/mm/slab.c
 -3412,6 +3412,7 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 	void *obj;
 	int x;
 
+	VM_BUG_ON(nodeid > num_online_nodes());
 	l3 = cachep->nodelists[nodeid];
 	BUG_ON(!l3);
