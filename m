Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbaJ1Gwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:52:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924AbaJ1DsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:48:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [PATCH 3.14 029/100] Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
Date: Tue, 28 Oct 2014 11:35:14 +0800
Message-Id: <20141028033501.913677709@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/hv/channel.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -434,7 +434,7 @@ int vmbus_teardown_gpadl(struct vmbus_ch
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
 	unsigned long flags;
-	int ret, t;
+	int ret;
 
 	info = kmalloc(sizeof(*info) +
 		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
@@ -456,11 +456,12 @@ int vmbus_teardown_gpadl(struct vmbus_ch
 	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_gpadl_teardown));
 
-	BUG_ON(ret != 0);
-	t = wait_for_completion_timeout(&info->waitevent, 5*HZ);
-	BUG_ON(t == 0);
+	if (ret)
+		goto post_msg_err;
 
-	/* Received a torndown response */
+	wait_for_completion(&info->waitevent);
+
+post_msg_err:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&info->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);


