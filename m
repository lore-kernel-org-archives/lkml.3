Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3LDMXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:23:16 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:55027 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab3LDMXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:23:14 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] Documentation: start documenting driver design patterns
Date: Wed,  4 Dec 2013 13:22:37 +0100
Message-Id: <1386159757-29966-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After realizing that we tend to tell developers the same thing over
and over, let's attempt to document some commin design patterns
used in the device drivers. The idea is that this can be extended
so I just start out with two well-known design patterns.

Cc: Rob Landley <rob@landley.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
I guess this goes to Greg for merging through the device core
tree if it is liked, let's see.
---
 Documentation/driver-model/design-patterns.txt | 116 +++++++++++++++++++++++++
 1 file changed, 116 insertions(+)
 create mode 100644 Documentation/driver-model/design-patterns.txt

diff --git a/Documentation/driver-model/design-patterns.txt b/Documentation/driver-model/design-patterns.txt
new file mode 100644
index 000000000000..9ef8c1684558
--- /dev/null
+++ b/Documentation/driver-model/design-patterns.txt
@@ -0,0 +1,116 @@
+
+Device Driver Design Patterns
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+This document describes a few common design patterns found in device drivers.
+It is likely that subsystem maintainers will ask driver developers to
+conform to these design patterns.
+
+1. State Container
+2. container_of()
+
+
+1. State Container
+~~~~~~~~~~~~~~~~~~
+
+While the kernel contains a few device drivers that assume that they will
+only be probed() once on a certain system (singletons), it is custom to assume
+that the device the driver binds to will appear in several instances. This
+means that the probe() function and all callbacks need to be reentrant.
+
+The most common way to achieve this is to use the state container design
+pattern. It usually has this form:
+
+struct foo {
+    spinlock_t lock; /* Example member */
+    (...)
+};
+
+static int foo_probe(...)
+{
+    struct foo *foo;
+
+    foo = devm_kzalloc(dev, sizeof(*foo), GFP_KERNEL);
+    if (!foo)
+        return -ENOMEM;
+    spin_lock_init(&foo->lock);
+    (...)
+}
+
+This will create an instance of struct foo in memory every time probe() is
+called. This is our state container for this instance of the device driver.
+Of course it is then necessary to always pass this instance of the
+state around to all functions that need access to the state and its members.
+
+For example, if the driver is registering an interrupt handler, you would
+pass around a pointer to struct foo like this:
+
+static irqreturn_t foo_handler(int irq, void *arg)
+{
+    struct foo *foo = arg;
+    (...)
+}
+
+static int foo_probe(...)
+{
+    struct foo *foo;
+
+    (...)
+    ret = request_irq(irq, foo_handler, 0, "foo", foo);
+}
+
+This way you always get a pointer back to the correct instance of foo in
+your interrupt handler.
+
+
+2. container_of()
+~~~~~~~~~~~~~~~~~
+
+Continuing on the above example we add a offloaded work:
+
+struct foo {
+    spinlock_t lock;
+    struct workqueue_struct *wq;
+    struct work_struct offload;
+    (...)
+};
+
+static void foo_work(struct work_struct *work)
+{
+    struct foo *foo = container_of(work, struct foo, offload);
+
+    (...)
+}
+
+static irqreturn_t foo_handler(int irq, void *arg)
+{
+    struct foo *foo = arg;
+
+    queue_work(foo->wq, &foo->offload);
+    (...)
+}
+
+static int foo_probe(...)
+{
+    struct foo *foo;
+
+    foo->wq = create_singlethread_workqueue("foo-wq");
+    INIT_WORK(&foo->offload, foo_work);
+    (...)
+}
+
+The design pattern is the same for a a hrtimer or something similar that will
+return a single argument which is a pointer to a struct member in the
+callback.
+
+container_of() is a macro defined in <linux/kernel.h>
+
+What container_of() does is to obtain a pointer to the containing struct from
+a pointer to a member by a simple subtraction using the offsetof() macro from
+standard C, which allows something similar to object oriented behaviours.
+Notice that the contained member must not be a pointer, but an actual member
+for this to work.
+
+We can see here that we avoid having global pointers to our struct foo *
+instance this way, while still keeping the number of parameters passed to the
+work function to a single pointer.
-- 
1.8.3.1

