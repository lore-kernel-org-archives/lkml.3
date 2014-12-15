Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaLOTo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:44:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40772 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaLOT3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:29:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dwight Engen <dwight.engen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 21/96] sunvdc: compute vdisk geometry from capacity
Date: Mon, 15 Dec 2014 11:25:41 -0800
Message-Id: <1418671616-25482-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Pais <allen.pais@oracle.com>

[ Upstream commit de5b73f08468b4fc5e2f6d1505f650262622f78b ]

The LDom diskserver doesn't return reliable geometry data. In addition,
the types for all fields in the vio_disk_geom are u16, which were being
truncated in the cast into the u8's of the Linux struct hd_geometry.

Modify vdc_getgeo() to compute the geometry from the disk's capacity in a
manner consistent with xen-blkfront::blkif_getgeo().

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/sunvdc.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 66ddf70..1616ad0 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -70,7 +70,6 @@ struct vdc_port {
 
 	char			disk_name[32];
 
-	struct vio_disk_geom	geom;
 	struct vio_disk_vtoc	label;
 };
 
@@ -103,11 +102,15 @@ static inline u32 vdc_tx_dring_avail(struct vio_dring_state *dr)
 static int vdc_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
 	struct gendisk *disk = bdev->bd_disk;
-	struct vdc_port *port = disk->private_data;
+	sector_t nsect = get_capacity(disk);
+	sector_t cylinders = nsect;
 
-	geo->heads = (u8) port->geom.num_hd;
-	geo->sectors = (u8) port->geom.num_sec;
-	geo->cylinders = port->geom.num_cyl;
+	geo->heads = 0xff;
+	geo->sectors = 0x3f;
+	sector_div(cylinders, geo->heads * geo->sectors);
+	geo->cylinders = cylinders;
+	if ((sector_t)(geo->cylinders + 1) * geo->heads * geo->sectors < nsect)
+		geo->cylinders = 0xffff;
 
 	return 0;
 }
@@ -714,16 +717,18 @@ static int probe_disk(struct vdc_port *port)
 		if (port->vdisk_size == -1)
 			return -ENODEV;
 	} else {
+		struct vio_disk_geom geom;
+
 		err = generic_request(port, VD_OP_GET_DISKGEOM,
-				      &port->geom, sizeof(port->geom));
+				      &geom, sizeof(geom));
 		if (err < 0) {
 			printk(KERN_ERR PFX "VD_OP_GET_DISKGEOM returns "
 			       "error %d\n", err);
 			return err;
 		}
-		port->vdisk_size = ((u64)port->geom.num_cyl *
-				    (u64)port->geom.num_hd *
-				    (u64)port->geom.num_sec);
+		port->vdisk_size = ((u64)geom.num_cyl *
+				    (u64)geom.num_hd *
+				    (u64)geom.num_sec);
 	}
 
 	q = blk_init_queue(do_vdc_request, &port->vio.lock);
-- 
1.9.1

