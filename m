Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaIPCeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:34:01 -0400
Received: from mail-bl2on0133.outbound.protection.outlook.com ([65.55.169.133]:40416
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753985AbaIPCdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:33:42 -0400
X-WSS-ID: 0NBZ33Z-07-F1W-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-apci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <astone@redhat.com>,
        <hanjun.guo@linaro.org>, <rjw@rjwysocki.net>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <Sudeep.Holla@arm.com>, <olof@lixom.net>,
        <grant.likely@linaro.org>, <graeme.gregory@linaro.org>,
        <arnd@arndb.de>, <jason@lakedaemon.net>
Subject: [PATCH 4/4] [RFC PATCH for Juno 2/2] tty: SBSA compatible UART
Date: Mon, 15 Sep 2014 19:47:26 -0500
Message-ID: <1410828446-28502-5-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(229853001)(97736003)(68736004)(21056001)(87286001)(19580405001)(87936001)(4396001)(95666004)(2201001)(92566001)(104166001)(76176999)(86152002)(53416004)(47776003)(77156001)(89996001)(105586002)(102836001)(84676001)(101416001)(99396002)(106466001)(50986999)(77096002)(31966008)(48376002)(85852003)(83072002)(20776003)(33646002)(44976005)(50226001)(92726001)(86362001)(62966002)(36756003)(88136002)(19580395003)(90102001)(83322001)(93916002)(85306004)(107046002)(76482001)(80022003)(46102003)(77982003)(74662003)(81342003)(79102003)(74502003)(81542003)(2101003)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR02MB495;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grame Gregory <graeme.gregory@linaro.org>

This is a subset of pl011 UART which does not supprt DMA or baud rate
changing.

It is specified in the Server Base System Architecture document from
ARM.

Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
---
 drivers/tty/Kconfig    |   6 +
 drivers/tty/Makefile   |   1 +
 drivers/tty/sbsauart.c | 328 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 335 insertions(+)
 create mode 100644 drivers/tty/sbsauart.c

diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index b24aa01..50fe279 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -419,4 +419,10 @@ config DA_CONSOLE
 	help
 	  This enables a console on a Dash channel.
 
+config SBSAUART_TTY
+	tristate "SBSA UART TTY Driver"
+	help
+	  Console and system TTY driver for the SBSA UART which is defined
+	  in the Server Base System Architecure document for ARM64 servers.
+
 endif # TTY
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 58ad1c0..c3211c0 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -29,5 +29,6 @@ obj-$(CONFIG_SYNCLINK)		+= synclink.o
 obj-$(CONFIG_PPC_EPAPR_HV_BYTECHAN) += ehv_bytechan.o
 obj-$(CONFIG_GOLDFISH_TTY)	+= goldfish.o
 obj-$(CONFIG_DA_TTY)		+= metag_da.o
+obj-$(CONFIG_SBSAUART_TTY)	+= sbsauart.o
 
 obj-y += ipwireless/
diff --git a/drivers/tty/sbsauart.c b/drivers/tty/sbsauart.c
new file mode 100644
index 0000000..c9bf923
--- /dev/null
+++ b/drivers/tty/sbsauart.c
@@ -0,0 +1,328 @@
+/*
+ * SBSA (Server Base System Architecture) Compatible UART driver
+ *
+ * Copyright (C) 2014 Linaro Ltd
+ *
+ * Author: Graeme Gregory <graeme.gregory@linaro.org>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/acpi.h>
+#include <linux/amba/serial.h>
+#include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+
+struct sbsa_tty {
+	struct tty_port port;
+	spinlock_t lock;
+	void __iomem *base;
+	u32 irq;
+	int opencount;
+	struct console console;
+};
+
+static struct tty_driver *sbsa_tty_driver;
+static struct sbsa_tty *sbsa_tty;
+
+#define SBSAUART_CHAR_MASK	0xFF
+
+static void sbsa_tty_do_write(const char *buf, unsigned count)
+{
+	unsigned long irq_flags;
+	struct sbsa_tty *qtty = sbsa_tty;
+	void __iomem *base = qtty->base;
+	unsigned n;
+
+	spin_lock_irqsave(&qtty->lock, irq_flags);
+	for (n = 0; n < count; n++) {
+		while (readw(base + UART01x_FR) & UART01x_FR_TXFF)
+			mdelay(10);
+		writew(buf[n], base + UART01x_DR);
+	}
+	spin_unlock_irqrestore(&qtty->lock, irq_flags);
+}
+
+static void sbsauart_fifo_to_tty(struct sbsa_tty *qtty)
+{
+	void __iomem *base = qtty->base;
+	unsigned int flag, max_count = 32;
+	u16 status, ch;
+
+	while (max_count--) {
+		status = readw(base + UART01x_FR);
+		if (status & UART01x_FR_RXFE)
+			break;
+
+		/* Take chars from the FIFO and update status */
+		ch = readw(base + UART01x_DR);
+		flag = TTY_NORMAL;
+
+		if (ch & UART011_DR_BE)
+			flag = TTY_BREAK;
+		else if (ch & UART011_DR_PE)
+			flag = TTY_PARITY;
+		else if (ch & UART011_DR_FE)
+			flag = TTY_FRAME;
+		else if (ch & UART011_DR_OE)
+			flag = TTY_OVERRUN;
+
+		ch &= SBSAUART_CHAR_MASK;
+
+		tty_insert_flip_char(&qtty->port, ch, flag);
+	}
+
+	tty_schedule_flip(&qtty->port);
+
+	/* Clear the RX IRQ */
+	writew(UART011_RXIC | UART011_RXIC, base + UART011_ICR);
+}
+
+static irqreturn_t sbsa_tty_interrupt(int irq, void *dev_id)
+{
+	struct sbsa_tty *qtty = sbsa_tty;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&qtty->lock, irq_flags);
+	sbsauart_fifo_to_tty(qtty);
+	spin_unlock_irqrestore(&qtty->lock, irq_flags);
+
+	return IRQ_HANDLED;
+}
+
+static int sbsa_tty_open(struct tty_struct *tty, struct file *filp)
+{
+	struct sbsa_tty *qtty = sbsa_tty;
+
+	return tty_port_open(&qtty->port, tty, filp);
+}
+
+static void sbsa_tty_close(struct tty_struct *tty, struct file *filp)
+{
+	tty_port_close(tty->port, tty, filp);
+}
+
+static void sbsa_tty_hangup(struct tty_struct *tty)
+{
+	tty_port_hangup(tty->port);
+}
+
+static int sbsa_tty_write(struct tty_struct *tty, const unsigned char *buf,
+								int count)
+{
+	sbsa_tty_do_write(buf, count);
+	return count;
+}
+
+static int sbsa_tty_write_room(struct tty_struct *tty)
+{
+	return 32;
+}
+
+static void sbsa_tty_console_write(struct console *co, const char *b,
+								unsigned count)
+{
+	sbsa_tty_do_write(b, count);
+
+	if(b[count - 1] == '\n');
+		sbsa_tty_do_write("\r", 1);
+}
+
+static struct tty_driver *sbsa_tty_console_device(struct console *c,
+								int *index)
+{
+	*index = c->index;
+	return sbsa_tty_driver;
+}
+
+static int sbsa_tty_console_setup(struct console *co, char *options)
+{
+	if ((unsigned)co->index > 0)
+		return -ENODEV;
+	if (sbsa_tty->base == NULL)
+		return -ENODEV;
+	return 0;
+}
+
+static struct tty_port_operations sbsa_port_ops = {
+};
+
+static const struct tty_operations sbsa_tty_ops = {
+	.open = sbsa_tty_open,
+	.close = sbsa_tty_close,
+	.hangup = sbsa_tty_hangup,
+	.write = sbsa_tty_write,
+	.write_room = sbsa_tty_write_room,
+};
+
+static int sbsa_tty_create_driver(void)
+{
+	int ret;
+	struct tty_driver *tty;
+
+	sbsa_tty = kzalloc(sizeof(*sbsa_tty), GFP_KERNEL);
+	if (sbsa_tty == NULL) {
+		ret = -ENOMEM;
+		goto err_alloc_sbsa_tty_failed;
+	}
+	tty = alloc_tty_driver(1);
+	if (tty == NULL) {
+		ret = -ENOMEM;
+		goto err_alloc_tty_driver_failed;
+	}
+	tty->driver_name = "sbsauart";
+	tty->name = "ttySBSA";
+	tty->type = TTY_DRIVER_TYPE_SERIAL;
+	tty->subtype = SERIAL_TYPE_NORMAL;
+	tty->init_termios = tty_std_termios;
+	tty->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
+						TTY_DRIVER_DYNAMIC_DEV;
+	tty_set_operations(tty, &sbsa_tty_ops);
+	ret = tty_register_driver(tty);
+	if (ret)
+		goto err_tty_register_driver_failed;
+
+	sbsa_tty_driver = tty;
+	return 0;
+
+err_tty_register_driver_failed:
+	put_tty_driver(tty);
+err_alloc_tty_driver_failed:
+	kfree(sbsa_tty);
+	sbsa_tty = NULL;
+err_alloc_sbsa_tty_failed:
+	return ret;
+}
+
+static void sbsa_tty_delete_driver(void)
+{
+	tty_unregister_driver(sbsa_tty_driver);
+	put_tty_driver(sbsa_tty_driver);
+	sbsa_tty_driver = NULL;
+	kfree(sbsa_tty);
+	sbsa_tty = NULL;
+}
+
+static int sbsa_tty_probe(struct platform_device *pdev)
+{
+	struct sbsa_tty *qtty;
+	int ret = -EINVAL;
+	int i;
+	struct resource *r;
+	struct device *ttydev;
+	void __iomem *base;
+	u32 irq;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL)
+		return -EINVAL;
+
+	base = ioremap(r->start, r->end - r->start);
+	if (base == NULL)
+		pr_err("sbsa_tty: unable to remap base\n");
+
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (r == NULL)
+		goto err_unmap;
+
+	irq = r->start;
+
+	if (pdev->id > 0)
+		goto err_unmap;
+
+	ret = sbsa_tty_create_driver();
+	if (ret)
+		goto err_unmap;
+
+	qtty = sbsa_tty;
+	spin_lock_init(&qtty->lock);
+	tty_port_init(&qtty->port);
+	qtty->port.ops = &sbsa_port_ops;
+	qtty->base = base;
+	qtty->irq = irq;
+
+	/* Clear and Mask all IRQs */
+	writew(0, base + UART011_IMSC);
+	writew(0xFFFF, base + UART011_ICR);
+
+	ret = request_irq(irq, sbsa_tty_interrupt, IRQF_SHARED,
+						"sbsa_tty", pdev);
+	if (ret)
+		goto err_request_irq_failed;
+
+	/* Unmask the RX IRQ */
+	writew(UART011_RXIM | UART011_RTIM, base + UART011_IMSC);
+
+	ttydev = tty_port_register_device(&qtty->port, sbsa_tty_driver,
+							0, &pdev->dev);
+	if (IS_ERR(ttydev)) {
+		ret = PTR_ERR(ttydev);
+		goto err_tty_register_device_failed;
+	}
+
+	strcpy(qtty->console.name, "ttySBSA");
+	qtty->console.write = sbsa_tty_console_write;
+	qtty->console.device = sbsa_tty_console_device;
+	qtty->console.setup = sbsa_tty_console_setup;
+	qtty->console.flags = CON_PRINTBUFFER;
+	qtty->console.index = pdev->id;
+	register_console(&qtty->console);
+
+	return 0;
+
+	tty_unregister_device(sbsa_tty_driver, i);
+err_tty_register_device_failed:
+	free_irq(irq, pdev);
+err_request_irq_failed:
+	sbsa_tty_delete_driver();
+err_unmap:
+	iounmap(base);
+	return ret;
+}
+
+static int sbsa_tty_remove(struct platform_device *pdev)
+{
+	struct sbsa_tty *qtty;
+
+	qtty = sbsa_tty;
+	unregister_console(&qtty->console);
+	tty_unregister_device(sbsa_tty_driver, pdev->id);
+	iounmap(qtty->base);
+	qtty->base = 0;
+	free_irq(qtty->irq, pdev);
+	sbsa_tty_delete_driver();
+	return 0;
+}
+
+static const struct acpi_device_id sbsa_acpi_match[] = {
+	{ "ARMH0011", 0 },
+	{ }
+};
+
+static struct platform_driver sbsa_tty_platform_driver = {
+	.probe = sbsa_tty_probe,
+	.remove = sbsa_tty_remove,
+	.driver = {
+		.name = "sbsa_tty",
+		.acpi_match_table = ACPI_PTR(sbsa_acpi_match),
+	}
+};
+
+module_platform_driver(sbsa_tty_platform_driver);
+
+MODULE_LICENSE("GPL v2");
-- 
1.9.3

