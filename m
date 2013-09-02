Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab3IBKan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:30:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:7573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab3IBKak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:30:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="354790393"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>, <stable@vger.kernel.org>
Subject: [char-misc-next 1/3] mei: make me client counters less error prone
Date: Mon,  2 Sep 2013 13:29:45 +0300
Message-Id: <1378117787-11528-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
References: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. u8 counters are prone to hard to detect overflow:
 make them unsigned long to match bit_ functions argument type

2. don't check me_clients_num for negativity, it is unsigned.

3. init all the me client counters from one place

Cc:  <stable@vger.kernel.org> # 3.9+
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c     | 10 ++++++----
 drivers/misc/mei/mei_dev.h |  6 +++---
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index f706fe8..52afe1e 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -35,11 +35,15 @@ static void mei_hbm_me_cl_allocate(struct mei_device *dev)
 	struct mei_me_client *clients;
 	int b;
 
+	dev->me_clients_num = 0;
+	dev->me_client_presentation_num = 0;
+	dev->me_client_index = 0;
+
 	/* count how many ME clients we have */
 	for_each_set_bit(b, dev->me_clients_map, MEI_CLIENTS_MAX)
 		dev->me_clients_num++;
 
-	if (dev->me_clients_num <= 0)
+	if (dev->me_clients_num == 0)
 		return;
 
 	kfree(dev->me_clients);
@@ -221,7 +225,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 	struct hbm_props_request *prop_req;
 	const size_t len = sizeof(struct hbm_props_request);
 	unsigned long next_client_index;
-	u8 client_num;
+	unsigned long client_num;
 
 
 	client_num = dev->me_client_presentation_num;
@@ -680,8 +684,6 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
 		    dev->hbm_state == MEI_HBM_ENUM_CLIENTS) {
 				dev->init_clients_timer = 0;
-				dev->me_client_presentation_num = 0;
-				dev->me_client_index = 0;
 				mei_hbm_me_cl_allocate(dev);
 				dev->hbm_state = MEI_HBM_CLIENT_PROPERTIES;
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 7b918b2..456b322 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -396,9 +396,9 @@ struct mei_device {
 	struct mei_me_client *me_clients; /* Note: memory has to be allocated */
 	DECLARE_BITMAP(me_clients_map, MEI_CLIENTS_MAX);
 	DECLARE_BITMAP(host_clients_map, MEI_CLIENTS_MAX);
-	u8 me_clients_num;
-	u8 me_client_presentation_num;
-	u8 me_client_index;
+	unsigned long me_clients_num;
+	unsigned long me_client_presentation_num;
+	unsigned long me_client_index;
 
 	struct mei_cl wd_cl;
 	enum mei_wd_states wd_state;
-- 
1.8.3.1

