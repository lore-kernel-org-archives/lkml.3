Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3HZU2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:28:37 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:52329
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab3HZU2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:28:36 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of channel offers
Date: Mon, 26 Aug 2013 14:08:58 -0700
Message-Id: <1377551338-29582-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The channel state should be correctly set before registering the device. In the current
code the driver probe would fail for channels that have been rescinded and subsequently
re-offered. Fix the bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hv/channel_mgmt.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 12ec8c8..bbff5f2 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -293,6 +293,13 @@ static void vmbus_process_offer(struct work_struct *work)
 	}
 
 	/*
+	 * This state is used to indicate a successful open
+	 * so that when we do close the channel normally, we
+	 * can cleanup properly
+	 */
+	newchannel->state = CHANNEL_OPEN_STATE;
+
+	/*
 	 * Start the process of binding this offer to the driver
 	 * We need to set the DeviceObject field before calling
 	 * vmbus_child_dev_add()
@@ -318,13 +325,6 @@ static void vmbus_process_offer(struct work_struct *work)
 		kfree(newchannel->device_obj);
 
 		free_channel(newchannel);
-	} else {
-		/*
-		 * This state is used to indicate a successful open
-		 * so that when we do close the channel normally, we
-		 * can cleanup properly
-		 */
-		newchannel->state = CHANNEL_OPEN_STATE;
 	}
 }
 
-- 
1.7.4.1

