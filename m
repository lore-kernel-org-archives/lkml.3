Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073Ab3CMXal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:30:41 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:35530 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab3CMXak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:30:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org
Subject: [PATCH] TTY: serial, stop accessing potential NULLs
Date: Thu, 14 Mar 2013 00:30:34 +0100
Message-Id: <1363217434-29262-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commits:
* 6732c8bb8671acbdac6cdc93dd72ddd581dd5e25 (TTY: switch
  tty_schedule_flip)
* 2e124b4a390ca85325fae75764bef92f0547fa25 (TTY: switch
  tty_flip_buffer_push)
* 05c7cd39907184328f48d3e7899f9cdd653ad336 (TTY: switch
  tty_insert_flip_string)
* 92a19f9cec9a80ad93c06e115822deb729e2c6ad (TTY: switch
  tty_insert_flip_char)
* 227434f8986c3827a1faedd1feb437acd6285315 (TTY: switch
  tty_buffer_request_room to tty_port)

introduced a potential NULL dereference to some drivers. In
particular, when the device is used as a console, incoming bytes can
kill the box. This is caused by removed checks for TTY against NULL.

It happened because it was unclear to me why the checks were there. I
assumed them superfluous because the interrupts were unbound or
otherwise stopped. But this is not the case for consoles for these
drivers, as was pointed out by David Miller.

Now, this patch re-introduces the checks (at this point we check
port->state, not the tty proper, as we do not care about tty pointers
anymore). For both of the drivers, we place the check below the
handling of break signal so that sysrq can actually work. (One needs
to issue a break and then sysrq key within the following 5 seconds.)

We do not change sc26xx, sunhv, and sunsu here because they behave the
same as before.  People having that hardware should fix the driver
eventually, however. They always could unconditionally dereference tty
in receive_chars, port->state in uart_handle_dcd_change, and
up->port.state->port.tty.

There is perhaps more to fix in all those drivers, but they are at
least in a state they were before.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: sparclinux@vger.kernel.org
---
 drivers/tty/serial/sunsab.c   | 2 +-
 drivers/tty/serial/sunzilog.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 8de2213..a422c8b 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -203,7 +203,7 @@ receive_chars(struct uart_sunsab_port *up,
 				flag = TTY_FRAME;
 		}
 
-		if (uart_handle_sysrq_char(&up->port, ch))
+		if (uart_handle_sysrq_char(&up->port, ch) || !port)
 			continue;
 
 		if ((stat->sreg.isr0 & (up->port.ignore_status_mask & 0xff)) == 0 &&
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 27669ff..813ef8e 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -388,7 +388,7 @@ sunzilog_receive_chars(struct uart_sunzilog_port *up,
 			else if (r1 & CRC_ERR)
 				flag = TTY_FRAME;
 		}
-		if (uart_handle_sysrq_char(&up->port, ch))
+		if (uart_handle_sysrq_char(&up->port, ch) || !port)
 			continue;
 
 		if (up->port.ignore_status_mask == 0xff ||
-- 
1.8.1.5


