Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaC1Ku4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:50:56 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:35487 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaC1Kuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:50:54 -0400
Message-ID: <533553E2.7050801@huawei.com>
Date: Fri, 28 Mar 2014 18:50:10 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v4 1/4] kmemleak: free internal objects only if there're no
 leaks to be reported
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if you stop kmemleak thread before disabling kmemleak,
kmemleak objects will be freed and so you won't be able to check
previously reported leaks.

With this patch, kmemleak objects won't be freed if there're leaks
that can be reported.

v2: s/kmemleak_as_leaks/kmemleak_found_leaks

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/kmemleak.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 31f01c5..474379e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -218,7 +218,8 @@ static int kmemleak_stack_scan = 1;
 static DEFINE_MUTEX(scan_mutex);
 /* setting kmemleak=on, will set this var, skipping the disable */
 static int kmemleak_skip_disable;
-
+/* If there are leaks that can be reported */
+static bool kmemleak_found_leaks;
 
 /*
  * Early object allocation/freeing logging. Kmemleak is initialized after the
@@ -1382,9 +1383,12 @@ static void kmemleak_scan(void)
 	}
 	rcu_read_unlock();
 
-	if (new_leaks)
+	if (new_leaks) {
+		kmemleak_found_leaks = true;
+
 		pr_info("%d new suspected memory leaks (see "
 			"/sys/kernel/debug/kmemleak)\n", new_leaks);
+	}
 
 }
 
@@ -1592,6 +1596,8 @@ static void kmemleak_clear(void)
 		spin_unlock_irqrestore(&object->lock, flags);
 	}
 	rcu_read_unlock();
+
+	kmemleak_found_leaks = false;
 }
 
 /*
@@ -1685,12 +1691,11 @@ static const struct file_operations kmemleak_fops = {
 static void kmemleak_do_cleanup(struct work_struct *work)
 {
 	struct kmemleak_object *object;
-	bool cleanup = scan_thread == NULL;
 
 	mutex_lock(&scan_mutex);
 	stop_scan_thread();
 
-	if (cleanup) {
+	if (!kmemleak_found_leaks) {
 		rcu_read_lock();
 		list_for_each_entry_rcu(object, &object_list, object_list)
 			delete_object_full(object->pointer);
-- 
1.8.0.2

