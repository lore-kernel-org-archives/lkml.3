Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3JQOV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:21:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:41876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab3JQOV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:21:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,514,1378882800"; 
   d="scan'208";a="418421747"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc] mei: move host_clients_map cleanup to device init
Date: Thu, 17 Oct 2013 17:20:22 +0300
Message-Id: <1382019622-7768-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Move host_clients_map cleanup from host client init to device init.

This fixes bug where we cleaned up the bitmask that servers as pool for
host client ids while file descriptors are kept open during suspend.
On resume a new connection will be assigned id that is already taken
by opened file descriptor. Consequently read/write will fail due to
mismatched book keeping.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 9 ---------
 drivers/misc/mei/init.c   | 8 ++++++++
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index a48c0e7..0ccc22c 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -365,15 +365,6 @@ void mei_host_client_init(struct work_struct *work)
 
 	mutex_lock(&dev->device_lock);
 
-	bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
-	dev->open_handle_count = 0;
-
-	/*
-	 * Reserving the first three client IDs
-	 * 0: Reserved for MEI Bus Message communications
-	 */
-	bitmap_set(dev->host_clients_map, 0, 1);
-
 	for (i = 0; i < dev->me_clients_num; i++) {
 		client_props = &dev->me_clients[i].props;
 
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index bcb4a6b..4c93e3d 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -68,6 +68,14 @@ void mei_device_init(struct mei_device *dev)
 	mei_io_list_init(&dev->amthif_cmd_list);
 	mei_io_list_init(&dev->amthif_rd_complete_list);
 
+	bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
+	dev->open_handle_count = 0;
+
+	/*
+	 * Reserving the first client ID
+	 * 0: Reserved for MEI Bus Message communications
+	 */
+	bitmap_set(dev->host_clients_map, 0, 1);
 }
 EXPORT_SYMBOL_GPL(mei_device_init);
 
-- 
1.8.3.1

