Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422711Ab3AXVZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:25:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:40789 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072Ab3AXVQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:16:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Joel D. Diaz" <joeldiaz@us.ibm.com>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <JBottomley@Parallels.com>,
        CAI Qian <caiqian@redhat.com>
Subject: [ 14/22] SCSI: sd: Reshuffle init_sd to avoid crash
Date: Thu, 24 Jan 2013 13:15:35 -0800
Message-Id: <20130124211509.408577654@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2919,10 +2919,6 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
-	err = scsi_register_driver(&sd_template.gendrv);
-	if (err)
-		goto err_out_class;
-
 	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
 					 0, 0, NULL);
 	if (!sd_cdb_cache) {
@@ -2936,8 +2932,15 @@ static int __init init_sd(void)
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
 
@@ -2960,10 +2963,10 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
+	scsi_unregister_driver(&sd_template.gendrv);
 	mempool_destroy(sd_cdb_pool);
 	kmem_cache_destroy(sd_cdb_cache);
 
-	scsi_unregister_driver(&sd_template.gendrv);
 	class_unregister(&sd_disk_class);
 
 	for (i = 0; i < SD_MAJORS; i++)


