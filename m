Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaBZMby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:31:54 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:65376 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaBZMbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:31:51 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv8 4/6] zram: add multi stream functionality
Date: Wed, 26 Feb 2014 15:27:57 +0300
Message-Id: <1393417679-13657-5-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.291.g027825b
In-Reply-To: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
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
to mutex-based (see https://lkml.org/lkml/2014/2/18/16)

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

When only one compression stream available, mutex with spin on owner tends
to perform much better than frequent wait_event()/wake_up(). This is why
single stream implemented as a special case with mutex locking.

Introduce zram device attribute max_comp_streams to show and store current
zcomp's max number of zcomp streams (max_strm) and extend zcomp's
zcomp_create() with `max_strm' parameter. `max_strm' limits the number of
zcomp_strm structs in compression backend's idle list (max_comp_streams).

max_comp_streams used during initialisation as follows:
-- passing to zcomp_create() max_strm equals to 1 will initialise zcomp
using single compression stream zcomp_strm_single (mutex-based locking).
-- passing to zcomp_create() max_strm greater than 1 will initialise zcomp
using multi compression stream zcomp_strm_multi (spinlock-based locking).

default max_comp_streams value is 1, meaning that zram with single stream
will be initialised.

Later patch will introduce configuration knob to change max_comp_streams
on already initialised and used zcomp.

iozone -t 3 -R -r 16K -s 60M -I +Z

       test           base       1 strm (mutex)     3 strm (spinlock)
-----------------------------------------------------------------------
 Initial write      589286.78       583518.39          718011.05
       Rewrite      604837.97       596776.38         1515125.72
  Random write      584120.11       595714.58         1388850.25
        Pwrite      535731.17       541117.38          739295.27
        Fwrite     1418083.88      1478612.72         1484927.06

Usage example:
set max_comp_streams to 4
        echo 4 > /sys/block/zram0/max_comp_streams

show current max_comp_streams (default value is 1).
        cat /sys/block/zram0/max_comp_streams

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c    | 126 +++++++++++++++++++++++++++++++++++++++++-
 drivers/block/zram/zcomp.h    |   2 +-
 drivers/block/zram/zram_drv.c |  42 +++++++++++++-
 drivers/block/zram/zram_drv.h |   2 +-
 4 files changed, 166 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 210cc28..0b790ac 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -15,6 +15,8 @@
 
 #include "zcomp.h"
 
+extern struct zcomp_backend zcomp_lzo;
+
 /*
  * single zcomp_strm backend
  */
@@ -23,7 +25,20 @@ struct zcomp_strm_single {
 	struct zcomp_strm *zstrm;
 };
 
-extern struct zcomp_backend zcomp_lzo;
+/*
+ * multi zcomp_strm backend
+ */
+struct zcomp_strm_multi {
+	/* protect strm list */
+	spinlock_t strm_lock;
+	/* max possible number of zstrm streams */
+	int max_strm;
+	/* number of available zstrm streams */
+	int avail_strm;
+	/* list of available strms */
+	struct list_head idle_strm;
+	wait_queue_head_t strm_wait;
+};
 
 static struct zcomp_backend *find_backend(const char *compress)
 {
@@ -63,6 +78,107 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
 	return zstrm;
 }
 
+/*
+ * get idle zcomp_strm or wait until other process release
+ * (zcomp_strm_put()) one for us
+ */
+static struct zcomp_strm *zcomp_strm_multi_get(struct zcomp *comp)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+	struct zcomp_strm *zstrm;
+
+	while (1) {
+		spin_lock(&zs->strm_lock);
+		if (!list_empty(&zs->idle_strm)) {
+			zstrm = list_entry(zs->idle_strm.next,
+					struct zcomp_strm, list);
+			list_del(&zstrm->list);
+			spin_unlock(&zs->strm_lock);
+			return zstrm;
+		}
+		/* zstrm streams limit reached, wait for idle stream */
+		if (zs->avail_strm >= zs->max_strm) {
+			spin_unlock(&zs->strm_lock);
+			wait_event(zs->strm_wait, !list_empty(&zs->idle_strm));
+			continue;
+		}
+		/* allocate new zstrm stream */
+		zs->avail_strm++;
+		spin_unlock(&zs->strm_lock);
+
+		zstrm = zcomp_strm_alloc(comp);
+		if (!zstrm) {
+			spin_lock(&zs->strm_lock);
+			zs->avail_strm--;
+			spin_unlock(&zs->strm_lock);
+			wait_event(zs->strm_wait, !list_empty(&zs->idle_strm));
+			continue;
+		}
+		break;
+	}
+	return zstrm;
+}
+
+/* add stream back to idle list and wake up waiter or free the stream */
+static void zcomp_strm_multi_put(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+
+	spin_lock(&zs->strm_lock);
+	if (zs->avail_strm <= zs->max_strm) {
+		list_add(&zstrm->list, &zs->idle_strm);
+		spin_unlock(&zs->strm_lock);
+		wake_up(&zs->strm_wait);
+		return;
+	}
+
+	zs->avail_strm--;
+	spin_unlock(&zs->strm_lock);
+	zcomp_strm_free(comp, zstrm);
+}
+
+static void zcomp_strm_multi_destroy(struct zcomp *comp)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+	struct zcomp_strm *zstrm;
+
+	while (!list_empty(&zs->idle_strm)) {
+		zstrm = list_entry(zs->idle_strm.next,
+				struct zcomp_strm, list);
+		list_del(&zstrm->list);
+		zcomp_strm_free(comp, zstrm);
+	}
+	kfree(zs);
+}
+
+static int zcomp_strm_multi_create(struct zcomp *comp, int max_strm)
+{
+	struct zcomp_strm *zstrm;
+	struct zcomp_strm_multi *zs;
+
+	comp->destroy = zcomp_strm_multi_destroy;
+	comp->strm_get = zcomp_strm_multi_get;
+	comp->strm_put = zcomp_strm_multi_put;
+	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
+	if (!zs)
+		return -ENOMEM;
+
+	comp->stream = zs;
+	spin_lock_init(&zs->strm_lock);
+	INIT_LIST_HEAD(&zs->idle_strm);
+	init_waitqueue_head(&zs->strm_wait);
+	zs->max_strm = max_strm;
+	zs->avail_strm = 1;
+
+	zstrm = zcomp_strm_alloc(comp);
+	if (!zstrm) {
+		kfree(zs);
+		return -ENOMEM;
+	}
+	list_add(&zstrm->list, &zs->idle_strm);
+	return 0;
+}
+
 static struct zcomp_strm *zcomp_strm_single_get(struct zcomp *comp)
 {
 	struct zcomp_strm_single *zs = comp->stream;
@@ -139,7 +255,7 @@ void zcomp_destroy(struct zcomp *comp)
  * if requested algorithm is not supported or in case
  * of init error
  */
-struct zcomp *zcomp_create(const char *compress)
+struct zcomp *zcomp_create(const char *compress, int max_strm)
 {
 	struct zcomp *comp;
 	struct zcomp_backend *backend;
@@ -153,7 +269,11 @@ struct zcomp *zcomp_create(const char *compress)
 		return NULL;
 
 	comp->backend = backend;
-	if (zcomp_strm_single_create(comp) != 0) {
+	if (max_strm > 1)
+		zcomp_strm_multi_create(comp, max_strm);
+	else
+		zcomp_strm_single_create(comp);
+	if (!comp->stream) {
 		kfree(comp);
 		return NULL;
 	}
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 861e04d..9d77cbf 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -42,7 +42,7 @@ struct zcomp {
 	void (*destroy)(struct zcomp *comp);
 };
 
-struct zcomp *zcomp_create(const char *comp);
+struct zcomp *zcomp_create(const char *comp, int max_strm);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_strm_get(struct zcomp *comp);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 569ff58..42b9c7f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -108,6 +108,40 @@ static ssize_t mem_used_total_show(struct device *dev,
 	return sprintf(buf, "%llu\n", val);
 }
 
+static ssize_t max_comp_streams_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->max_comp_streams;
+	up_read(&zram->init_lock);
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t max_comp_streams_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	int num;
+	struct zram *zram = dev_to_zram(dev);
+
+	if (kstrtoint(buf, 0, &num))
+		return -EINVAL;
+	if (num < 1)
+		return -EINVAL;
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		up_write(&zram->init_lock);
+		pr_info("Can't set max_comp_streams for initialized device\n");
+		return -EBUSY;
+	}
+	zram->max_comp_streams = num;
+	up_write(&zram->init_lock);
+	return len;
+}
+
 /* flag operations needs meta->tb_lock */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
@@ -502,6 +536,8 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	}
 
 	zcomp_destroy(zram->comp);
+	zram->max_comp_streams = 1;
+
 	zram_meta_free(zram->meta);
 	zram->meta = NULL;
 	/* Reset stats */
@@ -530,7 +566,7 @@ static ssize_t disksize_store(struct device *dev,
 		return -EBUSY;
 	}
 
-	zram->comp = zcomp_create(default_compressor);
+	zram->comp = zcomp_create(default_compressor, zram->max_comp_streams);
 	if (!zram->comp) {
 		up_write(&zram->init_lock);
 		pr_info("Cannot initialise %s compressing backend\n",
@@ -693,6 +729,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
+static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
+		max_comp_streams_show, max_comp_streams_store);
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
@@ -717,6 +755,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_orig_data_size.attr,
 	&dev_attr_compr_data_size.attr,
 	&dev_attr_mem_used_total.attr,
+	&dev_attr_max_comp_streams.attr,
 	NULL,
 };
 
@@ -779,6 +818,7 @@ static int create_device(struct zram *zram, int device_id)
 	}
 
 	zram->meta = NULL;
+	zram->max_comp_streams = 1;
 	return 0;
 
 out_free_disk:
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 45e04f7..ccf36d1 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -99,7 +99,7 @@ struct zram {
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
-
+	int max_comp_streams;
 	struct zram_stats stats;
 };
 #endif
-- 
1.9.0.291.g027825b

