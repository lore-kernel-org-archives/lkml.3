Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3ILSPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:15:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab3ILSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [ 09/16] Drivers: hv: vmbus: Fix a bug in the handling of channel offers
Date: Thu, 12 Sep 2013 11:15:01 -0700
Message-Id: <20130912181157.228222145@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 42dceebe34600b2d02a38baa3e869009ba3d14c7 upstream.

The channel state should be correctly set before registering the device. In the current
code the driver probe would fail for channels that have been rescinded and subsequently
re-offered. Fix the bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/channel_mgmt.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -262,6 +262,13 @@ static void vmbus_process_offer(struct w
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
@@ -287,13 +294,6 @@ static void vmbus_process_offer(struct w
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
 


