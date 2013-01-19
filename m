Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab3ASJNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:13:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:20330 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab3ASJC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:02:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,498,1355126400"; 
   d="scan'208";a="278958176"
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 02/21] NTB: Handle ntb client device probes without present hardware
Date: Sat, 19 Jan 2013 02:02:16 -0700
Message-Id: <1358586155-23322-3-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempts to probe client ntb drivers without ntb hardware present will
result in null pointer dereference due to the lack of the ntb bus device
being registers.  Check to see if this is the case, and fail all calls
by the clients registering their drivers.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 250190f..1d17857 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -288,6 +288,9 @@ int ntb_register_client_dev(char *device_name)
 	struct ntb_transport *nt;
 	int rc;
 
+	if (list_empty(&ntb_transport_list))
+		return -ENODEV;
+
 	list_for_each_entry(nt, &ntb_transport_list, entry) {
 		struct device *dev;
 
@@ -336,6 +339,9 @@ int ntb_register_client(struct ntb_client *drv)
 {
 	drv->driver.bus = &ntb_bus_type;
 
+	if (list_empty(&ntb_transport_list))
+		return -ENODEV;
+
 	return driver_register(&drv->driver);
 }
 EXPORT_SYMBOL_GPL(ntb_register_client);
-- 
1.7.9.5

