Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3LSXfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:35:32 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:52788 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3LSXfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:35:31 -0500
Date: Thu, 19 Dec 2013 18:35:26 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH wq/for-3.14 1/2] workqueue: update max_active clamping rules
Message-ID: <20131219233526.GD22725@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131218213936.GA8218@mtj.dyndns.org>
 <20131218214128.GB8218@mtj.dyndns.org>
 <1735137.dNmBz0IqxU@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1735137.dNmBz0IqxU@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bdd220b2a1b86fee14a12b69fb0cadafe60a1dac Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 19 Dec 2013 18:33:09 -0500

@max_active handling is currently inconsistent.

* In alloc_workqueue(), 0 gets converted to the default and the value
  gets clamped to [1, lim].

* In workqueue_set_max_active(), 0 is not converted to the default and
  the value is clamped to [1, lim].

* When a workqueue is exposed through sysfs, input < 1 fails with
  -EINVAL; otherwise, the value is clamped to [1, lim].

* fscache exposes max_active through a sysctl and clamps the value in
  [1, lim].

We want to be able to express zero @max_active but as it's a special
case and 0 is already used for default, don't want to use 0 for it.
Update @max_active clamping so that the following rules are followed.

* In both alloc_workqueue() and workqueue_set_max_active(), 0 is
  converted to the default, and a new special value WQ_FROZEN_ACTIVE
  becomes 0; otherwise, the value is clamped to [1, lim].

* In both sysfs and fscache sysctl, input < 1 fails with -EINVAL;
  otherwise, the value is clamped to [1, lim].

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
---
 fs/fscache/main.c         | 10 +++++++---
 include/linux/workqueue.h |  1 +
 kernel/workqueue.c        |  6 +++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 7c27907..9d5a716 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -62,9 +62,13 @@ static int fscache_max_active_sysctl(struct ctl_table *table, int write,
 	int ret;
 
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (ret == 0)
-		workqueue_set_max_active(*wqp, *datap);
-	return ret;
+	if (ret < 0)
+		return ret;
+	if (*datap < 1)
+		return -EINVAL;
+
+	workqueue_set_max_active(*wqp, *datap);
+	return 0;
 }
 
 ctl_table fscache_sysctls[] = {
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..334daa3 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -338,6 +338,7 @@ enum {
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
 
+	WQ_FROZEN_ACTIVE	= -1,	  /* special value for frozen wq */
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
 	WQ_DFL_ACTIVE		= WQ_MAX_ACTIVE / 2,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..6748fbf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4136,6 +4136,11 @@ static int wq_clamp_max_active(int max_active, unsigned int flags,
 {
 	int lim = flags & WQ_UNBOUND ? WQ_UNBOUND_MAX_ACTIVE : WQ_MAX_ACTIVE;
 
+	if (max_active == 0)
+		return WQ_DFL_ACTIVE;
+	if (max_active == WQ_FROZEN_ACTIVE)
+		return 0;
+
 	if (max_active < 1 || max_active > lim)
 		pr_warn("workqueue: max_active %d requested for %s is out of range, clamping between %d and %d\n",
 			max_active, name, 1, lim);
@@ -4176,7 +4181,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	vsnprintf(wq->name, sizeof(wq->name), fmt, args);
 	va_end(args);
 
-	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 
 	/* init wq */
-- 
1.8.4.2

