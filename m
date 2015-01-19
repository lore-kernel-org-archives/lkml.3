Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbbASS4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:56:31 -0500
Received: from sauhun.de ([89.238.76.85]:58989 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbbASS4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:56:30 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@linux-mips.org, Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>, Julia Lawall <julia.lawall@lip6.fr>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH] i2c: drop ancient protection against sysfs refcounting issues
Date: Mon, 19 Jan 2015 19:55:56 +0100
Message-Id: <1421693756-12917-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back in the days, sysfs seemed to have refcounting issues and subsystems
needed a completion to be safe. This is not the case anymore, so I2C can
get rid of this code. There is noone else besides I2C doing something
like this currently (checked with the attached coccinelle script which
checks if a release function exists and if it contains a completion).

I have been digging through the history of linux.git and
linux-history.git and found that e.g. w1 used to have such a mechanism
and also simply removed it later.

Some more info from Greg Kroah-Hartman:
"Having that call "wait" for the other release call to happen is really
old, as Jean points out, from 2003.  We have "fixed" sysfs since then to
detach the files from the devices easier, we used to have some nasy
reference count issues in that area."

And some testing from Jean Delvare which matches my results:
"However I just tested unloading an i2c bus driver while its adapter's
new_device attribute was opened and rmmod returned immediately. So it
doesn't look like accessing sysfs attributes actually takes a reference
to the underlying i2c_adapter."

Let's get rid of this code before really nobody knows/understands
anymore what this was for and if it has a subtle use.

Reported-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Julia Lawall <julia.lawall@lip6.fr>
---

Of course, more testing is appreciated. Here is the coccinelle script:

===

@has_type@
identifier d_type, rel_f;
@@

struct device_type d_type = {
	.release = rel_f,
};

@has_device@
struct device *d;
identifier rel_f, p;
@@

(
	p->dev.release = &rel_f;
|
	d->release = &rel_f;
)

@find_type depends on has_type@
identifier has_type.rel_f, d;
@@

void rel_f(struct device *d)
{
	...
*	complete(...);
	...
}

@find_device depends on has_device@
identifier has_device.rel_f, d;
@@

void rel_f(struct device *d)
{
	...
*	complete(...);
	...
}

===

 drivers/i2c/i2c-core.c | 10 +---------
 include/linux/i2c.h    |  1 -
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 39d25a8cb1ad..15cc5902cf89 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -41,7 +41,6 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/clk/clk-conf.h>
-#include <linux/completion.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
 #include <linux/rwsem.h>
@@ -1184,8 +1183,7 @@ EXPORT_SYMBOL_GPL(i2c_new_dummy);
 
 static void i2c_adapter_dev_release(struct device *dev)
 {
-	struct i2c_adapter *adap = to_i2c_adapter(dev);
-	complete(&adap->dev_released);
+	/* empty, but the driver core insists we need a release function */
 }
 
 /*
@@ -1795,14 +1793,8 @@ void i2c_del_adapter(struct i2c_adapter *adap)
 
 	/* device name is gone after device_unregister */
 	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
-
-	/* clean up the sysfs representation */
-	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
 
-	/* wait for sysfs to drop all references */
-	wait_for_completion(&adap->dev_released);
-
 	/* free bus id */
 	mutex_lock(&core_lock);
 	idr_remove(&i2c_adapter_idr, adap->nr);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 524b45ea85a2..1df0c20ce648 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -466,7 +466,6 @@ struct i2c_adapter {
 
 	int nr;
 	char name[48];
-	struct completion dev_released;
 
 	struct mutex userspace_clients_lock;
 	struct list_head userspace_clients;
-- 
2.1.3

