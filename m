Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab3DVFtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:49:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65390 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab3DVFt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:49:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,524,1363104000"; 
   d="scan'208";a="7109997"
From: liguang <lig.fnst@cn.fujitsu.com>
To: tglx@linutronix.de, peterz@infradead.org, akpm@linux-foundation.org,
        shli@fusionio.com, srivatsa.bhat@linux.vnet.ibm.com,
        suresh.b.siddha@intel.com, fweisbec@gmail.com, sedat.dilek@gmail.com,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] smp: remove 'priv' of call_single_data
Date: Mon, 22 Apr 2013 13:47:23 +0800
Message-Id: <1366609643-17628-2-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1366609643-17628-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1366609643-17628-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/22 13:47:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/22 13:47:50,
	Serialize complete at 2013/04/22 13:47:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the 'priv' field seems a little redundant,
because we can pass data via 'info'.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 include/linux/smp.h |    1 -
 kernel/softirq.c    |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 3e07a7d..e6564c1 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -20,7 +20,6 @@ struct call_single_data {
 	smp_call_func_t func;
 	void *info;
 	u16 flags;
-	u16 priv;
 };
 
 /* total number of cpus in this system (may exceed NR_CPUS) */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 14d7758..aa82723 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -620,8 +620,7 @@ static void remote_softirq_receive(void *data)
 	unsigned long flags;
 	int softirq;
 
-	softirq = cp->priv;
-
+	softirq = *(int *)cp->info;
 	local_irq_save(flags);
 	__local_trigger(cp, softirq);
 	local_irq_restore(flags);
@@ -631,9 +630,8 @@ static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softir
 {
 	if (cpu_online(cpu)) {
 		cp->func = remote_softirq_receive;
-		cp->info = cp;
+		cp->info = &softirq;
 		cp->flags = 0;
-		cp->priv = softirq;
 
 		__smp_call_function_single(cpu, cp, 0);
 		return 0;
-- 
1.7.2.5

