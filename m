Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab3K0BjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:39:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3K0A6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.10 72/80] mei: nfc: fix memory leak in error path
Date: Tue, 26 Nov 2013 16:57:41 -0800
Message-Id: <20131127005645.918777112@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 4bff7208f332b2b1d7cf1338e50527441283a198 upstream.

The flow may reach the err label without freeing cl and cl_info

cl and cl_info weren't assigned to ndev->cl and cl_info
so they weren't freed in mei_nfc_free called on error path

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/nfc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -485,8 +485,11 @@ int mei_nfc_host_init(struct mei_device
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
@@ -527,10 +530,9 @@ int mei_nfc_host_init(struct mei_device
 
 	cl->device_uuid = mei_nfc_guid;
 
+
 	list_add_tail(&cl->device_link, &dev->device_list);
 
-	ndev->cl_info = cl_info;
-	ndev->cl = cl;
 	ndev->req_id = 1;
 
 	INIT_WORK(&ndev->init_work, mei_nfc_init);


