Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3LQSOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:14:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60844 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3LQSOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, Matt Wilson <msw@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 031/103] xen/gnttab: leave lazy MMU mode in the case of a m2p override failure
Date: Tue, 17 Dec 2013 18:12:20 +0000
Message-Id: <1387304012-23805-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Wilson <msw@amazon.com>

commit 14883a75ec76b44759385fb12629f4a0f1aef4e3 upstream.

Commit f62805f1 introduced a bug where lazy MMU mode isn't exited if a
m2p_add/remove_override call fails.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Anthony Liguori <aliguori@amazon.com>
Cc: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Matt Wilson <msw@amazon.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/grant-table.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 8a6ecc5..93cb98e 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -867,9 +867,10 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
 				       &kmap_ops[i] : NULL);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
+ out:
 	if (lazy)
 		arch_leave_lazy_mmu_mode();
 
@@ -900,9 +901,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
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
1.8.3.2

