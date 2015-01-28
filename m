Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbbA2DTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:19:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964974AbbA2Cf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:59 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robert Baldyga <r.baldyga@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 054/139] serial: samsung: wait for transfer completion before clock disable
Date: Wed, 28 Jan 2015 14:19:57 -0800
Message-Id: <1422483682-15393-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/samsung.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c1af04d..6097355 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -544,11 +544,15 @@ static void s3c24xx_serial_pm(struct uart_port *port, unsigned int level,
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
1.9.1

