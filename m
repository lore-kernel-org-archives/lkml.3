Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaEUXAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:00:17 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35741 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaEUXAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:00:14 -0400
Date: Wed, 21 May 2014 15:59:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Francesco Ruggeri <fruggeri@arista.com>
Cc: Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: pci: kernel crash in bus_find_device
Message-ID: <20140521225958.GB2467@roeck-us.net>
References: <CA+HUmGjvHgWB3vcPnXAEVFdFuy9sOaB1BjaDW1-7ai933XEGWQ@mail.gmail.com>
 <20140520195041.GA28913@roeck-us.net>
 <CA+HUmGg4mE5RDxShNCK78yLi9gdX_FnHtWPKfGD4LaEqrCdj2Q@mail.gmail.com>
 <20140520233812.GA15640@roeck-us.net>
 <CA+HUmGge7AEpAnwAG_VJD2CKTtRBoC2bCGVU_t4qm-x6+OCr-g@mail.gmail.com>
 <20140521193010.GA1721@roeck-us.net>
 <CA+HUmGhm1VLTvMKW1TUUPqStUhD11M5u0VyTZyXyWz_ZS8uSVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HUmGhm1VLTvMKW1TUUPqStUhD11M5u0VyTZyXyWz_ZS8uSVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 01:04:04PM -0700, Francesco Ruggeri wrote:
> I have been using an x86 platform.
> When I started working on it I got early crashes until I added the
> check for p not NULL in
> 
> +void bus_release_device(struct device *dev)
> +{
> + struct device_private *p = dev->p;
> +
> + if (p && klist_node_attached(&p->knode_bus))
> + klist_put_last(&p->knode_bus);
> +}
> +
> 
> Maybe on powerpc *p is overriden between device_del and device_release?
> 
> Or maybe some of the BUG_ONs in the patch? The ones on knode_dead are
> treated as WARN_ONs in the current klist code.
> The one in BUG_ON(!klist_dec_and_del(n)); is new, and in my tests I
> ran into it without the second patch (but only when I ran my module
> and tests).
> 
Hi Francesco,

I replaced the BUG_ON with WARN_ON; still crashes.

Anyway, the problem seems to be known. I found two related exchanges.

[1] describes pretty much the same problem. I don't see if/where it was
ever fixed, though.

[2] is a patch to fix the problem. It did not apply cleanly to 3.14,
so I had to make some adjustments in klist_iter_init_node. Resulting
patch is below. With this patch, the problem is gone. It is not perfect,
as it aborts the loop if it encounters a deleted kobject, but it is better
than nothing. Unfortunately, the patch never made it upstream; no idea why.
Copying the author and Greg to get additional feedback.

Guenter

[1] https://lkml.org/lkml/2008/10/26/79
[2] https://lkml.org/lkml/2012/4/16/218

----

>From 2bf95c4a05a91dbe7168b53d4405dee3a0912a98 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Mon, 16 Apr 2012 15:06:25 +0200
Subject: [PATCH] driver core: check start node in klist_iter_init_node

klist_iter_init_node() takes a node as a start argument.
However, this node might not be valid anymore.
This patch updates the klist_iter_init_node() and
dependent functions to return an error if so.
All calling functions have been audited to check
for a return code here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>
[groeck: ported to 3.14]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/base/bus.c     |   46 +++++++++++++++++++++++++++++-----------------
 drivers/base/class.c   |   32 ++++++++++++++++++++------------
 drivers/base/driver.c  |   18 +++++++++++-------
 include/linux/device.h |   10 +++++-----
 include/linux/klist.h  |    2 +-
 lib/klist.c            |   15 +++++++++++----
 6 files changed, 77 insertions(+), 46 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index fbad61b..9d6af80 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -305,11 +305,13 @@ int bus_for_each_dev(struct bus_type *bus, struct device *start,
 	if (!bus || !bus->p || (start && !start->p))
 		return -EINVAL;
 
-	klist_iter_init_node(&bus->p->klist_devices, &i,
-			     (start ? &start->p->knode_bus : NULL));
-	while ((dev = next_device(&i)) && !error)
-		error = fn(dev, data);
-	klist_iter_exit(&i);
+	error = klist_iter_init_node(&bus->p->klist_devices, &i,
+				     (start ? &start->p->knode_bus : NULL));
+	if (!error) {
+		while ((dev = next_device(&i)) && !error)
+			error = fn(dev, data);
+		klist_iter_exit(&i);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(bus_for_each_dev);
@@ -339,8 +341,10 @@ struct device *bus_find_device(struct bus_type *bus,
 	if (!bus || !bus->p)
 		return NULL;
 
-	klist_iter_init_node(&bus->p->klist_devices, &i,
-			     (start ? &start->p->knode_bus : NULL));
+	if (klist_iter_init_node(&bus->p->klist_devices, &i,
+				 (start ? &start->p->knode_bus : NULL)) < 0)
+		return NULL;
+
 	while ((dev = next_device(&i)))
 		if (match(dev, data) && get_device(dev))
 			break;
@@ -393,7 +397,9 @@ struct device *subsys_find_device_by_id(struct bus_type *subsys, unsigned int id
 		return NULL;
 
 	if (hint) {
-		klist_iter_init_node(&subsys->p->klist_devices, &i, &hint->p->knode_bus);
+		if (klist_iter_init_node(&subsys->p->klist_devices, &i,
+					 &hint->p->knode_bus) < 0)
+			return NULL;
 		dev = next_device(&i);
 		if (dev && dev->id == id && get_device(dev)) {
 			klist_iter_exit(&i);
@@ -455,11 +461,13 @@ int bus_for_each_drv(struct bus_type *bus, struct device_driver *start,
 	if (!bus)
 		return -EINVAL;
 
-	klist_iter_init_node(&bus->p->klist_drivers, &i,
-			     start ? &start->p->knode_bus : NULL);
-	while ((drv = next_driver(&i)) && !error)
-		error = fn(drv, data);
-	klist_iter_exit(&i);
+	error = klist_iter_init_node(&bus->p->klist_drivers, &i,
+				     start ? &start->p->knode_bus : NULL);
+	if (!error) {
+		while ((drv = next_driver(&i)) && !error)
+			error = fn(drv, data);
+		klist_iter_exit(&i);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(bus_for_each_drv);
@@ -1057,15 +1065,19 @@ EXPORT_SYMBOL_GPL(bus_sort_breadthfirst);
  * otherwise if it is NULL, the iteration starts at the beginning of
  * the list.
  */
-void subsys_dev_iter_init(struct subsys_dev_iter *iter, struct bus_type *subsys,
-			  struct device *start, const struct device_type *type)
+int subsys_dev_iter_init(struct subsys_dev_iter *iter, struct bus_type *subsys,
+			 struct device *start, const struct device_type *type)
 {
 	struct klist_node *start_knode = NULL;
+	int error;
 
 	if (start)
 		start_knode = &start->p->knode_bus;
-	klist_iter_init_node(&subsys->p->klist_devices, &iter->ki, start_knode);
-	iter->type = type;
+	error = klist_iter_init_node(&subsys->p->klist_devices, &iter->ki,
+				     start_knode);
+	if (!error)
+		iter->type = type;
+	return error;
 }
 EXPORT_SYMBOL_GPL(subsys_dev_iter_init);
 
diff --git a/drivers/base/class.c b/drivers/base/class.c
index f96f704..46bcbc0 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -290,15 +290,20 @@ void class_destroy(struct class *cls)
  * otherwise if it is NULL, the iteration starts at the beginning of
  * the list.
  */
-void class_dev_iter_init(struct class_dev_iter *iter, struct class *class,
-			 struct device *start, const struct device_type *type)
+int class_dev_iter_init(struct class_dev_iter *iter, struct class *class,
+			struct device *start, const struct device_type *type)
 {
 	struct klist_node *start_knode = NULL;
+	int error;
 
 	if (start)
 		start_knode = &start->knode_class;
-	klist_iter_init_node(&class->p->klist_devices, &iter->ki, start_knode);
-	iter->type = type;
+	error = klist_iter_init_node(&class->p->klist_devices, &iter->ki,
+				     start_knode);
+	if (!error)
+		iter->type = type;
+
+	return error;
 }
 EXPORT_SYMBOL_GPL(class_dev_iter_init);
 
@@ -376,14 +381,15 @@ int class_for_each_device(struct class *class, struct device *start,
 		return -EINVAL;
 	}
 
-	class_dev_iter_init(&iter, class, start, NULL);
-	while ((dev = class_dev_iter_next(&iter))) {
-		error = fn(dev, data);
-		if (error)
-			break;
+	error = class_dev_iter_init(&iter, class, start, NULL);
+	if (!error) {
+		while ((dev = class_dev_iter_next(&iter))) {
+			error = fn(dev, data);
+			if (error)
+				break;
+		}
+		class_dev_iter_exit(&iter);
 	}
-	class_dev_iter_exit(&iter);
-
 	return error;
 }
 EXPORT_SYMBOL_GPL(class_for_each_device);
@@ -423,7 +429,9 @@ struct device *class_find_device(struct class *class, struct device *start,
 		return NULL;
 	}
 
-	class_dev_iter_init(&iter, class, start, NULL);
+	if (class_dev_iter_init(&iter, class, start, NULL) < 0)
+		return NULL;
+
 	while ((dev = class_dev_iter_next(&iter))) {
 		if (match(dev, data)) {
 			get_device(dev);
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 9e29943..d7836c1 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -50,11 +50,13 @@ int driver_for_each_device(struct device_driver *drv, struct device *start,
 	if (!drv)
 		return -EINVAL;
 
-	klist_iter_init_node(&drv->p->klist_devices, &i,
-			     start ? &start->p->knode_driver : NULL);
-	while ((dev = next_device(&i)) && !error)
-		error = fn(dev, data);
-	klist_iter_exit(&i);
+	error = klist_iter_init_node(&drv->p->klist_devices, &i,
+				     start ? &start->p->knode_driver : NULL);
+	if (!error) {
+		while ((dev = next_device(&i)) && !error)
+			error = fn(dev, data);
+		klist_iter_exit(&i);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(driver_for_each_device);
@@ -84,8 +86,10 @@ struct device *driver_find_device(struct device_driver *drv,
 	if (!drv || !drv->p)
 		return NULL;
 
-	klist_iter_init_node(&drv->p->klist_devices, &i,
-			     (start ? &start->p->knode_driver : NULL));
+	if (klist_iter_init_node(&drv->p->klist_devices, &i,
+				 (start ? &start->p->knode_driver : NULL)) < 0)
+		return NULL;
+
 	while ((dev = next_device(&i)))
 		if (match(dev, data) && get_device(dev))
 			break;
diff --git a/include/linux/device.h b/include/linux/device.h
index 952b010..9b5bed7 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -141,7 +141,7 @@ struct subsys_dev_iter {
 	struct klist_iter		ki;
 	const struct device_type	*type;
 };
-void subsys_dev_iter_init(struct subsys_dev_iter *iter,
+int subsys_dev_iter_init(struct subsys_dev_iter *iter,
 			 struct bus_type *subsys,
 			 struct device *start,
 			 const struct device_type *type);
@@ -400,10 +400,10 @@ int class_compat_create_link(struct class_compat *cls, struct device *dev,
 void class_compat_remove_link(struct class_compat *cls, struct device *dev,
 			      struct device *device_link);
 
-extern void class_dev_iter_init(struct class_dev_iter *iter,
-				struct class *class,
-				struct device *start,
-				const struct device_type *type);
+extern int class_dev_iter_init(struct class_dev_iter *iter,
+			       struct class *class,
+			       struct device *start,
+			       const struct device_type *type);
 extern struct device *class_dev_iter_next(struct class_dev_iter *iter);
 extern void class_dev_iter_exit(struct class_dev_iter *iter);
 
diff --git a/include/linux/klist.h b/include/linux/klist.h
index a370ce5..9f63323 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -60,7 +60,7 @@ struct klist_iter {
 
 
 extern void klist_iter_init(struct klist *k, struct klist_iter *i);
-extern void klist_iter_init_node(struct klist *k, struct klist_iter *i,
+extern int klist_iter_init_node(struct klist *k, struct klist_iter *i,
 				 struct klist_node *n);
 extern void klist_iter_exit(struct klist_iter *i);
 extern struct klist_node *klist_next(struct klist_iter *i);
diff --git a/lib/klist.c b/lib/klist.c
index 358a368..dc911f8 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -278,13 +278,20 @@ EXPORT_SYMBOL_GPL(klist_node_attached);
  * Similar to klist_iter_init(), but starts the action off with @n,
  * instead of with the list head.
  */
-void klist_iter_init_node(struct klist *k, struct klist_iter *i,
-			  struct klist_node *n)
+int klist_iter_init_node(struct klist *k, struct klist_iter *i,
+			 struct klist_node *n)
 {
+	if (n) {
+		if (!kref_get_unless_zero(&n->n_ref))
+			return -ENODEV;
+		if (!n->n_klist || knode_dead(n)) {
+			klist_dec_and_del(n);
+			return -ENODEV;
+		}
+	}
 	i->i_klist = k;
 	i->i_cur = n;
-	if (n)
-		kref_get(&n->n_ref);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(klist_iter_init_node);
 
-- 
1.7.9.5

