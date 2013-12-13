Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3LMCLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:11:06 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:39664 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3LMCKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:44 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 06/14] xen: x86 pvh: use XENMEM_add_to_physmap_range for foreign gmfn mappings
Date: Thu, 12 Dec 2013 21:10:13 -0500
Message-Id: <1386900621-27528-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Squeezing the necessary fields into the existing XENMEM_add_to_physmap
interface was proving to be a bit tricky so we have decided to go with
a new interface upstream (the XENMAPSPACE_gmfn_foreign interface using
XENMEM_add_to_physmap was never committed anywhere). This interface
also allows for batching which was impossible to support at the same
time as foreign mfns in the old interface.

This reverts the relevant parts of "PVH: basic and header changes,
elfnote changes, ..." and followups and trivially converts
pvh_add_to_xen_p2m over.

Acked-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c             |   18 ++++++++++++------
 include/xen/interface/memory.h |    5 +----
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index c7de065..e334134 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2532,13 +2532,19 @@ static int pvh_add_to_xen_p2m(unsigned long lpfn, unsigned long fgmfn,
 			      unsigned int domid)
 {
 	int rc;
-	struct xen_add_to_physmap xatp = { .foreign_domid = domid };
+	struct xen_add_to_physmap_range xatp = {
+		.domid = DOMID_SELF,
+		.foreign_domid = domid,
+		.size = 1,
+		.space = XENMAPSPACE_gmfn_foreign,
+	};
+	xen_ulong_t idx = fgmfn;
+	xen_pfn_t gpfn = lpfn;
+
+	set_xen_guest_handle(xatp.idxs, &idx);
+	set_xen_guest_handle(xatp.gpfns, &gpfn);
 
-	xatp.gpfn = lpfn;
-	xatp.idx = fgmfn;
-	xatp.domid = DOMID_SELF;
-	xatp.space = XENMAPSPACE_gmfn_foreign;
-	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
+	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
 	if (rc)
 		pr_warn("d0: Failed to map pfn (0x%lx) to mfn (0x%lx) rc:%d\n",
 			lpfn, fgmfn, rc);
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index a122164..2ecfe4f 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -175,10 +175,7 @@ struct xen_add_to_physmap {
     uint16_t    size;
 
     /* Source mapping space. */
-    uint16_t space;
-    domid_t foreign_domid;         /* IFF XENMAPSPACE_gmfn_foreign */
-
-#define XENMAPIDX_grant_table_status 0x80000000
+    unsigned int space;
 
     /* Index into source mapping space. */
     xen_ulong_t idx;
-- 
1.7.7.6

