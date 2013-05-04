Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934562Ab3EDBCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 21:02:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22345 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934420Ab3EDBCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 21:02:31 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=rDoqQw2vEtoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=F_i-Va4x4dEA:10 a=HtGwPfanYq0meMElFpsA:9 a=jeBq3FmKZ4MA:10 a=9J5VuaLb3qoA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130504010230.006664180@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 03 May 2013 21:02:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <bitbucket@online.de>
Subject: [PATCH RT 3/4] swap: Use unique local lock name for swap_lock
References: <20130504010207.365885836@goodmis.org>
Content-Disposition: inline; filename=0003-swap-Use-unique-local-lock-name-for-swap_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

>From lib/Kconfig.debug on CONFIG_FORCE_WEAK_PER_CPU:

----
s390 and alpha require percpu variables in modules to be
defined weak to work around addressing range issue which
puts the following two restrictions on percpu variable
definitions.

1. percpu symbols must be unique whether static or not
2. percpu variables can't be defined inside a function

To ensure that generic code follows the above rules, this
option forces all percpu variables to be defined as weak.
----

The addition of the local IRQ swap_lock in mm/swap.c broke this config
as the name "swap_lock" is used through out the kernel. Just do a "git
grep swap_lock" to see, and the new swap_lock is a local lock which
defines the swap_lock for per_cpu.

The fix was to rename swap_lock to swapvec_lock which keeps it unique.

Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/swap.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 662972f..ccf04d2 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -43,7 +43,7 @@ static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
 
 static DEFINE_LOCAL_IRQ_LOCK(rotate_lock);
-static DEFINE_LOCAL_IRQ_LOCK(swap_lock);
+static DEFINE_LOCAL_IRQ_LOCK(swapvec_lock);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -331,13 +331,13 @@ static void activate_page_drain(int cpu)
 void activate_page(struct page *page)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-		struct pagevec *pvec = &get_locked_var(swap_lock,
+		struct pagevec *pvec = &get_locked_var(swapvec_lock,
 						       activate_page_pvecs);
 
 		page_cache_get(page);
 		if (!pagevec_add(pvec, page))
 			pagevec_lru_move_fn(pvec, __activate_page, NULL);
-		put_locked_var(swap_lock, activate_page_pvecs);
+		put_locked_var(swapvec_lock, activate_page_pvecs);
 	}
 }
 
@@ -378,12 +378,12 @@ EXPORT_SYMBOL(mark_page_accessed);
 
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
-	struct pagevec *pvec = &get_locked_var(swap_lock, lru_add_pvecs)[lru];
+	struct pagevec *pvec = &get_locked_var(swapvec_lock, lru_add_pvecs)[lru];
 
 	page_cache_get(page);
 	if (!pagevec_add(pvec, page))
 		____pagevec_lru_add(pvec, lru);
-	put_locked_var(swap_lock, lru_add_pvecs);
+	put_locked_var(swapvec_lock, lru_add_pvecs);
 }
 EXPORT_SYMBOL(__lru_cache_add);
 
@@ -547,19 +547,19 @@ void deactivate_page(struct page *page)
 		return;
 
 	if (likely(get_page_unless_zero(page))) {
-		struct pagevec *pvec = &get_locked_var(swap_lock,
+		struct pagevec *pvec = &get_locked_var(swapvec_lock,
 						       lru_deactivate_pvecs);
 
 		if (!pagevec_add(pvec, page))
 			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
-		put_locked_var(swap_lock, lru_deactivate_pvecs);
+		put_locked_var(swapvec_lock, lru_deactivate_pvecs);
 	}
 }
 
 void lru_add_drain(void)
 {
-	drain_cpu_pagevecs(local_lock_cpu(swap_lock));
-	local_unlock_cpu(swap_lock);
+	drain_cpu_pagevecs(local_lock_cpu(swapvec_lock));
+	local_unlock_cpu(swapvec_lock);
 }
 
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
@@ -776,7 +776,7 @@ EXPORT_SYMBOL(pagevec_lookup);
 static int __init swap_init_locks(void)
 {
 	local_irq_lock_init(rotate_lock);
-	local_irq_lock_init(swap_lock);
+	local_irq_lock_init(swapvec_lock);
 	return 1;
 }
 early_initcall(swap_init_locks);
-- 
1.7.10.4


