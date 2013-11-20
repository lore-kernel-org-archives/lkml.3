Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3KTUMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:12:14 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49975 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab3KTUMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:12:10 -0500
From: Matt Wilson <msw@linux.com>
To: xen-devel@lists.xenproject.org
Cc: Matt Wilson <msw@amazon.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] xen/gnttab: leave lazy MMU mode in the case of a m2p override failure
Date: Wed, 20 Nov 2013 12:11:35 -0800
Message-Id: <1384978295-18292-1-git-send-email-msw@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wilson <msw@amazon.com>

Commit f62805f1 introduced a bug where lazy MMU mode isn't exited if a
m2p_add/remove_override call fails.

Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Anthony Liguori <aliguori@amazon.com>
Cc: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Matt Wilson <msw@amazon.com>
---
 drivers/xen/grant-table.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 62ccf54..0283871 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -930,9 +930,10 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
 				       &kmap_ops[i] : NULL);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
+ out:
 	if (lazy)
 		arch_leave_lazy_mmu_mode();
 
@@ -969,9 +970,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		ret = m2p_remove_override(pages[i], kmap_ops ?
 				       &kmap_ops[i] : NULL);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
+ out:
 	if (lazy)
 		arch_leave_lazy_mmu_mode();
 
-- 
1.7.9.5

