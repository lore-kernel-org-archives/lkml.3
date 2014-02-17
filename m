Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaBQNR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:17:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:45352 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbaBQNO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:14:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,860,1384329600"; 
   d="scan'208";a="456852919"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 06/11] mei: fix potential read outside of array bounds
Date: Mon, 17 Feb 2014 15:13:22 +0200
Message-Id: <1392642807-8878-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
References: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Drop not-very-useful check and with this
fix read on index that can be after array end.
Cleanup search function as byproduct.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 6639bc3..488edd0 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -29,20 +29,21 @@
  * mei_me_cl_by_uuid - locate index of me client
  *
  * @dev: mei device
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
  * returns me client index or -ENOENT if not found
  */
 int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *uuid)
 {
-	int i, res = -ENOENT;
+	int i;
 
 	for (i = 0; i < dev->me_clients_num; ++i)
 		if (uuid_le_cmp(*uuid,
-				dev->me_clients[i].props.protocol_name) == 0) {
-			res = i;
-			break;
-		}
+				dev->me_clients[i].props.protocol_name) == 0)
+			return i;
 
-	return res;
+	return -ENOENT;
 }
 
 
@@ -60,16 +61,12 @@ int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *uuid)
 int mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 {
 	int i;
+
 	for (i = 0; i < dev->me_clients_num; i++)
 		if (dev->me_clients[i].client_id == client_id)
-			break;
-	if (WARN_ON(dev->me_clients[i].client_id != client_id))
-		return -ENOENT;
+			return i;
 
-	if (i == dev->me_clients_num)
-		return -ENOENT;
-
-	return i;
+	return -ENOENT;
 }
 
 
-- 
1.8.5.3

