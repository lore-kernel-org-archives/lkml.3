Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab3BCPFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:05:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34547 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867Ab3BCO57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:59 -0500
Message-Id: <20130203144654.009442404@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "Joel D. Diaz" <joeldiaz@us.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 113/128] [SCSI] sd: Reshuffle init_sd to avoid crash
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sd.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 352bc77..a45e12a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3116,10 +3116,6 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
-	err = scsi_register_driver(&sd_template.gendrv);
-	if (err)
-		goto err_out_class;
-
 	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
 					 0, 0, NULL);
 	if (!sd_cdb_cache) {
@@ -3133,8 +3129,15 @@ static int __init init_sd(void)
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
 
@@ -3157,10 +3160,10 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
+	scsi_unregister_driver(&sd_template.gendrv);
 	mempool_destroy(sd_cdb_pool);
 	kmem_cache_destroy(sd_cdb_cache);
 
-	scsi_unregister_driver(&sd_template.gendrv);
 	class_unregister(&sd_disk_class);
 
 	for (i = 0; i < SD_MAJORS; i++)


