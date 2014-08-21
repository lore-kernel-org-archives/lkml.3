Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaHULbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:31:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:16491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbaHULbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969485"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 05/14] mei: add me client remove functions
Date: Thu, 21 Aug 2014 14:29:14 +0300
Message-Id: <1408620563-25834-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support dynamic addition/remove we add wrappers
for removal of me clients

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 22 +++++++++++++++++++++-
 drivers/misc/mei/client.h |  2 ++
 drivers/misc/mei/hbm.c    | 21 +++++++++++++++------
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index b1d72e6..4dbcd92 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -47,7 +47,6 @@ struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
 	return NULL;
 }
 
-
 /**
  * mei_me_cl_by_id return index to me_clients for client_id
  *
@@ -70,6 +69,27 @@ struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 	return NULL;
 }
 
+/**
+ * mei_me_cl_remove - remove me client matching uuid and client_id
+ *
+ * @dev: the device structure
+ * @uuid: me client uuid
+ * @client_id: me client address
+ */
+void mei_me_cl_remove(struct mei_device *dev, const uuid_le *uuid, u8 client_id)
+{
+	struct mei_me_client *me_cl, *next;
+
+	list_for_each_entry_safe(me_cl, next, &dev->me_clients, list) {
+		if (uuid_le_cmp(*uuid, me_cl->props.protocol_name) == 0 &&
+		    me_cl->client_id == client_id) {
+			list_del(&me_cl->list);
+			kfree(me_cl);
+			break;
+		}
+	}
+}
+
 
 /**
  * mei_cl_cmp_id - tells if the clients are the same
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index ddb95b2..8871a85 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -27,6 +27,8 @@
 struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
 					const uuid_le *cuuid);
 struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
+void mei_me_cl_remove(struct mei_device *dev,
+		      const uuid_le *uuid, u8 client_id);
 
 /*
  * MEI IO Functions
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 45659de..5fb177b 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -71,21 +71,30 @@ void mei_hbm_idle(struct mei_device *dev)
 }
 
 /**
- * mei_hbm_reset - reset hbm counters and book keeping data structurs
+ * mei_me_cl_remove_all - remove all me clients
  *
  * @dev: the device structure
  */
-void mei_hbm_reset(struct mei_device *dev)
+static void mei_me_cl_remove_all(struct mei_device *dev)
 {
 	struct mei_me_client *me_cl, *next;
+	list_for_each_entry_safe(me_cl, next, &dev->me_clients, list) {
+			list_del(&me_cl->list);
+			kfree(me_cl);
+	}
+}
 
+/**
+ * mei_hbm_reset - reset hbm counters and book keeping data structurs
+ *
+ * @dev: the device structure
+ */
+void mei_hbm_reset(struct mei_device *dev)
+{
 	dev->me_client_presentation_num = 0;
 	dev->me_client_index = 0;
 
-	list_for_each_entry_safe(me_cl, next, &dev->me_clients, list) {
-		list_del(&me_cl->list);
-		kfree(me_cl);
-	}
+	mei_me_cl_remove_all(dev);
 
 	mei_hbm_idle(dev);
 }
-- 
1.9.3

