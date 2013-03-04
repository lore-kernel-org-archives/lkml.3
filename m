Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3CDDmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60771 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab3CDDme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:34 -0500
Message-Id: <20130304033721.248498992@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [ 139/153] 8250: use correct value for PORT_BRCM_TRUMANAGE
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

When backporting commit ebebd49a8eab ('8250/16?50: Add support for
Broadcom TruManage redirected serial port') I took the next
available port type number for PORT_BRCM_TRUMANAGE (22).

However, the 8250 port type numbers are exposed to userland through
the TIOC{G,S}SERIAL ioctls and so must remain stable.  Redefine
PORT_BRCM_TRUMANAGE as 25, matching mainline as of commit
85f024401bf807.

This leaves port types 22-24 within the valid range for 8250 but not
implemented there.  Change serial8250_verify_port() to specifically
reject these and change serial8250_type() to return "unknown" for them
(though I'm not sure why it would ever see them).

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -2695,7 +2695,7 @@ serial8250_verify_port(struct uart_port
 	if (ser->irq >= nr_irqs || ser->irq < 0 ||
 	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 	    ser->type >= ARRAY_SIZE(uart_config) || ser->type == PORT_CIRRUS ||
-	    ser->type == PORT_STARTECH)
+	    ser->type == PORT_STARTECH || uart_config[ser->type].name == NULL)
 		return -EINVAL;
 	return 0;
 }
@@ -2705,7 +2705,7 @@ serial8250_type(struct uart_port *port)
 {
 	int type = port->type;
 
-	if (type >= ARRAY_SIZE(uart_config))
+	if (type >= ARRAY_SIZE(uart_config) || uart_config[type].name == NULL)
 		type = 0;
 	return uart_config[type].name;
 }
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -47,8 +47,8 @@
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
 #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
-#define PORT_BRCM_TRUMANAGE	22
-#define PORT_MAX_8250	22	/* max port ID */
+#define PORT_BRCM_TRUMANAGE	25
+#define PORT_MAX_8250	25	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed


