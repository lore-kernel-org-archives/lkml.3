Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3JJKxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:53:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40890 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3JJKxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:53:50 -0400
Date: Thu, 10 Oct 2013 11:53:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Airlie <airlied@linux.ie>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131010105324.GA5105@n2100.arm.linux.org.uk>
References: <20131007051038.GA9764@localhost> <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com> <20131007083505.GA22585@localhost> <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com> <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com> <20131008020918.GA1220@localhost> <20131008021452.GA6456@localhost> <20131008080625.GA25034@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1310100322040.14436@skynet.skynet.ie> <20131010091920.GO25034@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010091920.GO25034@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:19:20AM +0100, Russell King - ARM Linux wrote:
> On Thu, Oct 10, 2013 at 03:23:45AM +0100, Dave Airlie wrote:
> > 
> > > I think David Arlie also needs a quiet talking to about how to use the
> > > device model:
> > > 
> > > int drm_sysfs_device_add(struct drm_minor *minor)
> > > {
> > >         minor->kdev.release = drm_sysfs_device_release;
> > > ...
> > >         err = device_register(&minor->kdev);
> > > }
> > > 
> > > static void drm_sysfs_device_release(struct device *dev)
> > > {
> > >         memset(dev, 0, sizeof(struct device));
> > >         return;
> > > }
> > > 
> > > Since when has that been acceptable in a release function?
> > 
> > Well the commit that added it had a reason that seems to cover some other 
> > device model abuses, so maybe someone who actually understands the device 
> > model (all 2 people) can review usage.
> 
> Please - there's more than two people who understand this stuff.
> 
> You appear to manage to understand the refcounting principle for things
> like the DRM framebuffers, DRM buffer objects etc, and the driver model
> (and kobjects in general) are no different.
> 
> I've just been reading the code around here little more, and hit the usb
> implementation.  I don't see how USB drivers get cleaned up when they're
> disconnected from the USB bus.  I see drm_unplug_dev() which gets called
> on a USB disconnection (from udl/udl_drv.c) which effectively makes the
> device unavailable, but I don't see anything which frees anything.  I see
> nothing calling drm_put_dev() here.  How does the drm_device in this case
> get freed?

Don't worry about the above - I've worked out how USB works in that regard.
However, I can't say that I like the feel of the code in drm_unplug_dev()
and drm_put_dev() - if these two can run simultaneously in two threads of
execution, there's the chance that things will go awry.  I don't think
that can happen due to the way the unplugged-ness is dealt with, but it
doesn't "feel" safe.

I think something like the below may address the issue - I've only build
tested this so far.

We have another case where DRM does the wrong thing here too - a similar
thing goes on with connectors as well.  I've not yet looked into this,
but I'll take a look later today.

Fengguang - could you give this some runs through your marvellous test
system and see whether it fixes the problem you're seeing please?

David - maybe you can find some time to look at the Armada driver I
re-posted last weekend?

 drivers/gpu/drm/drm_stub.c  |    8 +++++---
 drivers/gpu/drm/drm_sysfs.c |   42 +++++++++++++++++++++++++++++++++---------
 include/drm/drmP.h          |    1 +
 3 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 39d8645..1a837e1 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -396,6 +396,7 @@ EXPORT_SYMBOL(drm_get_minor);
 int drm_put_minor(struct drm_minor **minor_p)
 {
 	struct drm_minor *minor = *minor_p;
+	int minor_id = minor->index;
 
 	DRM_DEBUG("release secondary minor %d\n", minor->index);
 
@@ -403,11 +404,12 @@ int drm_put_minor(struct drm_minor **minor_p)
 	drm_debugfs_cleanup(minor);
 #endif
 
-	drm_sysfs_device_remove(minor);
+	if (!drm_device_is_unplugged(minor->dev))
+		drm_sysfs_device_remove(minor);
 
-	idr_remove(&drm_minors_idr, minor->index);
+	idr_remove(&drm_minors_idr, minor_id);
 
-	kfree(minor);
+	drm_sysfs_device_put(minor);
 	*minor_p = NULL;
 	return 0;
 }
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 2290b3b..e0733a0 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -170,7 +170,7 @@ void drm_sysfs_destroy(void)
  * with cleaning up any other stuff.  But we do that in the DRM core, so
  * this function can just return and hope that the core does its job.
  */
-static void drm_sysfs_device_release(struct device *dev)
+static void drm_sysfs_connector_release(struct device *dev)
 {
 	memset(dev, 0, sizeof(struct device));
 	return;
@@ -399,7 +399,7 @@ int drm_sysfs_connector_add(struct drm_connector *connector)
 
 	connector->kdev.parent = &dev->primary->kdev;
 	connector->kdev.class = drm_class;
-	connector->kdev.release = drm_sysfs_device_release;
+	connector->kdev.release = drm_sysfs_connector_release;
 
 	DRM_DEBUG("adding \"%s\" to sysfs\n",
 		  drm_get_connector_name(connector));
@@ -512,6 +512,17 @@ void drm_sysfs_hotplug_event(struct drm_device *dev)
 }
 EXPORT_SYMBOL(drm_sysfs_hotplug_event);
 
+/*
+ * We can only free the drm_minor once its embedded struct device has
+ * been released.
+ */
+static void drm_sysfs_device_release(struct device *dev)
+{
+	struct drm_minor *minor = container_of(dev, struct drm_minor, kdev);
+
+	kfree(minor);
+}
+
 /**
  * drm_sysfs_device_add - adds a class device to sysfs for a character driver
  * @dev: DRM device to be added
@@ -554,17 +565,30 @@ int drm_sysfs_device_add(struct drm_minor *minor)
 }
 
 /**
- * drm_sysfs_device_remove - remove DRM device
- * @dev: DRM device to remove
+ * drm_sysfs_device_remove - delete DRM minor device
+ * @minor: DRM minor device to remove
  *
- * This call unregisters and cleans up a class device that was created with a
- * call to drm_sysfs_device_add()
+ * This call removes the sysfs object(s) associated with this DRM minor
+ * device from userspace view.  This doesn't necessarily stop them being
+ * accessed as these are refcounted, neither does it free the memory
+ * associated with it.  Call drm_sysfs_device_put() to drop the final
+ * reference so it can be freed after this call.
  */
 void drm_sysfs_device_remove(struct drm_minor *minor)
 {
-	if (minor->kdev.parent)
-		device_unregister(&minor->kdev);
-	minor->kdev.parent = NULL;
+	device_del(&minor->kdev);
+}
+
+/**
+ * drm_sysfs_device_put - drop last reference to DRM minor device
+ * @minor: DRM minor device to be dropped
+ *
+ * Drop the reference count associated with this minor object, which
+ * will allow it to be freed when the last user has gone away.
+ */
+void drm_sysfs_device_put(struct drm_minor *minor)
+{
+	put_device(&minor->kdev);
 }
 
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index b46fb45..57ae052 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1548,6 +1548,7 @@ extern void drm_sysfs_destroy(void);
 extern int drm_sysfs_device_add(struct drm_minor *minor);
 extern void drm_sysfs_hotplug_event(struct drm_device *dev);
 extern void drm_sysfs_device_remove(struct drm_minor *minor);
+extern void drm_sysfs_device_put(struct drm_minor *minor);
 extern int drm_sysfs_connector_add(struct drm_connector *connector);
 extern void drm_sysfs_connector_remove(struct drm_connector *connector);
 
