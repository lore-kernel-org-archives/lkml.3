Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab3IBKb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:31:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:7573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111Ab3IBKan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:30:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="354790409"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>, <stable@vger.kernel.org>
Subject: [char-misc-next 2/3] mei: bus: stop wait for read during cl state transition
Date: Mon,  2 Sep 2013 13:29:46 +0300
Message-Id: <1378117787-11528-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
References: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bus layer omitted check for client state transition while waiting
for read completion
The client state transition may occur for example as result
of firmware initiated reset

Add mei_cl_is_transitioning wrapper to reduce the code
repetition.:

Cc:  <stable@vger.kernel.org> # 3.9+
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c    |  5 ++++-
 drivers/misc/mei/client.h |  6 ++++++
 drivers/misc/mei/main.c   | 11 ++++-------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index a150a42..f5dabb3 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -295,10 +295,13 @@ int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length)
 
 	if (cl->reading_state != MEI_READ_COMPLETE &&
 	    !waitqueue_active(&cl->rx_wait)) {
+
 		mutex_unlock(&dev->device_lock);
 
 		if (wait_event_interruptible(cl->rx_wait,
-				(MEI_READ_COMPLETE == cl->reading_state))) {
+				cl->reading_state == MEI_READ_COMPLETE  ||
+				mei_cl_is_transitioning(cl))) {
+
 			if (signal_pending(current))
 				return -EINTR;
 			return -ERESTARTSYS;
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 9eb031e..892cc42 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -90,6 +90,12 @@ static inline bool mei_cl_is_connected(struct mei_cl *cl)
 		cl->dev->dev_state == MEI_DEV_ENABLED &&
 		cl->state == MEI_FILE_CONNECTED);
 }
+static inline bool mei_cl_is_transitioning(struct mei_cl *cl)
+{
+	return (MEI_FILE_INITIALIZING == cl->state ||
+		MEI_FILE_DISCONNECTED == cl->state ||
+		MEI_FILE_DISCONNECTING == cl->state);
+}
 
 bool mei_cl_is_other_connecting(struct mei_cl *cl);
 int mei_cl_disconnect(struct mei_cl *cl);
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 7404584..b8f8604 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -255,19 +255,16 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 		mutex_unlock(&dev->device_lock);
 
 		if (wait_event_interruptible(cl->rx_wait,
-			(MEI_READ_COMPLETE == cl->reading_state ||
-			 MEI_FILE_INITIALIZING == cl->state ||
-			 MEI_FILE_DISCONNECTED == cl->state ||
-			 MEI_FILE_DISCONNECTING == cl->state))) {
+				MEI_READ_COMPLETE == cl->reading_state ||
+				mei_cl_is_transitioning(cl))) {
+
 			if (signal_pending(current))
 				return -EINTR;
 			return -ERESTARTSYS;
 		}
 
 		mutex_lock(&dev->device_lock);
-		if (MEI_FILE_INITIALIZING == cl->state ||
-		    MEI_FILE_DISCONNECTED == cl->state ||
-		    MEI_FILE_DISCONNECTING == cl->state) {
+		if (mei_cl_is_transitioning(cl)) {
 			rets = -EBUSY;
 			goto out;
 		}
-- 
1.8.3.1

