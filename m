Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaEEAFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:05:48 -0400
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:52563 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754132AbaEEAFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:05:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3355:3865:3867:3868:3870:3871:3872:4321:4605:5007:6261:7874:8603:9592:10004:10026:10848:11026:11232:11473:11658:11914:12043:12291:12295:12296:12438:12517:12519:12555:12683:13972:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: clam97_3054cf8234a29
X-Filterd-Recvd-Size: 3968
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] cdrom: Remove unnecessary prototype for cdrom_get_disc_info
Date: Sun,  4 May 2014 17:05:13 -0700
Message-Id: <632524fb5a972bb8bde7604200b9c60f8d97f64e.1399247745.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51EDAD79.3050707@kernel.dk>
References: <51EDAD79.3050707@kernel.dk>
In-Reply-To: <cover.1399247745.git.joe@perches.com>
References: <cover.1399247745.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the function to the proper spot instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 71 ++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index c8ca342..49ac566 100644
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

