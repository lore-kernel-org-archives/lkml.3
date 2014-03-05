Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbaCEPNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:13:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41009 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbaCEOZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Chen <peter.chen@freescale.com>,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 063/131] usb: chipidea: need to mask when writting endptflush and endptprime
Date: Wed,  5 Mar 2014 14:23:07 +0000
Message-Id: <1394029455-23128-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu CASTET <matthieu.castet@parrot.com>

commit 5bf5dbeda2454296f1984adfbfc8e6f5965ac389 upstream.

ENDPTFLUSH and ENDPTPRIME registers are set by software and clear
by hardware. There is a bit for each endpoint. When we are setting
a bit for an endpoint we should make sure we do not touch other
endpoint bit. There is a race condition if the hardware clear the
bit between the read and the write in hw_write.

Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Matthieu CASTET <matthieu.castet@parrot.com>
Tested-by: Michael Grzeschik <mgrzeschik@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/chipidea/udc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 3a223a8..b13fc29 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -103,7 +103,7 @@ static int hw_ep_flush(struct ci_hdrc *ci, int num, int dir)
 
 	do {
 		/* flush any pending transfer */
-		hw_write(ci, OP_ENDPTFLUSH, BIT(n), BIT(n));
+		hw_write(ci, OP_ENDPTFLUSH, ~0, BIT(n));
 		while (hw_read(ci, OP_ENDPTFLUSH, BIT(n)))
 			cpu_relax();
 	} while (hw_read(ci, OP_ENDPTSTAT, BIT(n)));
@@ -203,7 +203,7 @@ static int hw_ep_prime(struct ci_hdrc *ci, int num, int dir, int is_ctrl)
 	if (is_ctrl && dir == RX && hw_read(ci, OP_ENDPTSETUPSTAT, BIT(num)))
 		return -EAGAIN;
 
-	hw_write(ci, OP_ENDPTPRIME, BIT(n), BIT(n));
+	hw_write(ci, OP_ENDPTPRIME, ~0, BIT(n));
 
 	while (hw_read(ci, OP_ENDPTPRIME, BIT(n)))
 		cpu_relax();
-- 
1.9.0

