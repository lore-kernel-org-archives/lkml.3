Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaGGX57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:57:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbaGGXzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, Jiri Slaby <jslaby@suse.cz>,
        Tim Kryger <tim.kryger@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Wang Nan <wangnan0@huawei.com>
Subject: [PATCH 3.10 48/53] serial: 8250_dw: Fix LCR workaround regression
Date: Mon,  7 Jul 2014 16:58:33 -0700
Message-Id: <20140707235830.740880485@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hogan <james.hogan@imgtec.com>

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
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_dw.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -92,7 +92,8 @@ static void dw8250_serial_out(struct uar
 	if (offset == UART_LCR) {
 		int tries = 1000;
 		while (tries--) {
-			if (value == p->serial_in(p, UART_LCR))
+			unsigned int lcr = p->serial_in(p, UART_LCR);
+			if ((value & ~UART_LCR_SPAR) == (lcr & ~UART_LCR_SPAR))
 				return;
 			dw8250_force_idle(p);
 			writeb(value, p->membase + (UART_LCR << p->regshift));
@@ -121,7 +122,8 @@ static void dw8250_serial_out32(struct u
 	if (offset == UART_LCR) {
 		int tries = 1000;
 		while (tries--) {
-			if (value == p->serial_in(p, UART_LCR))
+			unsigned int lcr = p->serial_in(p, UART_LCR);
+			if ((value & ~UART_LCR_SPAR) == (lcr & ~UART_LCR_SPAR))
 				return;
 			dw8250_force_idle(p);
 			writel(value, p->membase + (UART_LCR << p->regshift));


