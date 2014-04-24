Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaDXJRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:17:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbaDXI4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 159/182] mei: ignore client writing state during cb completion
Date: Thu, 24 Apr 2014 09:51:24 +0100
Message-Id: <1398329507-5911-160-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 34ec43661fe8f1977dd0f05353302ae2ed10aabb upstream.

Ignore client writing state during cb completion to fix a memory
leak.

When moving cbs to the completion list we should not look at
writing_state as this state can be already overwritten by next
write, the fact that a cb is on the write waiting list means
that it was already written to the HW and we can safely complete it.

Same pays for wait in poll handler, we do not have to check the state
wake is done after completion list processing.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/mei/interrupt.c | 3 +--
 drivers/misc/mei/main.c      | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 4b59cb7..8967b09 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -420,8 +420,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 
 		cl->status = 0;
 		list_del(&cb->list);
-		if (MEI_WRITING == cl->writing_state &&
-		    cb->fop_type == MEI_FOP_WRITE &&
+		if (cb->fop_type == MEI_FOP_WRITE &&
 		    cl != &dev->iamthif_cl) {
 			dev_dbg(&dev->pdev->dev, "MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index e67de23..6ad37d9 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -640,8 +640,7 @@ static unsigned int mei_poll(struct file *file, poll_table *wait)
 	mutex_unlock(&dev->device_lock);
 	poll_wait(file, &cl->tx_wait, wait);
 	mutex_lock(&dev->device_lock);
-	if (MEI_WRITE_COMPLETE == cl->writing_state)
-		mask |= (POLLIN | POLLRDNORM);
+	mask |= (POLLIN | POLLRDNORM);
 
 out:
 	mutex_unlock(&dev->device_lock);
-- 
1.9.1

