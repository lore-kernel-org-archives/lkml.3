Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaJ0TEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:04:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaJ0TEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 034/105] Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
Date: Mon, 27 Oct 2014 11:56:09 -0700
Message-Id: <1414436240-13879-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 66be653083057358724d56d817e870e53fb81ca7 upstream.

Eliminate calls to BUG_ON() by properly handling errors. In cases where
rollback is possible, we will return the appropriate error to have the
calling code decide how to rollback state. In the case where we are
transferring ownership of the guest physical pages to the host,
we will wait for the host to respond.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hv/channel.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index cea623c..d2d9cd6 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -432,7 +432,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
 	unsigned long flags;
-	int ret, t;
+	int ret;
 
 	info = kmalloc(sizeof(*info) +
 		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
@@ -454,11 +454,12 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
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

