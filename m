Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbaIOWRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:17:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51037 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaIOWR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 085/187] mei: fix return value on disconnect timeout
Date: Mon, 15 Sep 2014 15:08:15 -0700
Message-Id: <1410818997-9432-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit fe2f17eb3da38ac0d5a00c511255bf3a33d16d24 upstream.

wait_event_timeout can return 0 or the remaining jiffies
so return -ETIME if disconnected state not reached.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/mei/client.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 54122db..0a91a23 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -436,7 +436,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 {
 	struct mei_device *dev;
 	struct mei_cl_cb *cb;
-	int rets, err;
+	int rets;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
@@ -470,24 +470,18 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	}
 	mutex_unlock(&dev->device_lock);
 
-	err = wait_event_timeout(dev->wait_recvd_msg,
+	wait_event_timeout(dev->wait_recvd_msg,
 			MEI_FILE_DISCONNECTED == cl->state,
 			mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
 
 	mutex_lock(&dev->device_lock);
+
 	if (MEI_FILE_DISCONNECTED == cl->state) {
 		rets = 0;
 		cl_dbg(dev, cl, "successfully disconnected from FW client.\n");
 	} else {
-		rets = -ENODEV;
-		if (MEI_FILE_DISCONNECTED != cl->state)
-			cl_err(dev, cl, "wrong status client disconnect.\n");
-
-		if (err)
-			cl_dbg(dev, cl, "wait failed disconnect err=%08x\n",
-					err);
-
-		cl_err(dev, cl, "failed to disconnect from FW client.\n");
+		cl_dbg(dev, cl, "timeout on disconnect from FW client.\n");
+		rets = -ETIME;
 	}
 
 	mei_io_list_flush(&dev->ctrl_rd_list, cl);
-- 
1.9.1

