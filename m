Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaDAQQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:16:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44748 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaDAQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 39/86] can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails
Date: Tue,  1 Apr 2014 09:07:52 -0700
Message-Id: <1396368519-12728-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 7e9e148af01ef388efb6e2490805970be4622792 upstream.

If flexcan_chip_start() in flexcan_open() fails, the interrupt is not freed,
this patch adds the missing cleanup.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/flexcan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 663e4df..9771652 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -860,12 +860,14 @@ static int flexcan_open(struct net_device *dev)
 	/* start chip and queuing */
 	err = flexcan_chip_start(dev);
 	if (err)
-		goto out_close;
+		goto out_free_irq;
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
 
 	return 0;
 
+ out_free_irq:
+	free_irq(dev->irq, dev);
  out_close:
 	close_candev(dev);
  out:
-- 
1.8.3.2

