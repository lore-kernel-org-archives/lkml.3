Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3JKXoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:44:03 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36100
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab3JKXoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:44:01 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>,
        "[3.11+]"@linuxonhyperv.com
Subject: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in channel rescind code
Date: Fri, 11 Oct 2013 17:27:16 -0700
Message-Id: <1381537636-24889-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rescind of subchannels were not being correctly handled. Fix the bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>        [3.11+]
---
 drivers/hv/channel_mgmt.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index bbff5f2..eebf566 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -203,7 +203,8 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
 	struct vmbus_channel *primary_channel;
 	struct vmbus_channel_relid_released msg;
 
-	vmbus_device_unregister(channel->device_obj);
+	if (channel->device_obj)
+		vmbus_device_unregister(channel->device_obj);
 	memset(&msg, 0, sizeof(struct vmbus_channel_relid_released));
 	msg.child_relid = channel->offermsg.child_relid;
 	msg.header.msgtype = CHANNELMSG_RELID_RELEASED;
@@ -213,11 +214,6 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
 		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 		list_del(&channel->listentry);
 		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
-	} else {
-		primary_channel = channel->primary_channel;
-		spin_lock_irqsave(&primary_channel->sc_lock, flags);
-		list_del(&channel->listentry);
-		spin_unlock_irqrestore(&primary_channel->sc_lock, flags);
 	}
 	free_channel(channel);
 }
-- 
1.7.4.1

