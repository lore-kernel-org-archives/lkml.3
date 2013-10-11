Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3JKE25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 00:28:57 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:58878 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3JKE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 00:28:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9twEehVg4JNqVrvEgCQ6R_0Saae0e9Gj2EsQSFviSywzEQ@mail.gmail.com>
References: <20131007051038.GA9764@localhost>
	<CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
	<CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
	<CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
	<20131008020918.GA1220@localhost>
	<20131008021452.GA6456@localhost>
	<20131008080625.GA25034@n2100.arm.linux.org.uk>
	<alpine.DEB.2.00.1310100322040.14436@skynet.skynet.ie>
	<20131010091920.GO25034@n2100.arm.linux.org.uk>
	<20131010105324.GA5105@n2100.arm.linux.org.uk>
	<CAPM=9twEehVg4JNqVrvEgCQ6R_0Saae0e9Gj2EsQSFviSywzEQ@mail.gmail.com>
Date: Fri, 11 Oct 2013 14:28:53 +1000
Message-ID: <CAPM=9tw1L0_6fSX9AUU=V1VmWCOT4BknsYbG+rdnf-Rt7mr5ZQ@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Dave Airlie <airlied@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@linux.ie>, Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: multipart/mixed; boundary=001a11c3f40050b44c04e86f8e42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c3f40050b44c04e86f8e42
Content-Type: text/plain; charset=ISO-8859-1

> Damn gmail screwed up my reply-all,
>
> anyhoo I get the feeling I'd rather do this like fbdev does and stop using
> an embedded kdev for this if I can. The lifetime of the minor and the sysfs
> objects aren't necessarily that tied together esp with hot unplug of
> USB devices.
>
> e.g. when a USB device goes away I don't want the sysfs files to
> remain hanging around,
> or the userspace device nodes, however I can't remove all the internal
> driver state until userspace finally closes all open device
> files,
>
> I think this is a bit of a bad misdesign of the whole device api that
> sysfs exposure and device exposure is tied
> to objects you are encourgaged to embed.
>
> I think maybe I'll just copy fbdev and do a separate device_create
> with a nonembedded dev.
>

Okay it compiles but not boot tested yet.,attached as well just in
case gmail eats it.

>From be06235b2d2a26c0e52c099e70922b71f1245b9e Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Fri, 11 Oct 2013 14:07:25 +1000
Subject: [PATCH] drm/sysfs: sort out minor and connector device object
 lifetimes.

So drm was abusing device lifetimes, by having embedded device structures
in the minor and connector it meant that the lifetime of the internal drm
objects (drm_minor and drm_connector) were tied to the lifetime of the device
files in sysfs, so if something kept those files opened the current code
would kfree the objects and things would go downhill from there.

Now in reality there is no need for these lifetimes to be so intertwined,
especailly with hotplugging of devices where we wish to remove the sysfs
and userspace facing pieces before we can unwind the internal objects due
to open userspace files or mmaps, so split the objects out so the struct
device is no longer embedded and do what fbdev does and just allocate
and remove the sysfs inodes separately.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/drm_sysfs.c       | 94 ++++++++++++++-------------------------
 drivers/gpu/drm/i915/i915_irq.c   |  8 ++--
 drivers/gpu/drm/i915/i915_sysfs.c | 28 ++++++------
 include/drm/drmP.h                |  2 +-
 include/drm/drm_crtc.h            |  2 +-
 5 files changed, 54 insertions(+), 80 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 2290b3b..dae42c7 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -22,8 +22,8 @@
 #include <drm/drm_core.h>
 #include <drm/drmP.h>

-#define to_drm_minor(d) container_of(d, struct drm_minor, kdev)
-#define to_drm_connector(d) container_of(d, struct drm_connector, kdev)
+#define to_drm_minor(d) dev_get_drvdata(d)
+#define to_drm_connector(d) dev_get_drvdata(d)

 static struct device_type drm_sysfs_device_minor = {
     .name = "drm_minor"
@@ -162,20 +162,6 @@ void drm_sysfs_destroy(void)
     drm_class = NULL;
 }

-/**
- * drm_sysfs_device_release - do nothing
- * @dev: Linux device
- *
- * Normally, this would free the DRM device associated with @dev, along
- * with cleaning up any other stuff.  But we do that in the DRM core, so
- * this function can just return and hope that the core does its job.
- */
-static void drm_sysfs_device_release(struct device *dev)
-{
-    memset(dev, 0, sizeof(struct device));
-    return;
-}
-
 /*
  * Connector properties
  */
@@ -394,29 +380,26 @@ int drm_sysfs_connector_add(struct drm_connector
*connector)
     int i;
     int ret;

-    /* We shouldn't get called more than once for the same connector */
-    BUG_ON(device_is_registered(&connector->kdev));
-
-    connector->kdev.parent = &dev->primary->kdev;
-    connector->kdev.class = drm_class;
-    connector->kdev.release = drm_sysfs_device_release;
+    if (connector->kdev)
+        return 0;

+    /* We shouldn't get called more than once for the same connector */
+    connector->kdev = device_create(drm_class, dev->primary->kdev,
+                    0, connector, "card%d-%s",
+                    dev->primary->index, drm_get_connector_name(connector));
     DRM_DEBUG("adding \"%s\" to sysfs\n",
           drm_get_connector_name(connector));

-    dev_set_name(&connector->kdev, "card%d-%s",
-             dev->primary->index, drm_get_connector_name(connector));
-    ret = device_register(&connector->kdev);
-
-    if (ret) {
-        DRM_ERROR("failed to register connector device: %d\n", ret);
+    if (IS_ERR(connector->kdev)) {
+        DRM_ERROR("failed to register connector device: %ld\n",
PTR_ERR(connector->kdev));
+        ret = PTR_ERR(connector->kdev);
         goto out;
     }

     /* Standard attributes */

     for (attr_cnt = 0; attr_cnt < ARRAY_SIZE(connector_attrs); attr_cnt++) {
-        ret = device_create_file(&connector->kdev, &connector_attrs[attr_cnt]);
+        ret = device_create_file(connector->kdev, &connector_attrs[attr_cnt]);
         if (ret)
             goto err_out_files;
     }
@@ -433,7 +416,7 @@ int drm_sysfs_connector_add(struct drm_connector *connector)
         case DRM_MODE_CONNECTOR_Component:
         case DRM_MODE_CONNECTOR_TV:
             for (opt_cnt = 0; opt_cnt <
ARRAY_SIZE(connector_attrs_opt1); opt_cnt++) {
-                ret = device_create_file(&connector->kdev,
&connector_attrs_opt1[opt_cnt]);
+                ret = device_create_file(connector->kdev,
&connector_attrs_opt1[opt_cnt]);
                 if (ret)
                     goto err_out_files;
             }
@@ -442,7 +425,7 @@ int drm_sysfs_connector_add(struct drm_connector *connector)
             break;
     }

-    ret = sysfs_create_bin_file(&connector->kdev.kobj, &edid_attr);
+    ret = sysfs_create_bin_file(&connector->kdev->kobj, &edid_attr);
     if (ret)
         goto err_out_files;

@@ -453,10 +436,11 @@ int drm_sysfs_connector_add(struct drm_connector
*connector)

 err_out_files:
     for (i = 0; i < opt_cnt; i++)
-        device_remove_file(&connector->kdev, &connector_attrs_opt1[i]);
+        device_remove_file(connector->kdev, &connector_attrs_opt1[i]);
     for (i = 0; i < attr_cnt; i++)
-        device_remove_file(&connector->kdev, &connector_attrs[i]);
-    device_unregister(&connector->kdev);
+        device_remove_file(connector->kdev, &connector_attrs[i]);
+    put_device(connector->kdev);
+    device_unregister(connector->kdev);

 out:
     return ret;
@@ -480,16 +464,17 @@ void drm_sysfs_connector_remove(struct
drm_connector *connector)
 {
     int i;

-    if (!connector->kdev.parent)
+    if (!connector->kdev)
         return;
     DRM_DEBUG("removing \"%s\" from sysfs\n",
           drm_get_connector_name(connector));

     for (i = 0; i < ARRAY_SIZE(connector_attrs); i++)
-        device_remove_file(&connector->kdev, &connector_attrs[i]);
-    sysfs_remove_bin_file(&connector->kdev.kobj, &edid_attr);
-    device_unregister(&connector->kdev);
-    connector->kdev.parent = NULL;
+        device_remove_file(connector->kdev, &connector_attrs[i]);
+    sysfs_remove_bin_file(&connector->kdev->kobj, &edid_attr);
+    put_device(connector->kdev);
+    device_unregister(connector->kdev);
+    connector->kdev = NULL;
 }
 EXPORT_SYMBOL(drm_sysfs_connector_remove);

@@ -508,7 +493,7 @@ void drm_sysfs_hotplug_event(struct drm_device *dev)

     DRM_DEBUG("generating hotplug event\n");

-    kobject_uevent_env(&dev->primary->kdev.kobj, KOBJ_CHANGE, envp);
+    kobject_uevent_env(&dev->primary->kdev->kobj, KOBJ_CHANGE, envp);
 }
 EXPORT_SYMBOL(drm_sysfs_hotplug_event);

@@ -523,15 +508,8 @@ EXPORT_SYMBOL(drm_sysfs_hotplug_event);
  */
 int drm_sysfs_device_add(struct drm_minor *minor)
 {
-    int err;
     char *minor_str;

-    minor->kdev.parent = minor->dev->dev;
-
-    minor->kdev.class = drm_class;
-    minor->kdev.release = drm_sysfs_device_release;
-    minor->kdev.devt = minor->device;
-    minor->kdev.type = &drm_sysfs_device_minor;
     if (minor->type == DRM_MINOR_CONTROL)
         minor_str = "controlD%d";
         else if (minor->type == DRM_MINOR_RENDER)
@@ -539,18 +517,14 @@ int drm_sysfs_device_add(struct drm_minor *minor)
         else
                 minor_str = "card%d";

-    dev_set_name(&minor->kdev, minor_str, minor->index);
-
-    err = device_register(&minor->kdev);
-    if (err) {
-        DRM_ERROR("device add failed: %d\n", err);
-        goto err_out;
+    minor->kdev = device_create(drm_class, minor->dev->dev,
+                    MKDEV(DRM_MAJOR, minor->index),
+                    minor, minor_str, minor->index);
+    if (IS_ERR(minor->kdev)) {
+        DRM_ERROR("device create failed %ld\n", PTR_ERR(minor->kdev));
+        return PTR_ERR(minor->kdev);
     }
-
     return 0;
-
-err_out:
-    return err;
 }

 /**
@@ -562,9 +536,9 @@ err_out:
  */
 void drm_sysfs_device_remove(struct drm_minor *minor)
 {
-    if (minor->kdev.parent)
-        device_unregister(&minor->kdev);
-    minor->kdev.parent = NULL;
+    if (minor->kdev)
+        device_destroy(drm_class, MKDEV(DRM_MAJOR, minor->index));
+    minor->kdev = NULL;
 }


diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index b356dc1..8d133bf 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -933,7 +933,7 @@ static void ivybridge_parity_work(struct work_struct *work)
         parity_event[4] = kasprintf(GFP_KERNEL, "SLICE=%d", slice);
         parity_event[5] = NULL;

-        kobject_uevent_env(&dev_priv->dev->primary->kdev.kobj,
+        kobject_uevent_env(&dev_priv->dev->primary->kdev->kobj,
                    KOBJ_CHANGE, parity_event);

         DRM_DEBUG("Parity error: Slice = %d, Row = %d, Bank = %d, Sub
bank = %d.\n",
@@ -1530,7 +1530,7 @@ static void i915_error_work_func(struct work_struct *work)
     char *reset_done_event[] = { I915_ERROR_UEVENT "=0", NULL };
     int ret;

-    kobject_uevent_env(&dev->primary->kdev.kobj, KOBJ_CHANGE, error_event);
+    kobject_uevent_env(&dev->primary->kdev->kobj, KOBJ_CHANGE, error_event);

     /*
      * Note that there's only one work item which does gpu resets, so we
@@ -1544,7 +1544,7 @@ static void i915_error_work_func(struct work_struct *work)
      */
     if (i915_reset_in_progress(error) && !i915_terminally_wedged(error)) {
         DRM_DEBUG_DRIVER("resetting chip\n");
-        kobject_uevent_env(&dev->primary->kdev.kobj, KOBJ_CHANGE,
+        kobject_uevent_env(&dev->primary->kdev->kobj, KOBJ_CHANGE,
                    reset_event);

         /*
@@ -1571,7 +1571,7 @@ static void i915_error_work_func(struct work_struct *work)
             smp_mb__before_atomic_inc();
             atomic_inc(&dev_priv->gpu_error.reset_counter);

-            kobject_uevent_env(&dev->primary->kdev.kobj,
+            kobject_uevent_env(&dev->primary->kdev->kobj,
                        KOBJ_CHANGE, reset_done_event);
         } else {
             atomic_set(&error->reset_counter, I915_WEDGED);
diff --git a/drivers/gpu/drm/i915/i915_sysfs.c
b/drivers/gpu/drm/i915/i915_sysfs.c
index 44f4c1a..868aed8 100644
--- a/drivers/gpu/drm/i915/i915_sysfs.c
+++ b/drivers/gpu/drm/i915/i915_sysfs.c
@@ -48,14 +48,14 @@ static u32 calc_residency(struct drm_device *dev,
const u32 reg)
 static ssize_t
 show_rc6_mask(struct device *kdev, struct device_attribute *attr, char *buf)
 {
-    struct drm_minor *dminor = container_of(kdev, struct drm_minor, kdev);
+    struct drm_minor *dminor = dev_get_drvdata(kdev);
     return snprintf(buf, PAGE_SIZE, "%x\n", intel_enable_rc6(dminor->dev));
 }

 static ssize_t
 show_rc6_ms(struct device *kdev, struct device_attribute *attr, char *buf)
 {
-    struct drm_minor *dminor = container_of(kdev, struct drm_minor, kdev);
+    struct drm_minor *dminor = dev_get_drvdata(kdev);
     u32 rc6_residency = calc_residency(dminor->dev, GEN6_GT_GFX_RC6);
     return snprintf(buf, PAGE_SIZE, "%u\n", rc6_residency);
 }
@@ -63,7 +63,7 @@ show_rc6_ms(struct device *kdev, struct
device_attribute *attr, char *buf)
 static ssize_t
 show_rc6p_ms(struct device *kdev, struct device_attribute *attr, char *buf)
 {
-    struct drm_minor *dminor = container_of(kdev, struct drm_minor, kdev);
+    struct drm_minor *dminor = dev_get_drvdata(kdev);
     u32 rc6p_residency = calc_residency(dminor->dev, GEN6_GT_GFX_RC6p);
     if (IS_VALLEYVIEW(dminor->dev))
         rc6p_residency = 0;
@@ -73,7 +73,7 @@ show_rc6p_ms(struct device *kdev, struct
device_attribute *attr, char *buf)
 static ssize_t
 show_rc6pp_ms(struct device *kdev, struct device_attribute *attr, char *buf)
 {
-    struct drm_minor *dminor = container_of(kdev, struct drm_minor, kdev);
+    struct drm_minor *dminor = dev_get_drvdata(kdev);
     u32 rc6pp_residency = calc_residency(dminor->dev, GEN6_GT_GFX_RC6pp);
     if (IS_VALLEYVIEW(dminor->dev))
         rc6pp_residency = 0;
@@ -119,7 +119,7 @@ i915_l3_read(struct file *filp, struct kobject *kobj,
          loff_t offset, size_t count)
 {
     struct device *dev = container_of(kobj, struct device, kobj);
-    struct drm_minor *dminor = container_of(dev, struct drm_minor, kdev);
+    struct drm_minor *dminor = dev_get_drvdata(dev);
     struct drm_device *drm_dev = dminor->dev;
     struct drm_i915_private *dev_priv = drm_dev->dev_private;
     int slice = (int)(uintptr_t)attr->private;
@@ -155,7 +155,7 @@ i915_l3_write(struct file *filp, struct kobject *kobj,
           loff_t offset, size_t count)
 {
     struct device *dev = container_of(kobj, struct device, kobj);
-    struct drm_minor *dminor = container_of(dev, struct drm_minor, kdev);
+    struct drm_minor *dminor = dev_get_drvdata(dev);
     struct drm_device *drm_dev = dminor->dev;
     struct drm_i915_private *dev_priv = drm_dev->dev_private;
     struct i915_hw_context *ctx;
@@ -523,7 +523,7 @@ void i915_setup_sysfs(struct drm_device *dev)

 #ifdef CONFIG_PM
     if (INTEL_INFO(dev)->gen >= 6) {
-        ret = sysfs_merge_group(&dev->primary->kdev.kobj,
+        ret = sysfs_merge_group(&dev->primary->kdev->kobj,
                     &rc6_attr_group);
         if (ret)
             DRM_ERROR("RC6 residency sysfs setup failed\n");
@@ -544,13 +544,13 @@ void i915_setup_sysfs(struct drm_device *dev)

     ret = 0;
     if (IS_VALLEYVIEW(dev))
-        ret = sysfs_create_files(&dev->primary->kdev.kobj, vlv_attrs);
+        ret = sysfs_create_files(&dev->primary->kdev->kobj, vlv_attrs);
     else if (INTEL_INFO(dev)->gen >= 6)
-        ret = sysfs_create_files(&dev->primary->kdev.kobj, gen6_attrs);
+        ret = sysfs_create_files(&dev->primary->kdev->kobj, gen6_attrs);
     if (ret)
         DRM_ERROR("RPS sysfs setup failed\n");

-    ret = sysfs_create_bin_file(&dev->primary->kdev.kobj,
+    ret = sysfs_create_bin_file(&dev->primary->kdev->kobj,
                     &error_state_attr);
     if (ret)
         DRM_ERROR("error_state sysfs setup failed\n");
@@ -558,14 +558,14 @@ void i915_setup_sysfs(struct drm_device *dev)

 void i915_teardown_sysfs(struct drm_device *dev)
 {
-    sysfs_remove_bin_file(&dev->primary->kdev.kobj, &error_state_attr);
+    sysfs_remove_bin_file(&dev->primary->kdev->kobj, &error_state_attr);
     if (IS_VALLEYVIEW(dev))
-        sysfs_remove_files(&dev->primary->kdev.kobj, vlv_attrs);
+        sysfs_remove_files(&dev->primary->kdev->kobj, vlv_attrs);
     else
-        sysfs_remove_files(&dev->primary->kdev.kobj, gen6_attrs);
+        sysfs_remove_files(&dev->primary->kdev->kobj, gen6_attrs);
     device_remove_bin_file(&dev->primary->kdev,  &dpf_attrs_1);
     device_remove_bin_file(&dev->primary->kdev,  &dpf_attrs);
 #ifdef CONFIG_PM
-    sysfs_unmerge_group(&dev->primary->kdev.kobj, &rc6_attr_group);
+    sysfs_unmerge_group(&dev->primary->kdev->kobj, &rc6_attr_group);
 #endif
 }
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 9ba6a38..33eaba6 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1043,7 +1043,7 @@ struct drm_minor {
     int index;            /**< Minor device number */
     int type;                       /**< Control or render */
     dev_t device;            /**< Device number for mknod */
-    struct device kdev;        /**< Linux device */
+    struct device *kdev;        /**< Linux device */
     struct drm_device *dev;

     struct dentry *debugfs_root;
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 92e7820..c7ce4e2 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -587,7 +587,7 @@ enum drm_connector_force {
  */
 struct drm_connector {
     struct drm_device *dev;
-    struct device kdev;
+    struct device *kdev;
     struct device_attribute *attr;
     struct list_head head;

-- 
1.8.3.1

--001a11c3f40050b44c04e86f8e42
Content-Type: application/octet-stream; 
	name="0001-drm-sysfs-sort-out-minor-and-connector-device-object.patch"
Content-Disposition: attachment; 
	filename="0001-drm-sysfs-sort-out-minor-and-connector-device-object.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmmx00bo0

RnJvbSBiZTA2MjM1YjJkMmEyNmMwZTUyYzA5OWU3MDkyMmI3MWYxMjQ1YjllIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBGcmksIDExIE9jdCAyMDEzIDE0OjA3OjI1ICsxMDAwClN1YmplY3Q6IFtQQVRDSF0gZHJtL3N5
c2ZzOiBzb3J0IG91dCBtaW5vciBhbmQgY29ubmVjdG9yIGRldmljZSBvYmplY3QKIGxpZmV0aW1l
cy4KClNvIGRybSB3YXMgYWJ1c2luZyBkZXZpY2UgbGlmZXRpbWVzLCBieSBoYXZpbmcgZW1iZWRk
ZWQgZGV2aWNlIHN0cnVjdHVyZXMKaW4gdGhlIG1pbm9yIGFuZCBjb25uZWN0b3IgaXQgbWVhbnQg
dGhhdCB0aGUgbGlmZXRpbWUgb2YgdGhlIGludGVybmFsIGRybQpvYmplY3RzIChkcm1fbWlub3Ig
YW5kIGRybV9jb25uZWN0b3IpIHdlcmUgdGllZCB0byB0aGUgbGlmZXRpbWUgb2YgdGhlIGRldmlj
ZQpmaWxlcyBpbiBzeXNmcywgc28gaWYgc29tZXRoaW5nIGtlcHQgdGhvc2UgZmlsZXMgb3BlbmVk
IHRoZSBjdXJyZW50IGNvZGUKd291bGQga2ZyZWUgdGhlIG9iamVjdHMgYW5kIHRoaW5ncyB3b3Vs
ZCBnbyBkb3duaGlsbCBmcm9tIHRoZXJlLgoKTm93IGluIHJlYWxpdHkgdGhlcmUgaXMgbm8gbmVl
ZCBmb3IgdGhlc2UgbGlmZXRpbWVzIHRvIGJlIHNvIGludGVydHdpbmVkLAplc3BlY2FpbGx5IHdp
dGggaG90cGx1Z2dpbmcgb2YgZGV2aWNlcyB3aGVyZSB3ZSB3aXNoIHRvIHJlbW92ZSB0aGUgc3lz
ZnMKYW5kIHVzZXJzcGFjZSBmYWNpbmcgcGllY2VzIGJlZm9yZSB3ZSBjYW4gdW53aW5kIHRoZSBp
bnRlcm5hbCBvYmplY3RzIGR1ZQp0byBvcGVuIHVzZXJzcGFjZSBmaWxlcyBvciBtbWFwcywgc28g
c3BsaXQgdGhlIG9iamVjdHMgb3V0IHNvIHRoZSBzdHJ1Y3QKZGV2aWNlIGlzIG5vIGxvbmdlciBl
bWJlZGRlZCBhbmQgZG8gd2hhdCBmYmRldiBkb2VzIGFuZCBqdXN0IGFsbG9jYXRlCmFuZCByZW1v
dmUgdGhlIHN5c2ZzIGlub2RlcyBzZXBhcmF0ZWx5LgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBBaXJs
aWUgPGFpcmxpZWRAcmVkaGF0LmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vZHJtX3N5c2ZzLmMg
ICAgICAgfCA5NCArKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZl
cnMvZ3B1L2RybS9pOTE1L2k5MTVfaXJxLmMgICB8ICA4ICsrLS0KIGRyaXZlcnMvZ3B1L2RybS9p
OTE1L2k5MTVfc3lzZnMuYyB8IDI4ICsrKysrKy0tLS0tLQogaW5jbHVkZS9kcm0vZHJtUC5oICAg
ICAgICAgICAgICAgIHwgIDIgKy0KIGluY2x1ZGUvZHJtL2RybV9jcnRjLmggICAgICAgICAgICB8
ICAyICstCiA1IGZpbGVzIGNoYW5nZWQsIDU0IGluc2VydGlvbnMoKyksIDgwIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fc3lzZnMuYyBiL2RyaXZlcnMvZ3B1
L2RybS9kcm1fc3lzZnMuYwppbmRleCAyMjkwYjNiLi5kYWU0MmM3IDEwMDY0NAotLS0gYS9kcml2
ZXJzL2dwdS9kcm0vZHJtX3N5c2ZzLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2RybV9zeXNmcy5j
CkBAIC0yMiw4ICsyMiw4IEBACiAjaW5jbHVkZSA8ZHJtL2RybV9jb3JlLmg+CiAjaW5jbHVkZSA8
ZHJtL2RybVAuaD4KIAotI2RlZmluZSB0b19kcm1fbWlub3IoZCkgY29udGFpbmVyX29mKGQsIHN0
cnVjdCBkcm1fbWlub3IsIGtkZXYpCi0jZGVmaW5lIHRvX2RybV9jb25uZWN0b3IoZCkgY29udGFp
bmVyX29mKGQsIHN0cnVjdCBkcm1fY29ubmVjdG9yLCBrZGV2KQorI2RlZmluZSB0b19kcm1fbWlu
b3IoZCkgZGV2X2dldF9kcnZkYXRhKGQpCisjZGVmaW5lIHRvX2RybV9jb25uZWN0b3IoZCkgZGV2
X2dldF9kcnZkYXRhKGQpCiAKIHN0YXRpYyBzdHJ1Y3QgZGV2aWNlX3R5cGUgZHJtX3N5c2ZzX2Rl
dmljZV9taW5vciA9IHsKIAkubmFtZSA9ICJkcm1fbWlub3IiCkBAIC0xNjIsMjAgKzE2Miw2IEBA
IHZvaWQgZHJtX3N5c2ZzX2Rlc3Ryb3kodm9pZCkKIAlkcm1fY2xhc3MgPSBOVUxMOwogfQogCi0v
KioKLSAqIGRybV9zeXNmc19kZXZpY2VfcmVsZWFzZSAtIGRvIG5vdGhpbmcKLSAqIEBkZXY6IExp
bnV4IGRldmljZQotICoKLSAqIE5vcm1hbGx5LCB0aGlzIHdvdWxkIGZyZWUgdGhlIERSTSBkZXZp
Y2UgYXNzb2NpYXRlZCB3aXRoIEBkZXYsIGFsb25nCi0gKiB3aXRoIGNsZWFuaW5nIHVwIGFueSBv
dGhlciBzdHVmZi4gIEJ1dCB3ZSBkbyB0aGF0IGluIHRoZSBEUk0gY29yZSwgc28KLSAqIHRoaXMg
ZnVuY3Rpb24gY2FuIGp1c3QgcmV0dXJuIGFuZCBob3BlIHRoYXQgdGhlIGNvcmUgZG9lcyBpdHMg
am9iLgotICovCi1zdGF0aWMgdm9pZCBkcm1fc3lzZnNfZGV2aWNlX3JlbGVhc2Uoc3RydWN0IGRl
dmljZSAqZGV2KQotewotCW1lbXNldChkZXYsIDAsIHNpemVvZihzdHJ1Y3QgZGV2aWNlKSk7Ci0J
cmV0dXJuOwotfQotCiAvKgogICogQ29ubmVjdG9yIHByb3BlcnRpZXMKICAqLwpAQCAtMzk0LDI5
ICszODAsMjYgQEAgaW50IGRybV9zeXNmc19jb25uZWN0b3JfYWRkKHN0cnVjdCBkcm1fY29ubmVj
dG9yICpjb25uZWN0b3IpCiAJaW50IGk7CiAJaW50IHJldDsKIAotCS8qIFdlIHNob3VsZG4ndCBn
ZXQgY2FsbGVkIG1vcmUgdGhhbiBvbmNlIGZvciB0aGUgc2FtZSBjb25uZWN0b3IgKi8KLQlCVUdf
T04oZGV2aWNlX2lzX3JlZ2lzdGVyZWQoJmNvbm5lY3Rvci0+a2RldikpOwotCi0JY29ubmVjdG9y
LT5rZGV2LnBhcmVudCA9ICZkZXYtPnByaW1hcnktPmtkZXY7Ci0JY29ubmVjdG9yLT5rZGV2LmNs
YXNzID0gZHJtX2NsYXNzOwotCWNvbm5lY3Rvci0+a2Rldi5yZWxlYXNlID0gZHJtX3N5c2ZzX2Rl
dmljZV9yZWxlYXNlOworCWlmIChjb25uZWN0b3ItPmtkZXYpCisJCXJldHVybiAwOwogCisJLyog
V2Ugc2hvdWxkbid0IGdldCBjYWxsZWQgbW9yZSB0aGFuIG9uY2UgZm9yIHRoZSBzYW1lIGNvbm5l
Y3RvciAqLworCWNvbm5lY3Rvci0+a2RldiA9IGRldmljZV9jcmVhdGUoZHJtX2NsYXNzLCBkZXYt
PnByaW1hcnktPmtkZXYsCisJCQkJCTAsIGNvbm5lY3RvciwgImNhcmQlZC0lcyIsCisJCQkJCWRl
di0+cHJpbWFyeS0+aW5kZXgsIGRybV9nZXRfY29ubmVjdG9yX25hbWUoY29ubmVjdG9yKSk7CiAJ
RFJNX0RFQlVHKCJhZGRpbmcgXCIlc1wiIHRvIHN5c2ZzXG4iLAogCQkgIGRybV9nZXRfY29ubmVj
dG9yX25hbWUoY29ubmVjdG9yKSk7CiAKLQlkZXZfc2V0X25hbWUoJmNvbm5lY3Rvci0+a2Rldiwg
ImNhcmQlZC0lcyIsCi0JCSAgICAgZGV2LT5wcmltYXJ5LT5pbmRleCwgZHJtX2dldF9jb25uZWN0
b3JfbmFtZShjb25uZWN0b3IpKTsKLQlyZXQgPSBkZXZpY2VfcmVnaXN0ZXIoJmNvbm5lY3Rvci0+
a2Rldik7Ci0KLQlpZiAocmV0KSB7Ci0JCURSTV9FUlJPUigiZmFpbGVkIHRvIHJlZ2lzdGVyIGNv
bm5lY3RvciBkZXZpY2U6ICVkXG4iLCByZXQpOworCWlmIChJU19FUlIoY29ubmVjdG9yLT5rZGV2
KSkgeworCQlEUk1fRVJST1IoImZhaWxlZCB0byByZWdpc3RlciBjb25uZWN0b3IgZGV2aWNlOiAl
bGRcbiIsIFBUUl9FUlIoY29ubmVjdG9yLT5rZGV2KSk7CisJCXJldCA9IFBUUl9FUlIoY29ubmVj
dG9yLT5rZGV2KTsKIAkJZ290byBvdXQ7CiAJfQogCiAJLyogU3RhbmRhcmQgYXR0cmlidXRlcyAq
LwogCiAJZm9yIChhdHRyX2NudCA9IDA7IGF0dHJfY250IDwgQVJSQVlfU0laRShjb25uZWN0b3Jf
YXR0cnMpOyBhdHRyX2NudCsrKSB7Ci0JCXJldCA9IGRldmljZV9jcmVhdGVfZmlsZSgmY29ubmVj
dG9yLT5rZGV2LCAmY29ubmVjdG9yX2F0dHJzW2F0dHJfY250XSk7CisJCXJldCA9IGRldmljZV9j
cmVhdGVfZmlsZShjb25uZWN0b3ItPmtkZXYsICZjb25uZWN0b3JfYXR0cnNbYXR0cl9jbnRdKTsK
IAkJaWYgKHJldCkKIAkJCWdvdG8gZXJyX291dF9maWxlczsKIAl9CkBAIC00MzMsNyArNDE2LDcg
QEAgaW50IGRybV9zeXNmc19jb25uZWN0b3JfYWRkKHN0cnVjdCBkcm1fY29ubmVjdG9yICpjb25u
ZWN0b3IpCiAJCWNhc2UgRFJNX01PREVfQ09OTkVDVE9SX0NvbXBvbmVudDoKIAkJY2FzZSBEUk1f
TU9ERV9DT05ORUNUT1JfVFY6CiAJCQlmb3IgKG9wdF9jbnQgPSAwOyBvcHRfY250IDwgQVJSQVlf
U0laRShjb25uZWN0b3JfYXR0cnNfb3B0MSk7IG9wdF9jbnQrKykgewotCQkJCXJldCA9IGRldmlj
ZV9jcmVhdGVfZmlsZSgmY29ubmVjdG9yLT5rZGV2LCAmY29ubmVjdG9yX2F0dHJzX29wdDFbb3B0
X2NudF0pOworCQkJCXJldCA9IGRldmljZV9jcmVhdGVfZmlsZShjb25uZWN0b3ItPmtkZXYsICZj
b25uZWN0b3JfYXR0cnNfb3B0MVtvcHRfY250XSk7CiAJCQkJaWYgKHJldCkKIAkJCQkJZ290byBl
cnJfb3V0X2ZpbGVzOwogCQkJfQpAQCAtNDQyLDcgKzQyNSw3IEBAIGludCBkcm1fc3lzZnNfY29u
bmVjdG9yX2FkZChzdHJ1Y3QgZHJtX2Nvbm5lY3RvciAqY29ubmVjdG9yKQogCQkJYnJlYWs7CiAJ
fQogCi0JcmV0ID0gc3lzZnNfY3JlYXRlX2Jpbl9maWxlKCZjb25uZWN0b3ItPmtkZXYua29iaiwg
JmVkaWRfYXR0cik7CisJcmV0ID0gc3lzZnNfY3JlYXRlX2Jpbl9maWxlKCZjb25uZWN0b3ItPmtk
ZXYtPmtvYmosICZlZGlkX2F0dHIpOwogCWlmIChyZXQpCiAJCWdvdG8gZXJyX291dF9maWxlczsK
IApAQCAtNDUzLDEwICs0MzYsMTEgQEAgaW50IGRybV9zeXNmc19jb25uZWN0b3JfYWRkKHN0cnVj
dCBkcm1fY29ubmVjdG9yICpjb25uZWN0b3IpCiAKIGVycl9vdXRfZmlsZXM6CiAJZm9yIChpID0g
MDsgaSA8IG9wdF9jbnQ7IGkrKykKLQkJZGV2aWNlX3JlbW92ZV9maWxlKCZjb25uZWN0b3ItPmtk
ZXYsICZjb25uZWN0b3JfYXR0cnNfb3B0MVtpXSk7CisJCWRldmljZV9yZW1vdmVfZmlsZShjb25u
ZWN0b3ItPmtkZXYsICZjb25uZWN0b3JfYXR0cnNfb3B0MVtpXSk7CiAJZm9yIChpID0gMDsgaSA8
IGF0dHJfY250OyBpKyspCi0JCWRldmljZV9yZW1vdmVfZmlsZSgmY29ubmVjdG9yLT5rZGV2LCAm
Y29ubmVjdG9yX2F0dHJzW2ldKTsKLQlkZXZpY2VfdW5yZWdpc3RlcigmY29ubmVjdG9yLT5rZGV2
KTsKKwkJZGV2aWNlX3JlbW92ZV9maWxlKGNvbm5lY3Rvci0+a2RldiwgJmNvbm5lY3Rvcl9hdHRy
c1tpXSk7CisJcHV0X2RldmljZShjb25uZWN0b3ItPmtkZXYpOworCWRldmljZV91bnJlZ2lzdGVy
KGNvbm5lY3Rvci0+a2Rldik7CiAKIG91dDoKIAlyZXR1cm4gcmV0OwpAQCAtNDgwLDE2ICs0NjQs
MTcgQEAgdm9pZCBkcm1fc3lzZnNfY29ubmVjdG9yX3JlbW92ZShzdHJ1Y3QgZHJtX2Nvbm5lY3Rv
ciAqY29ubmVjdG9yKQogewogCWludCBpOwogCi0JaWYgKCFjb25uZWN0b3ItPmtkZXYucGFyZW50
KQorCWlmICghY29ubmVjdG9yLT5rZGV2KQogCQlyZXR1cm47CiAJRFJNX0RFQlVHKCJyZW1vdmlu
ZyBcIiVzXCIgZnJvbSBzeXNmc1xuIiwKIAkJICBkcm1fZ2V0X2Nvbm5lY3Rvcl9uYW1lKGNvbm5l
Y3RvcikpOwogCiAJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoY29ubmVjdG9yX2F0dHJzKTsg
aSsrKQotCQlkZXZpY2VfcmVtb3ZlX2ZpbGUoJmNvbm5lY3Rvci0+a2RldiwgJmNvbm5lY3Rvcl9h
dHRyc1tpXSk7Ci0Jc3lzZnNfcmVtb3ZlX2Jpbl9maWxlKCZjb25uZWN0b3ItPmtkZXYua29iaiwg
JmVkaWRfYXR0cik7Ci0JZGV2aWNlX3VucmVnaXN0ZXIoJmNvbm5lY3Rvci0+a2Rldik7Ci0JY29u
bmVjdG9yLT5rZGV2LnBhcmVudCA9IE5VTEw7CisJCWRldmljZV9yZW1vdmVfZmlsZShjb25uZWN0
b3ItPmtkZXYsICZjb25uZWN0b3JfYXR0cnNbaV0pOworCXN5c2ZzX3JlbW92ZV9iaW5fZmlsZSgm
Y29ubmVjdG9yLT5rZGV2LT5rb2JqLCAmZWRpZF9hdHRyKTsKKwlwdXRfZGV2aWNlKGNvbm5lY3Rv
ci0+a2Rldik7CisJZGV2aWNlX3VucmVnaXN0ZXIoY29ubmVjdG9yLT5rZGV2KTsKKwljb25uZWN0
b3ItPmtkZXYgPSBOVUxMOwogfQogRVhQT1JUX1NZTUJPTChkcm1fc3lzZnNfY29ubmVjdG9yX3Jl
bW92ZSk7CiAKQEAgLTUwOCw3ICs0OTMsNyBAQCB2b2lkIGRybV9zeXNmc19ob3RwbHVnX2V2ZW50
KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpCiAKIAlEUk1fREVCVUcoImdlbmVyYXRpbmcgaG90cGx1
ZyBldmVudFxuIik7CiAKLQlrb2JqZWN0X3VldmVudF9lbnYoJmRldi0+cHJpbWFyeS0+a2Rldi5r
b2JqLCBLT0JKX0NIQU5HRSwgZW52cCk7CisJa29iamVjdF91ZXZlbnRfZW52KCZkZXYtPnByaW1h
cnktPmtkZXYtPmtvYmosIEtPQkpfQ0hBTkdFLCBlbnZwKTsKIH0KIEVYUE9SVF9TWU1CT0woZHJt
X3N5c2ZzX2hvdHBsdWdfZXZlbnQpOwogCkBAIC01MjMsMTUgKzUwOCw4IEBAIEVYUE9SVF9TWU1C
T0woZHJtX3N5c2ZzX2hvdHBsdWdfZXZlbnQpOwogICovCiBpbnQgZHJtX3N5c2ZzX2RldmljZV9h
ZGQoc3RydWN0IGRybV9taW5vciAqbWlub3IpCiB7Ci0JaW50IGVycjsKIAljaGFyICptaW5vcl9z
dHI7CiAKLQltaW5vci0+a2Rldi5wYXJlbnQgPSBtaW5vci0+ZGV2LT5kZXY7Ci0KLQltaW5vci0+
a2Rldi5jbGFzcyA9IGRybV9jbGFzczsKLQltaW5vci0+a2Rldi5yZWxlYXNlID0gZHJtX3N5c2Zz
X2RldmljZV9yZWxlYXNlOwotCW1pbm9yLT5rZGV2LmRldnQgPSBtaW5vci0+ZGV2aWNlOwotCW1p
bm9yLT5rZGV2LnR5cGUgPSAmZHJtX3N5c2ZzX2RldmljZV9taW5vcjsKIAlpZiAobWlub3ItPnR5
cGUgPT0gRFJNX01JTk9SX0NPTlRST0wpCiAJCW1pbm9yX3N0ciA9ICJjb250cm9sRCVkIjsKICAg
ICAgICAgZWxzZSBpZiAobWlub3ItPnR5cGUgPT0gRFJNX01JTk9SX1JFTkRFUikKQEAgLTUzOSwx
OCArNTE3LDE0IEBAIGludCBkcm1fc3lzZnNfZGV2aWNlX2FkZChzdHJ1Y3QgZHJtX21pbm9yICpt
aW5vcikKICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAgIG1pbm9yX3N0ciA9ICJjYXJkJWQi
OwogCi0JZGV2X3NldF9uYW1lKCZtaW5vci0+a2RldiwgbWlub3Jfc3RyLCBtaW5vci0+aW5kZXgp
OwotCi0JZXJyID0gZGV2aWNlX3JlZ2lzdGVyKCZtaW5vci0+a2Rldik7Ci0JaWYgKGVycikgewot
CQlEUk1fRVJST1IoImRldmljZSBhZGQgZmFpbGVkOiAlZFxuIiwgZXJyKTsKLQkJZ290byBlcnJf
b3V0OworCW1pbm9yLT5rZGV2ID0gZGV2aWNlX2NyZWF0ZShkcm1fY2xhc3MsIG1pbm9yLT5kZXYt
PmRldiwKKwkJCQkgICAgTUtERVYoRFJNX01BSk9SLCBtaW5vci0+aW5kZXgpLAorCQkJCSAgICBt
aW5vciwgbWlub3Jfc3RyLCBtaW5vci0+aW5kZXgpOworCWlmIChJU19FUlIobWlub3ItPmtkZXYp
KSB7CisJCURSTV9FUlJPUigiZGV2aWNlIGNyZWF0ZSBmYWlsZWQgJWxkXG4iLCBQVFJfRVJSKG1p
bm9yLT5rZGV2KSk7CisJCXJldHVybiBQVFJfRVJSKG1pbm9yLT5rZGV2KTsKIAl9Ci0KIAlyZXR1
cm4gMDsKLQotZXJyX291dDoKLQlyZXR1cm4gZXJyOwogfQogCiAvKioKQEAgLTU2Miw5ICs1MzYs
OSBAQCBlcnJfb3V0OgogICovCiB2b2lkIGRybV9zeXNmc19kZXZpY2VfcmVtb3ZlKHN0cnVjdCBk
cm1fbWlub3IgKm1pbm9yKQogewotCWlmIChtaW5vci0+a2Rldi5wYXJlbnQpCi0JCWRldmljZV91
bnJlZ2lzdGVyKCZtaW5vci0+a2Rldik7Ci0JbWlub3ItPmtkZXYucGFyZW50ID0gTlVMTDsKKwlp
ZiAobWlub3ItPmtkZXYpCisJCWRldmljZV9kZXN0cm95KGRybV9jbGFzcywgTUtERVYoRFJNX01B
Sk9SLCBtaW5vci0+aW5kZXgpKTsKKwltaW5vci0+a2RldiA9IE5VTEw7CiB9CiAKIApkaWZmIC0t
Z2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9pcnEuYyBiL2RyaXZlcnMvZ3B1L2RybS9p
OTE1L2k5MTVfaXJxLmMKaW5kZXggYjM1NmRjMS4uOGQxMzNiZiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9ncHUvZHJtL2k5MTUvaTkxNV9pcnEuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1
X2lycS5jCkBAIC05MzMsNyArOTMzLDcgQEAgc3RhdGljIHZvaWQgaXZ5YnJpZGdlX3Bhcml0eV93
b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJcGFyaXR5X2V2ZW50WzRdID0ga2FzcHJp
bnRmKEdGUF9LRVJORUwsICJTTElDRT0lZCIsIHNsaWNlKTsKIAkJcGFyaXR5X2V2ZW50WzVdID0g
TlVMTDsKIAotCQlrb2JqZWN0X3VldmVudF9lbnYoJmRldl9wcml2LT5kZXYtPnByaW1hcnktPmtk
ZXYua29iaiwKKwkJa29iamVjdF91ZXZlbnRfZW52KCZkZXZfcHJpdi0+ZGV2LT5wcmltYXJ5LT5r
ZGV2LT5rb2JqLAogCQkJCSAgIEtPQkpfQ0hBTkdFLCBwYXJpdHlfZXZlbnQpOwogCiAJCURSTV9E
RUJVRygiUGFyaXR5IGVycm9yOiBTbGljZSA9ICVkLCBSb3cgPSAlZCwgQmFuayA9ICVkLCBTdWIg
YmFuayA9ICVkLlxuIiwKQEAgLTE1MzAsNyArMTUzMCw3IEBAIHN0YXRpYyB2b2lkIGk5MTVfZXJy
b3Jfd29ya19mdW5jKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAljaGFyICpyZXNldF9kb25l
X2V2ZW50W10gPSB7IEk5MTVfRVJST1JfVUVWRU5UICI9MCIsIE5VTEwgfTsKIAlpbnQgcmV0Owog
Ci0Ja29iamVjdF91ZXZlbnRfZW52KCZkZXYtPnByaW1hcnktPmtkZXYua29iaiwgS09CSl9DSEFO
R0UsIGVycm9yX2V2ZW50KTsKKwlrb2JqZWN0X3VldmVudF9lbnYoJmRldi0+cHJpbWFyeS0+a2Rl
di0+a29iaiwgS09CSl9DSEFOR0UsIGVycm9yX2V2ZW50KTsKIAogCS8qCiAJICogTm90ZSB0aGF0
IHRoZXJlJ3Mgb25seSBvbmUgd29yayBpdGVtIHdoaWNoIGRvZXMgZ3B1IHJlc2V0cywgc28gd2UK
QEAgLTE1NDQsNyArMTU0NCw3IEBAIHN0YXRpYyB2b2lkIGk5MTVfZXJyb3Jfd29ya19mdW5jKHN0
cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkgKi8KIAlpZiAoaTkxNV9yZXNldF9pbl9wcm9ncmVz
cyhlcnJvcikgJiYgIWk5MTVfdGVybWluYWxseV93ZWRnZWQoZXJyb3IpKSB7CiAJCURSTV9ERUJV
R19EUklWRVIoInJlc2V0dGluZyBjaGlwXG4iKTsKLQkJa29iamVjdF91ZXZlbnRfZW52KCZkZXYt
PnByaW1hcnktPmtkZXYua29iaiwgS09CSl9DSEFOR0UsCisJCWtvYmplY3RfdWV2ZW50X2Vudigm
ZGV2LT5wcmltYXJ5LT5rZGV2LT5rb2JqLCBLT0JKX0NIQU5HRSwKIAkJCQkgICByZXNldF9ldmVu
dCk7CiAKIAkJLyoKQEAgLTE1NzEsNyArMTU3MSw3IEBAIHN0YXRpYyB2b2lkIGk5MTVfZXJyb3Jf
d29ya19mdW5jKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJCXNtcF9tYl9fYmVmb3JlX2F0
b21pY19pbmMoKTsKIAkJCWF0b21pY19pbmMoJmRldl9wcml2LT5ncHVfZXJyb3IucmVzZXRfY291
bnRlcik7CiAKLQkJCWtvYmplY3RfdWV2ZW50X2VudigmZGV2LT5wcmltYXJ5LT5rZGV2LmtvYmos
CisJCQlrb2JqZWN0X3VldmVudF9lbnYoJmRldi0+cHJpbWFyeS0+a2Rldi0+a29iaiwKIAkJCQkJ
ICAgS09CSl9DSEFOR0UsIHJlc2V0X2RvbmVfZXZlbnQpOwogCQl9IGVsc2UgewogCQkJYXRvbWlj
X3NldCgmZXJyb3ItPnJlc2V0X2NvdW50ZXIsIEk5MTVfV0VER0VEKTsKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfc3lzZnMuYyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5
MTVfc3lzZnMuYwppbmRleCA0NGY0YzFhLi44NjhhZWQ4IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pOTE1X3N5c2ZzLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9z
eXNmcy5jCkBAIC00OCwxNCArNDgsMTQgQEAgc3RhdGljIHUzMiBjYWxjX3Jlc2lkZW5jeShzdHJ1
Y3QgZHJtX2RldmljZSAqZGV2LCBjb25zdCB1MzIgcmVnKQogc3RhdGljIHNzaXplX3QKIHNob3df
cmM2X21hc2soc3RydWN0IGRldmljZSAqa2Rldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0
dHIsIGNoYXIgKmJ1ZikKIHsKLQlzdHJ1Y3QgZHJtX21pbm9yICpkbWlub3IgPSBjb250YWluZXJf
b2Yoa2Rldiwgc3RydWN0IGRybV9taW5vciwga2Rldik7CisJc3RydWN0IGRybV9taW5vciAqZG1p
bm9yID0gZGV2X2dldF9kcnZkYXRhKGtkZXYpOwogCXJldHVybiBzbnByaW50ZihidWYsIFBBR0Vf
U0laRSwgIiV4XG4iLCBpbnRlbF9lbmFibGVfcmM2KGRtaW5vci0+ZGV2KSk7CiB9CiAKIHN0YXRp
YyBzc2l6ZV90CiBzaG93X3JjNl9tcyhzdHJ1Y3QgZGV2aWNlICprZGV2LCBzdHJ1Y3QgZGV2aWNl
X2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQogewotCXN0cnVjdCBkcm1fbWlub3IgKmRtaW5v
ciA9IGNvbnRhaW5lcl9vZihrZGV2LCBzdHJ1Y3QgZHJtX21pbm9yLCBrZGV2KTsKKwlzdHJ1Y3Qg
ZHJtX21pbm9yICpkbWlub3IgPSBkZXZfZ2V0X2RydmRhdGEoa2Rldik7CiAJdTMyIHJjNl9yZXNp
ZGVuY3kgPSBjYWxjX3Jlc2lkZW5jeShkbWlub3ItPmRldiwgR0VONl9HVF9HRlhfUkM2KTsKIAly
ZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsICIldVxuIiwgcmM2X3Jlc2lkZW5jeSk7CiB9
CkBAIC02Myw3ICs2Myw3IEBAIHNob3dfcmM2X21zKHN0cnVjdCBkZXZpY2UgKmtkZXYsIHN0cnVj
dCBkZXZpY2VfYXR0cmlidXRlICphdHRyLCBjaGFyICpidWYpCiBzdGF0aWMgc3NpemVfdAogc2hv
d19yYzZwX21zKHN0cnVjdCBkZXZpY2UgKmtkZXYsIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICph
dHRyLCBjaGFyICpidWYpCiB7Ci0Jc3RydWN0IGRybV9taW5vciAqZG1pbm9yID0gY29udGFpbmVy
X29mKGtkZXYsIHN0cnVjdCBkcm1fbWlub3IsIGtkZXYpOworCXN0cnVjdCBkcm1fbWlub3IgKmRt
aW5vciA9IGRldl9nZXRfZHJ2ZGF0YShrZGV2KTsKIAl1MzIgcmM2cF9yZXNpZGVuY3kgPSBjYWxj
X3Jlc2lkZW5jeShkbWlub3ItPmRldiwgR0VONl9HVF9HRlhfUkM2cCk7CiAJaWYgKElTX1ZBTExF
WVZJRVcoZG1pbm9yLT5kZXYpKQogCQlyYzZwX3Jlc2lkZW5jeSA9IDA7CkBAIC03Myw3ICs3Myw3
IEBAIHNob3dfcmM2cF9tcyhzdHJ1Y3QgZGV2aWNlICprZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJp
YnV0ZSAqYXR0ciwgY2hhciAqYnVmKQogc3RhdGljIHNzaXplX3QKIHNob3dfcmM2cHBfbXMoc3Ry
dWN0IGRldmljZSAqa2Rldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1
ZikKIHsKLQlzdHJ1Y3QgZHJtX21pbm9yICpkbWlub3IgPSBjb250YWluZXJfb2Yoa2Rldiwgc3Ry
dWN0IGRybV9taW5vciwga2Rldik7CisJc3RydWN0IGRybV9taW5vciAqZG1pbm9yID0gZGV2X2dl
dF9kcnZkYXRhKGtkZXYpOwogCXUzMiByYzZwcF9yZXNpZGVuY3kgPSBjYWxjX3Jlc2lkZW5jeShk
bWlub3ItPmRldiwgR0VONl9HVF9HRlhfUkM2cHApOwogCWlmIChJU19WQUxMRVlWSUVXKGRtaW5v
ci0+ZGV2KSkKIAkJcmM2cHBfcmVzaWRlbmN5ID0gMDsKQEAgLTExOSw3ICsxMTksNyBAQCBpOTE1
X2wzX3JlYWQoc3RydWN0IGZpbGUgKmZpbHAsIHN0cnVjdCBrb2JqZWN0ICprb2JqLAogCSAgICAg
bG9mZl90IG9mZnNldCwgc2l6ZV90IGNvdW50KQogewogCXN0cnVjdCBkZXZpY2UgKmRldiA9IGNv
bnRhaW5lcl9vZihrb2JqLCBzdHJ1Y3QgZGV2aWNlLCBrb2JqKTsKLQlzdHJ1Y3QgZHJtX21pbm9y
ICpkbWlub3IgPSBjb250YWluZXJfb2YoZGV2LCBzdHJ1Y3QgZHJtX21pbm9yLCBrZGV2KTsKKwlz
dHJ1Y3QgZHJtX21pbm9yICpkbWlub3IgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsKIAlzdHJ1Y3Qg
ZHJtX2RldmljZSAqZHJtX2RldiA9IGRtaW5vci0+ZGV2OwogCXN0cnVjdCBkcm1faTkxNV9wcml2
YXRlICpkZXZfcHJpdiA9IGRybV9kZXYtPmRldl9wcml2YXRlOwogCWludCBzbGljZSA9IChpbnQp
KHVpbnRwdHJfdClhdHRyLT5wcml2YXRlOwpAQCAtMTU1LDcgKzE1NSw3IEBAIGk5MTVfbDNfd3Jp
dGUoc3RydWN0IGZpbGUgKmZpbHAsIHN0cnVjdCBrb2JqZWN0ICprb2JqLAogCSAgICAgIGxvZmZf
dCBvZmZzZXQsIHNpemVfdCBjb3VudCkKIHsKIAlzdHJ1Y3QgZGV2aWNlICpkZXYgPSBjb250YWlu
ZXJfb2Yoa29iaiwgc3RydWN0IGRldmljZSwga29iaik7Ci0Jc3RydWN0IGRybV9taW5vciAqZG1p
bm9yID0gY29udGFpbmVyX29mKGRldiwgc3RydWN0IGRybV9taW5vciwga2Rldik7CisJc3RydWN0
IGRybV9taW5vciAqZG1pbm9yID0gZGV2X2dldF9kcnZkYXRhKGRldik7CiAJc3RydWN0IGRybV9k
ZXZpY2UgKmRybV9kZXYgPSBkbWlub3ItPmRldjsKIAlzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAq
ZGV2X3ByaXYgPSBkcm1fZGV2LT5kZXZfcHJpdmF0ZTsKIAlzdHJ1Y3QgaTkxNV9od19jb250ZXh0
ICpjdHg7CkBAIC01MjMsNyArNTIzLDcgQEAgdm9pZCBpOTE1X3NldHVwX3N5c2ZzKHN0cnVjdCBk
cm1fZGV2aWNlICpkZXYpCiAKICNpZmRlZiBDT05GSUdfUE0KIAlpZiAoSU5URUxfSU5GTyhkZXYp
LT5nZW4gPj0gNikgewotCQlyZXQgPSBzeXNmc19tZXJnZV9ncm91cCgmZGV2LT5wcmltYXJ5LT5r
ZGV2LmtvYmosCisJCXJldCA9IHN5c2ZzX21lcmdlX2dyb3VwKCZkZXYtPnByaW1hcnktPmtkZXYt
PmtvYmosCiAJCQkJCSZyYzZfYXR0cl9ncm91cCk7CiAJCWlmIChyZXQpCiAJCQlEUk1fRVJST1Io
IlJDNiByZXNpZGVuY3kgc3lzZnMgc2V0dXAgZmFpbGVkXG4iKTsKQEAgLTU0NCwxMyArNTQ0LDEz
IEBAIHZvaWQgaTkxNV9zZXR1cF9zeXNmcyhzdHJ1Y3QgZHJtX2RldmljZSAqZGV2KQogCiAJcmV0
ID0gMDsKIAlpZiAoSVNfVkFMTEVZVklFVyhkZXYpKQotCQlyZXQgPSBzeXNmc19jcmVhdGVfZmls
ZXMoJmRldi0+cHJpbWFyeS0+a2Rldi5rb2JqLCB2bHZfYXR0cnMpOworCQlyZXQgPSBzeXNmc19j
cmVhdGVfZmlsZXMoJmRldi0+cHJpbWFyeS0+a2Rldi0+a29iaiwgdmx2X2F0dHJzKTsKIAllbHNl
IGlmIChJTlRFTF9JTkZPKGRldiktPmdlbiA+PSA2KQotCQlyZXQgPSBzeXNmc19jcmVhdGVfZmls
ZXMoJmRldi0+cHJpbWFyeS0+a2Rldi5rb2JqLCBnZW42X2F0dHJzKTsKKwkJcmV0ID0gc3lzZnNf
Y3JlYXRlX2ZpbGVzKCZkZXYtPnByaW1hcnktPmtkZXYtPmtvYmosIGdlbjZfYXR0cnMpOwogCWlm
IChyZXQpCiAJCURSTV9FUlJPUigiUlBTIHN5c2ZzIHNldHVwIGZhaWxlZFxuIik7CiAKLQlyZXQg
PSBzeXNmc19jcmVhdGVfYmluX2ZpbGUoJmRldi0+cHJpbWFyeS0+a2Rldi5rb2JqLAorCXJldCA9
IHN5c2ZzX2NyZWF0ZV9iaW5fZmlsZSgmZGV2LT5wcmltYXJ5LT5rZGV2LT5rb2JqLAogCQkJCSAg
ICAmZXJyb3Jfc3RhdGVfYXR0cik7CiAJaWYgKHJldCkKIAkJRFJNX0VSUk9SKCJlcnJvcl9zdGF0
ZSBzeXNmcyBzZXR1cCBmYWlsZWRcbiIpOwpAQCAtNTU4LDE0ICs1NTgsMTQgQEAgdm9pZCBpOTE1
X3NldHVwX3N5c2ZzKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpCiAKIHZvaWQgaTkxNV90ZWFyZG93
bl9zeXNmcyhzdHJ1Y3QgZHJtX2RldmljZSAqZGV2KQogewotCXN5c2ZzX3JlbW92ZV9iaW5fZmls
ZSgmZGV2LT5wcmltYXJ5LT5rZGV2LmtvYmosICZlcnJvcl9zdGF0ZV9hdHRyKTsKKwlzeXNmc19y
ZW1vdmVfYmluX2ZpbGUoJmRldi0+cHJpbWFyeS0+a2Rldi0+a29iaiwgJmVycm9yX3N0YXRlX2F0
dHIpOwogCWlmIChJU19WQUxMRVlWSUVXKGRldikpCi0JCXN5c2ZzX3JlbW92ZV9maWxlcygmZGV2
LT5wcmltYXJ5LT5rZGV2LmtvYmosIHZsdl9hdHRycyk7CisJCXN5c2ZzX3JlbW92ZV9maWxlcygm
ZGV2LT5wcmltYXJ5LT5rZGV2LT5rb2JqLCB2bHZfYXR0cnMpOwogCWVsc2UKLQkJc3lzZnNfcmVt
b3ZlX2ZpbGVzKCZkZXYtPnByaW1hcnktPmtkZXYua29iaiwgZ2VuNl9hdHRycyk7CisJCXN5c2Zz
X3JlbW92ZV9maWxlcygmZGV2LT5wcmltYXJ5LT5rZGV2LT5rb2JqLCBnZW42X2F0dHJzKTsKIAlk
ZXZpY2VfcmVtb3ZlX2Jpbl9maWxlKCZkZXYtPnByaW1hcnktPmtkZXYsICAmZHBmX2F0dHJzXzEp
OwogCWRldmljZV9yZW1vdmVfYmluX2ZpbGUoJmRldi0+cHJpbWFyeS0+a2RldiwgICZkcGZfYXR0
cnMpOwogI2lmZGVmIENPTkZJR19QTQotCXN5c2ZzX3VubWVyZ2VfZ3JvdXAoJmRldi0+cHJpbWFy
eS0+a2Rldi5rb2JqLCAmcmM2X2F0dHJfZ3JvdXApOworCXN5c2ZzX3VubWVyZ2VfZ3JvdXAoJmRl
di0+cHJpbWFyeS0+a2Rldi0+a29iaiwgJnJjNl9hdHRyX2dyb3VwKTsKICNlbmRpZgogfQpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9kcm0vZHJtUC5oIGIvaW5jbHVkZS9kcm0vZHJtUC5oCmluZGV4IDli
YTZhMzguLjMzZWFiYTYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvZHJtL2RybVAuaAorKysgYi9pbmNs
dWRlL2RybS9kcm1QLmgKQEAgLTEwNDMsNyArMTA0Myw3IEBAIHN0cnVjdCBkcm1fbWlub3Igewog
CWludCBpbmRleDsJCQkvKio8IE1pbm9yIGRldmljZSBudW1iZXIgKi8KIAlpbnQgdHlwZTsgICAg
ICAgICAgICAgICAgICAgICAgIC8qKjwgQ29udHJvbCBvciByZW5kZXIgKi8KIAlkZXZfdCBkZXZp
Y2U7CQkJLyoqPCBEZXZpY2UgbnVtYmVyIGZvciBta25vZCAqLwotCXN0cnVjdCBkZXZpY2Uga2Rl
djsJCS8qKjwgTGludXggZGV2aWNlICovCisJc3RydWN0IGRldmljZSAqa2RldjsJCS8qKjwgTGlu
dXggZGV2aWNlICovCiAJc3RydWN0IGRybV9kZXZpY2UgKmRldjsKIAogCXN0cnVjdCBkZW50cnkg
KmRlYnVnZnNfcm9vdDsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvZHJtL2RybV9jcnRjLmggYi9pbmNs
dWRlL2RybS9kcm1fY3J0Yy5oCmluZGV4IDkyZTc4MjAuLmM3Y2U0ZTIgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvZHJtL2RybV9jcnRjLmgKKysrIGIvaW5jbHVkZS9kcm0vZHJtX2NydGMuaApAQCAtNTg3
LDcgKzU4Nyw3IEBAIGVudW0gZHJtX2Nvbm5lY3Rvcl9mb3JjZSB7CiAgKi8KIHN0cnVjdCBkcm1f
Y29ubmVjdG9yIHsKIAlzdHJ1Y3QgZHJtX2RldmljZSAqZGV2OwotCXN0cnVjdCBkZXZpY2Uga2Rl
djsKKwlzdHJ1Y3QgZGV2aWNlICprZGV2OwogCXN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRy
OwogCXN0cnVjdCBsaXN0X2hlYWQgaGVhZDsKIAotLSAKMS44LjMuMQoK
--001a11c3f40050b44c04e86f8e42--
