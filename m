Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab3KNVaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:30:08 -0500
Received: from mail.tpi.com ([74.45.170.26]:33087 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab3KNV37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:29:59 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 3.13-rc1] xen-blkfront: Silence pfn maybe-uninitialized warning
Date: Thu, 14 Nov 2013 14:29:52 -0700
Message-Id: <1384464592-35970-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pfn cannot actually be used unless (!info->feature_persistent), nor is
pfn accessed in get_grant() unless (!info->feature_persistent), but silence
this warning anyway. gcc-4.8

drivers/block/xen-blkfront.c: In function 'do_blkif_request':
drivers/block/xen-blkfront.c:508:20: warning: 'pfn' may be used uninitialized in this function [-Wmaybe-uninitialized]
     gnt_list_entry = get_grant(&gref_head, pfn, info);
                    ^
drivers/block/xen-blkfront.c:492:19: note: 'pfn' was declared here
     unsigned long pfn;

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/block/xen-blkfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 432db1b..5f926de 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -489,7 +489,7 @@ static int blkif_queue_request(struct request *req)
 
 			if ((ring_req->operation == BLKIF_OP_INDIRECT) &&
 			    (i % SEGS_PER_INDIRECT_FRAME == 0)) {
-				unsigned long pfn;
+				unsigned long uninitialized_var(pfn);
 
 				if (segments)
 					kunmap_atomic(segments);
-- 
1.7.9.5

