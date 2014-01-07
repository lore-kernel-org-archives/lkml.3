Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaAGItU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:49:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:48677 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbaAGItT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:49:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="461249877"
Subject: [PATCH 1/3] workqueue: Calling destroy_work_on_stack() to pair
 with INIT_WORK_ONSTACK()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jan 2014 16:50:05 +0800
Message-ID: <1389084605.3650.66.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
call destroy_work_on_stack() which frees the debug object to pair
with INIT_WORK_ONSTACK().

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 kernel/workqueue.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b010eac..82ef9f3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4789,6 +4789,7 @@ static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 
 		/* wait for per-cpu unbinding to finish */
 		flush_work(&unbind_work);
+		destroy_work_on_stack(&unbind_work);
 		break;
 	}
 	return NOTIFY_OK;
@@ -4828,6 +4829,7 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
 	schedule_work_on(cpu, &wfc.work);
 	flush_work(&wfc.work);
+	destroy_work_on_stack(&wfc.work);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
-- 
1.7.9.5



