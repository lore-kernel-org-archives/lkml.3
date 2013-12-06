Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162432Ab3LFNP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:15:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44670 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162014Ab3LFNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 233/272] mei: nfc: fix memory leak in error path
Date: Fri,  6 Dec 2013 12:58:42 +0000
Message-Id: <1386334761-25517-234-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 4bff7208f332b2b1d7cf1338e50527441283a198 upstream.

The flow may reach the err label without freeing cl and cl_info

cl and cl_info weren't assigned to ndev->cl and cl_info
so they weren't freed in mei_nfc_free called on error path

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.3.2

