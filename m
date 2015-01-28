Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbbA1F1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:27:21 -0500
Received: from mail.kernel.org ([198.145.29.136]:37135 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902AbbA1EOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:47 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 017/177] Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
Date: Wed, 28 Jan 2015 12:06:40 +0800
Message-Id: <1422418236-12852-33-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 66be653083057358724d56d817e870e53fb81ca7 upstream.

Eliminate calls to BUG_ON() by properly handling errors. In cases where
rollback is possible, we will return the appropriate error to have the
calling code decide how to rollback state. In the case where we are
transferring ownership of the guest physical pages to the host,
we will wait for the host to respond.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/hv/channel.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index f4c3d28..fa59090 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -472,7 +472,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
 	unsigned long flags;
-	int ret, t;
+	int ret;
 
 	info = kmalloc(sizeof(*info) +
 		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
@@ -494,11 +494,12 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
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
1.9.1

