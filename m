Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaAPTKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:10:48 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:50302
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaAPTKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:10:46 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Don't timeout during the initial connection with host
Date: Thu, 16 Jan 2014 11:59:58 -0800
Message-Id: <1389902398-20067-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
---
 drivers/hv/connection.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 855bbda..f2d7bf9 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -67,7 +67,6 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	int ret = 0;
 	struct vmbus_channel_initiate_contact *msg;
 	unsigned long flags;
-	int t;
 
 	init_completion(&msginfo->waitevent);
 
@@ -102,15 +101,7 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
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
1.7.4.1

