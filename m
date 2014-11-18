Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaKRGwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:52:35 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45191 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaKRGwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:52:33 -0500
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: San Mehat <san@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC] serial_core: Add wake_peer uart operation
Date: Tue, 18 Nov 2014 12:20:01 +0530
Message-Id: <1416293401-7714-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: San Mehat <san@google.com>

serial_core: Add wake_peer uart operation

Add wake_peer which is called before starting UART TX. The idea here
is to provide a mechanism where we can wakeup our peer before sending
data.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: San Mehat <san@google.com>
[Kiran: Added context to commit message]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
This is one of the number of patches from the Android AOSP common.git tree,
which is used on almost all Android devices.  I wanted to submit it for review
to see if it should go upstream.

 drivers/tty/serial/serial_core.c | 3 +++
 include/linux/serial_core.h      | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index df3a8c7..dc45c4b 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -95,6 +95,9 @@ static void __uart_start(struct tty_struct *tty)
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port = state->uart_port;
 
+	if (port->ops->wake_peer)
+		port->ops->wake_peer(port);
+
 	if (!uart_tx_stopped(port))
 		port->ops->start_tx(port);
 }
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 21c2e05..219b6a3 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -66,6 +66,7 @@ struct uart_ops {
 	void		(*set_ldisc)(struct uart_port *, int new);
 	void		(*pm)(struct uart_port *, unsigned int state,
 			      unsigned int oldstate);
+	void		(*wake_peer)(struct uart_port *);
 
 	/*
 	 * Return a string describing the type of the port
-- 
1.8.2.1

