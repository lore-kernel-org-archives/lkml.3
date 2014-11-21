Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbaKUJFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:05:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaKUJFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:05:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] parport: parport_pc, do not remove parent devices early
Date: Fri, 21 Nov 2014 10:05:09 +0100
Message-Id: <1416560709-7721-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the parport_pc module is removed from the system, all parport
devices are iterated in parport_pc_exit and removed by a call to
parport_pc_unregister_port. Note that some parport devices have its
'struct device' parent, known as port->dev.  And when port->dev is a
platform device, it is destroyed in parport_pc_exit too.

Now, when parport_pc_unregister_port is called for a going port,
drv->detach(port) is called for every parport driver in the system.
ppdev can be one of them. ppdev's detach() tears down its per-port
sysfs directory, which established port->dev as a parent earlier.

But since parport_pc_exit kills port->dev parents before unregisters
ports proper, ppdev's sysfs directory has no living parent anymore.
This results in the following warning:

WARNING: CPU: 1 PID: 785 at fs/sysfs/group.c:219 sysfs_remove_group+0x9b/0xa0
sysfs group ffffffff81c69e20 not found for kobject 'parport1'
Modules linked in: parport_pc(E-) ppdev(E) [last unloaded: ppdev]
CPU: 1 PID: 785 Comm: rmmod Tainted: G        W   E  3.18.0-rc5-next-20141120+ #824
...
Call Trace:
...
 [<ffffffff810aff76>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff8123d81b>] sysfs_remove_group+0x9b/0xa0
 [<ffffffff814c27e7>] dpm_sysfs_remove+0x57/0x60
 [<ffffffff814b6ac9>] device_del+0x49/0x240
 [<ffffffff814b6ce2>] device_unregister+0x22/0x70
 [<ffffffff814b6dac>] device_destroy+0x3c/0x50
 [<ffffffffc012209a>] pp_detach+0x4a/0x60 [ppdev]
 [<ffffffff814b32dd>] parport_remove_port+0x11d/0x150
 [<ffffffffc0137328>] parport_pc_unregister_port+0x28/0xf0 [parport_pc]
 [<ffffffffc0138c0e>] parport_pc_exit+0x76/0x468 [parport_pc]
 [<ffffffff81128dbc>] SyS_delete_module+0x18c/0x230

It is also easily reproducible on qemu with two dummy ports '-parallel
/dev/null -parallel /dev/null'.

So switch the order of killing the two structures. But since port is
freed by parport_pc_unregister_port, we have to remember port->dev
in a local variable.

Perhaps nothing worse than the warning happens thanks to the device
refcounting. We *should* be on the safe side.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Martin Pluskal <mpluskal@suse.com>
---
 drivers/parport/parport_pc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 7ae20b7a56bc..53d15b30636a 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -3339,13 +3339,14 @@ static void __exit parport_pc_exit(void)
 	while (!list_empty(&ports_list)) {
 		struct parport_pc_private *priv;
 		struct parport *port;
+		struct device *dev;
 		priv = list_entry(ports_list.next,
 				  struct parport_pc_private, list);
 		port = priv->port;
-		if (port->dev && port->dev->bus == &platform_bus_type)
-			platform_device_unregister(
-				to_platform_device(port->dev));
+		dev = port->dev;
 		parport_pc_unregister_port(port);
+		if (dev && dev->bus == &platform_bus_type)
+			platform_device_unregister(to_platform_device(dev));
 	}
 }
 
-- 
2.1.3

