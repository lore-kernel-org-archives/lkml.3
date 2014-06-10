Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaFJTsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:48:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35048 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaFJTst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:48:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 021/160] mei: ignore client writing state during cb completion
Date: Tue, 10 Jun 2014 12:44:21 -0700
Message-Id: <1402429600-20477-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/mei/interrupt.c | 3 +--
 drivers/misc/mei/main.c      | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 6ce63f5..f061cf0 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -424,8 +424,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 
 		cl->status = 0;
 		list_del(&cb->list);
-		if (MEI_WRITING == cl->writing_state &&
-		    cb->fop_type == MEI_FOP_WRITE &&
+		if (cb->fop_type == MEI_FOP_WRITE &&
 		    cl != &dev->iamthif_cl) {
 			cl_dbg(dev, cl, "MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 9661a81..56c8205 100644
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
1.9.1

