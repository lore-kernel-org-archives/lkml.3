Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbbAMOhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:37:24 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:63748 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbAMOhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:37:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] serial: digicolor: fix sysrq handling
Date: Tue, 13 Jan 2015 15:37:11 +0100
Message-ID: <1730002.vWGOEymGdz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:2NjfEuyqt9z2j3Ryoa2y6kGmEDwkhrho3JgkhE/of5rVUdprOOz
 d4d4ADhnOFW+nAmfpNJgtTbN3ByUwF9tYt4pd1hZ9qjumEy05DlLdcPhoKev6HH1mprVWmH
 m1YBnn/nRgQuZ1wBHXXdi1aChMrInOyzPIINoV4ZpXXM88yZuNRmdhSFr+aPQBwJT7E38tp
 NSceRZtf8sJ71T8nGvHQQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to build the digicolor-usart driver when sysrq is disabled
results in a compile error:

drivers/tty/serial/digicolor-usart.c: In function 'digicolor_uart_console_write':
drivers/tty/serial/digicolor-usart.c:407:33: error: 'struct uart_port' has no member named 'sysrq'

Like a lot of other drivers, this one requires an #ifdef to avoid
accessing the sysrq field here. While looking into this, I noticed
that the case where sysrq support is enabled is also broken, because
the driver fails to set the SUPPORT_SYSRQ macro.

This patch hopefully fixes both, but I do not hardware to test if sysrq
is actually working now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index 09ce0b3764e2..1e4bdd895804 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -23,6 +23,10 @@
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
 
+#if defined(CONFIG_SERIAL_CONEXANT_DIGICOLOR_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
+
 #define UA_ENABLE			0x00
 #define UA_ENABLE_ENABLE		BIT(0)
 
@@ -403,10 +407,11 @@ static void digicolor_uart_console_write(struct console *co, const char *c,
 	u8 status;
 	unsigned long flags;
 	int locked = 1;
-
+#ifdef SUPPORT_SYSRQ
 	if (port->sysrq || oops_in_progress)
 		locked = spin_trylock_irqsave(&port->lock, flags);
 	else
+#endif
 		spin_lock_irqsave(&port->lock, flags);
 
 	uart_console_write(port, c, n, digicolor_uart_console_putchar);

