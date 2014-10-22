Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaJVNRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:17:52 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:34752 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582AbaJVNRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:17:49 -0400
X-Listener-Flag: 11101
From: Eddie Huang <eddie.huang@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Alan Cox <alan@linux.intel.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <yh.chen@mediatek.com>,
        <hc.yen@mediatek.com>, <nathan.chung@mediatek.com>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 1/3] tty: serial: Fix mediatek UART driver setting baudrate issue
Date: Wed, 22 Oct 2014 21:12:07 +0800
Message-ID: <1413983529-21887-2-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1413983529-21887-1-git-send-email-eddie.huang@mediatek.com>
References: <1413983529-21887-1-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mtk8250_set_termios function, calculating quot value can not be zero,
otherwise, using DIV_ROUND_CLOSEST(port->uartclk, quot * baud) will fail due to
divisor is zero.

Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
---
 drivers/tty/serial/8250/8250_mtk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index 8f37d57..6f93123 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -74,14 +74,14 @@ mtk8250_set_termios(struct uart_port *port, struct ktermios *termios,
 		/* Set to next lower baudrate supported */
 		if ((baud == 500000) || (baud == 576000))
 			baud = 460800;
-		quot = DIV_ROUND_CLOSEST(port->uartclk, 4 * baud);
+		quot = DIV_ROUND_UP(port->uartclk, 4 * baud);
 	} else {
 		serial_port_out(port, UART_MTK_HIGHS, 0x3);
 
 		/* Set to highest baudrate supported */
 		if (baud >= 1152000)
 			baud = 921600;
-		quot = DIV_ROUND_CLOSEST(port->uartclk, 256 * baud);
+		quot = DIV_ROUND_UP(port->uartclk, 256 * baud);
 	}
 
 	/*
-- 
1.8.1.1.dirty

