Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbaLWV1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:27:45 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:47629 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLWV1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:27:44 -0500
Date: Tue, 23 Dec 2014 22:27:38 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dwalker@fifo99.com, Matt Mackall <mpm@selenic.com>,
        Satyam Sharma <satyam.sharma@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 2/3] netconsole: make loglevel configurable per target
Message-ID: <20141223222738.14e3fcd0@neptune.home>
In-Reply-To: <20141220224908.GB4466@fifo99.com>
References: <20141220224908.GB4466@fifo99.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to registering a new console for each target so that loglevel
based message filtering can be set individually for each target.

This adds a new loglevel= option to netconsole module parameter and also
add a configfs file to configure the loglevel.

The loglevel conf be adjusted at any time for synamic netconsole
consoles.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
Note: only configuration via configfs has been runtime-tested.

 Documentation/networking/netconsole.txt |  11 ++-
 drivers/net/netconsole.c                | 114 +++++++++++++++++++++++---------
 2 files changed, 94 insertions(+), 31 deletions(-)

diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
index a5d574a..c1df516 100644
--- a/Documentation/networking/netconsole.txt
+++ b/Documentation/networking/netconsole.txt
@@ -24,7 +24,7 @@ Sender and receiver configuration:
 It takes a string configuration parameter "netconsole" in the
 following format:
 
- netconsole=[src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
+ netconsole=[src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr][,loglevel=level]
 
    where
         src-port      source for UDP packets (defaults to 6665)
@@ -33,6 +33,9 @@ following format:
         tgt-port      port for logging agent (6666)
         tgt-ip        IP address for logging agent
         tgt-macaddr   ethernet MAC address for logging agent (broadcast)
+        level         limit messages printed to those whose loglevel is
+                      smaller that value, range is 1 to 8
+                      If missing, loglevel limit as set via syslog(1) applies
 
 Examples:
 
@@ -114,11 +117,16 @@ The interface exposes these parameters of a netconsole target to userspace:
 	remote_ip	Remote agent's IP address		(read-write)
 	local_mac	Local interface's MAC address		(read-only)
 	remote_mac	Remote agent's MAC address		(read-write)
+	loglevel        Console loglevel filter                 (read-write)
 
 The "enabled" attribute is also used to control whether the parameters of
 a target can be updated or not -- you can modify the parameters of only
 disabled targets (i.e. if "enabled" is 0).
 
+The "loglevel" parameter can be set at any time. When set to "0" it will
+read back as empty string and global loglevel filter applies. Otherwise
+specified loglevel filter applies.
+
 To update a target's parameters:
 
  cat enabled				# check if enabled is 1
@@ -164,6 +172,7 @@ priority messages to the console. You can change this at runtime using:
 
  dmesg -n 8
 
+or by specifying netconsole loglevel parameter
 or by specifying "debug" on the kernel command line at boot, to send
 all kernel messages to the console. A specific value for this parameter
 can also be set using the "loglevel" kernel boot option. See the
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index ba2f5e7..a96cd8e 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -103,10 +103,12 @@ struct netconsole_target {
 #ifdef	CONFIG_NETCONSOLE_DYNAMIC
 	struct config_item	item;
 #endif
+	struct console		console;
 	int			enabled;
 	struct mutex		mutex;
 	struct netpoll		np;
 };
+static void write_msg(struct console *con, const char *msg, unsigned int len);
 
 #ifdef	CONFIG_NETCONSOLE_DYNAMIC
 
@@ -171,6 +173,7 @@ static struct netconsole_target *alloc_param_target(char *target_config)
 {
 	int err = -ENOMEM;
 	struct netconsole_target *nt;
+	char *loglevel;
 
 	/*
 	 * Allocate and initialize with defaults.
@@ -186,8 +189,26 @@ static struct netconsole_target *alloc_param_target(char *target_config)
 	nt->np.remote_port = 6666;
 	mutex_init(&nt->mutex);
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
+	snprintf(nt->console.name, sizeof(nt->console.name), "netcon");
+	/* Dump existing printks when we register */
+	nt->console.flags = CON_ENABLED | CON_PRINTBUFFER;
+	nt->console.write = write_msg;
 
 	/* Parse parameters and setup netpoll */
+	loglevel = strstr(target_config, ",loglevel=");
+	if (loglevel) {
+		int level;
+		err = kstrtoint(loglevel+10, 10, &level);
+		if (err < 0)
+			goto fail;
+		if (level < 1 || level > 8) {
+			err = -EINVAL;
+			goto fail;
+		}
+		nt->console.loglevel = level;
+		nt->console.flags |= CON_LOGLEVEL;
+		*loglevel = '\0';
+	}
 	err = netpoll_parse_options(&nt->np, target_config);
 	if (err)
 		goto fail;
@@ -228,6 +249,7 @@ static void free_param_target(struct netconsole_target *nt)
  *				|	remote_ip
  *				|	local_mac
  *				|	remote_mac
+ *				|	loglevel
  *				|
  *				<target>/...
  */
@@ -301,6 +323,14 @@ static ssize_t show_remote_mac(struct netconsole_target *nt, char *buf)
 	return snprintf(buf, PAGE_SIZE, "%pM\n", nt->np.remote_mac);
 }
 
+static ssize_t show_loglevel(struct netconsole_target *nt, char *buf)
+{
+	if (nt->console.flags & CON_LOGLEVEL)
+		return snprintf(buf, PAGE_SIZE, "%u\n", nt->console.loglevel);
+	else
+		return snprintf(buf, PAGE_SIZE, "\n");
+}
+
 /*
  * This one is special -- targets created through the configfs interface
  * are not enabled (and the corresponding netpoll activated) by default.
@@ -338,6 +368,8 @@ static ssize_t store_enabled(struct netconsole_target *nt,
 		if (err)
 			return err;
 
+		nt->enabled = 1;
+		register_console(&nt->console);
 		pr_info("netconsole: network logging started\n");
 	} else {	/* 0 */
 		/* We need to disable the netconsole before cleaning it up
@@ -347,11 +379,11 @@ static ssize_t store_enabled(struct netconsole_target *nt,
 		spin_lock_irqsave(&target_list_lock, flags);
 		nt->enabled = 0;
 		spin_unlock_irqrestore(&target_list_lock, flags);
+		unregister_console(&nt->console);
 		netpoll_cleanup(&nt->np);
+		nt->console.flags = nt->console.flags & ~CON_PRINTBUFFER;
 	}
 
-	nt->enabled = enabled;
-
 	return strnlen(buf, count);
 }
 
@@ -494,6 +526,27 @@ static ssize_t store_remote_mac(struct netconsole_target *nt,
 	return strnlen(buf, count);
 }
 
+static ssize_t store_loglevel(struct netconsole_target *nt,
+				 const char *buf,
+				 size_t count)
+{
+	int rv, level;
+
+	rv = kstrtoint(buf, 10, &level);
+	if (rv < 0)
+		return rv;
+	if (level < 0 || level > 8)
+		return -EINVAL;
+
+	if (level > 0) {
+		nt->console.loglevel = level;
+		nt->console.flags |= CON_LOGLEVEL;
+	} else
+		nt->console.flags &= ~CON_LOGLEVEL;
+
+	return strnlen(buf, count);
+}
+
 /*
  * Attribute definitions for netconsole_target.
  */
@@ -514,6 +567,7 @@ NETCONSOLE_TARGET_ATTR_RW(local_ip);
 NETCONSOLE_TARGET_ATTR_RW(remote_ip);
 NETCONSOLE_TARGET_ATTR_RO(local_mac);
 NETCONSOLE_TARGET_ATTR_RW(remote_mac);
+NETCONSOLE_TARGET_ATTR_RW(loglevel);
 
 static struct configfs_attribute *netconsole_target_attrs[] = {
 	&netconsole_target_enabled.attr,
@@ -524,6 +578,7 @@ static struct configfs_attribute *netconsole_target_attrs[] = {
 	&netconsole_target_remote_ip.attr,
 	&netconsole_target_local_mac.attr,
 	&netconsole_target_remote_mac.attr,
+	&netconsole_target_loglevel.attr,
 	NULL,
 };
 
@@ -605,6 +660,10 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 	nt->np.remote_port = 6666;
 	mutex_init(&nt->mutex);
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
+	snprintf(nt->console.name, sizeof(nt->console.name), "netcon-%s", name);
+	nt->console.flags = CON_ENABLED;
+	nt->console.write = write_msg;
+	nt->console.loglevel = 0;
 
 	/* Initialize the config_item member */
 	config_item_init_type_name(&nt->item, name, &netconsole_target_type);
@@ -626,6 +685,7 @@ static void drop_netconsole_target(struct config_group *group,
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_del(&nt->list);
 	spin_unlock_irqrestore(&target_list_lock, flags);
+	unregister_console(&nt->console);
 
 	/*
 	 * The target may have never been enabled, or was manually disabled
@@ -732,7 +792,7 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 {
 	int frag, left;
 	unsigned long flags;
-	struct netconsole_target *nt;
+	struct netconsole_target *nt = container_of(con, struct netconsole_target, console);
 	const char *tmp;
 
 	if (oops_only && !oops_in_progress)
@@ -742,34 +802,26 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 		return;
 
 	spin_lock_irqsave(&target_list_lock, flags);
-	list_for_each_entry(nt, &target_list, list) {
-		netconsole_target_get(nt);
-		if (nt->enabled && netif_running(nt->np.dev)) {
-			/*
-			 * We nest this inside the for-each-target loop above
-			 * so that we're able to get as much logging out to
-			 * at least one target if we die inside here, instead
-			 * of unnecessarily keeping all targets in lock-step.
-			 */
-			tmp = msg;
-			for (left = len; left;) {
-				frag = min(left, MAX_PRINT_CHUNK);
-				netpoll_send_udp(&nt->np, tmp, frag);
-				tmp += frag;
-				left -= frag;
-			}
+	netconsole_target_get(nt);
+	if (nt->enabled && netif_running(nt->np.dev)) {
+		/*
+		 * We nest this inside the for-each-target loop above
+		 * so that we're able to get as much logging out to
+		 * at least one target if we die inside here, instead
+		 * of unnecessarily keeping all targets in lock-step.
+		 */
+		tmp = msg;
+		for (left = len; left;) {
+			frag = min(left, MAX_PRINT_CHUNK);
+			netpoll_send_udp(&nt->np, tmp, frag);
+			tmp += frag;
+			left -= frag;
 		}
-		netconsole_target_put(nt);
 	}
+	netconsole_target_put(nt);
 	spin_unlock_irqrestore(&target_list_lock, flags);
 }
 
-static struct console netconsole = {
-	.name	= "netcon",
-	.flags	= CON_ENABLED,
-	.write	= write_msg,
-};
-
 static int __init init_netconsole(void)
 {
 	int err;
@@ -785,8 +837,6 @@ static int __init init_netconsole(void)
 				err = PTR_ERR(nt);
 				goto fail;
 			}
-			/* Dump existing printks when we register */
-			netconsole.flags |= CON_PRINTBUFFER;
 
 			spin_lock_irqsave(&target_list_lock, flags);
 			list_add(&nt->list, &target_list);
@@ -802,7 +852,9 @@ static int __init init_netconsole(void)
 	if (err)
 		goto undonotifier;
 
-	register_console(&netconsole);
+	list_for_each_entry_safe(nt, tmp, &target_list, list) {
+		register_console(&nt->console);
+	}
 	pr_info("network logging started\n");
 
 	return err;
@@ -830,7 +882,9 @@ static void __exit cleanup_netconsole(void)
 {
 	struct netconsole_target *nt, *tmp;
 
-	unregister_console(&netconsole);
+	list_for_each_entry_safe(nt, tmp, &target_list, list) {
+		unregister_console(&nt->console);
+	}
 	dynamic_netconsole_exit();
 	unregister_netdevice_notifier(&netconsole_netdev_notifier);
 
-- 
2.0.4

