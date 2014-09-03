Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445AbaICWSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:18:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbaICWQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.16 027/125] mei: fix return value on disconnect timeout
Date: Wed,  3 Sep 2014 15:06:24 -0700
Message-Id: <20140903220624.478492165@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit fe2f17eb3da38ac0d5a00c511255bf3a33d16d24 upstream.

wait_event_timeout can return 0 or the remaining jiffies
so return -ETIME if disconnected state not reached.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/client.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -459,7 +459,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 {
 	struct mei_device *dev;
 	struct mei_cl_cb *cb;
-	int rets, err;
+	int rets;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
@@ -501,23 +501,18 @@ int mei_cl_disconnect(struct mei_cl *cl)
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
-			cl_dbg(dev, cl, "wait failed disconnect err=%d\n", err);
-
-		cl_err(dev, cl, "failed to disconnect from FW client.\n");
+		cl_dbg(dev, cl, "timeout on disconnect from FW client.\n");
+		rets = -ETIME;
 	}
 
 	mei_io_list_flush(&dev->ctrl_rd_list, cl);


