Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbaFCVe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:34:29 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:63437 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965076AbaFCVe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:34:28 -0400
From: =?UTF-8?q?Cl=C3=A9ment=20Calmels?= <clement.calmels@free.fr>
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sd: bad return code of init_sd
Date: Tue,  3 Jun 2014 23:34:25 +0200
Message-Id: <1401831265-8547-1-git-send-email-clement.calmels@free.fr>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In init_sd function, if kmem_cache_create or mempool_create_slab_pools
calls fail, the error will not be correclty reported because
class_register previously set the value of err to 0.

Signed-off-by: Clément Calmels <clement.calmels@free.fr>
---
 drivers/scsi/sd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e9689d5..7daa2aa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3205,12 +3205,14 @@ static int __init init_sd(void)
 					 0, 0, NULL);
 	if (!sd_cdb_cache) {
 		printk(KERN_ERR "sd: can't init extended cdb cache\n");
+		err = -ENOMEM;
 		goto err_out_class;
 	}
 
 	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
 	if (!sd_cdb_pool) {
 		printk(KERN_ERR "sd: can't init extended cdb pool\n");
+		err = -ENOMEM;
 		goto err_out_cache;
 	}
 
-- 
2.0.0

