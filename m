Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbaJ1LUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:20:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11341 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJ1LUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:20:16 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-5f-544f7bee2744
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH] serial: samsung: wait for transfer completion before clock
 disable
Date: Tue, 28 Oct 2014 12:19:59 +0100
Message-id: <1414495199-15559-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t9jQd131f4hBvMfqls0L17PZvH59y5W
	i8u75rBZnFncy26x9shddosHh3eyWyzY+IjRgd1j/9w17B59W1YxepxZcITd4/MmuQCWKC6b
	lNSczLLUIn27BK6M7metjAUHOComTbvO2sD4m62LkZNDQsBEYvP3OawQtpjEhXvrgeJcHEIC
	0xklGs5vZIRw2pkkvjx4CdbBJqAjseX7BEYQW0RATuLJ7T/MIEXMAmsYJVY1bQIbJSwQKtHz
	6QM7iM0ioCpxbss0sDivgKvE3cXnodbJSZw8Npl1AiP3AkaGVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjB4fFMegfjqgaLQ4wCHIxKPLyGD/1ChFgTy4orcw8xSnAwK4nwRsT4hwjxpiRW
	VqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgTDuwfq0NX2Jks0KB
	ua783u+idmeezV26pDBnXYo0y3t/h6luJxZePvaOb9n3OVGXxWe07wjnmPTz74/Fzzkk85fH
	nblnw2OY6BiQY5CfFec+4+Vnkdk1XmdYne5tP+fAo+nwXOnG068NeiY+Cs8+L5NRnLEqwCLd
	p1n2PsNWk67UsqT1HYJRSizFGYmGWsxFxYkAA/soGwsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds waiting until transmit buffer and shifter will be empty
before clock disabling.

Without this fix it's possible to have clock disabled while data was
not transmited yet, which causes unproper state of TX line and problems
in following data transfers.

Cc: <stable@vger.kernel.org> # v2.6.26+
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/tty/serial/samsung.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c78f43a..587d63b 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -559,11 +559,15 @@ static void s3c24xx_serial_pm(struct uart_port *port, unsigned int level,
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

