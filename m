Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaKZQWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:22:52 -0500
Received: from syn.loicp.eu ([176.31.96.212]:32800 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaKZQWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:22:50 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Nov 2014 11:22:50 EST
Date: Wed, 26 Nov 2014 17:15:48 +0100
From: Loic Pefferkorn <loic@loicp.eu>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, gdonald@gmail.com,
        keith.mannthey@intel.com, john.hammond@intel.com
Cc: devel@driverdev.osuosl.org, HPDD-discuss@ml01.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: fix sparse warnings related to lock context
 imbalance
Message-ID: <02a457cec587341d0f1665491f6360323694b008.1417017302.git.loic@loicp.eu>
Mail-Followup-To: oleg.drokin@intel.com, andreas.dilger@intel.com,
	gregkh@linuxfoundation.org, gdonald@gmail.com,
	keith.mannthey@intel.com, john.hammond@intel.com,
	devel@driverdev.osuosl.org, HPDD-discuss@lists.01.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __acquires() and __releases() function annotations, to fix sparse warnings related to lock context imbalance.

This fixes the following warnings:

drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c:153:5: warning: context imbalance in 'cfs_trace_lock_tcd' - wrong count at exit
drivers/staging/lustre/lustre/libcfs/hash.c:128:1: warning: context imbalance in 'cfs_hash_spin_lock' - wrong count at exit
drivers/staging/lustre/lustre/libcfs/hash.c:142:9: warning: context imbalance in 'cfs_hash_rw_lock' - wrong count at exit
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/l_lock.c:57:17: warning: context imbalance in 'lock_res_and_lock' - wrong count at exit
drivers/staging/lustre/lustre/libcfs/libcfs_lock.c:93:1: warning: context imbalance in 'cfs_percpt_lock' - wrong count at exit

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/lustre/lustre/libcfs/hash.c                  | 4 ++++
 drivers/staging/lustre/lustre/libcfs/libcfs_lock.c           | 2 ++
 drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c | 2 ++
 drivers/staging/lustre/lustre/obdclass/cl_object.c           | 2 ++
 4 files changed, 10 insertions(+)

diff --git a/drivers/staging/lustre/lustre/libcfs/hash.c b/drivers/staging/lustre/lustre/libcfs/hash.c
index 32da783..7c6e2a3 100644
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
diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c b/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
index 2c199c7..1e529fc 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
@@ -91,6 +91,7 @@ EXPORT_SYMBOL(cfs_percpt_lock_alloc);
  */
 void
 cfs_percpt_lock(struct cfs_percpt_lock *pcl, int index)
+	__acquires(pcl->pcl_locks[index])
 {
 	int	ncpt = cfs_cpt_number(pcl->pcl_cptab);
 	int	i;
@@ -125,6 +126,7 @@ EXPORT_SYMBOL(cfs_percpt_lock);
 /** unlock a CPU partition */
 void
 cfs_percpt_unlock(struct cfs_percpt_lock *pcl, int index)
+	__releases(pcl->pcl_locks[index])
 {
 	int	ncpt = cfs_cpt_number(pcl->pcl_cptab);
 	int	i;
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
index 976c61e..257669b 100644
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
index ce96bd2..8577f97 100644
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
2.1.2

