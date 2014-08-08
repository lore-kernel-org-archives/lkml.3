Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbaHHKnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:43:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:54190 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbaHHKnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:43:08 -0400
X-IronPort-AV: E=Sophos;i="5.01,824,1400025600"; 
   d="scan'208";a="160628298"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH net-next] xen-netback: Don't deschedule NAPI when carrier off
Date: Fri, 8 Aug 2014 11:43:00 +0100
Message-ID: <1407494580-19404-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the patch called "xen-netback: Turn off the carrier if the guest is not able
to receive" NAPI was descheduled when the carrier was set off. That's
not what most of the drivers do, and we don't have any specific reason to do so
as well, so revert that change.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
---
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 48a55cd..12656f6 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -78,12 +78,8 @@ int xenvif_poll(struct napi_struct *napi, int budget)
 	/* This vif is rogue, we pretend we've there is nothing to do
 	 * for this vif to deschedule it from NAPI. But this interface
 	 * will be turned off in thread context later.
-	 * Also, if a guest doesn't post enough slots to receive data on one of
-	 * its queues, the carrier goes down and NAPI is descheduled here so
-	 * the guest can't send more packets until it's ready to receive.
 	 */
-	if (unlikely(queue->vif->disabled ||
-		     !netif_carrier_ok(queue->vif->dev))) {
+	if (unlikely(queue->vif->disabled )) {
 		napi_complete(napi);
 		return 0;
 	}
