Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaCCTGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:06:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbaCCS64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:58:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 46/67] Drivers: hv: vmbus: Don't timeout during the initial connection with host
Date: Mon,  3 Mar 2014 10:55:34 -0800
Message-Id: <1393872955-28810-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 269f979467cf49f2ea8132316c1f00f8c9678f7c upstream.

When the guest attempts to connect with the host when there may already be a
connection with the host (as would be the case during the kdump/kexec path),
it is difficult to guarantee timely response from the host. Starting with
WS2012 R2, the host supports this ability to re-connect with the host
(explicitly to support kexec). Prior to responding to the guest, the host
needs to ensure that device states based on the previous connection to
the host have been properly torn down. This may introduce unbounded delays.
To deal with this issue, don't do a timed wait during the initial connect
with the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.8 (applied to vmbus_connect) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hv/connection.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 650c9f0..d7f3df9 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -45,7 +45,6 @@ struct vmbus_connection vmbus_connection = {
 int vmbus_connect(void)
 {
 	int ret = 0;
-	int t;
 	struct vmbus_channel_msginfo *msginfo = NULL;
 	struct vmbus_channel_initiate_contact *msg;
 	unsigned long flags;
@@ -132,16 +131,7 @@ int vmbus_connect(void)
 	}
 
 	/* Wait for the connection response */
-	t =  wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
-	if (t == 0) {
-		spin_lock_irqsave(&vmbus_connection.channelmsg_lock,
-				flags);
-		list_del(&msginfo->msglistentry);
-		spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock,
-					flags);
-		ret = -ETIMEDOUT;
-		goto cleanup;
-	}
+	wait_for_completion(&msginfo->waitevent);
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&msginfo->msglistentry);
-- 
1.8.3.2

