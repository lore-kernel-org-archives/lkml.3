Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab3K0A7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:59:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab3K0A6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.12 029/116] Drivers: hv: vmbus: Fix a bug in channel rescind code
Date: Tue, 26 Nov 2013 16:56:42 -0800
Message-Id: <20131127005738.954212945@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 565ce6422ff92f5af71e4d5a09f78215433b2695 upstream.

Rescind of subchannels were not being correctly handled. Fix the bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/channel_mgmt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -203,7 +203,8 @@ static void vmbus_process_rescind_offer(
 	struct vmbus_channel *primary_channel;
 	struct vmbus_channel_relid_released msg;
 
-	vmbus_device_unregister(channel->device_obj);
+	if (channel->device_obj)
+		vmbus_device_unregister(channel->device_obj);
 	memset(&msg, 0, sizeof(struct vmbus_channel_relid_released));
 	msg.child_relid = channel->offermsg.child_relid;
 	msg.header.msgtype = CHANNELMSG_RELID_RELEASED;
@@ -216,7 +217,7 @@ static void vmbus_process_rescind_offer(
 	} else {
 		primary_channel = channel->primary_channel;
 		spin_lock_irqsave(&primary_channel->sc_lock, flags);
-		list_del(&channel->listentry);
+		list_del(&channel->sc_list);
 		spin_unlock_irqrestore(&primary_channel->sc_lock, flags);
 	}
 	free_channel(channel);


