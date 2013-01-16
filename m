Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab3APQBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:01:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35915 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab3APQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:08 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 057/222] can: Do not call dev_put if restart timer is running upon close
Date: Wed, 16 Jan 2013 13:54:17 -0200
Message-Id: <1358351822-7675-58-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@systec-electronic.com>

commit ab48b03ec9ae1840a1e427e2375bd0d9d554b4ed upstream.

If the restart timer is running due to BUS-OFF and the device is
disconnected an dev_put will decrease the usage counter to -1 thus
blocking the interface removal, resulting in the following dmesg
lines repeating every 10s:
can: notifier: receive list not found for dev can0
can: notifier: receive list not found for dev can0
can: notifier: receive list not found for dev can0
unregister_netdevice: waiting for can0 to become free. Usage count = -1

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/can/dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index f03d7a4..4972609 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -576,8 +576,7 @@ void close_candev(struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
-	if (del_timer_sync(&priv->restart_timer))
-		dev_put(dev);
+	del_timer_sync(&priv->restart_timer);
 	can_flush_echo_skb(dev);
 }
 EXPORT_SYMBOL_GPL(close_candev);
-- 
1.7.9.5

