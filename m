Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3FDOpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:45:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54681 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755311Ab3FDOpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:45:02 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 3/4] mtd: onenand: samsung: Release memory after incorrect return/goto
Date: Tue,  4 Jun 2013 07:44:49 -0700
Message-Id: <ec732a1673510a786e5333b00730b8226e792357.1370356776.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <60123fd3175b7cceadf6c335b12e58b797e18f65.1370356776.git.joe@perches.com>
References: <60123fd3175b7cceadf6c335b12e58b797e18f65.1370356776.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code uses

    return foo;
    goto err_type;

when instead the form should have been

    ret = foo;
    goto err_type;

Here this causes a useful kfree to be skipped.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mtd/onenand/samsung.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
index 2cf7408..90bd111 100644
--- a/drivers/mtd/onenand/samsung.c
+++ b/drivers/mtd/onenand/samsung.c
@@ -895,8 +895,8 @@ static int s3c_onenand_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
 		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENOENT;
-		goto ahb_resource_failed;
+		err = -ENOENT;
+		goto resource_failed;
 	}
 
 	onenand->base_res = request_mem_region(r->start, resource_size(r),
-- 
1.8.1.2.459.gbcd45b4.dirty

