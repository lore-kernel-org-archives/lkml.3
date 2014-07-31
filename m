Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaGaD3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:29:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11177 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754477AbaGaD3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:29:12 -0400
X-IronPort-AV: E=Sophos;i="5.00,999,1396972800"; 
   d="scan'208";a="33996431"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        <stable@kernel.org>
Subject: [PATCH] smpboot: add missing get_online_cpus() when register
Date: Thu, 31 Jul 2014 11:30:17 +0800
Message-ID: <1406777421-12830-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the smpboot_register_percpu_thread() is called after smpboot_create_threads()
but before __cpu_up(), the smpboot thread of the online-ing CPU is not created,
and it results a bug.  So we use get_online_cpus() to prevent it.

smpboot_unregister_percpu_thread() travels all possible CPU, it doesn't need
get_online_cpus() which is removed in the patch.

CC: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
CC: stable@kernel.org
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/smpboot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index eb89e18..8adab87 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -279,6 +279,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	unsigned int cpu;
 	int ret = 0;
 
+	get_online_cpus();
 	mutex_lock(&smpboot_threads_lock);
 	for_each_online_cpu(cpu) {
 		ret = __smpboot_create_thread(plug_thread, cpu);
@@ -291,6 +292,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	list_add(&plug_thread->list, &hotplug_threads);
 out:
 	mutex_unlock(&smpboot_threads_lock);
+	put_online_cpus();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
@@ -303,11 +305,9 @@ EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
  */
 void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread)
 {
-	get_online_cpus();
 	mutex_lock(&smpboot_threads_lock);
 	list_del(&plug_thread->list);
 	smpboot_destroy_threads(plug_thread);
 	mutex_unlock(&smpboot_threads_lock);
-	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(smpboot_unregister_percpu_thread);
-- 
1.7.4.4

