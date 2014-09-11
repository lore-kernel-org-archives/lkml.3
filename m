Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaIKNiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:38:09 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58927 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaIKNiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:38:07 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [RFC PATCH] serial: Emulate break using control characters
Date: Thu, 11 Sep 2014 14:37:43 +0100
Message-Id: <1410442663-10068-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the magic SysRq functions can accessed by sending a break on
the serial port. Unfortunately some networked serial proxies make it
difficult to send a break meaning SysRq functions cannot be used. This
patch provides a workaround by allowing the (fairly unlikely) sequence
of ^B^R^K characters to emulate a real break.

This approach is very nearly as robust as normal sysrq/break handling
because all trigger recognition happens during interrupt handling. Only
major difference is that to emulate a break we must enter the ISR four
times (instead of twice) and manage an extra byte of state.

No means is provided to escape the trigger sequence (and pass ^B^R^K to
the underlying process) however the sequence is proved reasonably pretty
collision resistant in practice. The most significant consequence is
that ^B and ^B^R are delayed until a new character is observed.

The most significant collision I am aware of is with emacs-like
backward-char bindings (^B) because the character movement will become
lumpy (two characters every two key presses rather than one character
per key press). Arrow keys or ^B^B^F provide workarounds.

Special note for tmux users:
  tmux defaults to using ^B as its escape character but does not have a
  default binding for ^B^R. Likewise tmux had no visual indicator
  showing the beginning of break sequence meaning delayed the delivery
  of ^B is not observable. Thus serial break emulation does not interfere
  with the use of tmux's default key bindings.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---

Notes:
    I've been sitting on this patch for a long time. However I realized
    today just how frequently I end up using this and wondered if perhaps I
    am not alone.
    
    Yes! How did you guess? As it happens I do have quite a few broken
    network to UART interfaces.
    

 include/linux/serial_core.h | 83 +++++++++++++++++++++++++++++++++++----------
 lib/Kconfig.debug           | 15 ++++++++
 2 files changed, 80 insertions(+), 18 deletions(-)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index cf3a1e7..dffb188 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -150,6 +150,9 @@ struct uart_port {
 	struct console		*cons;			/* struct console, if any */
 #if defined(CONFIG_SERIAL_CORE_CONSOLE) || defined(SUPPORT_SYSRQ)
 	unsigned long		sysrq;			/* sysrq timeout */
+#ifdef CONFIG_MAGIC_SYSRQ_BREAK_EMULATION
+	char                    sysrq_emul;             /* sysrq break emulation */
+#endif
 #endif

 	upf_t			flags;
@@ -364,24 +367,6 @@ extern void uart_handle_cts_change(struct uart_port *uport,
 extern void uart_insert_char(struct uart_port *port, unsigned int status,
 		 unsigned int overrun, unsigned int ch, unsigned int flag);

-#ifdef SUPPORT_SYSRQ
-static inline int
-uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
-{
-	if (port->sysrq) {
-		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch);
-			port->sysrq = 0;
-			return 1;
-		}
-		port->sysrq = 0;
-	}
-	return 0;
-}
-#else
-#define uart_handle_sysrq_char(port,ch) ({ (void)port; 0; })
-#endif
-
 /*
  * We do the SysRQ and SAK checking like this...
  */
@@ -406,6 +391,68 @@ static inline int uart_handle_break(struct uart_port *port)
 	return 0;
 }

+#if defined(SUPPORT_SYSRQ) && defined(CONFIG_MAGIC_SYSRQ_BREAK_EMULATION)
+/*
+ * Emulate a break if we are the serial console and receive ^B, ^R, ^K.
+ */
+static inline int
+uart_handle_sysrq_break_emulation(struct uart_port *port, unsigned int ch)
+{
+	const unsigned int ctrlb = 'B' & 31;
+	const unsigned int ctrlr = 'R' & 31;
+	const unsigned int ctrlk = 'K' & 31;
+
+	if (uart_console(port)) {
+		if ((port->sysrq_emul == 0 && ch == ctrlb) ||
+		    (port->sysrq_emul == ctrlb && ch == ctrlr)) {
+			/* for either of the first two trigger characters
+			 * update the state variable and move on.
+			 */
+			port->sysrq_emul = ch;
+			return 1;
+		} else if (port->sysrq_emul == ctrlr && ch == ctrlk &&
+			   uart_handle_break(port)) {
+			/* the break has already been emulated whilst
+			 * evaluating the condition, tidy up and move on
+			 */
+			port->sysrq_emul = 0;
+			return 1;
+		}
+	}
+
+	if (port->sysrq_emul) {
+		/* received a partial (false) trigger, tidy up and move on */
+		uart_insert_char(port, 0, 0, ctrlb, TTY_NORMAL);
+		if (port->sysrq_emul == ctrlr)
+			uart_insert_char(port, 0, 0, ctrlr, TTY_NORMAL);
+		port->sysrq_emul = 0;
+	}
+
+	return 0;
+}
+#else
+#define uart_handle_sysrq_break_emulation(port, ch) ({ (void)port; 0; })
+#endif
+
+#ifdef SUPPORT_SYSRQ
+static inline int
+uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
+{
+	if (port->sysrq) {
+		if (ch && time_before(jiffies, port->sysrq)) {
+			handle_sysrq(ch);
+			port->sysrq = 0;
+			return 1;
+		}
+		port->sysrq = 0;
+	}
+
+	return uart_handle_sysrq_break_emulation(port, ch);
+}
+#else
+#define uart_handle_sysrq_char(port,ch) ({ (void)port; 0; })
+#endif
+
 /*
  *	UART_ENABLE_MS - determine if port should enable modem status irqs
  */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a285900..bcd9cf5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -345,6 +345,21 @@ config MAGIC_SYSRQ_DEFAULT_ENABLE
 	  This may be set to 1 or 0 to enable or disable them all, or
 	  to a bitmask as described in Documentation/sysrq.txt.

+config MAGIC_SYSRQ_BREAK_EMULATION
+	bool "Enable magic SysRq serial break emulation"
+	depends on MAGIC_SYSRQ && SERIAL_CORE_CONSOLE
+	default n
+	help
+	  If you say Y here, then you can use the character sequence ^B^R^K
+	  to simulate a BREAK on the serial console. This is useful if for
+	  some reason you cannot send a BREAK to your console's serial port.
+	  For example, if you have a serial device server that cannot
+	  send a BREAK. Enabling this feature can delay the delivery of
+	  characters to the TTY because the ^B and a subsequent ^R will be
+	  delayed until we know what the next character is.
+
+	  If unsure, say N.
+
 config DEBUG_KERNEL
 	bool "Kernel debugging"
 	help
--
1.9.3

