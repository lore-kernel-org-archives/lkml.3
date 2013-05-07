Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab3EGB40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:56:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:24087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933130Ab3EGB4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="309273803"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 10/10] NTB: Multiple NTB client fix
Date: Mon,  6 May 2013 18:55:29 -0700
Message-Id: <1367891729-11738-11-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
References: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix issue with adding multiple ntb client devices to the ntb virtual
bus.  Previously, multiple devices would be added with the same name,
resulting in crashes.  To get around this issue, add a unique number to
the device when it is added.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 583a7d3..f8d7081 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -300,7 +300,7 @@ int ntb_register_client_dev(char *device_name)
 {
 	struct ntb_transport_client_dev *client_dev;
 	struct ntb_transport *nt;
-	int rc;
+	int rc, i = 0;
 
 	if (list_empty(&ntb_transport_list))
 		return -ENODEV;
@@ -318,7 +318,7 @@ int ntb_register_client_dev(char *device_name)
 		dev = &client_dev->dev;
 
 		/* setup and register client devices */
-		dev_set_name(dev, "%s", device_name);
+		dev_set_name(dev, "%s%d", device_name, i);
 		dev->bus = &ntb_bus_type;
 		dev->release = ntb_client_release;
 		dev->parent = &ntb_query_pdev(nt->ndev)->dev;
@@ -330,6 +330,7 @@ int ntb_register_client_dev(char *device_name)
 		}
 
 		list_add_tail(&client_dev->entry, &nt->client_devs);
+		i++;
 	}
 
 	return 0;
-- 
1.7.9.5

