Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaCWPJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:09:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:58099 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaCWPJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:23 -0400
Message-Id: <20140323150754.272874059@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        cpufreq <cpufreq@vger.kernel.org>, pm <linux-pm@vger.kernel.org>
Subject: [patch 15/16] cpufreq: intel-pstate: Use del_timer_sync in
 intel_pstate_cpu_exit() 
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline;
 filename=cpufreq-intel-pstate-use-del_timer_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are about to free the data structure. Make sure no timer callback
is running. I might be paranoid, but the ->exit callback can be
invoked from so many places, that it is not entirely clear whether
del_timer is always called on the cpu on which it is enqueued.

While looking through the call sites I noticed, that
cpufreq_init_policy() can fail and invoke cpufreq_driver->exit() but
it does not return the failure and the callsite happily proceeds.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: cpufreq <cpufreq@vger.kernel.org>
Cc: pm <linux-pm@vger.kernel.org>
---

 drivers/cpufreq/intel_pstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/drivers/cpufreq/intel_pstate.c
===================================================================
--- tip.orig/drivers/cpufreq/intel_pstate.c
+++ tip/drivers/cpufreq/intel_pstate.c
@@ -777,7 +777,7 @@ static int intel_pstate_cpu_exit(struct
 {
 	int cpu = policy->cpu;
 
-	del_timer(&all_cpu_data[cpu]->timer);
+	del_timer_sync(&all_cpu_data[cpu]->timer);
 	kfree(all_cpu_data[cpu]);
 	all_cpu_data[cpu] = NULL;
 	return 0;


