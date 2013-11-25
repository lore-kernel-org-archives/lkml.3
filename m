Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3KYNUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:20:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57156 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3KYNIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 40/78] USB: mos7840: fix tiocmget error handling
Date: Mon, 25 Nov 2013 13:06:27 +0000
Message-Id: <1385384825-21681-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a91ccd26e75235d86248d018fe3779732bcafd8d upstream.

Make sure to return errors from tiocmget rather than rely on
uninitialised stack data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7840.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index d9368be..08aad01 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1707,7 +1707,11 @@ static int mos7840_tiocmget(struct tty_struct *tty)
 		return -ENODEV;
 
 	status = mos7840_get_uart_reg(port, MODEM_STATUS_REGISTER, &msr);
+	if (status != 1)
+		return -EIO;
 	status = mos7840_get_uart_reg(port, MODEM_CONTROL_REGISTER, &mcr);
+	if (status != 1)
+		return -EIO;
 	result = ((mcr & MCR_DTR) ? TIOCM_DTR : 0)
 	    | ((mcr & MCR_RTS) ? TIOCM_RTS : 0)
 	    | ((mcr & MCR_LOOPBACK) ? TIOCM_LOOP : 0)
-- 
1.8.3.2

