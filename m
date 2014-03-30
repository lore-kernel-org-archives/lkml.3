Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaCaAEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:04:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753719AbaC3Xm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.629299830@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 092/200] Drivers: hv: vmbus: Don't timeout during the
 initial connection with host
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hv/connection.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -45,7 +45,6 @@ struct vmbus_connection vmbus_connection
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

