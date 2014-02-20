Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaBTXvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:51:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbaBTXvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.10 41/66] Drivers: hv: vmbus: Dont timeout during the initial connection with host
Date: Thu, 20 Feb 2014 15:51:40 -0800
Message-Id: <20140220234910.670811682@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/hv/connection.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -67,7 +67,6 @@ static int vmbus_negotiate_version(struc
 	int ret = 0;
 	struct vmbus_channel_initiate_contact *msg;
 	unsigned long flags;
-	int t;
 
 	init_completion(&msginfo->waitevent);
 
@@ -102,15 +101,7 @@ static int vmbus_negotiate_version(struc
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


