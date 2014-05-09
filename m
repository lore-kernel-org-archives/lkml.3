Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaEIAQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 20:16:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:3749 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753280AbaEIAQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 20:16:45 -0400
Date: Thu, 8 May 2014 20:16:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.12.15-rt26
Message-ID: <20140508201643.359d0768@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.12.15-rt26 stable release.

The 3.12-rt series is now under the stable releases. This came out
later than scheduled due to making sure one of the updates was correct.

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.12-rt
  Head SHA1: d0785b146144c18f524d17908d880c553865e417


Or to build 3.12.15-rt26 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.12.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.12.15.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.15-rt26.patch.xz



You can also build from 3.12.15-rt25 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.15-rt25-rt26.patch.xz



Enjoy,

-- Steve


Changes from v3.12.15-rt25:

---

Steven Rostedt (1):
      rt: Move migrate_disable up in trylocks

Steven Rostedt (Red Hat) (2):
      net: gianfar: Fix missing return of gfar_clean_tx_ring()
      Linux 3.12.15-rt26

----
 drivers/net/ethernet/freescale/gianfar.c |  1 +
 kernel/rt.c                              | 20 ++++++++++++--------
 localversion-rt                          |  2 +-
 3 files changed, 14 insertions(+), 9 deletions(-)
---------------------------
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 091945c..df27493 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2615,6 +2615,7 @@ static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 	tx_queue->dirty_tx = bdp;
 
 	netdev_tx_completed_queue(txq, howmany, bytes_sent);
+	return howmany;
 }
 
 static void gfar_schedule_cleanup(struct gfar_priv_grp *gfargrp)
diff --git a/kernel/rt.c b/kernel/rt.c
index 5d17727..5f44def 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -180,12 +180,15 @@ EXPORT_SYMBOL(_mutex_unlock);
  */
 int __lockfunc rt_write_trylock(rwlock_t *rwlock)
 {
-	int ret = rt_mutex_trylock(&rwlock->lock);
+	int ret;
+
+	migrate_disable();
+	ret = rt_mutex_trylock(&rwlock->lock);
 
-	if (ret) {
+	if (ret)
 		rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
-		migrate_disable();
-	}
+	else
+		migrate_enable();
 
 	return ret;
 }
@@ -212,11 +215,12 @@ int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 	 * write locked.
 	 */
 	if (rt_mutex_owner(lock) != current) {
+		migrate_disable();
 		ret = rt_mutex_trylock(lock);
-		if (ret) {
+		if (ret)
 			rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
-			migrate_disable();
-		}
+		else
+			migrate_enable();
 	} else if (!rwlock->read_depth) {
 		ret = 0;
 	}
@@ -245,8 +249,8 @@ void __lockfunc rt_read_lock(rwlock_t *rwlock)
 	 */
 	if (rt_mutex_owner(lock) != current) {
 		rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
-		__rt_spin_lock(lock);
 		migrate_disable();
+		__rt_spin_lock(lock);
 	}
 	rwlock->read_depth++;
 }
diff --git a/localversion-rt b/localversion-rt
index c5b71f9..2e9afd4 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt25
+-rt26
