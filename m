Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaLILBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:01:43 -0500
Received: from box2.japko.eu ([91.121.152.53]:53043 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbaLILBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:01:40 -0500
Date: Tue, 9 Dec 2014 12:01:38 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Malcolm Priestley <tvboxspy@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6656: Use ether_addr_copy() on vnt_private
 members.
Message-ID: <20141209110138.GA10913@x61s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch.pl warning:
WARNING: Prefer ether_addr_copy() over memcpy() if the Ethernet
addresses are __aligned(2)

current_net_addr and permanent_net_addr members of vnt_private alignment
is changed to at last 16 bits so that ether_addr_copy can be safely used
on them.

buf->data is of type ieee80211_cts which is already properly aligned.

Signed-off-by: Krzysztof Adamski <k@japko.eu>
---
 drivers/staging/vt6656/device.h   | 4 ++--
 drivers/staging/vt6656/main_usb.c | 3 ++-
 drivers/staging/vt6656/rxtx.c     | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 5a7ca52..4dcc67d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -307,8 +307,8 @@ struct vnt_private {
 
 	struct vnt_cmd_card_init init_command;
 	struct vnt_rsp_card_init init_response;
-	u8 current_net_addr[ETH_ALEN];
-	u8 permanent_net_addr[ETH_ALEN];
+	u8 current_net_addr[ETH_ALEN] __aligned(2);
+	u8 permanent_net_addr[ETH_ALEN] __aligned(2);
 
 	u8 exist_sw_net_addr;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index b95d5b1..71adc1f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -34,6 +34,7 @@
  */
 #undef __NO_VERSION__
 
+#include <linux/etherdevice.h>
 #include <linux/file.h>
 #include "device.h"
 #include "card.h"
@@ -319,7 +320,7 @@ static int vnt_init_registers(struct vnt_private *priv)
 
 	/* get permanent network address */
 	memcpy(priv->permanent_net_addr, init_rsp->net_addr, 6);
-	memcpy(priv->current_net_addr, priv->permanent_net_addr, ETH_ALEN);
+	ether_addr_copy(priv->current_net_addr, priv->permanent_net_addr);
 
 	/* if exist SW network address, use it */
 	dev_dbg(&priv->usb->dev, "Network address = %pM\n",
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 280c923..75d2c5e 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -553,7 +553,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
+		ether_addr_copy(buf->data.ra, priv->current_net_addr);
 
 		return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
 	} else {
@@ -571,7 +571,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
+		ether_addr_copy(buf->data.ra, priv->current_net_addr);
 
 		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
 	}
-- 
1.9.3

