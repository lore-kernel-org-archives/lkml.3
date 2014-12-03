Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaLCMAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:00:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaLCL1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Allen Pais <allen.pais@oracle.com>,
        Dwight Engen <dwight.engen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 009/101] sunvdc: compute vdisk geometry from capacity
Date: Wed,  3 Dec 2014 12:25:31 +0100
Message-Id: <2c6b39c0b39d7a0e39b88612d4538d46a682491b.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Allen Pais <allen.pais@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit de5b73f08468b4fc5e2f6d1505f650262622f78b ]

The LDom diskserver doesn't return reliable geometry data. In addition,
the types for all fields in the vio_disk_geom are u16, which were being
truncated in the cast into the u8's of the Linux struct hd_geometry.

Modify vdc_getgeo() to compute the geometry from the disk's capacity in a
manner consistent with xen-blkfront::blkif_getgeo().

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/sunvdc.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 66ddf704ad7f..1616ad091a5e 100644
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
2.1.3

