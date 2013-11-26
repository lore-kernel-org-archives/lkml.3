Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3KZSNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:13:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab3KZSNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:13:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.11 29/36] Drivers: hv: vmbus: Fix a bug in channel rescind code
Date: Tue, 26 Nov 2013 10:12:39 -0800
Message-Id: <20131126181031.204016086@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131126181025.029404973@linuxfoundation.org>
References: <20131126181025.029404973@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -172,7 +172,8 @@ static void vmbus_process_rescind_offer(
 	struct vmbus_channel *primary_channel;
 	struct vmbus_channel_relid_released msg;
 
-	vmbus_device_unregister(channel->device_obj);
+	if (channel->device_obj)
+		vmbus_device_unregister(channel->device_obj);
 	memset(&msg, 0, sizeof(struct vmbus_channel_relid_released));
 	msg.child_relid = channel->offermsg.child_relid;
 	msg.header.msgtype = CHANNELMSG_RELID_RELEASED;
@@ -185,7 +186,7 @@ static void vmbus_process_rescind_offer(
 	} else {
 		primary_channel = channel->primary_channel;
 		spin_lock_irqsave(&primary_channel->sc_lock, flags);
-		list_del(&channel->listentry);
+		list_del(&channel->sc_list);
 		spin_unlock_irqrestore(&primary_channel->sc_lock, flags);
 	}
 	free_channel(channel);


