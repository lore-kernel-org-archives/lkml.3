Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaLHISq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:18:46 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40514 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaLHISo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:18:44 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/7] CXL: Change contexts_lock to a mutex to fix sleep while atomic bug
Date: Mon,  8 Dec 2014 19:17:55 +1100
Message-Id: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120808-0033-0000-0000-000000B05037
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

We had a known sleep while atomic bug if a CXL device was forcefully
unbound while it was in use. This could occur as a result of EEH, or
manually induced with something like this while the device was in use:

echo 0000:01:00.0 > /sys/bus/pci/drivers/cxl-pci/unbind

The issue was that in this code path we iterated over each context and
forcefully detached it with the contexts_lock spin lock held, however
the detach also needed to take the spu_mutex, and call schedule.

This patch changes the contexts_lock to a mutex so that we are not in
atomic context while doing the detach, thereby avoiding the sleep while
atomic.

Also delete the related TODO comment, which suggested an alternate
solution which turned out to not be workable.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/context.c | 15 ++++++++-------
 drivers/misc/cxl/cxl.h     |  2 +-
 drivers/misc/cxl/native.c  |  7 -------
 drivers/misc/cxl/pci.c     |  2 +-
 drivers/misc/cxl/sysfs.c   | 10 +++++-----
 5 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/cxl/context.c b/drivers/misc/cxl/context.c
index cca4721..4aa31a3 100644
--- a/drivers/misc/cxl/context.c
+++ b/drivers/misc/cxl/context.c
@@ -82,12 +82,12 @@ int cxl_context_init(struct cxl_context *ctx, struct cxl_afu *afu, bool master)
 	 * Allocating IDR! We better make sure everything's setup that
 	 * dereferences from it.
 	 */
+	mutex_lock(&afu->contexts_lock);
 	idr_preload(GFP_KERNEL);
-	spin_lock(&afu->contexts_lock);
 	i = idr_alloc(&ctx->afu->contexts_idr, ctx, 0,
 		      ctx->afu->num_procs, GFP_NOWAIT);
-	spin_unlock(&afu->contexts_lock);
 	idr_preload_end();
+	mutex_unlock(&afu->contexts_lock);
 	if (i < 0)
 		return i;
 
@@ -168,21 +168,22 @@ void cxl_context_detach_all(struct cxl_afu *afu)
 	struct cxl_context *ctx;
 	int tmp;
 
-	rcu_read_lock();
-	idr_for_each_entry(&afu->contexts_idr, ctx, tmp)
+	mutex_lock(&afu->contexts_lock);
+	idr_for_each_entry(&afu->contexts_idr, ctx, tmp) {
 		/*
 		 * Anything done in here needs to be setup before the IDR is
 		 * created and torn down after the IDR removed
 		 */
 		__detach_context(ctx);
-	rcu_read_unlock();
+	}
+	mutex_unlock(&afu->contexts_lock);
 }
 
 void cxl_context_free(struct cxl_context *ctx)
 {
-	spin_lock(&ctx->afu->contexts_lock);
+	mutex_lock(&ctx->afu->contexts_lock);
 	idr_remove(&ctx->afu->contexts_idr, ctx->pe);
-	spin_unlock(&ctx->afu->contexts_lock);
+	mutex_unlock(&ctx->afu->contexts_lock);
 	synchronize_rcu();
 
 	free_page((u64)ctx->sstp);
diff --git a/drivers/misc/cxl/cxl.h b/drivers/misc/cxl/cxl.h
index b5b6bda..7c05239 100644
--- a/drivers/misc/cxl/cxl.h
+++ b/drivers/misc/cxl/cxl.h
@@ -351,7 +351,7 @@ struct cxl_afu {
 	struct device *chardev_s, *chardev_m, *chardev_d;
 	struct idr contexts_idr;
 	struct dentry *debugfs;
-	spinlock_t contexts_lock;
+	struct mutex contexts_lock;
 	struct mutex spa_mutex;
 	spinlock_t afu_cntl_lock;
 
diff --git a/drivers/misc/cxl/native.c b/drivers/misc/cxl/native.c
index 9a5a442..1001cf4 100644
--- a/drivers/misc/cxl/native.c
+++ b/drivers/misc/cxl/native.c
@@ -610,13 +610,6 @@ static inline int detach_process_native_dedicated(struct cxl_context *ctx)
 	return 0;
 }
 
-/*
- * TODO: handle case when this is called inside a rcu_read_lock() which may
- * happen when we unbind the driver (ie. cxl_context_detach_all()) .  Terminate
- * & remove use a mutex lock and schedule which will not good with lock held.
- * May need to write do_process_element_cmd() that handles outstanding page
- * faults synchronously.
- */
 static inline int detach_process_native_afu_directed(struct cxl_context *ctx)
 {
 	if (!ctx->pe_inserted)
diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index 10c98ab..0f2cc9f 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -502,7 +502,7 @@ static struct cxl_afu *cxl_alloc_afu(struct cxl *adapter, int slice)
 	afu->dev.release = cxl_release_afu;
 	afu->slice = slice;
 	idr_init(&afu->contexts_idr);
-	spin_lock_init(&afu->contexts_lock);
+	mutex_init(&afu->contexts_lock);
 	spin_lock_init(&afu->afu_cntl_lock);
 	mutex_init(&afu->spa_mutex);
 
diff --git a/drivers/misc/cxl/sysfs.c b/drivers/misc/cxl/sysfs.c
index ce7ec06..461bdbd 100644
--- a/drivers/misc/cxl/sysfs.c
+++ b/drivers/misc/cxl/sysfs.c
@@ -121,7 +121,7 @@ static ssize_t reset_store_afu(struct device *device,
 	int rc;
 
 	/* Not safe to reset if it is currently in use */
-	spin_lock(&afu->contexts_lock);
+	mutex_lock(&afu->contexts_lock);
 	if (!idr_is_empty(&afu->contexts_idr)) {
 		rc = -EBUSY;
 		goto err;
@@ -132,7 +132,7 @@ static ssize_t reset_store_afu(struct device *device,
 
 	rc = count;
 err:
-	spin_unlock(&afu->contexts_lock);
+	mutex_unlock(&afu->contexts_lock);
 	return rc;
 }
 
@@ -247,7 +247,7 @@ static ssize_t mode_store(struct device *device, struct device_attribute *attr,
 	int rc = -EBUSY;
 
 	/* can't change this if we have a user */
-	spin_lock(&afu->contexts_lock);
+	mutex_lock(&afu->contexts_lock);
 	if (!idr_is_empty(&afu->contexts_idr))
 		goto err;
 
@@ -271,7 +271,7 @@ static ssize_t mode_store(struct device *device, struct device_attribute *attr,
 	afu->current_mode = 0;
 	afu->num_procs = 0;
 
-	spin_unlock(&afu->contexts_lock);
+	mutex_unlock(&afu->contexts_lock);
 
 	if ((rc = _cxl_afu_deactivate_mode(afu, old_mode)))
 		return rc;
@@ -280,7 +280,7 @@ static ssize_t mode_store(struct device *device, struct device_attribute *attr,
 
 	return count;
 err:
-	spin_unlock(&afu->contexts_lock);
+	mutex_unlock(&afu->contexts_lock);
 	return rc;
 }
 
-- 
2.1.3

