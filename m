Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbbALSYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:24:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57552 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbbALSGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robert Baldyga <r.baldyga@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 056/216] serial: samsung: wait for transfer completion before clock disable
Date: Mon, 12 Jan 2015 18:02:53 +0000
Message-Id: <1421085933-32536-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Baldyga <r.baldyga@samsung.com>

commit 1ff383a4c3eda8893ec61b02831826e1b1f46b41 upstream.

This patch adds waiting until transmit buffer and shifter will be empty
before clock disabling.

Without this fix it's possible to have clock disabled while data was
not transmited yet, which causes unproper state of TX line and problems
in following data transfers.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/samsung.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c1d3ebdf3b97..7268409dfc68 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -567,11 +567,15 @@ static void s3c24xx_serial_pm(struct uart_port *port, unsigned int level,
 			      unsigned int old)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
+	int timeout = 10000;
 
 	ourport->pm_level = level;
 
 	switch (level) {
 	case 3:
+		while (--timeout && !s3c24xx_serial_txempty_nofifo(port))
+			udelay(100);
+
 		if (!IS_ERR(ourport->baudclk))
 			clk_disable_unprepare(ourport->baudclk);
 
-- 
2.1.4

