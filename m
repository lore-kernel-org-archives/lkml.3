Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab3BYRST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:18:19 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:33843 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3BYRSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:18:18 -0500
Date: Mon, 25 Feb 2013 12:18:10 -0500 (EST)
From: Aaron Tomlin <atomlin@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Rik <riel@redhat.com>, glommer@parallels.com
Message-ID: <591256534.8212978.1361812690861.JavaMail.root@redhat.com>
In-Reply-To: <813482873.8209105.1361812140956.JavaMail.root@redhat.com>
Subject: Re: [PATCH v2] mm: slab: Verify the nodeid passed to
 ____cache_alloc_node
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.33.1.237]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC24 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch is in response to bz#42967 [1]. Using VM_BUG_ON
instead of a generic BUG_ON so it's used only when 
CONFIG_DEBUG_VM is set, given that ____cache_alloc_node()
is a hot code path.

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

 slab.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/slab.c b/mm/slab.c
index e7667a3..735e8bd 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3412,6 +3412,7 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 	void *obj;
 	int x;
 
+	VM_BUG_ON(nodeid > num_online_nodes());
 	l3 = cachep->nodelists[nodeid];
 	BUG_ON(!l3);
