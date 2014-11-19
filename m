Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213AbaKSV0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:26:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844AbaKSVOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dwight Engen <dwight.engen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 09/70] sunvdc: dont call VD_OP_GET_VTOC
Date: Wed, 19 Nov 2014 12:52:00 -0800
Message-Id: <20141119205211.227307273@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/sunvdc.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -69,8 +69,6 @@ struct vdc_port {
 	u8			vdisk_mtype;
 
 	char			disk_name[32];
-
-	struct vio_disk_vtoc	label;
 };
 
 static inline struct vdc_port *to_vdc_port(struct vio_driver_state *vio)
@@ -710,13 +708,6 @@ static int probe_disk(struct vdc_port *p
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


