Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3KTIxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:53:05 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43891 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTIxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:53:03 -0500
From: Bob Liu <lliubbo@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org, konrad.wilk@oracle.com, JBeulich@suse.com,
        ian.campbell@citrix.com, keir@xen.org, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] xen: tmem: rmove useless parameters
Date: Wed, 20 Nov 2013 16:52:55 +0800
Message-Id: <1384937575-25168-1-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmem only takes a page as unit, so parameters tmem_offset, pfn_offset and len
are meanless, this patch remove those always 0 parameters.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/xen/tmem.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index 83b5c53..9fd0fdc 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -89,7 +89,7 @@ struct tmem_oid {
 /* xen tmem foundation ops/hypercalls */
 
 static inline int xen_tmem_op(u32 tmem_cmd, u32 tmem_pool, struct tmem_oid oid,
-	u32 index, unsigned long gmfn, u32 tmem_offset, u32 pfn_offset, u32 len)
+		u32 index, unsigned long gmfn)
 {
 	struct tmem_op op;
 	int rc = 0;
@@ -100,9 +100,6 @@ static inline int xen_tmem_op(u32 tmem_cmd, u32 tmem_pool, struct tmem_oid oid,
 	op.u.gen.oid[1] = oid.oid[1];
 	op.u.gen.oid[2] = oid.oid[2];
 	op.u.gen.index = index;
-	op.u.gen.tmem_offset = tmem_offset;
-	op.u.gen.pfn_offset = pfn_offset;
-	op.u.gen.len = len;
 	set_xen_guest_handle(op.u.gen.gmfn, (void *)gmfn);
 	rc = HYPERVISOR_tmem_op(&op);
 	return rc;
@@ -133,8 +130,7 @@ static int xen_tmem_put_page(u32 pool_id, struct tmem_oid oid,
 {
 	unsigned long gmfn = xen_pv_domain() ? pfn_to_mfn(pfn) : pfn;
 
-	return xen_tmem_op(TMEM_PUT_PAGE, pool_id, oid, index,
-		gmfn, 0, 0, 0);
+	return xen_tmem_op(TMEM_PUT_PAGE, pool_id, oid, index, gmfn);
 }
 
 static int xen_tmem_get_page(u32 pool_id, struct tmem_oid oid,
@@ -142,19 +138,17 @@ static int xen_tmem_get_page(u32 pool_id, struct tmem_oid oid,
 {
 	unsigned long gmfn = xen_pv_domain() ? pfn_to_mfn(pfn) : pfn;
 
-	return xen_tmem_op(TMEM_GET_PAGE, pool_id, oid, index,
-		gmfn, 0, 0, 0);
+	return xen_tmem_op(TMEM_GET_PAGE, pool_id, oid, index, gmfn);
 }
 
 static int xen_tmem_flush_page(u32 pool_id, struct tmem_oid oid, u32 index)
 {
-	return xen_tmem_op(TMEM_FLUSH_PAGE, pool_id, oid, index,
-		0, 0, 0, 0);
+	return xen_tmem_op(TMEM_FLUSH_PAGE, pool_id, oid, index, 0);
 }
 
 static int xen_tmem_flush_object(u32 pool_id, struct tmem_oid oid)
 {
-	return xen_tmem_op(TMEM_FLUSH_OBJECT, pool_id, oid, 0, 0, 0, 0, 0);
+	return xen_tmem_op(TMEM_FLUSH_OBJECT, pool_id, oid, 0, 0);
 }
 
 
@@ -163,7 +157,7 @@ static int xen_tmem_destroy_pool(u32 pool_id)
 {
 	struct tmem_oid oid = { { 0 } };
 
-	return xen_tmem_op(TMEM_DESTROY_POOL, pool_id, oid, 0, 0, 0, 0, 0);
+	return xen_tmem_op(TMEM_DESTROY_POOL, pool_id, oid, 0, 0);
 }
 
 /* cleancache ops */
-- 
1.7.10.4

