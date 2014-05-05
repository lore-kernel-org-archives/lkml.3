Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaEEAFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:05:34 -0400
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:56085 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753974AbaEEAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:05:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:2903:3138:3139:3140:3141:3142:3865:3867:3870:3871:3872:4052:4120:4321:4605:5007:6119:6261:7874:7903:8603:8660:9010:9592:10004:10026:10848:11026:11232:11473:11658:11914:12043:12291:12295:12296:12438:12517:12519:12555:12683:13148:13230:13972:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grain03_301ca33264926
X-Filterd-Recvd-Size: 9946
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] cdrom: Remove unnecessary prototype for cdrom_mrw_exit
Date: Sun,  4 May 2014 17:05:12 -0700
Message-Id: <c128f74c76e5ff6d7282e42da2227beffcf717ec.1399247745.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51EDAD79.3050707@kernel.dk>
References: <51EDAD79.3050707@kernel.dk>
In-Reply-To: <cover.1399247745.git.joe@perches.com>
References: <cover.1399247745.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the function to appropriate locations instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 238 +++++++++++++++++++++++++-------------------------
 1 file changed, 121 insertions(+), 117 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index f614847..c8ca342 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -338,8 +338,6 @@ do {							\
 
 /* Not-exported routines. */
 
-static int cdrom_mrw_exit(struct cdrom_device_info *cdi);
-
 static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *di);
 
 static void cdrom_sysctl_register(void);
@@ -359,113 +357,29 @@ static int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
 	return -EIO;
 }
 
-/* This macro makes sure we don't have to check on cdrom_device_ops
- * existence in the run-time routines below. Change_capability is a
- * hack to have the capability flags defined const, while we can still
- * change it here without gcc complaining at every line.
- */
-#define ENSURE(call, bits) if (cdo->call == NULL) *change_capability &= ~(bits)
-
-int register_cdrom(struct cdrom_device_info *cdi)
-{
-	static char banner_printed;
-        struct cdrom_device_ops *cdo = cdi->ops;
-        int *change_capability = (int *)&cdo->capability; /* hack */
-
-	cd_dbg(CD_OPEN, "entering register_cdrom\n");
-
-	if (cdo->open == NULL || cdo->release == NULL)
-		return -EINVAL;
-	if (!banner_printed) {
-		pr_info("Uniform CD-ROM driver " REVISION "\n");
-		banner_printed = 1;
-		cdrom_sysctl_register();
-	}
-
-	ENSURE(drive_status, CDC_DRIVE_STATUS );
-	if (cdo->check_events == NULL && cdo->media_changed == NULL)
-		*change_capability = ~(CDC_MEDIA_CHANGED | CDC_SELECT_DISC);
-	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
-	ENSURE(lock_door, CDC_LOCK);
-	ENSURE(select_speed, CDC_SELECT_SPEED);
-	ENSURE(get_last_session, CDC_MULTI_SESSION);
-	ENSURE(get_mcn, CDC_MCN);
-	ENSURE(reset, CDC_RESET);
-	ENSURE(generic_packet, CDC_GENERIC_PACKET);
-	cdi->mc_flags = 0;
-	cdo->n_minors = 0;
-        cdi->options = CDO_USE_FFLAGS;
-	
-	if (autoclose==1 && CDROM_CAN(CDC_CLOSE_TRAY))
-		cdi->options |= (int) CDO_AUTO_CLOSE;
-	if (autoeject==1 && CDROM_CAN(CDC_OPEN_TRAY))
-		cdi->options |= (int) CDO_AUTO_EJECT;
-	if (lockdoor==1)
-		cdi->options |= (int) CDO_LOCK;
-	if (check_media_type==1)
-		cdi->options |= (int) CDO_CHECK_TYPE;
-
-	if (CDROM_CAN(CDC_MRW_W))
-		cdi->exit = cdrom_mrw_exit;
-
-	if (cdi->disk)
-		cdi->cdda_method = CDDA_BPC_FULL;
-	else
-		cdi->cdda_method = CDDA_OLD;
-
-	if (!cdo->generic_packet)
-		cdo->generic_packet = cdrom_dummy_generic_packet;
-
-	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
-	mutex_lock(&cdrom_mutex);
-	list_add(&cdi->list, &cdrom_list);
-	mutex_unlock(&cdrom_mutex);
-	return 0;
-}
-#undef ENSURE
-
-void unregister_cdrom(struct cdrom_device_info *cdi)
-{
-	cd_dbg(CD_OPEN, "entering unregister_cdrom\n");
-
-	mutex_lock(&cdrom_mutex);
-	list_del(&cdi->list);
-	mutex_unlock(&cdrom_mutex);
-
-	if (cdi->exit)
-		cdi->exit(cdi);
-
-	cdi->ops->n_minors--;
-	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
-}
-
-int cdrom_get_media_event(struct cdrom_device_info *cdi,
-			  struct media_event_desc *med)
+static int cdrom_flush_cache(struct cdrom_device_info *cdi)
 {
 	struct packet_command cgc;
-	unsigned char buffer[8];
-	struct event_header *eh = (struct event_header *) buffer;
-
-	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
-	cgc.cmd[0] = GPCMD_GET_EVENT_STATUS_NOTIFICATION;
-	cgc.cmd[1] = 1;		/* IMMED */
-	cgc.cmd[4] = 1 << 4;	/* media event */
-	cgc.cmd[8] = sizeof(buffer);
-	cgc.quiet = 1;
-
-	if (cdi->ops->generic_packet(cdi, &cgc))
-		return 1;
 
-	if (be16_to_cpu(eh->data_len) < sizeof(*med))
-		return 1;
+	init_cdrom_command(&cgc, NULL, 0, CGC_DATA_NONE);
+	cgc.cmd[0] = GPCMD_FLUSH_CACHE;
 
-	if (eh->nea || eh->notification_class != 0x4)
-		return 1;
+	cgc.timeout = 5 * 60 * HZ;
 
-	memcpy(med, &buffer[sizeof(*eh)], sizeof(*med));
-	return 0;
+	return cdi->ops->generic_packet(cdi, &cgc);
 }
 
+/* This macro makes sure we don't have to check on cdrom_device_ops
+ * existence in the run-time routines below. Change_capability is a
+ * hack to have the capability flags defined const, while we can still
+ * change it here without gcc complaining at every line.
+ */
+#define ENSURE(call, bits)			\
+do {						\
+	if (cdo->call == NULL)			\
+		*change_capability &= ~(bits);	\
+} while (0)
+
 /*
  * the first prototypes used 0x2c as the page code for the mrw mode page,
  * subsequently this was changed to 0x03. probe the one used by this drive
@@ -582,18 +496,6 @@ static int cdrom_mrw_bgformat_susp(struct cdrom_device_info *cdi, int immed)
 	return cdi->ops->generic_packet(cdi, &cgc);
 }
 
-static int cdrom_flush_cache(struct cdrom_device_info *cdi)
-{
-	struct packet_command cgc;
-
-	init_cdrom_command(&cgc, NULL, 0, CGC_DATA_NONE);
-	cgc.cmd[0] = GPCMD_FLUSH_CACHE;
-
-	cgc.timeout = 5 * 60 * HZ;
-
-	return cdi->ops->generic_packet(cdi, &cgc);
-}
-
 static int cdrom_mrw_exit(struct cdrom_device_info *cdi)
 {
 	disc_information di;
@@ -627,17 +529,19 @@ static int cdrom_mrw_set_lba_space(struct cdrom_device_info *cdi, int space)
 	cgc.buffer = buffer;
 	cgc.buflen = sizeof(buffer);
 
-	if ((ret = cdrom_mode_sense(cdi, &cgc, cdi->mrw_mode_page, 0)))
+	ret = cdrom_mode_sense(cdi, &cgc, cdi->mrw_mode_page, 0);
+	if (ret)
 		return ret;
 
-	mph = (struct mode_page_header *) buffer;
+	mph = (struct mode_page_header *)buffer;
 	offset = be16_to_cpu(mph->desc_length);
 	size = be16_to_cpu(mph->mode_data_length) + 2;
 
 	buffer[offset + 3] = space;
 	cgc.buflen = size;
 
-	if ((ret = cdrom_mode_select(cdi, &cgc)))
+	ret = cdrom_mode_select(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	pr_info("%s: mrw address space %s selected\n",
@@ -645,6 +549,106 @@ static int cdrom_mrw_set_lba_space(struct cdrom_device_info *cdi, int space)
 	return 0;
 }
 
+int register_cdrom(struct cdrom_device_info *cdi)
+{
+	static char banner_printed;
+	struct cdrom_device_ops *cdo = cdi->ops;
+	int *change_capability = (int *)&cdo->capability; /* hack */
+
+	cd_dbg(CD_OPEN, "entering register_cdrom\n");
+
+	if (cdo->open == NULL || cdo->release == NULL)
+		return -EINVAL;
+	if (!banner_printed) {
+		pr_info("Uniform CD-ROM driver " REVISION "\n");
+		banner_printed = 1;
+		cdrom_sysctl_register();
+	}
+
+	ENSURE(drive_status, CDC_DRIVE_STATUS);
+	if (cdo->check_events == NULL && cdo->media_changed == NULL)
+		*change_capability = ~(CDC_MEDIA_CHANGED | CDC_SELECT_DISC);
+	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
+	ENSURE(lock_door, CDC_LOCK);
+	ENSURE(select_speed, CDC_SELECT_SPEED);
+	ENSURE(get_last_session, CDC_MULTI_SESSION);
+	ENSURE(get_mcn, CDC_MCN);
+	ENSURE(reset, CDC_RESET);
+	ENSURE(generic_packet, CDC_GENERIC_PACKET);
+	cdi->mc_flags = 0;
+	cdo->n_minors = 0;
+	cdi->options = CDO_USE_FFLAGS;
+
+	if (autoclose == 1 && CDROM_CAN(CDC_CLOSE_TRAY))
+		cdi->options |= (int) CDO_AUTO_CLOSE;
+	if (autoeject == 1 && CDROM_CAN(CDC_OPEN_TRAY))
+		cdi->options |= (int) CDO_AUTO_EJECT;
+	if (lockdoor == 1)
+		cdi->options |= (int) CDO_LOCK;
+	if (check_media_type == 1)
+		cdi->options |= (int) CDO_CHECK_TYPE;
+
+	if (CDROM_CAN(CDC_MRW_W))
+		cdi->exit = cdrom_mrw_exit;
+
+	if (cdi->disk)
+		cdi->cdda_method = CDDA_BPC_FULL;
+	else
+		cdi->cdda_method = CDDA_OLD;
+
+	if (!cdo->generic_packet)
+		cdo->generic_packet = cdrom_dummy_generic_packet;
+
+	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
+	mutex_lock(&cdrom_mutex);
+	list_add(&cdi->list, &cdrom_list);
+	mutex_unlock(&cdrom_mutex);
+	return 0;
+}
+#undef ENSURE
+
+void unregister_cdrom(struct cdrom_device_info *cdi)
+{
+	cd_dbg(CD_OPEN, "entering unregister_cdrom\n");
+
+	mutex_lock(&cdrom_mutex);
+	list_del(&cdi->list);
+	mutex_unlock(&cdrom_mutex);
+
+	if (cdi->exit)
+		cdi->exit(cdi);
+
+	cdi->ops->n_minors--;
+	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
+}
+
+int cdrom_get_media_event(struct cdrom_device_info *cdi,
+			  struct media_event_desc *med)
+{
+	struct packet_command cgc;
+	unsigned char buffer[8];
+	struct event_header *eh = (struct event_header *)buffer;
+
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
+	cgc.cmd[0] = GPCMD_GET_EVENT_STATUS_NOTIFICATION;
+	cgc.cmd[1] = 1;		/* IMMED */
+	cgc.cmd[4] = 1 << 4;	/* media event */
+	cgc.cmd[8] = sizeof(buffer);
+	cgc.quiet = 1;
+
+	if (cdi->ops->generic_packet(cdi, &cgc))
+		return 1;
+
+	if (be16_to_cpu(eh->data_len) < sizeof(*med))
+		return 1;
+
+	if (eh->nea || eh->notification_class != 0x4)
+		return 1;
+
+	memcpy(med, &buffer[sizeof(*eh)], sizeof(*med));
+	return 0;
+}
+
 static int cdrom_get_random_writable(struct cdrom_device_info *cdi,
 			      struct rwrt_feature_desc *rfd)
 {
-- 
1.8.1.2.459.gbcd45b4.dirty

