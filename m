Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3JUWd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:33:56 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36201 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3JUWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:33:53 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC v2 1/6] percpu_rw_semaphore: export symbols for modules
Date: Tue, 22 Oct 2013 00:33:23 +0200
Message-Id: <1382394808-20611-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
References: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRM could make great use of percpu-rwsems to track active users and wait
for them during hw hotplugging. Export symbols and allow using them in
runtime loadable modules.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 lib/Makefile       | 2 +-
 lib/percpu-rwsem.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index f3bb2cb..c1572be 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -45,7 +45,7 @@ obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
-lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
+obj-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
diff --git a/lib/percpu-rwsem.c b/lib/percpu-rwsem.c
index 652a8ee..893586c 100644
--- a/lib/percpu-rwsem.c
+++ b/lib/percpu-rwsem.c
@@ -7,6 +7,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
+#include <linux/export.h>
 
 int __percpu_init_rwsem(struct percpu_rw_semaphore *brw,
 			const char *name, struct lock_class_key *rwsem_key)
@@ -22,12 +23,14 @@ int __percpu_init_rwsem(struct percpu_rw_semaphore *brw,
 	init_waitqueue_head(&brw->write_waitq);
 	return 0;
 }
+EXPORT_SYMBOL(__percpu_init_rwsem);
 
 void percpu_free_rwsem(struct percpu_rw_semaphore *brw)
 {
 	free_percpu(brw->fast_read_ctr);
 	brw->fast_read_ctr = NULL; /* catch use after free bugs */
 }
+EXPORT_SYMBOL(percpu_free_rwsem);
 
 /*
  * This is the fast-path for down_read/up_read, it only needs to ensure
@@ -87,6 +90,7 @@ void percpu_down_read(struct percpu_rw_semaphore *brw)
 	/* avoid up_read()->rwsem_release() */
 	__up_read(&brw->rw_sem);
 }
+EXPORT_SYMBOL(percpu_down_read);
 
 void percpu_up_read(struct percpu_rw_semaphore *brw)
 {
@@ -99,6 +103,7 @@ void percpu_up_read(struct percpu_rw_semaphore *brw)
 	if (atomic_dec_and_test(&brw->slow_read_ctr))
 		wake_up_all(&brw->write_waitq);
 }
+EXPORT_SYMBOL(percpu_up_read);
 
 static int clear_fast_ctr(struct percpu_rw_semaphore *brw)
 {
@@ -150,6 +155,7 @@ void percpu_down_write(struct percpu_rw_semaphore *brw)
 	/* wait for all readers to complete their percpu_up_read() */
 	wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
 }
+EXPORT_SYMBOL(percpu_down_write);
 
 void percpu_up_write(struct percpu_rw_semaphore *brw)
 {
@@ -163,3 +169,4 @@ void percpu_up_write(struct percpu_rw_semaphore *brw)
 	/* the last writer unblocks update_fast_ctr() */
 	atomic_dec(&brw->write_ctr);
 }
+EXPORT_SYMBOL(percpu_up_write);
-- 
1.8.4.1

