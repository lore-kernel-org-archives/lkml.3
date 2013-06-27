Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3F0OG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:06:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46710 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3F0OG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:06:27 -0400
Date: Thu, 27 Jun 2013 15:06:14 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] delayed kobject release: help find buggy code
Message-ID: <20130627140613.GB12530@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

This is an updated copy of my delayed kobject release debugging patch
from 2011, which I notice hasn't hit mainline.  Please consider merging
this so that driver authors and subsystem maintainers have a way to test
code for kobject refcounting errors.

Moreover, please also consider whether to make the debug option default
to 'y' when CONFIG_DEBUG_KERNEL is enabled.

8<====
From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: kobject: delayed kobject release: help find buggy drivers

Implement debugging for kobject release functions.  kobjects are
reference counted, so the drop of the last reference to them is not
predictable. However, the common case is for the last reference to be
the kobject's removal from a subsystem, which results in the release
function being immediately called.

This can hide subtle bugs, which can occur when another thread holds a
reference to the kobject at the same time that a kobject is removed.
This results in the release method being delayed.

In order to make these kinds of problems more visible, the following
patch implements a delayed release; this has the effect that the
release function will be out of order with respect to the removal of
the kobject in the same manner that it would be if a reference was
being held.

This provides us with an easy way to allow driver writers to debug
their drivers and fix otherwise hidden problems.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 include/linux/kobject.h |    4 ++++
 lib/Kconfig.debug       |   19 +++++++++++++++++++
 lib/kobject.c           |   22 +++++++++++++++++++---
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 939b112..de6dcbcc 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <linux/workqueue.h>
 
 #define UEVENT_HELPER_PATH_LEN		256
 #define UEVENT_NUM_ENVP			32	/* number of env pointers */
@@ -65,6 +66,9 @@ struct kobject {
 	struct kobj_type	*ktype;
 	struct sysfs_dirent	*sd;
 	struct kref		kref;
+#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
+	struct delayed_work	release;
+#endif
 	unsigned int state_initialized:1;
 	unsigned int state_in_sysfs:1;
 	unsigned int state_add_uevent_sent:1;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 566cf2b..1f9de06 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -688,6 +688,25 @@ config DEBUG_KOBJECT
 	  If you say Y here, some extra kobject debugging messages will be sent
 	  to the syslog. 
 
+config DEBUG_KOBJECT_RELEASE
+	bool "kobject release debugging"
+	depends on DEBUG_KERNEL
+	help
+	  kobjects are reference counted objects.  This means that their
+	  last reference count put is not predictable, and the kobject can
+	  live on past the point at which a driver decides to drop it's
+	  initial reference to the kobject gained on allocation.  An
+	  example of this would be a struct device which has just been
+	  unregistered.
+
+	  However, some buggy drivers assume that after such an operation,
+	  the memory backing the kobject can be immediately freed.  This
+	  goes completely against the principles of a refcounted object.
+
+	  If you say Y here, the kernel will delay the release of kobjects
+	  on the last reference count to improve the visibility of this
+	  kind of kobject release bug.
+
 config DEBUG_HIGHMEM
 	bool "Highmem debugging"
 	depends on DEBUG_KERNEL && HIGHMEM
diff --git a/lib/kobject.c b/lib/kobject.c
index b7e29a6..3b1dbdc 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -545,8 +545,8 @@ static void kobject_cleanup(struct kobject *kobj)
 	struct kobj_type *t = get_ktype(kobj);
 	const char *name = kobj->name;
 
-	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __func__);
+	pr_debug("kobject: '%s' (%p): %s, parent %p\n",
+		 kobject_name(kobj), kobj, __func__, kobj->parent);
 
 	if (t && !t->release)
 		pr_debug("kobject: '%s' (%p): does not have a release() "
@@ -580,9 +580,25 @@ static void kobject_cleanup(struct kobject *kobj)
 	}
 }
 
+#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
+static void kobject_delayed_cleanup(struct work_struct *work)
+{
+	kobject_cleanup(container_of(to_delayed_work(work),
+				     struct kobject, release));
+}
+#endif
+
 static void kobject_release(struct kref *kref)
 {
-	kobject_cleanup(container_of(kref, struct kobject, kref));
+	struct kobject *kobj = container_of(kref, struct kobject, kref);
+#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
+	pr_debug("kobject: '%s' (%p): %s, parent %p (delayed)\n",
+		 kobject_name(kobj), kobj, __func__, kobj->parent);
+	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
+	schedule_delayed_work(&kobj->release, HZ);
+#else
+	kobject_cleanup(kobj);
+#endif
 }
 
 /**

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
