Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3IKRAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:00:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab3IKRAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:00:37 -0400
Message-ID: <5230A1AE.401@suse.com>
Date: Wed, 11 Sep 2013 13:00:30 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linux.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] kobject: introduce kobj_completion
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common way to handle kobject lifetimes in embedded in objects with
different lifetime rules is to pair the kobject with a struct completion.

This introduces a kobj_completion structure that can be used in place
of the pairing, along with several convenience functions for
initialization, release, and put-and-wait.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 include/linux/kobj_completion.h |   18 ++++++++++++++
 lib/kobject.c                   |   50 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/include/linux/kobj_completion.h	2013-09-10 12:58:03.530554144 -0400
@@ -0,0 +1,18 @@
+#ifndef _KOBJ_COMPLETION_H_
+#define _KOBJ_COMPLETION_H_
+
+#include <linux/kobject.h>
+#include <linux/completion.h>
+
+struct kobj_completion {
+	struct kobject kc_kobj;
+	struct completion kc_unregister;
+};
+
+#define kobj_to_kobj_completion(kobj) \
+	container_of(kobj, struct kobj_completion, kc_kobj)
+
+void kobj_completion_init(struct kobj_completion *kc, struct kobj_type *ktype);
+void kobj_completion_release(struct kobject *kobj);
+void kobj_completion_del_and_wait(struct kobj_completion *kc);
+#endif /* _KOBJ_COMPLETION_H_ */
--- a/lib/kobject.c	2013-09-10 12:57:54.198666613 -0400
+++ b/lib/kobject.c	2013-09-10 15:22:15.122724060 -0400
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kobject.h>
+#include <linux/kobj_completion.h>
 #include <linux/string.h>
 #include <linux/export.h>
 #include <linux/stat.h>
@@ -711,6 +712,55 @@ const struct sysfs_ops kobj_sysfs_ops =
 };
 
 /**
+ * kobj_completion_init - initialize a kobj_completion object.
+ * @kc: kobj_completion
+ * @ktype: type of kobject to initialize
+ *
+ * kobj_completion structures can be embedded within structures with different
+ * lifetime rules.  During the release of the enclosing object, we can
+ * wait on the release of the kobject so that we don't free it while it's
+ * still busy.
+ */
+void kobj_completion_init(struct kobj_completion *kc, struct kobj_type *ktype)
+{
+	init_completion(&kc->kc_unregister);
+	kobject_init(&kc->kc_kobj, ktype);
+}
+EXPORT_SYMBOL_GPL(kobj_completion_init);
+
+/**
+ * kobj_completion_release - release a kobj_completion object
+ * @kobj: kobject embedded in kobj_completion
+ *
+ * Used with kobject_release to notify waiters that the kobject has been
+ * released.
+ */
+void kobj_completion_release(struct kobject *kobj)
+{
+	struct kobj_completion *kc = kobj_to_kobj_completion(kobj);
+	complete(&kc->kc_unregister);
+}
+EXPORT_SYMBOL_GPL(kobj_completion_release);
+
+/**
+ * kobj_completion_del_and_wait - release the kobject and wait for it
+ * @kc: kobj_completion object to release
+ *
+ * Delete the kobject from sysfs and drop the reference count.  Then wait
+ * until any other outstanding references are also dropped.  This routine
+ * is only necessary once other references may have been taken on the
+ * kobject.  Typically this happens when the kobject has been published
+ * to sysfs via kobject_add.
+ */
+void kobj_completion_del_and_wait(struct kobj_completion *kc)
+{
+	kobject_del(&kc->kc_kobj);
+	kobject_put(&kc->kc_kobj);
+	wait_for_completion(&kc->kc_unregister);
+}
+EXPORT_SYMBOL_GPL(kobj_completion_del_and_wait);
+
+/**
  * kset_register - initialize and add a kset.
  * @k: kset.
  */
