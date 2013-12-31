Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3LaPzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 10:55:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21399 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3LaPzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 10:55:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] swiotlb: Don't DoS us with 'swiotlb buffer is full'
Date: Tue, 31 Dec 2013 10:54:14 -0500
Message-Id: <1388505254-2986-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for that so lets use ratelimiting.
Also add some extra information to be helpful.

CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e4399fa..7c97bd2 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -505,7 +505,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 
 not_found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
-	dev_warn(hwdev, "swiotlb buffer is full\n");
+	if (printk_ratelimit())
+		dev_warn(hwdev, "swiotlb buffer is full (sz: %ld bytes)\n", size);
 	return SWIOTLB_MAP_ERROR;
 found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
-- 
1.8.3.1

