Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3AXDdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:33:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44484 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3AXDcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:32:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Joel D. Diaz" <joeldiaz@us.ibm.com>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <JBottomley@Parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 74/74] [SCSI] sd: Reshuffle init_sd to avoid crash
Date: Thu, 24 Jan 2013 01:27:26 -0200
Message-Id: <1358998046-613-75-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Joel D. Diaz" <joeldiaz@us.ibm.com>

commit afd5e34b2bb34881d3a789e62486814a49b47faa upstream.

scsi_register_driver will register a prep_fn() function, which
in turn migh need to use the sd_cdp_pool for DIF.
Which hasn't been initialised at this point, leading to
a crash. So reshuffle the init_sd() and exit_sd() paths
to have the driver registered last.

Signed-off-by: Joel D. Diaz <joeldiaz@us.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/scsi/sd.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f72b80..043395d0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2920,10 +2920,6 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
-	err = scsi_register_driver(&sd_template.gendrv);
-	if (err)
-		goto err_out_class;
-
 	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
 					 0, 0, NULL);
 	if (!sd_cdb_cache) {
@@ -2937,8 +2933,15 @@ static int __init init_sd(void)
 		goto err_out_cache;
 	}
 
+	err = scsi_register_driver(&sd_template.gendrv);
+	if (err)
+		goto err_out_driver;
+
 	return 0;
 
+err_out_driver:
+	mempool_destroy(sd_cdb_pool);
+
 err_out_cache:
 	kmem_cache_destroy(sd_cdb_cache);
 
@@ -2961,10 +2964,10 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
+	scsi_unregister_driver(&sd_template.gendrv);
 	mempool_destroy(sd_cdb_pool);
 	kmem_cache_destroy(sd_cdb_cache);
 
-	scsi_unregister_driver(&sd_template.gendrv);
 	class_unregister(&sd_disk_class);
 
 	for (i = 0; i < SD_MAJORS; i++)
-- 
1.7.9.5

