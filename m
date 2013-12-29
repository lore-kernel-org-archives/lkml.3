Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab3L2DED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:04:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54958 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab3L2CJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:51 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.950172094@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 003/185] USB: mos7840: fix tiocmget error handling
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a91ccd26e75235d86248d018fe3779732bcafd8d upstream.

Make sure to return errors from tiocmget rather than rely on
uninitialised stack data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mos7840.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1689,7 +1689,11 @@ static int mos7840_tiocmget(struct tty_s
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

