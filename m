Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3KCNdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 08:33:46 -0500
Received: from imap.thunk.org ([74.207.234.97]:53765 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab3KCNdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 08:33:18 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] random: use device attach events for entropy
Date: Sun,  3 Nov 2013 08:33:12 -0500
Message-Id: <1383485595-2020-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1383485595-2020-1-git-send-email-tytso@mit.edu>
References: <1383485595-2020-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some investigation from FreeBSD shows that there is entropy available
from measuring the device attach times:

http://lists.randombit.net/pipermail/cryptography/2013-October/005689.html

This will hopefully help us more quickly initialize the entropy pools
while the system is booting (which is one of the times when we really
badly need more entropy, especially in the case of the first boot
after an consumer electronics device is taken out of the box).

Measurements indicate this makes a huge improvement in the security of
/dev/urandom during the boot sequence, so I'm cc'ing this to the
stable kernel series.  Especially for embedded systems, which use
flash and which don't necessarily have the network enabled when they
first generate ssh or x.509 keys (sigh), this can be a big deal.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 drivers/base/core.c    | 3 +++
 drivers/char/random.c  | 7 +++++++
 include/linux/random.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8856d74..5e98fc3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -26,6 +26,7 @@
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
 #include <linux/netdevice.h>
+#include <linux/random.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1156,6 +1157,8 @@ int device_add(struct device *dev)
 				class_intf->add_dev(dev, class_intf);
 		mutex_unlock(&dev->class->p->mutex);
 	}
+	add_device_attach_randomness(dev);
+
 done:
 	put_device(dev);
 	return error;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index f126bd2..51153fe 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -829,6 +829,13 @@ void add_input_randomness(unsigned int type, unsigned int code,
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
+void add_device_attach_randomness(struct device *dev)
+{
+	static struct timer_rand_state attach_state = { 0, };
+
+	add_timer_randomness(&attach_state, dev->devt);
+}
+
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
 void add_interrupt_randomness(int irq, int irq_flags)
diff --git a/include/linux/random.h b/include/linux/random.h
index 6312dd9..5ef9470 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -12,6 +12,8 @@
 extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
+struct device;
+extern void add_device_attach_randomness(struct device *dev);
 extern void add_interrupt_randomness(int irq, int irq_flags);
 
 extern void get_random_bytes(void *buf, int nbytes);
-- 
1.7.12.rc0.22.gcdd159b

