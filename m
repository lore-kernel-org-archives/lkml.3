Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3LBQhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:37:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:21888 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752311Ab3LBQg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:36:58 -0500
Date: Mon, 2 Dec 2013 11:36:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.8.13.13-rt25
Message-ID: <20131202113656.59fc764d@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.8.13.13-rt25 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.8-rt
  Head SHA1: 4d81f9bebd839789f8d3672f1bf6fdcbe3a8740f


Or to build 3.8.13.13-rt25 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/stable/patch-3.8.13.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13.13-rt25.patch.xz



You can also build from 3.8.13.13-rt24 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13.13-rt24-rt25.patch.xz



Enjoy,

-- Steve


Changes from v3.8.13.13-rt24:

---

Mike Galbraith (1):
      hwlat-detector: Don't ignore threshold module parameter

Sebastian Andrzej Siewior (2):
      mm/slub: do not rely on slab_cached passed to free_delayed()
      drm: remove preempt_disable() from drm_calc_vbltimestamp_from_scanoutpos()

Steven Rostedt (Red Hat) (1):
      Linux 3.8.13.13-rt25

Thomas Pfaff (1):
      genirq: Set the irq thread policy without checking CAP_SYS_NICE

Wolfram Sang (1):
      Kind of revert "powerpc: 52xx: provide a default in mpc52xx_irqhost_map()"

Yang Shi (1):
      mm/memcontrol: Don't call schedule_work_on in preemption disabled context

----
 arch/powerpc/platforms/52xx/mpc52xx_pic.c |  5 ++---
 drivers/gpu/drm/drm_irq.c                 |  7 -------
 drivers/misc/hwlat_detector.c             |  2 +-
 kernel/irq/manage.c                       |  2 +-
 localversion-rt                           |  2 +-
 mm/memcontrol.c                           |  4 ++--
 mm/slub.c                                 | 10 +++++-----
 7 files changed, 12 insertions(+), 20 deletions(-)
---------------------------
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index b69221b..2898b73 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -340,7 +340,7 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 {
 	int l1irq;
 	int l2irq;
-	struct irq_chip *irqchip;
+	struct irq_chip *uninitialized_var(irqchip);
 	void *hndlr;
 	int type;
 	u32 reg;
@@ -373,9 +373,8 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 	case MPC52xx_IRQ_L1_PERP: irqchip = &mpc52xx_periph_irqchip; break;
 	case MPC52xx_IRQ_L1_SDMA: irqchip = &mpc52xx_sdma_irqchip; break;
 	case MPC52xx_IRQ_L1_CRIT:
-	default:
 		pr_warn("%s: Critical IRQ #%d is unsupported! Nopping it.\n",
-			__func__, l1irq);
+			__func__, l2irq);
 		irq_set_chip(virq, &no_irq_chip);
 		return 0;
 	}
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 0f3cdda..fe7546e 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -624,11 +624,6 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 	 * code gets preempted or delayed for some reason.
 	 */
 	for (i = 0; i < DRM_TIMESTAMP_MAXRETRIES; i++) {
-		/* Disable preemption to make it very likely to
-		 * succeed in the first iteration even on PREEMPT_RT kernel.
-		 */
-		preempt_disable();
-
 		/* Get system timestamp before query. */
 		stime = ktime_get();
 
@@ -640,8 +635,6 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 		if (!drm_timestamp_monotonic)
 			mono_time_offset = ktime_get_monotonic_offset();
 
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
index a3cf48e..a569b71 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1044,7 +1044,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			goto out_mput;
 		}
 
-		sched_setscheduler(t, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &param);
 
 		/*
 		 * We keep the reference to the task struct even if
diff --git a/localversion-rt b/localversion-rt
index b2111a2..c5b71f9 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt24
+-rt25
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6b7ff19..1503ca3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2283,7 +2283,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
-	curcpu = get_cpu();
+	curcpu = get_cpu_light();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2300,7 +2300,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
-	put_cpu();
+	put_cpu_light();
 
 	if (!sync)
 		goto out;
diff --git a/mm/slub.c b/mm/slub.c
index f6871c5..7c925ae 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1427,13 +1427,13 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	__free_memcg_kmem_pages(page, order);
 }
 
-static void free_delayed(struct kmem_cache *s, struct list_head *h)
+static void free_delayed(struct list_head *h)
 {
 	while(!list_empty(h)) {
 		struct page *page = list_first_entry(h, struct page, lru);
 
 		list_del(&page->lru);
-		__free_slab(s, page);
+		__free_slab(page->slab_cache, page);
 	}
 }
 
@@ -2004,7 +2004,7 @@ static int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 				list_splice_init(&f->list, &tofree);
 				raw_spin_unlock(&f->lock);
 				local_irq_restore(flags);
-				free_delayed(s, &tofree);
+				free_delayed(&tofree);
 				oldpage = NULL;
 				pobjects = 0;
 				pages = 0;
@@ -2081,7 +2081,7 @@ static void flush_all(struct kmem_cache *s)
 		raw_spin_lock_irq(&f->lock);
 		list_splice_init(&f->list, &tofree);
 		raw_spin_unlock_irq(&f->lock);
-		free_delayed(s, &tofree);
+		free_delayed(&tofree);
 	}
 }
 
@@ -2329,7 +2329,7 @@ out:
 	list_splice_init(&f->list, &tofree);
 	raw_spin_unlock(&f->lock);
 	local_irq_restore(flags);
-	free_delayed(s, &tofree);
+	free_delayed(&tofree);
 	return freelist;
 
 new_slab:
