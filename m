Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3FWGk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 02:40:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:58746 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab3FWGjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 02:39:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,922,1363158000"; 
   d="scan'208";a="358108651"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Frode Isaksen <fisaksex@intel.com>,
        Frode Isaksen <frodex.isaksen@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/4] mei: mei_cl_connect: don't multiply the timeout twice
Date: Sun, 23 Jun 2013 09:37:01 +0300
Message-Id: <1371969422-16530-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371969422-16530-1-git-send-email-tomas.winkler@intel.com>
References: <1371969422-16530-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frode Isaksen <fisaksex@intel.com>

MEI_CL_CONNECT_TIMEOUT is the timeout in seconds to wait
for a response in mei_cl_connect.
The value was converted to jiffies using mei_secs_to_jiffies
helper function and assigned to a local variable
which is by mistake again multiplied by HZ

Signed-off-by: Frode Isaksen <frodex.isaksen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 11a465a..21d3f5a 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -485,7 +485,6 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 {
 	struct mei_device *dev;
 	struct mei_cl_cb *cb;
-	long timeout = mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT);
 	int rets;
 
 	if (WARN_ON(!cl || !cl->dev))
@@ -518,7 +517,7 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 	rets = wait_event_timeout(dev->wait_recvd_msg,
 				 (cl->state == MEI_FILE_CONNECTED ||
 				  cl->state == MEI_FILE_DISCONNECTED),
-				 timeout * HZ);
+				 mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 
 	if (cl->state != MEI_FILE_CONNECTED) {
-- 
1.8.1.2

