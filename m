Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaE3GQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:16:28 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36817 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbaE3GQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:16:25 -0400
X-AuditID: 85900ec0-d312bb9000001514-d4-538822346950
Subject: [PATCH V8 1/2] serial/uart: Introduce device specific attribute
 group to uart_port structure
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Alan <gnomes@lxorguk.ukuu.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Date: Fri, 30 May 2014 15:16:19 +0900
Message-ID: <20140530061619.21929.56183.stgit@yunodevel>
In-Reply-To: <20140530061617.21929.25777.stgit@yunodevel>
References: <20140530061617.21929.25777.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current serial device driver has the common sysfs I/F for all serial
devices, but it does not have device specific sysfs I/F. To make device
specific sysfs I/F, this patch introduces device specific attribute group to
uart_port structure.

Changes in V8:
 - Divide this patch from V7's patch based on Greg's comment

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 drivers/tty/serial/serial_core.c |   18 +++++++++++-------
 include/linux/serial_core.h      |    4 ++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b68550d..524cb49 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2552,15 +2552,16 @@ static struct attribute *tty_dev_attrs[] = {
 	NULL,
 	};
 
-static const struct attribute_group tty_dev_attr_group = {
+static struct attribute_group tty_dev_attr_group = {
 	.attrs = tty_dev_attrs,
 	};
 
-static const struct attribute_group *tty_dev_attr_groups[] = {
-	&tty_dev_attr_group,
-	NULL
-	};
-
+static void make_uport_attr_grps(struct uart_port *uport)
+{
+	uport->attr_grps[0] = &tty_dev_attr_group;
+	if (uport->dev_spec_attr_group)
+		uport->attr_grps[1] = uport->dev_spec_attr_group;
+}
 
 /**
  *	uart_add_one_port - attach a driver-defined port structure
@@ -2611,12 +2612,15 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 
 	uart_configure_port(drv, state, uport);
 
+	make_uport_attr_grps(uport);
+
 	/*
 	 * Register the port whether it's detected or not.  This allows
 	 * setserial to be used to alter this port's parameters.
 	 */
 	tty_dev = tty_port_register_device_attr(port, drv->tty_driver,
-			uport->line, uport->dev, port, tty_dev_attr_groups);
+			uport->line, uport->dev, port,
+			(const struct attribute_group **)uport->attr_grps);
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index f729be9..7e3122f 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -113,6 +113,8 @@ struct uart_icount {
 
 typedef unsigned int __bitwise__ upf_t;
 
+#define MAX_ATTR_GRPS		3
+
 struct uart_port {
 	spinlock_t		lock;			/* port lock */
 	unsigned long		iobase;			/* in/out[bwl] */
@@ -195,6 +197,8 @@ struct uart_port {
 	unsigned int		line;			/* port index */
 	resource_size_t		mapbase;		/* for ioremap */
 	struct device		*dev;			/* parent device */
+	struct attribute_group	*dev_spec_attr_group;	/* specific attribute */
+	struct attribute_group	*attr_grps[MAX_ATTR_GRPS];/* all attr. groups */
 	unsigned char		hub6;			/* this should be in the 8250 driver */
 	unsigned char		suspended;
 	unsigned char		irq_wake;

