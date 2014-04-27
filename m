Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaD0RIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:37 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48099 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbaD0RI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:28 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 35/47] staging/lustre: replace semaphores with mutexes
Date: Sun, 27 Apr 2014 13:06:59 -0400
Message-Id: <1398618431-29757-36-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

It's just optimization. The mutex subsystem is slightly faster
and has better scalability for contended workloads.

Remove the lustre_lock and it's accessor functions l_lock(),
l_unlock(), l_lock_init(), and l_has_lock() since they have
not been used by the code since Lustre 1.6.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9294
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4588
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_lib.h     | 13 -------------
 drivers/staging/lustre/lustre/include/obd.h            |  2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c          |  2 +-
 drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c | 16 ++++++++--------
 drivers/staging/lustre/lustre/mgc/mgc_request.c        |  8 ++++----
 5 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index 0368ca6..bdc9812 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -94,19 +94,6 @@ struct obd_client_handle {
 void statfs_pack(struct obd_statfs *osfs, struct kstatfs *sfs);
 void statfs_unpack(struct kstatfs *sfs, struct obd_statfs *osfs);
 
-/* l_lock.c */
-struct lustre_lock {
-	int			l_depth;
-	struct task_struct	*l_owner;
-	struct semaphore	l_sem;
-	spinlock_t		l_spin;
-};
-
-void l_lock_init(struct lustre_lock *);
-void l_lock(struct lustre_lock *);
-void l_unlock(struct lustre_lock *);
-int l_has_lock(struct lustre_lock *);
-
 /*
  * For md echo client
  */
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 7ed5fcd..d5c4613 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -406,7 +406,7 @@ struct client_obd {
 	struct mdc_rpc_lock     *cl_close_lock;
 
 	/* mgc datastruct */
-	struct semaphore	 cl_mgc_sem;
+	struct mutex		 cl_mgc_mutex;
 	struct local_oid_storage *cl_mgc_los;
 	struct dt_object	*cl_mgc_configs_dir;
 	atomic_t	     cl_mgc_refcount;
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index 42f5f1e..8bb5915 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -325,7 +325,7 @@ int client_obd_setup(struct obd_device *obddev, struct lustre_cfg *lcfg)
 	}
 
 	init_rwsem(&cli->cl_sem);
-	sema_init(&cli->cl_mgc_sem, 1);
+	mutex_init(&cli->cl_mgc_mutex);
 	cli->cl_conn_count = 0;
 	memcpy(server_uuid.uuid, lustre_cfg_buf(lcfg, 2),
 	       min_t(unsigned int, LUSTRE_CFG_BUFLEN(lcfg, 2),
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
index d169374..fc21210 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
@@ -71,7 +71,7 @@ struct cfs_cpt_data {
 	/* reserved for hotplug */
 	unsigned long		cpt_version;
 	/* mutex to protect cpt_cpumask */
-	struct semaphore	cpt_mutex;
+	struct mutex		cpt_mutex;
 	/* scratch buffer for set/unset_node */
 	cpumask_t		*cpt_cpumask;
 };
@@ -420,14 +420,14 @@ cfs_cpt_set_node(struct cfs_cpt_table *cptab, int cpt, int node)
 		return 0;
 	}
 
-	down(&cpt_data.cpt_mutex);
+	mutex_lock(&cpt_data.cpt_mutex);
 
 	mask = cpt_data.cpt_cpumask;
 	cfs_node_to_cpumask(node, mask);
 
 	rc = cfs_cpt_set_cpumask(cptab, cpt, mask);
 
-	up(&cpt_data.cpt_mutex);
+	mutex_unlock(&cpt_data.cpt_mutex);
 
 	return rc;
 }
@@ -444,14 +444,14 @@ cfs_cpt_unset_node(struct cfs_cpt_table *cptab, int cpt, int node)
 		return;
 	}
 
-	down(&cpt_data.cpt_mutex);
+	mutex_lock(&cpt_data.cpt_mutex);
 
 	mask = cpt_data.cpt_cpumask;
 	cfs_node_to_cpumask(node, mask);
 
 	cfs_cpt_unset_cpumask(cptab, cpt, mask);
 
-	up(&cpt_data.cpt_mutex);
+	mutex_unlock(&cpt_data.cpt_mutex);
 }
 EXPORT_SYMBOL(cfs_cpt_unset_node);
 
@@ -969,11 +969,11 @@ cfs_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 			break;
 		}
 
-		down(&cpt_data.cpt_mutex);
+		mutex_lock(&cpt_data.cpt_mutex);
 		/* if all HTs in a core are offline, it may break affinity */
 		cfs_cpu_ht_siblings(cpu, cpt_data.cpt_cpumask);
 		warn = any_online_cpu(*cpt_data.cpt_cpumask) >= nr_cpu_ids;
-		up(&cpt_data.cpt_mutex);
+		mutex_unlock(&cpt_data.cpt_mutex);
 		CDEBUG(warn ? D_WARNING : D_INFO,
 		       "Lustre: can't support CPU plug-out well now, "
 		       "performance and stability could be impacted "
@@ -1017,7 +1017,7 @@ cfs_cpu_init(void)
 	}
 
 	spin_lock_init(&cpt_data.cpt_lock);
-	sema_init(&cpt_data.cpt_mutex, 1);
+	mutex_init(&cpt_data.cpt_mutex);
 
 #ifdef CONFIG_HOTPLUG_CPU
 	register_hotcpu_notifier(&cfs_cpu_notifier);
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index de9fb14..a806aef 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -672,8 +672,8 @@ static int mgc_fs_setup(struct obd_device *obd, struct super_block *sb)
 	if (env == NULL)
 		return -ENOMEM;
 
-	/* The mgc fs exclusion sem. Only one fs can be setup at a time. */
-	down(&cli->cl_mgc_sem);
+	/* The mgc fs exclusion mutex. Only one fs can be setup at a time. */
+	mutex_lock(&cli->cl_mgc_mutex);
 
 	cfs_cleanup_group_info();
 
@@ -727,7 +727,7 @@ out_los:
 	if (rc < 0) {
 		local_oid_storage_fini(env, cli->cl_mgc_los);
 		cli->cl_mgc_los = NULL;
-		up(&cli->cl_mgc_sem);
+		mutex_unlock(&cli->cl_mgc_mutex);
 	}
 out_env:
 	lu_env_fini(env);
@@ -759,7 +759,7 @@ static int mgc_fs_cleanup(struct obd_device *obd)
 
 unlock:
 	class_decref(obd, "mgc_fs", obd);
-	up(&cli->cl_mgc_sem);
+	mutex_unlock(&cli->cl_mgc_mutex);
 
 	return 0;
 }
-- 
1.8.5.3

