Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaFWIew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:34:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55663 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Lawrence <joe.lawrence@stratus.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/111] SCSI: scsi_transport_sas: move bsg destructor into sas_rphy_remove
Date: Mon, 23 Jun 2014 10:31:02 +0200
Message-Id: <517e5981c10ff3fe845ace3c2d7e664da72eafdf.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Lawrence <joe.lawrence@stratus.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6aa6caff30f5dcb9e55b03b9710c30b83750cae5 upstream.

The recent change in sysfs, bcdde7e221a8750f9b62b6d0bd31b72ea4ad9309
"sysfs: make __sysfs_remove_dir() recursive" revealed an asymmetric
rphy device creation/deletion sequence in scsi_transport_sas:

  modprobe mpt2sas
    sas_rphy_add
      device_add A               rphy->dev
      device_add B               sas_device transport class
      device_add C               sas_end_device transport class
      device_add D               bsg class

  rmmod mpt2sas
    sas_rphy_delete
      sas_rphy_remove
        device_del B
        device_del C
        device_del A
          sysfs_remove_group     recursive sysfs dir removal
      sas_rphy_free
        device_del D             warning

  where device A is the parent of B, C, and D.

When sas_rphy_free tries to unregister the bsg request queue (device D
above), the ensuing sysfs cleanup discovers that its sysfs group has
already been removed and emits a warning, "sysfs group... not found for
kobject 'end_device-X:0'".

Since bsg creation is a side effect of sas_rphy_add, move its
complementary removal call into sas_rphy_remove. This imposes the
following tear-down order for the devices above: D, B, C, A.

Note the sas_device and sas_end_device transport class devices (B and C
above) are created and destroyed both via the list match traversal in
attribute_container_device_trigger, so the order in which they are
handled is fixed. This is fine as long as they are deleted before their
parent device.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/scsi_transport_sas.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b681427dde0..c341f855fadc 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1621,8 +1621,6 @@ void sas_rphy_free(struct sas_rphy *rphy)
 	list_del(&rphy->list);
 	mutex_unlock(&sas_host->lock);
 
-	sas_bsg_remove(shost, rphy);
-
 	transport_destroy_device(dev);
 
 	put_device(dev);
@@ -1681,6 +1679,7 @@ sas_rphy_remove(struct sas_rphy *rphy)
 	}
 
 	sas_rphy_unlink(rphy);
+	sas_bsg_remove(NULL, rphy);
 	transport_remove_device(dev);
 	device_del(dev);
 }
-- 
2.0.0

