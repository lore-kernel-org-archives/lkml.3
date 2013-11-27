Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab3K0BcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:32:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3K0A6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.12 005/116] USB: mos7840: fix tiocmget error handling
Date: Tue, 26 Nov 2013 16:56:18 -0800
Message-Id: <20131127005737.292859583@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a91ccd26e75235d86248d018fe3779732bcafd8d upstream.

Make sure to return errors from tiocmget rather than rely on
uninitialised stack data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1532,7 +1532,11 @@ static int mos7840_tiocmget(struct tty_s
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


