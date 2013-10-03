Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3JCRPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:15:10 -0400
Received: from mailout.micron.com ([137.201.242.129]:22005 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3JCRPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:15:05 -0400
Message-ID: <524DA6CD.3060409@micron.com>
Date: Thu, 3 Oct 2013 10:18:05 -0700
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>, <asamymuthupa@micron.com>
Subject: [PATCH] mtip32xx: Correctly handle security locked condition
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20194.000
X-TM-AS-Result: No--4.624400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If power is removed during a secure erase, the drive will end up in a
security locked condition.  This patch causes the driver to identify,
log, and flag the security lock state.  IOs are prevented from
submission to the drive until the locked state is addressed with a
secure erase.

Bumped version number to reflect this capability.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   16 ++++++++++++++--
 drivers/block/mtip32xx/mtip32xx.h |    2 +-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index aab28a4..a710f51 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -899,8 +899,9 @@ static void mtip_handle_tfe(struct driver_data *dd)
 			fail_reason = "thermal shutdown";
 		}
 		if (buf[288] == 0xBF) {
+			set_bit(MTIP_DDF_SEC_LOCK_BIT, &dd->dd_flag);
 			dev_info(&dd->pdev->dev,
-				"Drive indicates rebuild has failed.\n");
+				"Drive indicates rebuild has failed. Secure erase required.\n");
 			fail_all_ncq_cmds = 1;
 			fail_reason = "rebuild failed";
 		}
@@ -1566,6 +1567,12 @@ static int mtip_get_identify(struct mtip_port *port, void __user *user_buffer)
 	}
 #endif
 
+	/* Check security locked state */
+	if (port->identify[128] & 0x4)
+		set_bit(MTIP_DDF_SEC_LOCK_BIT, &port->dd->dd_flag);
+	else
+		clear_bit(MTIP_DDF_SEC_LOCK_BIT, &port->dd->dd_flag);
+
 #ifdef MTIP_TRIM /* Disabling TRIM support temporarily */
 	/* Demux ID.DRAT & ID.RZAT to determine trim support */
 	if (port->identify[69] & (1 << 14) && port->identify[69] & (1 << 5))
@@ -1887,6 +1894,10 @@ static void mtip_dump_identify(struct mtip_port *port)
 	strlcpy(cbuf, (char *)(port->identify+27), 41);
 	dev_info(&port->dd->pdev->dev, "Model: %s\n", cbuf);
 
+	dev_info(&port->dd->pdev->dev, "Security: %04x %s\n",
+		port->identify[128],
+		port->identify[128] & 0x4 ? "(LOCKED)" : "");
+
 	if (mtip_hw_get_capacity(port->dd, &sectors))
 		dev_info(&port->dd->pdev->dev,
 			"Capacity: %llu sectors (%llu MB)\n",
@@ -3594,7 +3605,8 @@ static int mtip_hw_exit(struct driver_data *dd)
 	 * saves its state.
 	 */
 	if (!dd->sr) {
-		if (!test_bit(MTIP_DDF_REBUILD_FAILED_BIT, &dd->dd_flag))
+		if (!test_bit(MTIP_PF_REBUILD_BIT, &dd->port->flags) &&
+		    !test_bit(MTIP_DDF_SEC_LOCK_BIT, &dd->dd_flag))
 			if (mtip_standby_immediate(dd->port))
 				dev_warn(&dd->pdev->dev,
 					"STANDBY IMMEDIATE failed\n");
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 9be7a15..f73444a 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -92,7 +92,7 @@
 
 /* Driver name and version strings */
 #define MTIP_DRV_NAME		"mtip32xx"
-#define MTIP_DRV_VERSION	"1.2.6os3"
+#define MTIP_DRV_VERSION	"1.3.0"
 
 /* Maximum number of minor device numbers per device. */
 #define MTIP_MAX_MINORS		16
-- 
1.7.1

