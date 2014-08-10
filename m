Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaHJHdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:33:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51100 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHJHdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:33:46 -0400
Date: Sun, 10 Aug 2014 09:33:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: use inlines where it makes sense
Message-ID: <20140810073343.GC19735@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
 <20140530163604.GA11943@kroah.com>
 <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
 <20140806213055.GA26046@amd.pavel.ucw.cz>
 <20140807002532.GB23406@kroah.com>
 <20140807081328.GB24700@amd.pavel.ucw.cz>
 <20140807202407.GC6060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807202407.GC6060@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make some uart function static inline to reduce ammount of exported code.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/nokia_h4p/hci_h4p.h b/drivers/staging/nokia_h4p/hci_h4p.h
index b91e8b3..6c72ca5 100644
--- a/drivers/staging/nokia_h4p/hci_h4p.h
+++ b/drivers/staging/nokia_h4p/hci_h4p.h
@@ -26,6 +26,8 @@
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/hci.h>
 
+#include <linux/serial_reg.h>
+
 #define UART_SYSC_OMAP_RESET	0x03
 #define UART_SYSS_RESETDONE	0x01
 #define UART_OMAP_SCR_EMPTY_THR	0x08
@@ -205,9 +207,28 @@ int hci_h4p_read_fw(struct hci_h4p_info *info, struct sk_buff_head *fw_queue);
 int hci_h4p_send_fw(struct hci_h4p_info *info, struct sk_buff_head *fw_queue);
 void hci_h4p_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb);
 
-void hci_h4p_outb(struct hci_h4p_info *info, unsigned int offset, u8 val);
-u8 hci_h4p_inb(struct hci_h4p_info *info, unsigned int offset);
-void hci_h4p_set_rts(struct hci_h4p_info *info, int active);
+static inline void hci_h4p_outb(struct hci_h4p_info *info, unsigned int offset, u8 val)
+{
+	__raw_writeb(val, info->uart_base + (offset << 2));
+}
+
+static inline u8 hci_h4p_inb(struct hci_h4p_info *info, unsigned int offset)
+{
+	return __raw_readb(info->uart_base + (offset << 2));
+}
+
+static inline void hci_h4p_set_rts(struct hci_h4p_info *info, int active)
+{
+	u8 b;
+
+	b = hci_h4p_inb(info, UART_MCR);
+	if (active)
+		b |= UART_MCR_RTS;
+	else
+		b &= ~UART_MCR_RTS;
+	hci_h4p_outb(info, UART_MCR, b);
+}
+
 int hci_h4p_wait_for_cts(struct hci_h4p_info *info, int active, int timeout_ms);
 void __hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 which);
 void hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 which);
diff --git a/drivers/staging/nokia_h4p/nokia_uart.c b/drivers/staging/nokia_h4p/nokia_uart.c
index 0fb57de..9aab7bb 100644
--- a/drivers/staging/nokia_h4p/nokia_uart.c
+++ b/drivers/staging/nokia_h4p/nokia_uart.c
@@ -19,7 +19,6 @@
  *
  */
 
-#include <linux/serial_reg.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
 
@@ -27,27 +26,7 @@
 
 #include "hci_h4p.h"
 
-inline void hci_h4p_outb(struct hci_h4p_info *info, unsigned int offset, u8 val)
-{
-	__raw_writeb(val, info->uart_base + (offset << 2));
-}
-
-inline u8 hci_h4p_inb(struct hci_h4p_info *info, unsigned int offset)
-{
-	return __raw_readb(info->uart_base + (offset << 2));
-}
 
-void hci_h4p_set_rts(struct hci_h4p_info *info, int active)
-{
-	u8 b;
-
-	b = hci_h4p_inb(info, UART_MCR);
-	if (active)
-		b |= UART_MCR_RTS;
-	else
-		b &= ~UART_MCR_RTS;
-	hci_h4p_outb(info, UART_MCR, b);
-}
 
 int hci_h4p_wait_for_cts(struct hci_h4p_info *info, int active,
 			 int timeout_ms)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
