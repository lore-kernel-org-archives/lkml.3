Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaDAV0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:26:34 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:46106 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaDAV0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:26:33 -0400
Message-ID: <533B2F03.6060008@gmail.com>
Date: Tue, 01 Apr 2014 23:26:27 +0200
From: Struan Bartlett <struan.bartlett@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@resnulli.us>, Joe Perches <joe@perches.com>,
        Dan Aloni <alonid@postram.com>
Subject: [PATCH v2] netconsole: Add tty driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds tty driver to netconsole module. When module is loaded,
creates /dev/netcon0 device and enables support for console=netcon0
kernel cmdline option, causing /dev/console output to be sent to
/dev/netcon0. This allows startup/shutdown script output from
headless platforms to be logged over (secure) network.

To: Matt Mackall <mpm@selenic.com>
Signed-off-by: Struan Bartlett <struan.bartlett@gmail.com>
---

Changes since v1:
  * Fixed whitespace mangled by broken mailer

--- a/drivers/net/netconsole.c	2014-03-31 04:40:15.000000000 +0100
+++ b/drivers/net/netconsole.c	2014-04-01 11:58:50.000000000 +0100
@@ -15,6 +15,7 @@
   *               generic card hooks
   *               works non-modular
   * 2003-09-07    rewritten with netpoll api
+ * 2014-03-31    tty driver by Struan Bartlett
   */

  /****************************************************************
@@ -47,6 +48,7 @@
  #include <linux/netpoll.h>
  #include <linux/inet.h>
  #include <linux/configfs.h>
+#include <linux/tty.h>

  MODULE_AUTHOR("Maintainer: Matt Mackall <mpm@selenic.com>");
  MODULE_DESCRIPTION("Console driver for network interfaces");
@@ -728,7 +730,7 @@ static struct notifier_block netconsole_
  	.notifier_call  = netconsole_netdev_event,
  };

-static void write_msg(struct console *con, const char *msg, unsigned 
int len)
+static void _write_msg(const char *msg, unsigned int len)
  {
  	int frag, left;
  	unsigned long flags;
@@ -764,10 +766,63 @@ static void write_msg(struct console *co
  	spin_unlock_irqrestore(&target_list_lock, flags);
  }

+static void write_msg(struct console *con, const char *msg, unsigned 
int len)
+{
+	_write_msg(msg, len);
+}
+
+static int netconsole_tty_open(struct tty_struct *tty, struct file *filp)
+{
+	return 0;
+}
+
+static void netconsole_tty_close(struct tty_struct *tty, struct file *filp)
+{
+}
+
+static int netconsole_tty_write(struct tty_struct *tty,
+				const unsigned char *buf, int count)
+{
+	_write_msg(buf, count);
+	return count;
+}
+
+static int netconsole_tty_put_char(struct tty_struct *tty, unsigned 
char ch)
+{
+	char temp[2] = { ch, 0 };
+	_write_msg(temp, 1);
+	return 1;
+}
+
+static int netconsole_tty_write_room(struct tty_struct *tty)
+{
+	return MAX_PRINT_CHUNK;
+}
+
+static const struct tty_operations netconsole_tty_ops = {
+	.open		= netconsole_tty_open,
+	.close		= netconsole_tty_close,
+	.write		= netconsole_tty_write,
+	.put_char	= netconsole_tty_put_char,
+	.write_room	= netconsole_tty_write_room,
+};
+
+static struct tty_port netconsole_tty_port;
+static struct tty_driver *netconsole_tty_driver;
+
+static struct tty_driver *netconsole_device(struct console *co, int *index)
+{
+	if (!(co->flags & CON_ENABLED))
+		return NULL;
+	*index = co->index;
+	return netconsole_tty_driver;
+}
+
  static struct console netconsole = {
  	.name	= "netcon",
  	.flags	= CON_ENABLED,
  	.write	= write_msg,
+	.device = netconsole_device
  };

  static int __init init_netconsole(void)
@@ -802,11 +857,39 @@ static int __init init_netconsole(void)
  	if (err)
  		goto undonotifier;

+	netconsole_tty_driver = alloc_tty_driver(1);
+	if (!netconsole_tty_driver) {
+		err = -ENOMEM;
+		goto undonotifier;
+	}
+
+	tty_port_init(&netconsole_tty_port);
+
+	netconsole_tty_driver->driver_name = "netcon";
+	netconsole_tty_driver->name = "netcon";
+	netconsole_tty_driver->type = TTY_DRIVER_TYPE_SYSTEM;
+	netconsole_tty_driver->subtype = SYSTEM_TYPE_TTY;
+	netconsole_tty_driver->init_termios = tty_std_termios;
+	netconsole_tty_driver->init_termios.c_iflag = 0;
+	netconsole_tty_driver->init_termios.c_oflag = 0;
+	netconsole_tty_driver->flags = TTY_DRIVER_REAL_RAW;
+
+	tty_set_operations(netconsole_tty_driver, &netconsole_tty_ops);
+	tty_port_link_device(&netconsole_tty_port, netconsole_tty_driver, 0);
+
+	err = tty_register_driver(netconsole_tty_driver);
+	if (err)
+		goto undotty;
+
  	register_console(&netconsole);
  	pr_info("network logging started\n");

  	return err;

+undotty:
+	put_tty_driver(netconsole_tty_driver);
+	tty_port_destroy(&netconsole_tty_port);
+
  undonotifier:
  	unregister_netdevice_notifier(&netconsole_netdev_notifier);

@@ -830,6 +913,10 @@ static void __exit cleanup_netconsole(vo
  {
  	struct netconsole_target *nt, *tmp;

+	tty_unregister_driver(netconsole_tty_driver);
+	put_tty_driver(netconsole_tty_driver);
+	tty_port_destroy(&netconsole_tty_port);
+
  	unregister_console(&netconsole);
  	dynamic_netconsole_exit();
  	unregister_netdevice_notifier(&netconsole_netdev_notifier);
