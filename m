Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3LBQia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:38:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:8968 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752727Ab3LBQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:38:26 -0500
Date: Mon, 2 Dec 2013 11:38:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.2.52-rt74
Message-ID: <20131202113825.773fe9dd@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.52-rt74 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.2-rt
  Head SHA1: 0d68db4a4e26e478739458720e4970b9824f47a2


Or to build 3.2.52-rt74 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.52.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.52-rt74.patch.xz



You can also build from 3.2.52-rt73 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.52-rt73-rt74.patch.xz



Enjoy,

-- Steve


Changes from v3.2.52-rt73:

---

Mike Galbraith (1):
      hwlat-detector: Don't ignore threshold module parameter

Sebastian Andrzej Siewior (1):
      drm: remove preempt_disable() from drm_calc_vbltimestamp_from_scanoutpos()

Steven Rostedt (Red Hat) (1):
      Linux 3.2.52-rt74

Thomas Pfaff (1):
      genirq: Set the irq thread policy without checking CAP_SYS_NICE

Yang Shi (1):
      mm/memcontrol: Don't call schedule_work_on in preemption disabled context

----
 drivers/gpu/drm/drm_irq.c     | 7 -------
 drivers/misc/hwlat_detector.c | 2 +-
 kernel/irq/manage.c           | 2 +-
 localversion-rt               | 2 +-
 mm/memcontrol.c               | 4 ++--
 5 files changed, 5 insertions(+), 12 deletions(-)
---------------------------
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 73af885..2b13224 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -619,11 +619,6 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 	 * code gets preempted or delayed for some reason.
 	 */
 	for (i = 0; i < DRM_TIMESTAMP_MAXRETRIES; i++) {
-		/* Disable preemption to make it very likely to
-		 * succeed in the first iteration even on PREEMPT_RT kernel.
-		 */
-		preempt_disable();
-
 		/* Get system timestamp before query. */
 		do_gettimeofday(&stime);
 
@@ -633,8 +628,6 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 		/* Get system timestamp after query. */
 		do_gettimeofday(&raw_time);
 
-		preempt_enable();
-
 		/* Return as no-op if scanout query unsupported or failed. */
 		if (!(vbl_status & DRM_SCANOUTPOS_VALID)) {
 			DRM_DEBUG("crtc %d : scanoutpos query failed [%d].\n",
diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index 6f61d5f..d2676b8 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -413,7 +413,7 @@ static int init_stats(void)
 		goto out;
 
 	__reset_stats();
-	data.threshold = DEFAULT_LAT_THRESHOLD;	    /* threshold us */
+	data.threshold = threshold ?: DEFAULT_LAT_THRESHOLD;	    /* threshold us */
 	data.sample_window = DEFAULT_SAMPLE_WINDOW; /* window us */
 	data.sample_width = DEFAULT_SAMPLE_WIDTH;   /* width us */
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 88a4ff5..5b51ba7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1041,7 +1041,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			goto out_mput;
 		}
 
-		sched_setscheduler(t, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &param);
 
 		/*
 		 * We keep the reference to the task struct even if
diff --git a/localversion-rt b/localversion-rt
index e8ada8c..7d028f4 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt73
+-rt74
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f8bdd8d..df84f45 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2077,7 +2077,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
-	curcpu = get_cpu();
+	curcpu = get_cpu_light();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2094,7 +2094,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
-	put_cpu();
+	put_cpu_light();
 
 	if (!sync)
 		goto out;
