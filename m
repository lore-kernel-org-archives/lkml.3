Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3JUTPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:15:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:39506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3JUTPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:15:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414681929"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>, <stable@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 3/8] mei: nfc: fix memory leak in error path
Date: Mon, 21 Oct 2013 22:05:38 +0300
Message-Id: <1382382343-12066-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flow may reach the err label without freeing cl and cl_info

cl and cl_info weren't assigned to ndev->cl and cl_info
so they weren't freed in mei_nfc_free called on error path

Cc: <stable@vger.kernel.org> # 3.10+
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index d0c6907..994ca4a 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -485,8 +485,11 @@ int mei_nfc_host_init(struct mei_device *dev)
 	if (ndev->cl_info)
 		return 0;
 
-	cl_info = mei_cl_allocate(dev);
-	cl = mei_cl_allocate(dev);
+	ndev->cl_info = mei_cl_allocate(dev);
+	ndev->cl = mei_cl_allocate(dev);
+
+	cl = ndev->cl;
+	cl_info = ndev->cl_info;
 
 	if (!cl || !cl_info) {
 		ret = -ENOMEM;
@@ -527,10 +530,9 @@ int mei_nfc_host_init(struct mei_device *dev)
 
 	cl->device_uuid = mei_nfc_guid;
 
+
 	list_add_tail(&cl->device_link, &dev->device_list);
 
-	ndev->cl_info = cl_info;
-	ndev->cl = cl;
 	ndev->req_id = 1;
 
 	INIT_WORK(&ndev->init_work, mei_nfc_init);
-- 
1.8.3.1

