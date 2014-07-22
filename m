Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbaGVSRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:17:23 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56843 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaGVSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:17:22 -0400
Date: Tue, 22 Jul 2014 23:40:19 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] powerpc/perf/hv-24x7: Use kmem_cache_free
Message-ID: <20140722181019.GA3222@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free memory allocated using kmem_cache_zalloc using kmem_cache_free
rather than kfree.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@@
expression x,E,c;
@@

 x = \(kmem_cache_alloc\|kmem_cache_zalloc\|kmem_cache_alloc_node\)(c,...)
 ... when != x = E
     when != &x
?-kfree(x)
+kmem_cache_free(c,x)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 arch/powerpc/perf/hv-24x7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 66d0f17..70d4f74 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -223,7 +223,7 @@ e_free:
 		pr_err("h_get_24x7_catalog_page(ver=%lld, page=%lld) failed:"
 		       " rc=%ld\n",
 		       catalog_version_num, page_offset, hret);
-	kfree(page);
+	kmem_cache_free(hv_page_cache, page);
 
 	pr_devel("catalog_read: offset=%lld(%lld) count=%zu(%zu) catalog_len=%zu(%zu) => %zd\n",
 			offset, page_offset, count, page_count, catalog_len,
-- 
1.9.1

