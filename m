Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab3IBAN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:13:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:29144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523Ab3IBAL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:11:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1003,1367996400"; 
   d="scan'208";a="395354842"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/5] mei: make sure that me_clients_map big enough before copying
Date: Mon,  2 Sep 2013 03:11:01 +0300
Message-Id: <1378080664-7274-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
References: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make static analyzers happy validated that
sizeof me_clients_map  is larger than sizeof valid_addresses from the
enumeration response before memcpy
We can use BUILD_ON macro as both arrays are defined statically

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 6127ab6..95d4dab 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -673,7 +673,10 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 	case HOST_ENUM_RES_CMD:
 		enum_res = (struct hbm_host_enum_response *) mei_msg;
-		memcpy(dev->me_clients_map, enum_res->valid_addresses, 32);
+		BUILD_BUG_ON(sizeof(dev->me_clients_map)
+				< sizeof(enum_res->valid_addresses));
+		memcpy(dev->me_clients_map, enum_res->valid_addresses,
+			sizeof(enum_res->valid_addresses));
 		if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
 		    dev->hbm_state == MEI_HBM_ENUM_CLIENTS) {
 				dev->init_clients_timer = 0;
-- 
1.8.3.1

