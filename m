Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3EWHFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:05:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:29849 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab3EWHFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:05:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,726,1363158000"; 
   d="scan'208";a="245533020"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: deprecate the mei_wd_state_independence_msg
Date: Thu, 23 May 2013 10:03:13 +0300
Message-Id: <1369292593-23518-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wd independence is deprecated, remove it.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c    | 25 -------------------------
 drivers/misc/mei/mei_dev.h |  6 ------
 drivers/misc/mei/wd.c      |  6 ------
 3 files changed, 37 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 053139f..b9ad510 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -194,7 +194,6 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 	struct mei_cl_cb *cb_pos = NULL;
 	struct mei_cl_cb *cb = NULL;
 	struct mei_device *dev;
-	int i;
 	int rets;
 	int err;
 
@@ -210,20 +209,6 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 		goto out;
 	}
 
-	if ((cl->sm_state & MEI_WD_STATE_INDEPENDENCE_MSG_SENT) == 0) {
-		/* Do not allow to read watchdog client */
-		i = mei_me_cl_by_uuid(dev, &mei_wd_guid);
-		if (i >= 0) {
-			struct mei_me_client *me_client = &dev->me_clients[i];
-			if (cl->me_client_id == me_client->client_id) {
-				rets = -EBADF;
-				goto out;
-			}
-		}
-	} else {
-		cl->sm_state &= ~MEI_WD_STATE_INDEPENDENCE_MSG_SENT;
-	}
-
 	if (cl == &dev->iamthif_cl) {
 		rets = mei_amthif_read(dev, file, ubuf, length, offset);
 		goto out;
@@ -420,16 +405,6 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	if (rets)
 		goto out;
 
-	cl->sm_state = 0;
-	if (length == 4 &&
-	    ((memcmp(mei_wd_state_independence_msg[0],
-				 write_cb->request_buffer.data, 4) == 0) ||
-	     (memcmp(mei_wd_state_independence_msg[1],
-				 write_cb->request_buffer.data, 4) == 0) ||
-	     (memcmp(mei_wd_state_independence_msg[2],
-				 write_cb->request_buffer.data, 4) == 0)))
-		cl->sm_state |= MEI_WD_STATE_INDEPENDENCE_MSG_SENT;
-
 	if (cl == &dev->iamthif_cl) {
 		rets = mei_amthif_write(dev, write_cb);
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 197ba64..80a9031 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -56,11 +56,6 @@ extern const uuid_le mei_amthif_guid;
 extern const uuid_le mei_wd_guid;
 
 /*
- * Watchdog independence state message
- */
-extern const u8 mei_wd_state_independence_msg[3][4];
-
-/*
  * Number of Maximum MEI Clients
  */
 #define MEI_CLIENTS_MAX 256
@@ -201,7 +196,6 @@ struct mei_cl {
 	u8 timer_count;
 	enum mei_file_transaction_states reading_state;
 	enum mei_file_transaction_states writing_state;
-	int sm_state;
 	struct mei_cl_cb *read_cb;
 
 	/* MEI CL bus data */
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 6251a4e..b892143 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -31,12 +31,6 @@
 static const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
 static const u8 mei_stop_wd_params[] = { 0x02, 0x02, 0x14, 0x10 };
 
-const u8 mei_wd_state_independence_msg[3][4] = {
-	{0x05, 0x02, 0x51, 0x10},
-	{0x05, 0x02, 0x52, 0x10},
-	{0x07, 0x02, 0x01, 0x10}
-};
-
 /*
  * AMT Watchdog Device
  */
-- 
1.8.1.2

