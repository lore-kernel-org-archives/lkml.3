Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaF0S1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:27:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37267 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751065AbaF0S13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:27:29 -0400
Date: Fri, 27 Jun 2014 14:27:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [RFC] Add "rpm_not_supported" flag
In-Reply-To: <3098868.U0NfB8kYvJ@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1406271417120.875-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Rafael J. Wysocki wrote:

> On Sunday, June 22, 2014 12:45:42 PM Alan Stern wrote:
> > On Sun, 22 Jun 2014, Rafael J. Wysocki wrote:
> > 
> > > > How would you treat them specially?  Add a "runtime_pm_not_supported" 
> > > > flag?
> > > 
> > > I thought about a "runtime PM has been enabled at least once" flag rather
> > > that would be set by pm_runtime_enable() every time it is called and never
> > > cleared.  That would allow the core to distinguish between "runtime PM
> > > disabled temporarily" and "runtime PM not used" which turn out to be
> > > sufficiently different cases.
> > 
> > Interesting idea, but it can't tell the difference between "runtime PM
> > not supported" and "runtime PM not enabled yet".  I think a simple "not
> > supported" flag will be more straightforward.
> 
> The question is who will set the "unsupported" flag (think devices without
> drivers etc.).  Or perhaps the idea is that it will be set to start with?

Drivers or subsystems will set the flag.  It should not be set for
devices without drivers or subsystems, because the flag means that the
hardware doesn't support runtime power management, and the kernel
wouldn't know this if there was no driver or subsystem.

The flag will not be set to start with.  The idea is that you set it 
when you know for certain that the device cannot be power-managed, but 
you still want the Runtime PM API to work with the device.  In 
particular, calls to pm_runtime_resume() will succeed.

> > > Yes.  The core definitely needs to be able to distinguish between the
> > > "runtime PM disabled temporarily" and "runtime PM not supported/not used"
> > > situations.
> > 
> > Let me work out a patch, and we'll see what you think.  For the time
> > being we can stick with our "runtime PM must be disabled (or in error)  
> > when the status is changed" approach.
> 
> OK

The patch is below.  I haven't tested it with anything meaningful, but 
it seems straightforward enough.

One side point: The patch changes the string displayed for the 
power/runtime_status attribute file when disable_depth > 0.  Instead of 
"unsupported", it will now say "disabled".  The attribute will contain 
"not supported" when the new flag is set.

Is this acceptable?

Alan Stern



 Documentation/power/runtime_pm.txt |   20 +++++++++++++++++++-
 drivers/base/power/runtime.c       |   36 ++++++++++++++++++++++++++++++++++--
 drivers/base/power/sysfs.c         |    6 ++++--
 include/linux/pm.h                 |    1 +
 include/linux/pm_runtime.h         |    2 ++
 5 files changed, 60 insertions(+), 5 deletions(-)

Index: usb-3.16/Documentation/power/runtime_pm.txt
===================================================================
--- usb-3.16.orig/Documentation/power/runtime_pm.txt
+++ usb-3.16/Documentation/power/runtime_pm.txt
@@ -233,6 +233,10 @@ defined in include/linux/pm.h:
       equal to zero); the initial value of it is 1 (i.e. runtime PM is
       initially disabled for all devices)
 
+  int rpm_not_supported;
+    - if set, the device does not support runtime power management; attempts to
+      suspend the device will fail with -EOPNOTSUPP
+
   int runtime_error;
     - if set, there was a fatal error (one of the callbacks returned error code
       as described in Section 2), so the helper funtions will not work until
@@ -419,6 +423,11 @@ drivers/base/power/runtime.c and include
   void pm_suspend_ignore_children(struct device *dev, bool enable);
     - set/unset the power.ignore_children flag of the device
 
+  void pm_runtime_not_supported(struct device *dev);
+    - set the device's 'power.rpm_not_supported' flag, set the device's runtime
+      status to 'active', and increment the device's usage counter; this action
+      is irreversible
+
   int pm_runtime_set_active(struct device *dev);
     - clear the device's 'power.runtime_error' flag, set the device's runtime
       PM status to 'active' and update its parent's counter of 'active'
@@ -432,7 +441,7 @@ drivers/base/power/runtime.c and include
       PM status to 'suspended' and update its parent's counter of 'active'
       children as appropriate (it is only valid to use this function if
       'power.runtime_error' is set or 'power.disable_depth' is greater than
-      zero)
+      zero, and 'power.rpm_not_supported' must be zero)
 
   bool pm_runtime_active(struct device *dev);
     - return true if the device's runtime PM status is 'active' or its
@@ -586,6 +595,15 @@ value of /sys/devices/.../power/control
 manage the device at run time, the driver may confuse it by using
 pm_runtime_forbid() this way.
 
+If a driver supports runtime PM but one of its devices does not, the driver
+can call pm_runtime_not_supported() before calling pm_runtime_enable().  After
+that, calls to pm_runtime_resume() and related functions will succeed, but
+attempts to suspend the device will fail (much like what happens after calling
+pm_runtime_forbid(), except that pm_runtime_not_supported() cannot be undone by
+either the kernel or the user).  It is not necessary to call
+pm_runtime_set_active() for the device; pm_runtime_not_supported() sets the
+runtime PM status to 'active'.
+
 6. Runtime PM and System Sleep
 
 Runtime PM and system sleep (i.e., system suspend and hibernation, also known
Index: usb-3.16/include/linux/pm.h
===================================================================
--- usb-3.16.orig/include/linux/pm.h
+++ usb-3.16/include/linux/pm.h
@@ -584,6 +584,7 @@ struct dev_pm_info {
 	atomic_t		usage_count;
 	atomic_t		child_count;
 	unsigned int		disable_depth:3;
+	unsigned int		rpm_not_supported:1;
 	unsigned int		idle_notification:1;
 	unsigned int		request_pending:1;
 	unsigned int		deferred_resume:1;
Index: usb-3.16/include/linux/pm_runtime.h
===================================================================
--- usb-3.16.orig/include/linux/pm_runtime.h
+++ usb-3.16/include/linux/pm_runtime.h
@@ -47,6 +47,7 @@ extern int __pm_runtime_set_status(struc
 extern int pm_runtime_barrier(struct device *dev);
 extern void pm_runtime_enable(struct device *dev);
 extern void __pm_runtime_disable(struct device *dev, bool check_resume);
+extern void pm_runtime_not_supported(struct device *dev);
 extern void pm_runtime_allow(struct device *dev);
 extern void pm_runtime_forbid(struct device *dev);
 extern void pm_runtime_no_callbacks(struct device *dev);
@@ -144,6 +145,7 @@ static inline int __pm_runtime_set_statu
 static inline int pm_runtime_barrier(struct device *dev) { return 0; }
 static inline void pm_runtime_enable(struct device *dev) {}
 static inline void __pm_runtime_disable(struct device *dev, bool c) {}
+static inline void pm_runtime_not_supported(struct device *dev) {}
 static inline void pm_runtime_allow(struct device *dev) {}
 static inline void pm_runtime_forbid(struct device *dev) {}
 
Index: usb-3.16/drivers/base/power/runtime.c
===================================================================
--- usb-3.16.orig/drivers/base/power/runtime.c
+++ usb-3.16/drivers/base/power/runtime.c
@@ -239,7 +239,9 @@ static int rpm_check_suspend_allowed(str
 {
 	int retval = 0;
 
-	if (dev->power.runtime_error)
+	if (dev->power.rpm_not_supported)
+		retval = -EOPNOTSUPP;
+	else if (dev->power.runtime_error)
 		retval = -EINVAL;
 	else if (dev->power.disable_depth > 0)
 		retval = -EACCES;
@@ -974,7 +976,9 @@ EXPORT_SYMBOL_GPL(__pm_runtime_resume);
  * RPM_SUSPENDED, as long as that reflects the actual state of the device.
  * However, if the device has a parent and the parent is not active, and the
  * parent's power.ignore_children flag is unset, the device's status cannot be
- * set to RPM_ACTIVE, so -EBUSY is returned in that case.
+ * set to RPM_ACTIVE, so -EBUSY is returned in that case.  If the device's
+ * power.rpm_not_supported flag is set then the device's status cannot be set
+ * to RPM_SUSPENDED, so -EOPNOTSUPP is returned in that case.
  *
  * If successful, __pm_runtime_set_status() clears the power.runtime_error field
  * and the device parent's counter of unsuspended children is modified to
@@ -1002,6 +1006,11 @@ int __pm_runtime_set_status(struct devic
 		goto out_set;
 
 	if (status == RPM_SUSPENDED) {
+		if (dev->power.rpm_not_supported) {
+			error = -EOPNOTSUPP;
+			goto out;
+		}
+
 		/* It always is possible to set the status to 'suspended'. */
 		if (parent) {
 			atomic_add_unless(&parent->power.child_count, -1, 0);
@@ -1195,6 +1204,26 @@ void pm_runtime_enable(struct device *de
 EXPORT_SYMBOL_GPL(pm_runtime_enable);
 
 /**
+ * pm_runtime_not_supported - A device doesn't support runtime PM
+ * @dev: Device to handle.
+ *
+ * Set @dev->power.rpm_not_supported, indicating the @dev doesn't support
+ * runtime PM and consequently must always be in the RPM_ACTIVE state.
+ *
+ * For good measure, also set runtime_status to RPM_ACTIVE and increment
+ * usage_count.
+ */
+void pm_runtime_not_supported(struct device *dev)
+{
+	spin_lock_irq(&dev->power.lock);
+	dev->power.rpm_not_supported = 1;
+	dev->power.runtime_status = RPM_ACTIVE;
+	atomic_inc(&dev->power.usage_count);
+	spin_unlock_irq(&dev->power.lock);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_not_supported);
+
+/**
  * pm_runtime_forbid - Block runtime PM of a device.
  * @dev: Device to handle.
  *
@@ -1415,6 +1444,9 @@ void pm_runtime_remove(struct device *de
  *
  * Typically this function may be invoked from a system suspend callback to make
  * sure the device is put into low power state.
+ *
+ * If the device's power.rpm_not_supported flag is set, the result of calling
+ * this function is undefined.
  */
 int pm_runtime_force_suspend(struct device *dev)
 {
Index: usb-3.16/drivers/base/power/sysfs.c
===================================================================
--- usb-3.16.orig/drivers/base/power/sysfs.c
+++ usb-3.16/drivers/base/power/sysfs.c
@@ -163,10 +163,12 @@ static ssize_t rtpm_status_show(struct d
 {
 	const char *p;
 
-	if (dev->power.runtime_error) {
+	if (dev->power.rpm_not_supported) {
+		p = "not supported\n";
+	} else if (dev->power.runtime_error) {
 		p = "error\n";
 	} else if (dev->power.disable_depth) {
-		p = "unsupported\n";
+		p = "disabled\n";
 	} else {
 		switch (dev->power.runtime_status) {
 		case RPM_SUSPENDED:

