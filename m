Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaHZSCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:02:32 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53872
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbaHZSCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:02:25 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/4] Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
Date: Tue, 26 Aug 2014 12:05:50 -0700
Message-Id: <1409079952-16599-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1409079952-16599-1-git-send-email-kys@microsoft.com>
References: <1409079922-16560-1-git-send-email-kys@microsoft.com>
 <1409079952-16599-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate calls to BUG_ON() by properly handling errors. In cases where
rollback is possible, we will return the appropriate error to have the
calling code decide how to rollback state. In the case where we are
transferring ownership of the guest physical pages to the host,
we will wait for the host to respond.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hv/channel.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 531a593..0206314 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -435,7 +435,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
 	unsigned long flags;
-	int ret, t;
+	int ret;
 
 	info = kmalloc(sizeof(*info) +
 		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
@@ -457,11 +457,12 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_gpadl_teardown));
 
-	BUG_ON(ret != 0);
-	t = wait_for_completion_timeout(&info->waitevent, 5*HZ);
-	BUG_ON(t == 0);
+	if (ret)
+		goto post_msg_err;
+
+	wait_for_completion(&info->waitevent);
 
-	/* Received a torndown response */
+post_msg_err:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&info->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-- 
1.7.4.1

