Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaAJOjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:39:23 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:3202 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbaAJOjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:39:17 -0500
Date: Fri, 10 Jan 2014 15:39:07 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Wu <lekensteyn@gmail.com>
Subject: Re: Freeing of dev->p
Message-ID: <20140110153907.08297202@endymion.delvare>
In-Reply-To: <20140110041853.GA32018@kroah.com>
References: <20140108164058.059cf461@endymion.delvare>
	<20140108165628.GA15820@kroah.com>
	<20140108213330.2efbc84c@endymion.delvare>
	<20140110041853.GA32018@kroah.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, 9 Jan 2014 20:18:53 -0800, Greg Kroah-Hartman wrote:
> On Wed, Jan 08, 2014 at 09:33:30PM +0100, Jean Delvare wrote:
> > I consider allocating memory in dev_set_drvdata() very misleading, I
> > don't think we should keep doing that.
> 
> I had to add that later on when it was found that people were setting
> private data fields before allocating or initializing the structure,
> much like you are doing here.

Yes, I understand the idea.

> Which should be fine, except for the big problem you have pointed out.

Yup :(

> Hm, let me think about this.  If we move driver_data back out of the
> private section of the device, we should be ok, (...)

That's pretty much what I had in mind:

From: Jean Delvare <khali@linux-fr.org>
Subject: driver core: Move driver_data back to struct device

Having to allocate memory as part of dev_set_drvdata() is a problem
because that memory may never get freed if the device itself is not
created. So move driver_data back to struct device.

This is more or less a revert of commit
b4028437876866aba4747a655ede00f892089e14.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/base.h    |    3 ---
 drivers/base/dd.c      |   13 +++----------
 include/linux/device.h |    4 ++++
 3 files changed, 7 insertions(+), 13 deletions(-)

--- linux-3.13-rc7.orig/drivers/base/base.h	2013-11-04 00:41:51.000000000 +0100
+++ linux-3.13-rc7/drivers/base/base.h	2014-01-10 13:04:10.412200948 +0100
@@ -63,8 +63,6 @@ struct driver_private {
  *	binding of drivers which were unable to get all the resources needed by
  *	the device; typically because it depends on another driver getting
  *	probed first.
- * @driver_data - private pointer for driver specific info.  Will turn into a
- * list soon.
  * @device - pointer back to the struct class that this structure is
  * associated with.
  *
@@ -76,7 +74,6 @@ struct device_private {
 	struct klist_node knode_driver;
 	struct klist_node knode_bus;
 	struct list_head deferred_probe;
-	void *driver_data;
 	struct device *device;
 };
 #define to_device_private_parent(obj)	\
--- linux-3.13-rc7.orig/drivers/base/dd.c	2013-11-26 15:44:46.709655132 +0100
+++ linux-3.13-rc7/drivers/base/dd.c	2014-01-10 13:24:08.638450784 +0100
@@ -577,22 +577,15 @@ void driver_detach(struct device_driver
  */
 void *dev_get_drvdata(const struct device *dev)
 {
-	if (dev && dev->p)
-		return dev->p->driver_data;
+	if (dev)
+		return dev->driver_data;
 	return NULL;
 }
 EXPORT_SYMBOL(dev_get_drvdata);
 
 int dev_set_drvdata(struct device *dev, void *data)
 {
-	int error;
-
-	if (!dev->p) {
-		error = device_private_init(dev);
-		if (error)
-			return error;
-	}
-	dev->p->driver_data = data;
+	dev->driver_data = data;
 	return 0;
 }
 EXPORT_SYMBOL(dev_set_drvdata);
--- linux-3.13-rc7.orig/include/linux/device.h	2013-11-26 15:44:48.481695736 +0100
+++ linux-3.13-rc7/include/linux/device.h	2014-01-10 13:04:40.583896319 +0100
@@ -676,6 +676,8 @@ struct acpi_dev_node {
  * 		variants, which GPIO pins act in what additional roles, and so
  * 		on.  This shrinks the "Board Support Packages" (BSPs) and
  * 		minimizes board-specific #ifdefs in drivers.
+ * @driver_data: Private pointer for driver specific info.  Will turn into a
+ *		list soon.
  * @power:	For device power management.
  * 		See Documentation/power/devices.txt for details.
  * @pm_domain:	Provide callbacks that are executed during system suspend,
@@ -737,6 +739,8 @@ struct device {
 					   device */
 	void		*platform_data;	/* Platform specific data, device
 					   core doesn't touch it */
+	void		*driver_data;	/* Driver data, set and get with
+					   dev_set/get_drvdata */
 	struct dev_pm_info	power;
 	struct dev_pm_domain	*pm_domain;
 

For performance I'd even question the point of the dev check in
dev_get_drvdata(), especially when there is no such check in
dev_set_drvdata() which presumably is always called first. Plus
dev_set_drvdata() can no longer fail (something only 3 drivers in the
whole kernel tree were checking for anyway) so it could return void
instead of int. Then I suppose we could inline both functions again, for
performance. Well, put in short, really revering
b4028437876866aba4747a655ede00f892089e14 would be the way to go IMHO.

Really, while I understand your envy to protect driver core internals
from unwanted access, the cost here was simply too high IMHO, both in
terms of getting things right and performance. Some drivers are calling
dev_get_drvdata() directly or indirectly repeatedly at run-time. They
had no reason not to as this used to be so fast, and now it is no
longer an inline function, it has conditionals and a double pointer
indirection...

Plus, I can't think of anything really bad that could result from
accessing driver_data directly, contrary to the other members of struct
device_private.

> but give me a day or so to think about it some more...

Sure, take your time.

-- 
Jean Delvare
