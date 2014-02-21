Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaBULyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:54:33 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:40851 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbaBULyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:54:31 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv6 4/6] zram: add multi stream functionality
Date: Fri, 21 Feb 2014 14:50:41 +0300
Message-Id: <1392983443-9807-5-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.291.g027825b
In-Reply-To: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements multi stream compression support.

Introduce struct zcomp_strm_multi and a set of functions to manage
zcomp_strm stream access. zcomp_strm_multi has a list of idle zcomp_strm
structs, spinlock to protect idle list and wait queue, making it possible
to perform parallel compressions.

The following set of functions added:
- zcomp_strm_multi_get()/zcomp_strm_multi_put()
  get and put compression stream, implement required locking
- zcomp_strm_multi_create()/zcomp_strm_multi_destroy()
  create and destroy zcomp_strm_multi

zcomp ->strm_get() and ->strm_put() callbacks are set during initialisation
to zcomp_strm_multi_get()/zcomp_strm_multi_put() correspondingly.

Each time zcomp issues a zcomp_strm_multi_get() call, the following set of
operations performed:
- spin lock strm_lock
- if idle list is not empty, remove zcomp_strm from idle list, spin
  unlock and return zcomp stream pointer to caller
- if idle list is empty, current adds itself to wait queue. it will be
  awaken by zcomp_strm_multi_put() caller.

zcomp_strm_multi_put():
- spin lock strm_lock
- add zcomp stream to idle list
- spin unlock, wake up sleeper

Minchan Kim reported that spinlock-based locking scheme has demonstrated a
severe perfomance regression for single compression stream case, comparing
to mutex-based (https://lkml.org/lkml/2014/2/18/16)

base                      spinlock                    mutex

==Initial write           ==Initial write             ==Initial  write
records:  5               records:  5                 records:   5
avg:      1642424.35      avg:      699610.40         avg:       1655583.71
std:      39890.95(2.43%) std:      232014.19(33.16%) std:       52293.96
max:      1690170.94      max:      1163473.45        max:       1697164.75
min:      1568669.52      min:      573429.88         min:       1553410.23
==Rewrite                 ==Rewrite                   ==Rewrite
records:  5               records:  5                 records:   5
avg:      1611775.39      avg:      501406.64         avg:       1684419.11
std:      17144.58(1.06%) std:      15354.41(3.06%)   std:       18367.42
max:      1641800.95      max:      531356.78         max:       1706445.84
min:      1593515.27      min:      488817.78         min:       1655335.73
==Random  write           ==Random  write             ==Random   write
records:  5               records:  5                 records:   5
avg:      1626318.29      avg:      497250.78         avg:       1695582.06
std:      38550.23(2.37%) std:      1405.42(0.28%)    std:       9211.98
max:      1665839.62      max:      498585.88         max:       1703808.22
min:      1562141.21      min:      494526.45         min:       1677664.94
==Pwrite                  ==Pwrite                    ==Pwrite
records:  5               records:  5                 records:   5
avg:      1654641.25      avg:      581709.22         avg:       1641452.34
std:      47202.59(2.85%) std:      9670.46(1.66%)    std:       38963.62
max:      1740682.36      max:      591300.09         max:       1687387.69
min:      1611436.34      min:      564324.38         min:       1570496.11

When only one compression stream available, mutex with spin on owner tends
to perform much better than frequent wait_event()/wake_up(). This is why
single stream implemented as a special case with mutex locking.

In order to compile this functionality ZRAM_MULTI_STREAM config option
required to be set, which will be introduced later.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c | 101 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 9661226..41325ed 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -12,9 +12,14 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
+#ifdef CONFIG_ZRAM_MULTI_STREAM
+#include <linux/spinlock.h>
+#endif
 
 #include "zcomp.h"
 
+extern struct zcomp_backend zcomp_lzo;
+
 /*
  * single zcomp_strm backend private part
  */
@@ -23,7 +28,18 @@ struct zcomp_strm_single {
 	struct zcomp_strm *zstrm;
 };
 
-extern struct zcomp_backend zcomp_lzo;
+#ifdef CONFIG_ZRAM_MULTI_STREAM
+/*
+ * multi zcomp_strm backend private part
+ */
+struct zcomp_strm_multi {
+	/* protect strm list */
+	spinlock_t strm_lock;
+	/* list of available strms */
+	struct list_head idle_strm;
+	wait_queue_head_t strm_wait;
+};
+#endif
 
 static struct zcomp_backend *find_backend(const char *compress)
 {
@@ -63,6 +79,89 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
 	return zstrm;
 }
 
+#ifdef CONFIG_ZRAM_MULTI_STREAM
+/*
+ * get existing idle zcomp_strm or wait until other process release
+ * (zcomp_strm_put()) one for us
+ */
+static struct zcomp_strm *zcomp_strm_multi_get(struct zcomp *comp)
+{
+	struct zcomp_strm_multi *zp = comp->private;
+	struct zcomp_strm *zstrm;
+
+	while (1) {
+		spin_lock(&zp->strm_lock);
+		if (list_empty(&zp->idle_strm)) {
+			spin_unlock(&zp->strm_lock);
+			wait_event(zp->strm_wait,
+					!list_empty(&zp->idle_strm));
+			continue;
+		}
+
+		zstrm = list_entry(zp->idle_strm.next,
+				struct zcomp_strm, list);
+		list_del(&zstrm->list);
+		spin_unlock(&zp->strm_lock);
+		break;
+	}
+	return zstrm;
+}
+
+/* add zcomp_strm back to idle list and wake up waiter */
+static void zcomp_strm_multi_put(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	struct zcomp_strm_multi *zp = comp->private;
+
+	spin_lock(&zp->strm_lock);
+	list_add(&zstrm->list, &zp->idle_strm);
+	spin_unlock(&zp->strm_lock);
+
+	wake_up(&zp->strm_wait);
+}
+
+static void zcomp_strm_multi_destroy(struct zcomp *comp)
+{
+	struct zcomp_strm_multi *zp = comp->private;
+	struct zcomp_strm *zstrm;
+	while (!list_empty(&zp->idle_strm)) {
+		zstrm = list_entry(zp->idle_strm.next,
+				struct zcomp_strm, list);
+		list_del(&zstrm->list);
+		zcomp_strm_free(comp, zstrm);
+	}
+	kfree(zp);
+}
+
+static int zcomp_strm_multi_create(struct zcomp *comp, int num_strm)
+{
+	int i;
+	struct zcomp_strm *zstrm;
+	struct zcomp_strm_multi *zp;
+
+	comp->destroy = zcomp_strm_multi_destroy;
+	comp->strm_get = zcomp_strm_multi_get;
+	comp->strm_put = zcomp_strm_multi_put;
+	zp = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
+	comp->private = zp;
+	if (!zp)
+		return -ENOMEM;
+
+	spin_lock_init(&zp->strm_lock);
+	INIT_LIST_HEAD(&zp->idle_strm);
+	init_waitqueue_head(&zp->strm_wait);
+
+	for (i = 0; i < num_strm; i++) {
+		zstrm = zcomp_strm_alloc(comp);
+		if (!zstrm) {
+			zcomp_strm_multi_destroy(comp);
+			return -ENOMEM;
+		}
+		list_add(&zstrm->list, &zp->idle_strm);
+	}
+	return 0;
+}
+#endif
+
 static struct zcomp_strm *zcomp_strm_single_get(struct zcomp *comp)
 {
 	struct zcomp_strm_single *zp = comp->private;
-- 
1.9.0.291.g027825b

