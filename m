Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaC1Kxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:53:53 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:39944 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaC1Kxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:53:51 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: linux-serial@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: st-asc: Fix SysRq char handling
Date: Fri, 28 Mar 2014 10:53:10 +0000
Message-Id: <1396003990-30228-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver, like several others, uses the upper bits of the character
to track both real and dummy state. Unfortunately it neglects to mask
these bits properly when passing the character data around. This means
neither break detection nor sysrq character handling work correctly.

This patch adds the requires masking and has been tested to confirm
that it correctly handles magic sysrq sequences on ST's B2020 board.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/tty/serial/st-asc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index 21e6e84..dd3a96e 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -295,7 +295,7 @@ static void asc_receive_chars(struct uart_port *port)
 			status & ASC_STA_OE) {
 
 			if (c & ASC_RXBUF_FE) {
-				if (c == ASC_RXBUF_FE) {
+				if (c == (ASC_RXBUF_FE | ASC_RXBUF_DUMMY_RX)) {
 					port->icount.brk++;
 					if (uart_handle_break(port))
 						continue;
@@ -325,7 +325,7 @@ static void asc_receive_chars(struct uart_port *port)
 				flag = TTY_FRAME;
 		}
 
-		if (uart_handle_sysrq_char(port, c))
+		if (uart_handle_sysrq_char(port, c & 0xff))
 			continue;
 
 		uart_insert_char(port, c, ASC_RXBUF_DUMMY_OE, c & 0xff, flag);
-- 
1.9.0

