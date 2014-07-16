Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbaGPBUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:20:06 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44255 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbaGPBTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:19:40 -0400
X-AuditID: 85900ec0-d1d29b9000001514-76-53c5d32872d3
Subject: [PATCH V9 1/2] Serial: allow port drivers to have a default
 attribute group
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: Alan <gnomes@lxorguk.ukuu.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Hans-Christian Koch <hc.koch@scheerkoch.de>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Date: Wed, 16 Jul 2014 01:19:34 +0000
Message-ID: <20140716011934.31474.60154.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140716011931.31474.68825.stgit@yuno-kbuild.novalocal>
References: <20140716011931.31474.68825.stgit@yuno-kbuild.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Some serial drivers (like 8250), want to add sysfs files.  We need to do
so in a race-free way, so allow any port to be able to specify an
attribute group that should be added at device creation time.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 drivers/tty/serial/serial_core.c |   24 +++++++++++++++++-------
 include/linux/serial_core.h      |    2 ++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index fbf6c5a..4af764c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2563,12 +2563,6 @@ static const struct attribute_group tty_dev_attr_group = {
 	.attrs = tty_dev_attrs,
 	};
 
-static const struct attribute_group *tty_dev_attr_groups[] = {
-	&tty_dev_attr_group,
-	NULL
-	};
-
-
 /**
  *	uart_add_one_port - attach a driver-defined port structure
  *	@drv: pointer to the uart low level driver structure for this port
@@ -2585,6 +2579,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	struct tty_port *port;
 	int ret = 0;
 	struct device *tty_dev;
+	int num_groups;
 
 	BUG_ON(in_interrupt());
 
@@ -2618,12 +2613,26 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 
 	uart_configure_port(drv, state, uport);
 
+	num_groups = 2;
+	if (uport->attr_group)
+		num_groups++;
+
+	uport->tty_groups = kcalloc(num_groups, sizeof(**uport->tty_groups),
+				    GFP_KERNEL);
+	if (!uport->tty_groups) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	uport->tty_groups[0] = &tty_dev_attr_group;
+	if (uport->attr_group)
+		uport->tty_groups[1] = uport->attr_group;
+
 	/*
 	 * Register the port whether it's detected or not.  This allows
 	 * setserial to be used to alter this port's parameters.
 	 */
 	tty_dev = tty_port_register_device_attr(port, drv->tty_driver,
-			uport->line, uport->dev, port, tty_dev_attr_groups);
+			uport->line, uport->dev, port, uport->tty_groups);
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
@@ -2702,6 +2711,7 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 */
 	if (uport->type != PORT_UNKNOWN)
 		uport->ops->release_port(uport);
+	kfree(uport->tty_groups);
 
 	/*
 	 * Indicate that there isn't a port here anymore.
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 5bbb809..cf3a1e7 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -199,6 +199,8 @@ struct uart_port {
 	unsigned char		suspended;
 	unsigned char		irq_wake;
 	unsigned char		unused[2];
+	struct attribute_group	*attr_group;		/* port specific attributes */
+	const struct attribute_group **tty_groups;	/* all attributes (serial core use only) */
 	void			*private_data;		/* generic platform data pointer */
 };
 

