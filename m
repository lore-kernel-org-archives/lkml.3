Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3KAWky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:40:54 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44087 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291Ab3KAWka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:40:30 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 8/8] sh/dwarf: use rbtree postorder iteration helper instead of solution using repeated rb_erase()
Date: Fri,  1 Nov 2013 15:38:52 -0700
Message-Id: <1383345566-25087-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110122-7182-0000-0000-000008FB543F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of using repeated rb_erase() calls

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/sh/kernel/dwarf.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/sh/kernel/dwarf.c b/arch/sh/kernel/dwarf.c
index 49c09c7..67a049e 100644
--- a/arch/sh/kernel/dwarf.c
+++ b/arch/sh/kernel/dwarf.c
@@ -995,29 +995,19 @@ static struct unwinder dwarf_unwinder = {
 
 static void dwarf_unwinder_cleanup(void)
 {
-	struct rb_node **fde_rb_node = &fde_root.rb_node;
-	struct rb_node **cie_rb_node = &cie_root.rb_node;
+	struct dwarf_fde *fde, *next_fde;
+	struct dwarf_cie *cie, *next_cie;
 
 	/*
 	 * Deallocate all the memory allocated for the DWARF unwinder.
 	 * Traverse all the FDE/CIE lists and remove and free all the
 	 * memory associated with those data structures.
 	 */
-	while (*fde_rb_node) {
-		struct dwarf_fde *fde;
-
-		fde = rb_entry(*fde_rb_node, struct dwarf_fde, node);
-		rb_erase(*fde_rb_node, &fde_root);
+	rbtree_postorder_for_each_entry_safe(fde, next_fde, &fde_root, node)
 		kfree(fde);
-	}
 
-	while (*cie_rb_node) {
-		struct dwarf_cie *cie;
-
-		cie = rb_entry(*cie_rb_node, struct dwarf_cie, node);
-		rb_erase(*cie_rb_node, &cie_root);
+	rbtree_postorder_for_each_entry_safe(cie, next_cie, &cie_root, node)
 		kfree(cie);
-	}
 
 	kmem_cache_destroy(dwarf_reg_cachep);
 	kmem_cache_destroy(dwarf_frame_cachep);
-- 
1.8.4.2

