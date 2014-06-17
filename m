Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966713AbaFQVu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:50:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965292AbaFQVu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 190/212] can: only rename enabled led triggers when changing the netdev name
Date: Tue, 17 Jun 2014 14:44:44 -0700
Message-Id: <1403041506-13646-191-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 45fb4f8d81578e0a17c45c4593a3305afbf7a48b upstream.

Commit a1ef7bd9fce8 ("can: rename LED trigger name on netdev renames") renames
the led trigger names according to the changed netdevice name.

As not every CAN driver supports and initializes the led triggers, checking for
the CAN private datastructure with safe_candev_priv() in the notifier chain is
not enough.

This patch adds a check when CONFIG_CAN_LEDS is enabled and the driver does not
support led triggers.

For stable 3.9+

Cc: Fabio Baltieri <fabio.baltieri@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/led.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
index a3d99a8..ab7f1b0 100644
--- a/drivers/net/can/led.c
+++ b/drivers/net/can/led.c
@@ -97,6 +97,9 @@ static int can_led_notifier(struct notifier_block *nb, unsigned long msg,
 	if (!priv)
 		return NOTIFY_DONE;
 
+	if (!priv->tx_led_trig || !priv->rx_led_trig)
+		return NOTIFY_DONE;
+
 	if (msg == NETDEV_CHANGENAME) {
 		snprintf(name, sizeof(name), "%s-tx", netdev->name);
 		led_trigger_rename_static(name, priv->tx_led_trig);
-- 
1.9.1

