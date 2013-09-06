Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3IFO7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:59:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21284 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3IFO7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:59:32 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: stefano.stabellini@eu.citrix.com, david.vrabel@citrix.com,
        konrad.wilk@oracle.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH] xen/p2m: Don't call get_balloon_scratch_page() twice, keep interrupts disabled for multicalls
Date: Fri,  6 Sep 2013 11:00:46 -0400
Message-Id: <1378479646-12592-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m2p_remove_override() calls get_balloon_scratch_page() in
MULTI_update_va_mapping() even though it already has pointer to this page from
the earlier call (in scratch_page). This second call doesn't have a matching
put_balloon_scratch_page() thus not restoring preempt count back. (Also, there
is no put_balloon_scratch_page() in the error path.)

In addition, the second multicall uses __xen_mc_entry() which does not disable
interrupts. Rearrange xen_mc_* calls to keep interrupts off while performing
multicalls.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/p2m.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 0d4ec35..8b901e8 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -990,10 +990,13 @@ int m2p_remove_override(struct page *page,
 				printk(KERN_WARNING "m2p_remove_override: "
 						"pfn %lx mfn %lx, failed to modify kernel mappings",
 						pfn, mfn);
+				put_balloon_scratch_page();
 				return -1;
 			}
 
-			mcs = xen_mc_entry(
+			xen_mc_batch();
+
+			mcs = __xen_mc_entry(
 					sizeof(struct gnttab_unmap_and_replace));
 			unmap_op = mcs.args;
 			unmap_op->host_addr = kmap_op->host_addr;
@@ -1003,12 +1006,11 @@ int m2p_remove_override(struct page *page,
 			MULTI_grant_table_op(mcs.mc,
 					GNTTABOP_unmap_and_replace, unmap_op, 1);
 
-			xen_mc_issue(PARAVIRT_LAZY_MMU);
-
 			mcs = __xen_mc_entry(0);
 			MULTI_update_va_mapping(mcs.mc, scratch_page_address,
-					pfn_pte(page_to_pfn(get_balloon_scratch_page()),
+					pfn_pte(page_to_pfn(scratch_page),
 					PAGE_KERNEL_RO), 0);
+
 			xen_mc_issue(PARAVIRT_LAZY_MMU);
 
 			kmap_op->host_addr = 0;
-- 
1.8.3.1

