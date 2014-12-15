Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaLOT3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:29:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40731 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaLOT3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:29:06 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dwight Engen <dwight.engen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 24/96] sunvdc: don't call VD_OP_GET_VTOC
Date: Mon, 15 Dec 2014 11:25:44 -0800
Message-Id: <1418671616-25482-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dwight Engen <dwight.engen@oracle.com>

[ Upstream commit 85b0c6e62c48bb9179fd5b3e954f362fb346cbd5 ]

The VD_OP_GET_VTOC operation will succeed only if the vdisk backend has a
VTOC label, otherwise it will fail. In particular, it will return error
48 (ENOTSUP) if the disk has an EFI label. VTOC disk labels are already
handled by directly reading the disk in block/partitions/sun.c (enabled by
CONFIG_SUN_PARTITION which defaults to y on SPARC). Since port->label is
unused in the driver, remove the call and the field.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/sunvdc.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 756b8ec..0ebadf9 100644
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
1.9.1

