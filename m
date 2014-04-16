Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaDPGVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:21:53 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:55023 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDPGVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:21:52 -0400
Date: Wed, 16 Apr 2014 01:21:21 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Belisko Marek <marek.belisko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH] w1: avoid recursive device_add
Message-ID: <20140416062121.GF5096@spacedout.fries.net>
References: <CAAfyv37OPxJkcyYi0ZZe9MSQZ3TMeCuxa8rmWh8ahNF6Bs01Mg@mail.gmail.com>
 <20140323215041.GB5096@spacedout.fries.net>
 <698551395662480@web15j.yandex.ru>
 <CAAfyv352uNgS38ZKjb_r5Luvg=h1=f0G+ZJeZYAUSD1oxWdHxA@mail.gmail.com>
 <20140413222401.GE5096@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413222401.GE5096@spacedout.fries.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 16 Apr 2014 01:21:24 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__w1_attach_slave_device calls device_add which calls w1_bus_notify
which calls the w1_bq27000 slave driver, which calls
platform_device_add and device_add and deadlocks on getting
&(&priv->bus_notifier)->rwsem as it is still held in the previous
device_add.  This avoids the problem by processing the family
add/remove outside of the slave device_add call.

Commit 47eba33a0997fc7362a introduced this deadlock and added
a KOBJ_ADD, as the add was already reported in device_register two add
events were being sent.  This change suppresses the device_register
add so that any slave device sysfs entries are setup before the add
goes out.

Belisko Marek reported this change fixed the deadlock he was seeing on
ARM device tree, while testing on my x86-64 system never saw the
deadlock.

Reported-by: Belisko Marek <marek.belisko@gmail.com>
Signed-off-by: David Fries <David@Fries.net>
---
Evgeniy any comments?  The patch looks good to me.
Dr. H. Nikolaus Schaller, Can you give this patch another test?  I
don't expect any problems, but it is now only sending one add instead
of two which is a change.
I verified two KOBJ_ADD notifications were going out prior to this
change, and only one after.  There should only be one, also verified
that the w1_bq27000 add notification went out before the slave device
id, showing the suppression was working.  Used
udevadm monitor --kernel --property
for notification monitoring.

 drivers/w1/w1.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index b96f61b..ff52618 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -614,27 +614,11 @@ end:
 	return err;
 }
 
-/*
- * Handle sysfs file creation and removal here, before userspace is told that
- * the device is added / removed from the system
- */
-static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
-			 void *data)
+static int w1_family_notify(unsigned long action, struct w1_slave *sl)
 {
-	struct device *dev = data;
-	struct w1_slave *sl;
 	struct w1_family_ops *fops;
 	int err;
 
-	/*
-	 * Only care about slave devices at the moment.  Yes, we should use a
-	 * separate "type" for this, but for now, look at the release function
-	 * to know which type it is...
-	 */
-	if (dev->release != w1_slave_release)
-		return 0;
-
-	sl = dev_to_w1_slave(dev);
 	fops = sl->family->fops;
 
 	if (!fops)
@@ -673,10 +657,6 @@ static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
 	return 0;
 }
 
-static struct notifier_block w1_bus_nb = {
-	.notifier_call = w1_bus_notify,
-};
-
 static int __w1_attach_slave_device(struct w1_slave *sl)
 {
 	int err;
@@ -698,6 +678,9 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
 		dev_name(&sl->dev), sl);
 
+	/* suppress for w1_family_notify before sending KOBJ_ADD */
+	dev_set_uevent_suppress(&sl->dev, true);
+
 	err = device_register(&sl->dev);
 	if (err < 0) {
 		dev_err(&sl->dev,
@@ -705,7 +688,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 			dev_name(&sl->dev), err);
 		return err;
 	}
-
+	w1_family_notify(BUS_NOTIFY_ADD_DEVICE, sl);
 
 	dev_set_uevent_suppress(&sl->dev, false);
 	kobject_uevent(&sl->dev.kobj, KOBJ_ADD);
@@ -799,6 +782,7 @@ int w1_unref_slave(struct w1_slave *sl)
 		msg.type = W1_SLAVE_REMOVE;
 		w1_netlink_send(sl->master, &msg);
 
+		w1_family_notify(BUS_NOTIFY_DEL_DEVICE, sl);
 		device_unregister(&sl->dev);
 		#ifdef DEBUG
 		memset(sl, 0, sizeof(*sl));
@@ -1186,10 +1170,6 @@ static int __init w1_init(void)
 		goto err_out_exit_init;
 	}
 
-	retval = bus_register_notifier(&w1_bus_type, &w1_bus_nb);
-	if (retval)
-		goto err_out_bus_unregister;
-
 	retval = driver_register(&w1_master_driver);
 	if (retval) {
 		printk(KERN_ERR
-- 
1.7.10.4
