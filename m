Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbaCDVAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:00:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685AbaCDUEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Michael Grzeschik <mgrzeschik@pengutronix.de>
Subject: [PATCH 3.13 120/172] usb: chipidea: need to mask when writting endptflush and endptprime
Date: Tue,  4 Mar 2014 12:03:24 -0800
Message-Id: <20140304200303.569292634@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/chipidea/udc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -105,7 +105,7 @@ static int hw_ep_flush(struct ci_hdrc *c
 
 	do {
 		/* flush any pending transfer */
-		hw_write(ci, OP_ENDPTFLUSH, BIT(n), BIT(n));
+		hw_write(ci, OP_ENDPTFLUSH, ~0, BIT(n));
 		while (hw_read(ci, OP_ENDPTFLUSH, BIT(n)))
 			cpu_relax();
 	} while (hw_read(ci, OP_ENDPTSTAT, BIT(n)));
@@ -205,7 +205,7 @@ static int hw_ep_prime(struct ci_hdrc *c
 	if (is_ctrl && dir == RX && hw_read(ci, OP_ENDPTSETUPSTAT, BIT(num)))
 		return -EAGAIN;
 
-	hw_write(ci, OP_ENDPTPRIME, BIT(n), BIT(n));
+	hw_write(ci, OP_ENDPTPRIME, ~0, BIT(n));
 
 	while (hw_read(ci, OP_ENDPTPRIME, BIT(n)))
 		cpu_relax();


