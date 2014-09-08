Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaIHAaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 20:30:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48331 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaIHAaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 20:30:18 -0400
Date: Mon, 8 Sep 2014 09:30:13 +0900
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org
Subject: [PATCH 0.5/3] percpu_counter: make percpu_counters_lock irq-safe
Message-ID: <20140908003013.GB5061@mtj.dyndns.org>
References: <1409013812-21700-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409013812-21700-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter is scheduled to grow @gfp support to allow atomic
initialization.  This patch makes percpu_counters_lock irq-safe so
that it can be safely used from atomic contexts.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 lib/percpu_counter.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -115,6 +115,8 @@ EXPORT_SYMBOL(__percpu_counter_sum);
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount, gfp_t gfp,
 			  struct lock_class_key *key)
 {
+	unsigned long flags __maybe_unused;
+
 	raw_spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
@@ -126,9 +128,9 @@ int __percpu_counter_init(struct percpu_
 
 #ifdef CONFIG_HOTPLUG_CPU
 	INIT_LIST_HEAD(&fbc->list);
-	spin_lock(&percpu_counters_lock);
+	spin_lock_irqsave(&percpu_counters_lock, flags);
 	list_add(&fbc->list, &percpu_counters);
-	spin_unlock(&percpu_counters_lock);
+	spin_unlock_irqrestore(&percpu_counters_lock, flags);
 #endif
 	return 0;
 }
@@ -136,15 +138,17 @@ EXPORT_SYMBOL(__percpu_counter_init);
 
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
+	unsigned long flags __maybe_unused;
+
 	if (!fbc->counters)
 		return;
 
 	debug_percpu_counter_deactivate(fbc);
 
 #ifdef CONFIG_HOTPLUG_CPU
-	spin_lock(&percpu_counters_lock);
+	spin_lock_irqsave(&percpu_counters_lock, flags);
 	list_del(&fbc->list);
-	spin_unlock(&percpu_counters_lock);
+	spin_unlock_irqrestore(&percpu_counters_lock, flags);
 #endif
 	free_percpu(fbc->counters);
 	fbc->counters = NULL;
@@ -173,7 +177,7 @@ static int percpu_counter_hotcpu_callbac
 		return NOTIFY_OK;
 
 	cpu = (unsigned long)hcpu;
-	spin_lock(&percpu_counters_lock);
+	spin_lock_irq(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
 		s32 *pcount;
 		unsigned long flags;
@@ -184,7 +188,7 @@ static int percpu_counter_hotcpu_callbac
 		*pcount = 0;
 		raw_spin_unlock_irqrestore(&fbc->lock, flags);
 	}
-	spin_unlock(&percpu_counters_lock);
+	spin_unlock_irq(&percpu_counters_lock);
 #endif
 	return NOTIFY_OK;
 }
