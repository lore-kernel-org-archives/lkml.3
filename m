Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaHaLCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:02:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41802 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaHaLCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:02:05 -0400
Date: Sun, 31 Aug 2014 07:02:00 -0400
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, falcon@meizu.com,
        tiwai@suse.de, arjan@linux.intel.com, linux-kernel@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831110200.GC19853@htj.dyndns.org>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <20140831101358.GB19853@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831101358.GB19853@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, something like the following.  A couple things to note

* driver_attach() can never fail but is marked with __must_check.  We
  prolly should change it to void.

* Old/weird userspace which depends on insmod to wait for device
  probing might choke and the new behavior might need to be switched
  somehow (sysctl, insmod param or whatever).

Lightly tested and seems to work fine.

Thanks.
---
 drivers/base/bus.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83e910a..e4fc9bc 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -23,6 +23,7 @@
 
 /* /sys/devices/system */
 static struct kset *system_kset;
+static struct workqueue_struct *driver_attach_wq;
 
 #define to_bus_attr(_attr) container_of(_attr, struct bus_attribute, attr)
 
@@ -657,6 +658,20 @@ static ssize_t uevent_store(struct device_driver *drv, const char *buf,
 }
 static DRIVER_ATTR_WO(uevent);
 
+struct driver_attach_work {
+	struct work_struct		work;
+	struct device_driver		*driver;
+};
+
+static void driver_attach_workfn(struct work_struct *work)
+{
+	struct driver_attach_work *daw =
+		container_of(work, struct driver_attach_work, work);
+
+	driver_attach(daw->driver);
+	kfree(daw);
+}
+
 /**
  * bus_add_driver - Add a driver to the bus.
  * @drv: driver.
@@ -689,9 +704,23 @@ int bus_add_driver(struct device_driver *drv)
 
 	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
 	if (drv->bus->p->drivers_autoprobe) {
-		error = driver_attach(drv);
-		if (error)
-			goto out_unregister;
+		struct driver_attach_work *daw;
+
+		if (drv->owner) {
+			daw = kzalloc(sizeof(*daw), GFP_KERNEL);
+			if (!daw) {
+				error = -ENOMEM;
+				goto out_unregister;
+			}
+
+			INIT_WORK(&daw->work, driver_attach_workfn);
+			daw->driver = drv;
+			queue_work(driver_attach_wq, &daw->work);
+		} else {
+			error = driver_attach(drv);
+			if (error)
+				goto out_unregister;
+		}
 	}
 	module_add_driver(drv->owner, drv);
 
@@ -1268,5 +1297,9 @@ int __init buses_init(void)
 	if (!system_kset)
 		return -ENOMEM;
 
+	driver_attach_wq = alloc_ordered_workqueue("driver_attach", 0);
+	if (!driver_attach_wq)
+		return -ENOMEM;
+
 	return 0;
 }
