Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbbA2Kr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:47:28 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753792AbbA2I7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:38 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 154/176] can: dev: fix crtlmode_supported check
Date: Wed, 28 Jan 2015 15:29:44 +0100
Message-Id: <1d6e3205cb5d41a9ced10cfb61a13189e8e8e74e.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9b1087aa5e86448fe6ad40a58964e35f3ba423d5 upstream.

When changing flags in the CAN drivers ctrlmode the provided new content has to
be checked whether the bits are allowed to be changed. The bits that are to be
changed are given as a bitfield in cm->mask. Therefore checking against
cm->flags is wrong as the content can hold any kind of values.

The iproute2 tool sets the bits in cm->mask and cm->flags depending on the
detected command line options. To be robust against bogus user space
applications additionally sanitize the provided flags with the provided mask.

Cc: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/can/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 9bf47a064cdf..a4694aa20a3e 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -643,10 +643,14 @@ static int can_changelink(struct net_device *dev,
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
 		cm = nla_data(data[IFLA_CAN_CTRLMODE]);
-		if (cm->flags & ~priv->ctrlmode_supported)
+
+		/* check whether changed bits are allowed to be modified */
+		if (cm->mask & ~priv->ctrlmode_supported)
 			return -EOPNOTSUPP;
+
+		/* clear bits to be modified and copy the flag values */
 		priv->ctrlmode &= ~cm->mask;
-		priv->ctrlmode |= cm->flags;
+		priv->ctrlmode |= (cm->flags & cm->mask);
 	}
 
 	if (data[IFLA_CAN_BITTIMING]) {
-- 
2.2.2

