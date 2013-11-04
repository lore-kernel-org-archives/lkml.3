Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3KDMjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:39:39 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54884 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3KDMji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:39:38 -0500
From: Bob Liu <lliubbo@gmail.com>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] drivers: xen-selfballoon: consider slab pages
Date: Mon,  4 Nov 2013 20:39:24 +0800
Message-Id: <1383568764-30478-1-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the goal_page in xen-selfballon doesn't consider much about pages used
in kernel space.
A typical usage is slab pages, without consider slab pages the goal_page result
may be too rough and lead extra memory pressure to guest os.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/xen/xen-selfballoon.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 21e18c1..4814759 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -191,6 +191,8 @@ static void selfballoon_process(struct work_struct *work)
 		tgt_pages = cur_pages; /* default is no change */
 		goal_pages = vm_memory_committed() +
 				totalreserve_pages +
+				global_page_state(NR_SLAB_RECLAIMABLE) +
+				global_page_state(NR_SLAB_UNRECLAIMABLE) +
 				MB2PAGES(selfballoon_reserved_mb);
 #ifdef CONFIG_FRONTSWAP
 		/* allow space for frontswap pages to be repatriated */
-- 
1.7.10.4

