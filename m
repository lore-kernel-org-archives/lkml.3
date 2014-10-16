Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaJPU4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:56:01 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37572 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753231AbaJPUyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:54:45 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 09/10] serial: core: Remove extra locking in uart_write()
Date: Thu, 16 Oct 2014 16:54:26 -0400
Message-Id: <1413492867-20679-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uart_start() only claims the port->lock to call __uart_start(),
which does the actual processing. Eliminate the extra acquire/release
in uart_write(); call __uart_start() directly with port->lock already
held.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index e04ae58..6a3571e 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -537,9 +537,10 @@ static int uart_write(struct tty_struct *tty,
 		count -= c;
 		ret += c;
 	}
+
+	__uart_start(tty);
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	uart_start(tty);
 	return ret;
 }
 
-- 
2.1.1

