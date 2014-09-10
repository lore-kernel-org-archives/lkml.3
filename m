Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaIJTG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:06:57 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51709 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753177AbaIJTGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:06:55 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 01/14] serial: core: Document and assert lock requirements for irq helpers
Date: Wed, 10 Sep 2014 15:06:23 -0400
Message-Id: <1410375996-4693-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The serial core provides two helper functions, uart_handle_dcd_change()
and uart_handle_cts_change(), for UART drivers to use at interrupt
time. The serial core expects the UART driver to hold the uart port lock
when calling these helpers to prevent state corruption.

If lockdep enabled, trigger a warning if the uart port lock is not held
when calling these helper functions.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 732d386..0567b65 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2731,6 +2731,8 @@ EXPORT_SYMBOL(uart_match_port);
  *	uart_handle_dcd_change - handle a change of carrier detect state
  *	@uport: uart_port structure for the open port
  *	@status: new carrier detect status, nonzero if active
+ *
+ *	Caller must hold uport->lock
  */
 void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 {
@@ -2738,6 +2740,8 @@ void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 	struct tty_struct *tty = port->tty;
 	struct tty_ldisc *ld;
 
+	lockdep_assert_held_once(&uport->lock);
+
 	if (tty) {
 		ld = tty_ldisc_ref(tty);
 		if (ld) {
@@ -2762,12 +2766,16 @@ EXPORT_SYMBOL_GPL(uart_handle_dcd_change);
  *	uart_handle_cts_change - handle a change of clear-to-send state
  *	@uport: uart_port structure for the open port
  *	@status: new clear to send status, nonzero if active
+ *
+ *	Caller must hold uport->lock
  */
 void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
 {
 	struct tty_port *port = &uport->state->port;
 	struct tty_struct *tty = port->tty;
 
+	lockdep_assert_held_once(&uport->lock);
+
 	uport->icount.cts++;
 
 	if (tty_port_cts_enabled(port)) {
-- 
2.1.0

