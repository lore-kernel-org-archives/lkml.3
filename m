Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3BCB3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:29:17 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59139 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3BCBW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:28 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 37/62] mtd: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:38 -0800
Message-Id: <1359854463-2538-38-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/mtd/mtdcore.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index ec794a7..61d5f56 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -349,13 +349,8 @@ int add_mtd_device(struct mtd_info *mtd)
 	BUG_ON(mtd->writesize == 0);
 	mutex_lock(&mtd_table_mutex);
 
-	do {
-		if (!idr_pre_get(&mtd_idr, GFP_KERNEL))
-			goto fail_locked;
-		error = idr_get_new(&mtd_idr, mtd, &i);
-	} while (error == -EAGAIN);
-
-	if (error)
+	i = idr_alloc(&mtd_idr, mtd, 0, 0, GFP_KERNEL);
+	if (i < 0)
 		goto fail_locked;
 
 	mtd->index = i;
-- 
1.8.1

