Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaBUMvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:51:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaBUMvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 082/121] Drivers: hv: vmbus: Don't timeout during the initial connection with host
Date: Fri, 21 Feb 2014 12:48:26 +0000
Message-Id: <1392986945-9693-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hv/connection.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 0742931..bf07435 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -67,7 +67,6 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	int ret = 0;
 	struct vmbus_channel_initiate_contact *msg;
 	unsigned long flags;
-	int t;
 
 	init_completion(&msginfo->waitevent);
 
@@ -104,15 +103,7 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	}
 
 	/* Wait for the connection response */
-	t =  wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
-	if (t == 0) {
-		spin_lock_irqsave(&vmbus_connection.channelmsg_lock,
-				flags);
-		list_del(&msginfo->msglistentry);
-		spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock,
-					flags);
-		return -ETIMEDOUT;
-	}
+	wait_for_completion(&msginfo->waitevent);
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&msginfo->msglistentry);
-- 
1.9.0

