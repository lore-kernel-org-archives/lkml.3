Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaKXG4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:56:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34374 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaKXG4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:56:51 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-8c-5472d6b23d98
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 1/4] serial: samsung: wait for transfer completion before clock
 disable
Date: Mon, 24 Nov 2014 07:56:21 +0100
Message-id: <1416812184-4496-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1416812184-4496-1-git-send-email-r.baldyga@samsung.com>
References: <1416812184-4496-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jAd1N14pCDBrmc1nMWb+GzaJ58Xo2
	i8+/d7FaXN41h83izOJedou1R+6yWzw4vJPdYsHGR4wOHB4nZvxm8dg/dw27R9+WVYweZxYc
	Yff4vEkugDWKyyYlNSezLLVI3y6BK6P7WStjwQGOiknTrrM2MP5m62Lk5JAQMJGYdPMEM4Qt
	JnHh3nqgOBeHkMAiRonmHedYIJx2JonvV36zgFSxCehIbPk+gRHEFhGQk3hy+w8zSBGzwHFG
	iRtzzrOCJIQFIiU6Jh8GK2IRUJV4c6YXqJmDg1fARWLnenWIbXISJ49NBivnFHCVeH5zKthF
	QkAln1ZMYJ/AyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCAPZPewbiqweIQowAH
	oxIP74z1RSFCrIllxZW5hxglOJiVRHjP/isMEeJNSaysSi3Kjy8qzUktPsQozcGiJM5742Zu
	iJBAemJJanZqakFqEUyWiYNTqoHRcmb5rY9Web/b/pzXdCuYcGjfoQirDyU71O6Vb0mz0ttT
	tTjUeOW6fAHGOIZ5IlJ3NcOzORZ+6VjplhJ6+/lbT3Zf/5AF2YeNzx0+f8jns8jR874Tt0t9
	zIzWNTac7s6usFjOttFNpXxrhKGtWPRK8cm7Snjdfro+qtsZc357/kml7fKin2crsRRnJBpq
	MRcVJwIAscI1biwCAAA=
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

