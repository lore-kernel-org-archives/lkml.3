Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab3IBJM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:12:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab3IBIzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 10/58] can: pcan_usb: fix wrong memcpy() bytes length
Date: Mon,  2 Sep 2013 09:53:55 +0100
Message-Id: <1378112083-9475-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit 3c322a56b01695df15c70bfdc2d02e0ccd80654e upstream.

Fix possibly wrong memcpy() bytes length since some CAN records received from
PCAN-USB could define a DLC field in range [9..15].
In that case, the real DLC value MUST be used to move forward the record pointer
but, only 8 bytes max. MUST be copied into the data field of the struct
can_frame object of the skb given to the network core.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 25723d8..925ab8e 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -649,7 +649,7 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		if ((mc->ptr + rec_len) > mc->end)
 			goto decode_failed;
 
-		memcpy(cf->data, mc->ptr, rec_len);
+		memcpy(cf->data, mc->ptr, cf->can_dlc);
 		mc->ptr += rec_len;
 	}
 
-- 
1.8.3.2

