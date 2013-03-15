Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3COSzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:55:46 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:59190
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab3COSzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:55:43 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 6/6] Drivers: hv: vmbus: Handle channel rescind message correctly
Date: Fri, 15 Mar 2013 12:25:44 -0700
Message-Id: <1363375544-19901-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363375544-19901-1-git-send-email-kys@microsoft.com>
References: <1363375509-19860-1-git-send-email-kys@microsoft.com>
 <1363375544-19901-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly cleanup the channel state on receipt of the "offer rescind" message.
Starting with ws2012, the host requires that the channel "relid" be properly
cleaned up when the offer is rescinded.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel_mgmt.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index ff1be16..bad8128 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -165,8 +165,19 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
 	struct vmbus_channel *channel = container_of(work,
 						     struct vmbus_channel,
 						     work);
+	unsigned long flags;
+	struct vmbus_channel_relid_released msg;
 
 	vmbus_device_unregister(channel->device_obj);
+	memset(&msg, 0, sizeof(struct vmbus_channel_relid_released));
+	msg.child_relid = channel->offermsg.child_relid;
+	msg.header.msgtype = CHANNELMSG_RELID_RELEASED;
+	vmbus_post_msg(&msg, sizeof(struct vmbus_channel_relid_released));
+
+	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
+	list_del(&channel->listentry);
+	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
+	free_channel(channel);
 }
 
 void vmbus_free_channels(void)
-- 
1.7.4.1

