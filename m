Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3JYLFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:05:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:53742 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3JYLFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:05:49 -0400
X-IronPort-AV: E=Sophos;i="4.93,569,1378857600"; 
   d="scan'208";a="64688080"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 17/18] grant-table: call set_phys_to_machine after mapping grant refs
Date: Fri, 25 Oct 2013 11:51:52 +0100
Message-ID: <1382698313-13161-17-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mapping/unmapping grant refs, call
set_phys_to_machine to update the P2M with the new mappings for
autotranslate guests.
This is (almost) a nop on x86.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Changes in v9:
- add in-code comments.
---
 drivers/xen/grant-table.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index c4d2298..62ccf54 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -49,6 +49,7 @@
 #include <xen/grant_table.h>
 #include <xen/interface/memory.h>
 #include <xen/hvc-console.h>
+#include <xen/swiotlb-xen.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/interface.h>
 
@@ -898,8 +899,16 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 			gnttab_retry_eagain_gop(GNTTABOP_map_grant_ref, map_ops + i,
 						&map_ops[i].status, __func__);
 
-	if (xen_feature(XENFEAT_auto_translated_physmap))
+	/* this is basically a nop on x86 */
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		for (i = 0; i < count; i++) {
+			if (map_ops[i].status)
+				continue;
+			set_phys_to_machine(map_ops[i].host_addr >> PAGE_SHIFT,
+					map_ops[i].dev_bus_addr >> PAGE_SHIFT);
+		}
 		return ret;
+	}
 
 	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
 		arch_enter_lazy_mmu_mode();
@@ -942,8 +951,14 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 	if (ret)
 		return ret;
 
-	if (xen_feature(XENFEAT_auto_translated_physmap))
+	/* this is basically a nop on x86 */
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		for (i = 0; i < count; i++) {
+			set_phys_to_machine(unmap_ops[i].host_addr >> PAGE_SHIFT,
+					INVALID_P2M_ENTRY);
+		}
 		return ret;
+	}
 
 	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
 		arch_enter_lazy_mmu_mode();
-- 
1.7.2.5

