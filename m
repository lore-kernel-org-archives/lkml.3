Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3GABNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:13:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53425 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750868Ab3GABNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:13:49 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] cdrom: Remove unnecessary prototype for cdrom_get_disc_info
Date: Sun, 30 Jun 2013 18:12:07 -0700
Message-Id: <6fac63b15232bf26a5e17afc8a7fba26abe8b5c1.1372640819.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the function to the proper spot instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 71 ++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index a7dd384..7e5b628 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -338,8 +338,6 @@ do {							\
 
 /* Not-exported routines. */
 
-static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *di);
-
 static void cdrom_sysctl_register(void);
 
 static LIST_HEAD(cdrom_list);
@@ -369,6 +367,42 @@ static int cdrom_flush_cache(struct cdrom_device_info *cdi)
 	return cdi->ops->generic_packet(cdi, &cgc);
 }
 
+/* requires CD R/RW */
+static int cdrom_get_disc_info(struct cdrom_device_info *cdi,
+			       disc_information *di)
+{
+	struct cdrom_device_ops *cdo = cdi->ops;
+	struct packet_command cgc;
+	int ret, buflen;
+
+	/* set up command and get the disc info */
+	init_cdrom_command(&cgc, di, sizeof(*di), CGC_DATA_READ);
+	cgc.cmd[0] = GPCMD_READ_DISC_INFO;
+	cgc.cmd[8] = cgc.buflen = 2;
+	cgc.quiet = 1;
+
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
+		return ret;
+
+	/* not all drives have the same disc_info length, so requeue
+	 * packet with the length the drive tells us it can supply
+	 */
+	buflen = be16_to_cpu(di->disc_information_length) +
+		sizeof(di->disc_information_length);
+
+	if (buflen > sizeof(disc_information))
+		buflen = sizeof(disc_information);
+
+	cgc.cmd[8] = cgc.buflen = buflen;
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
+		return ret;
+
+	/* return actual fill size */
+	return buflen;
+}
+
 /* This macro makes sure we don't have to check on cdrom_device_ops
  * existence in the run-time routines below. Change_capability is a
  * hack to have the capability flags defined const, while we can still
@@ -3360,39 +3394,6 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 	return -ENOSYS;
 }
 
-/* requires CD R/RW */
-static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *di)
-{
-	struct cdrom_device_ops *cdo = cdi->ops;
-	struct packet_command cgc;
-	int ret, buflen;
-
-	/* set up command and get the disc info */
-	init_cdrom_command(&cgc, di, sizeof(*di), CGC_DATA_READ);
-	cgc.cmd[0] = GPCMD_READ_DISC_INFO;
-	cgc.cmd[8] = cgc.buflen = 2;
-	cgc.quiet = 1;
-
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
-		return ret;
-
-	/* not all drives have the same disc_info length, so requeue
-	 * packet with the length the drive tells us it can supply
-	 */
-	buflen = be16_to_cpu(di->disc_information_length) +
-		     sizeof(di->disc_information_length);
-
-	if (buflen > sizeof(disc_information))
-		buflen = sizeof(disc_information);
-
-	cgc.cmd[8] = cgc.buflen = buflen;
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
-		return ret;
-
-	/* return actual fill size */
-	return buflen;
-}
-
 EXPORT_SYMBOL(cdrom_get_last_written);
 EXPORT_SYMBOL(register_cdrom);
 EXPORT_SYMBOL(unregister_cdrom);
-- 
1.8.1.2.459.gbcd45b4.dirty

