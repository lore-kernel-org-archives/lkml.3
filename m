Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaDAUv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:51:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:65013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaDAUv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:51:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,775,1389772800"; 
   d="scan'208";a="512155850"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc] mei: ignore client writing state during cb completion
Date: Tue,  1 Apr 2014 23:50:41 +0300
Message-Id: <1396385441-10102-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Ignore client writing state during cb completion to fix a memory
leak.

When moving cbs to the completion list we should not look at
writing_state as this state can be already overwritten by next
write, the fact that a cb is on the write waiting list means
that it was already written to the HW and we can safely complete it.

Same pays for wait in poll handler, we do not have to check the state
wake is done after completion list processing.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c | 3 +--
 drivers/misc/mei/main.c      | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index c677438..5bba27b 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -428,8 +428,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 
 		cl->status = 0;
 		list_del(&cb->list);
-		if (MEI_WRITING == cl->writing_state &&
-		    cb->fop_type == MEI_FOP_WRITE &&
+		if (cb->fop_type == MEI_FOP_WRITE &&
 		    cl != &dev->iamthif_cl) {
 			cl_dbg(dev, cl, "MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 5424f8f..cfe1789 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -653,8 +653,7 @@ static unsigned int mei_poll(struct file *file, poll_table *wait)
 		goto out;
 	}
 
-	if (MEI_WRITE_COMPLETE == cl->writing_state)
-		mask |= (POLLIN | POLLRDNORM);
+	mask |= (POLLIN | POLLRDNORM);
 
 out:
 	mutex_unlock(&dev->device_lock);
-- 
1.9.0

