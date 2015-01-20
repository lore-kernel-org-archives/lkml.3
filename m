Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbbATTpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:45:18 -0500
Received: from syn.loicp.eu ([176.31.96.212]:51783 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbATTpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:45:15 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2015 14:45:14 EST
Date: Tue, 20 Jan 2015 20:39:11 +0100
From: Loic Pefferkorn <loic@loicp.eu>
To: oleg.drokin@intel.com, andreas.dilger@intel.com, gdonald@gmail.com,
        keith.mannthey@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, HPDD-discuss@ml01.01.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH v2] staging: lustre: fix sparse warnings related to lock
 context imbalance
Message-ID: <ba6b015f96529f26996146ed610189aba36772e2.1421782625.git.loic@loicp.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies against next-20150120.

Add __acquires() and __releases() function annotations, to fix sparse warnings related to lock context imbalance.

This patch fixes the following warnings:

drivers/staging/lustre//lustre/libcfs/linux/linux-tracefile.c:153:5: warning: context imbalance in 'cfs_trace_lock_tcd' - wrong count at exit
drivers/staging/lustre//lustre/libcfs/linux/linux-tracefile.c:171:39: warning: context imbalance in 'cfs_trace_unlock_tcd' - unexpected unlock
drivers/staging/lustre//lustre/libcfs/hash.c:128:1: warning: context imbalance in 'cfs_hash_spin_lock' - wrong count at exit
drivers/staging/lustre//lustre/libcfs/hash.c:134:1: warning: context imbalance in 'cfs_hash_spin_unlock' - unexpected unlock
drivers/staging/lustre//lustre/libcfs/hash.c:142:9: warning: context imbalance in 'cfs_hash_rw_lock' - wrong count at exit
include/linux/rwlock_api_smp.h:219:9: warning: context imbalance in 'cfs_hash_rw_unlock' - unexpected unlock
drivers/staging/lustre//lustre/obdclass/cl_object.c:195:6: warning: context imbalance in 'cl_object_attr_lock' - wrong count at exit
drivers/staging/lustre//lustre/obdclass/cl_object.c:204:6: warning: context imbalance in 'cl_object_attr_unlock' - unexpected unlock

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/lustre/lustre/libcfs/hash.c                  | 4 ++++
 drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c | 2 ++
 drivers/staging/lustre/lustre/obdclass/cl_object.c           | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/staging/lustre/lustre/libcfs/hash.c b/drivers/staging/lustre/lustre/libcfs/hash.c
index 2d1e672..d89f81a 100644
--- a/drivers/staging/lustre/lustre/libcfs/hash.c
+++ b/drivers/staging/lustre/lustre/libcfs/hash.c
@@ -126,18 +126,21 @@ cfs_hash_nl_unlock(union cfs_hash_lock *lock, int exclusive) {}
 
 static inline void
 cfs_hash_spin_lock(union cfs_hash_lock *lock, int exclusive)
+	__acquires(&lock->spin)
 {
 	spin_lock(&lock->spin);
 }
 
 static inline void
 cfs_hash_spin_unlock(union cfs_hash_lock *lock, int exclusive)
+	__releases(&lock->spin)
 {
 	spin_unlock(&lock->spin);
 }
 
 static inline void
 cfs_hash_rw_lock(union cfs_hash_lock *lock, int exclusive)
+	__acquires(&lock->rw)
 {
 	if (!exclusive)
 		read_lock(&lock->rw);
@@ -147,6 +150,7 @@ cfs_hash_rw_lock(union cfs_hash_lock *lock, int exclusive)
 
 static inline void
 cfs_hash_rw_unlock(union cfs_hash_lock *lock, int exclusive)
+	__releases(&lock->rw)
 {
 	if (!exclusive)
 		read_unlock(&lock->rw);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
index fdc7189..c8e2930 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
@@ -151,6 +151,7 @@ cfs_trace_buf_type_t cfs_trace_buf_idx_get(void)
  * for details.
  */
 int cfs_trace_lock_tcd(struct cfs_trace_cpu_data *tcd, int walking)
+	__acquires(&tcd->tc_lock)
 {
 	__LASSERT(tcd->tcd_type < CFS_TCD_TYPE_MAX);
 	if (tcd->tcd_type == CFS_TCD_TYPE_IRQ)
@@ -165,6 +166,7 @@ int cfs_trace_lock_tcd(struct cfs_trace_cpu_data *tcd, int walking)
 }
 
 void cfs_trace_unlock_tcd(struct cfs_trace_cpu_data *tcd, int walking)
+	__releases(&tcd->tcd_lock)
 {
 	__LASSERT(tcd->tcd_type < CFS_TCD_TYPE_MAX);
 	if (tcd->tcd_type == CFS_TCD_TYPE_IRQ)
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_object.c b/drivers/staging/lustre/lustre/obdclass/cl_object.c
index c40bb6c..f13d1fb 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_object.c
@@ -193,6 +193,7 @@ static spinlock_t *cl_object_attr_guard(struct cl_object *o)
  * cl_object_attr_get(), cl_object_attr_set().
  */
 void cl_object_attr_lock(struct cl_object *o)
+	__acquires(cl_object_attr_guard(o))
 {
 	spin_lock(cl_object_attr_guard(o));
 }
@@ -202,6 +203,7 @@ EXPORT_SYMBOL(cl_object_attr_lock);
  * Releases data-attributes lock, acquired by cl_object_attr_lock().
  */
 void cl_object_attr_unlock(struct cl_object *o)
+	__releases(cl_object_attr_guard(o))
 {
 	spin_unlock(cl_object_attr_guard(o));
 }
-- 
2.2.1

