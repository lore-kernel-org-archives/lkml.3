Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaLCL1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbaLCL1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dwight Engen <dwight.engen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 012/101] sunvdc: don't call VD_OP_GET_VTOC
Date: Wed,  3 Dec 2014 12:25:34 +0100
Message-Id: <6ec85a4339cb39197b1c82f1238ca479f086ea26.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dwight Engen <dwight.engen@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 85b0c6e62c48bb9179fd5b3e954f362fb346cbd5 ]

The VD_OP_GET_VTOC operation will succeed only if the vdisk backend has a
VTOC label, otherwise it will fail. In particular, it will return error
48 (ENOTSUP) if the disk has an EFI label. VTOC disk labels are already
handled by directly reading the disk in block/partitions/sun.c (enabled by
CONFIG_SUN_PARTITION which defaults to y on SPARC). Since port->label is
unused in the driver, remove the call and the field.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/sunvdc.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 756b8ec00f16..0ebadf93b6c5 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -69,8 +69,6 @@ struct vdc_port {
 	u8			vdisk_mtype;
 
 	char			disk_name[32];
-
-	struct vio_disk_vtoc	label;
 };
 
 static inline struct vdc_port *to_vdc_port(struct vio_driver_state *vio)
@@ -710,13 +708,6 @@ static int probe_disk(struct vdc_port *port)
 	if (comp.err)
 		return comp.err;
 
-	err = generic_request(port, VD_OP_GET_VTOC,
-			      &port->label, sizeof(port->label));
-	if (err < 0) {
-		printk(KERN_ERR PFX "VD_OP_GET_VTOC returns error %d\n", err);
-		return err;
-	}
-
 	if (vdc_version_supported(port, 1, 1)) {
 		/* vdisk_size should be set during the handshake, if it wasn't
 		 * then the underlying disk is reserved by another system
-- 
2.1.3

