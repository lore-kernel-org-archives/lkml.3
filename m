Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3IKEkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:40:51 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58910 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab3IKEkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:40:49 -0400
Date: Tue, 10 Sep 2013 21:37:19 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Keith Mannthey <Keith.Mannthey@intel.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Emil Goode <emilgoode@gmail.com>,
        Nikitas Angelinas <nikitas_angelinas@xyratex.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: lustre: clean up format string usages
Message-ID: <20130911043719.GA17181@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up the usage of snprintf, strncpy, and format strings in the
call to kthread_run to avoid ever accidentally allowing a format string
into the thread name.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    2 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |    2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    4 ++--
 drivers/staging/lustre/lustre/libcfs/workitem.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |    4 ++--
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |    8 ++++----
 drivers/staging/lustre/lustre/ptlrpc/service.c     |    6 +++---
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 086ca3d..26b49a2 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -1802,7 +1802,7 @@ kiblnd_recv (lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg, int delayed,
 int
 kiblnd_thread_start(int (*fn)(void *arg), void *arg, char *name)
 {
-	struct task_struct *task = kthread_run(fn, arg, name);
+	struct task_struct *task = kthread_run(fn, arg, "%s", name);
 
 	if (IS_ERR(task))
 		return PTR_ERR(task);
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index 2c581b7..68a4f52 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -1005,7 +1005,7 @@ ksocknal_send(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 int
 ksocknal_thread_start(int (*fn)(void *arg), void *arg, char *name)
 {
-	struct task_struct *task = kthread_run(fn, arg, name);
+	struct task_struct *task = kthread_run(fn, arg, "%s", name);
 
 	if (IS_ERR(task))
 		return PTR_ERR(task);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index 3916bda..a100a0b 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -800,9 +800,9 @@ static int ldlm_bl_thread_start(struct ldlm_bl_pool *blp)
 
 	init_completion(&bltd.bltd_comp);
 	bltd.bltd_num = atomic_read(&blp->blp_num_threads);
-	snprintf(bltd.bltd_name, sizeof(bltd.bltd_name) - 1,
+	snprintf(bltd.bltd_name, sizeof(bltd.bltd_name),
 		"ldlm_bl_%02d", bltd.bltd_num);
-	task = kthread_run(ldlm_bl_thread_main, &bltd, bltd.bltd_name);
+	task = kthread_run(ldlm_bl_thread_main, &bltd, "%s", bltd.bltd_name);
 	if (IS_ERR(task)) {
 		CERROR("cannot start LDLM thread ldlm_bl_%02d: rc %ld\n",
 		       atomic_read(&blp->blp_num_threads), PTR_ERR(task));
diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
index 462172d..1a55c81 100644
--- a/drivers/staging/lustre/lustre/libcfs/workitem.c
+++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
@@ -397,7 +397,7 @@ cfs_wi_sched_create(char *name, struct cfs_cpt_table *cptab,
 				 sched->ws_name, sched->ws_nthreads);
 		}
 
-		task = kthread_run(cfs_wi_scheduler, sched, name);
+		task = kthread_run(cfs_wi_scheduler, sched, "%s", name);
 		if (!IS_ERR(task)) {
 			nthrs--;
 			continue;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 227a0ae..5dec771 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -383,8 +383,8 @@ int ptlrpc_start_pinger(void)
 
 	/* CLONE_VM and CLONE_FILES just avoid a needless copy, because we
 	 * just drop the VM and FILES in cfs_daemonize_ctxt() right away. */
-	rc = PTR_ERR(kthread_run(ptlrpc_pinger_main,
-				 &pinger_thread, pinger_thread.t_name));
+	rc = PTR_ERR(kthread_run(ptlrpc_pinger_main, &pinger_thread,
+				 "%s", pinger_thread.t_name));
 	if (IS_ERR_VALUE(rc)) {
 		CERROR("cannot start thread: %d\n", rc);
 		return rc;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
index fbdeff6..89c9be9 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
@@ -615,7 +615,7 @@ int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 	init_completion(&pc->pc_starting);
 	init_completion(&pc->pc_finishing);
 	spin_lock_init(&pc->pc_lock);
-	strncpy(pc->pc_name, name, sizeof(pc->pc_name) - 1);
+	strlcpy(pc->pc_name, name, sizeof(pc->pc_name));
 	pc->pc_set = ptlrpc_prep_set();
 	if (pc->pc_set == NULL)
 		GOTO(out, rc = -ENOMEM);
@@ -638,7 +638,7 @@ int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 				GOTO(out, rc);
 		}
 
-		task = kthread_run(ptlrpcd, pc, pc->pc_name);
+		task = kthread_run(ptlrpcd, pc, "%s", pc->pc_name);
 		if (IS_ERR(task))
 			GOTO(out, rc = PTR_ERR(task));
 
@@ -745,7 +745,7 @@ static int ptlrpcd_init(void)
 	if (ptlrpcds == NULL)
 		GOTO(out, rc = -ENOMEM);
 
-	snprintf(name, 15, "ptlrpcd_rcv");
+	snprintf(name, sizeof(name), "ptlrpcd_rcv");
 	set_bit(LIOD_RECOVERY, &ptlrpcds->pd_thread_rcv.pc_flags);
 	rc = ptlrpcd_start(-1, nthreads, name, &ptlrpcds->pd_thread_rcv);
 	if (rc < 0)
@@ -764,7 +764,7 @@ static int ptlrpcd_init(void)
 	 *      unnecessary dependency. But how to distribute async RPCs load
 	 *      among all the ptlrpc daemons becomes another trouble. */
 	for (i = 0; i < nthreads; i++) {
-		snprintf(name, 15, "ptlrpcd_%d", i);
+		snprintf(name, sizeof(name), "ptlrpcd_%d", i);
 		rc = ptlrpcd_start(i, nthreads, name, &ptlrpcds->pd_threads[i]);
 		if (rc < 0)
 			GOTO(out, rc);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index ac8b5fd..acf75f3 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -2718,15 +2718,15 @@ int ptlrpc_start_thread(struct ptlrpc_service_part *svcpt, int wait)
 	spin_unlock(&svcpt->scp_lock);
 
 	if (svcpt->scp_cpt >= 0) {
-		snprintf(thread->t_name, PTLRPC_THR_NAME_LEN, "%s%02d_%03d",
+		snprintf(thread->t_name, sizeof(thread->t_name), "%s%02d_%03d",
 			 svc->srv_thread_name, svcpt->scp_cpt, thread->t_id);
 	} else {
-		snprintf(thread->t_name, PTLRPC_THR_NAME_LEN, "%s_%04d",
+		snprintf(thread->t_name, sizeof(thread->t_name), "%s_%04d",
 			 svc->srv_thread_name, thread->t_id);
 	}
 
 	CDEBUG(D_RPCTRACE, "starting thread '%s'\n", thread->t_name);
-	rc = PTR_ERR(kthread_run(ptlrpc_main, thread, thread->t_name));
+	rc = PTR_ERR(kthread_run(ptlrpc_main, thread, "%s", thread->t_name));
 	if (IS_ERR_VALUE(rc)) {
 		CERROR("cannot start thread '%s': rc %d\n",
 		       thread->t_name, rc);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
