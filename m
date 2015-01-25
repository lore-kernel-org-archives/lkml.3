Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbbAYSo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:44:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbbAYSKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.18 098/183] serial: fix parisc boot hang
Date: Sun, 25 Jan 2015 10:07:00 -0800
Message-Id: <20150125180814.421106886@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit 68ed7e1c3d236e9e1e60ed6cae22f2c1c4ba2952 upstream.

This is a partial revert of 2f2dafe (serial: serial_core.c: printk
replacement) which gets us booting again.  The real problem seems to be
the _emit path in early boot.  However, until we can root cause it, we
need at least to get boot working.

Fixes: 2f2dafe77df2c78e189a9fa6b1879dffd06ae5a1
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2102,7 +2102,9 @@ uart_report_port(struct uart_driver *drv
 		break;
 	}
 
-	dev_info(port->dev, "%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
+	printk(KERN_INFO "%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
+	       port->dev ? dev_name(port->dev) : "",
+	       port->dev ? ": " : "",
 	       drv->dev_name,
 	       drv->tty_driver->name_base + port->line,
 	       address, port->irq, port->uartclk / 16, uart_type(port));


