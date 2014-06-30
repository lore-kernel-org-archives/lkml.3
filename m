Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbaF3MOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:14:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51969 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Tim Kryger <tim.kryger@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH 3.12 052/181] serial: 8250_dw: Fix LCR workaround regression
Date: Mon, 30 Jun 2014 13:51:13 +0200
Message-Id: <7edfb8800c70f7460393c0684686f868e6d74c59.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6979f8d28049879e6147767d93ba6732c8bd94f4 upstream.

Commit c49436b657d0 (serial: 8250_dw: Improve unwritable LCR workaround)
caused a regression. It added a check that the LCR was written properly
to detect and workaround the busy quirk, but the behaviour of bit 5
(UART_LCR_SPAR) differs between IP versions 3.00a and 3.14c per the
docs. On older versions this caused the check to fail and it would
repeatedly force idle and rewrite the LCR register, causing delays and
preventing any input from serial being received.

This is fixed by masking out UART_LCR_SPAR before making the comparison.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Tim Kryger <tim.kryger@linaro.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Matt Porter <matt.porter@linaro.org>
Cc: Markus Mayer <markus.mayer@linaro.org>
Tested-by: Tim Kryger <tim.kryger@linaro.org>
Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Tested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/8250/8250_dw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 1dec9af3c9ab..70ecf541b77a 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -95,7 +95,8 @@ static void dw8250_serial_out(struct uart_port *p, int offset, int value)
 	if (offset == UART_LCR) {
 		int tries = 1000;
 		while (tries--) {
-			if (value == p->serial_in(p, UART_LCR))
+			unsigned int lcr = p->serial_in(p, UART_LCR);
+			if ((value & ~UART_LCR_SPAR) == (lcr & ~UART_LCR_SPAR))
 				return;
 			dw8250_force_idle(p);
 			writeb(value, p->membase + (UART_LCR << p->regshift));
@@ -131,7 +132,8 @@ static void dw8250_serial_out32(struct uart_port *p, int offset, int value)
 	if (offset == UART_LCR) {
 		int tries = 1000;
 		while (tries--) {
-			if (value == p->serial_in(p, UART_LCR))
+			unsigned int lcr = p->serial_in(p, UART_LCR);
+			if ((value & ~UART_LCR_SPAR) == (lcr & ~UART_LCR_SPAR))
 				return;
 			dw8250_force_idle(p);
 			writel(value, p->membase + (UART_LCR << p->regshift));
-- 
2.0.0

