Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbbANHi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:38:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbbANHi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:38:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 3.10 32/44] serial: samsung: wait for transfer completion before clock disable
Date: Tue, 13 Jan 2015 23:23:53 -0800
Message-Id: <20150114072229.219543080@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/serial/samsung.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -534,11 +534,15 @@ static void s3c24xx_serial_pm(struct uar
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
 


