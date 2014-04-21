Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaDUQks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:40:48 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:39428 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaDUQkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:40:40 -0400
From: Doug Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-samsung-soc@vger.kernel.org
Cc: olof@lixom.net, Doug Anderson <dianders@chromium.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] serial: samsung: Change barrier() to cpu_relax() in console output
Date: Mon, 21 Apr 2014 09:40:36 -0700
Message-Id: <1398098436-31895-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1398098436-31895-1-git-send-email-dianders@chromium.org>
References: <1398098436-31895-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two functions to write out to the console (one used in normal
console mode and one in polling console mode) were slightly different.
One used a barrier() in its loop and the other a cpu_relax().  The
barrier() really doesn't do anything since we're using rd_regl() to
read the port anyway.  Switch it to cpu_relax() to make things
consistent.

No known bugs / issues are fixed by this change--it just makes things
more consistent.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/tty/serial/samsung.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 12442748..1f5505e 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1466,7 +1466,7 @@ s3c24xx_serial_console_putchar(struct uart_port *port, int ch)
 	unsigned int ufcon = rd_regl(port, S3C2410_UFCON);
 
 	while (!s3c24xx_serial_console_txrdy(port, ufcon))
-		barrier();
+		cpu_relax();
 	wr_regb(port, S3C2410_UTXH, ch);
 }
 
-- 
1.9.1.423.g4596e3a

