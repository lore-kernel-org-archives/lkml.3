Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813AbaEMKkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60760 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760031AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 033/182] mei: ignore client writing state during cb completion
Date: Tue, 13 May 2014 11:26:25 +0200
Message-Id: <4a81749eabe1e46434bc13720780b12715c7aba6.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/misc/mei/interrupt.c | 3 +--
 drivers/misc/mei/main.c      | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 1b922e971d3e..41b4b4818b04 100644
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
index cabeddd66c1f..9558bef37eea 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -648,8 +648,7 @@ static unsigned int mei_poll(struct file *file, poll_table *wait)
 		goto out;
 	}
 
-	if (MEI_WRITE_COMPLETE == cl->writing_state)
-		mask |= (POLLIN | POLLRDNORM);
+	mask |= (POLLIN | POLLRDNORM);
 
 out:
 	mutex_unlock(&dev->device_lock);
-- 
1.9.3

