Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaCACRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:37 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42638 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaCACRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:35 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Liang Zhen <liang.zhen@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 17/17] lustre/libcfs: warn if all HTs in a core are gone
Date: Fri, 28 Feb 2014 21:16:46 -0500
Message-Id: <1393640206-20286-18-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libcfs cpu partition can't support CPU hotplug, but it is safe
when plug-in new CPU or enabling/disabling hyper-threading.
It has potential risk only if plug-out CPU because it may break CPU
affinity of Lustre threads.

Current libcfs will print warning for all CPU notification, this
patch changed this behavior and only output warning when we lost all
HTs in a CPU core which may have broken affinity of Lustre threads.

Signed-off-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-on: http://review.whamcloud.com/8770
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4454
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c    | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
index 58bb256..77b1ef6 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
@@ -952,6 +952,7 @@ static int
 cfs_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int  cpu = (unsigned long)hcpu;
+	bool	     warn;
 
 	switch (action) {
 	case CPU_DEAD:
@@ -962,9 +963,21 @@ cfs_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 		cpt_data.cpt_version++;
 		spin_unlock(&cpt_data.cpt_lock);
 	default:
-		CWARN("Lustre: can't support CPU hotplug well now, "
-		      "performance and stability could be impacted"
-		      "[CPU %u notify: %lx]\n", cpu, action);
+		if (action != CPU_DEAD && action != CPU_DEAD_FROZEN) {
+			CDEBUG(D_INFO, "CPU changed [cpu %u action %lx]\n",
+			       cpu, action);
+			break;
+		}
+
+		down(&cpt_data.cpt_mutex);
+		/* if all HTs in a core are offline, it may break affinity */
+		cfs_cpu_ht_siblings(cpu, cpt_data.cpt_cpumask);
+		warn = any_online_cpu(*cpt_data.cpt_cpumask) >= nr_cpu_ids;
+		up(&cpt_data.cpt_mutex);
+		CDEBUG(warn ? D_WARNING : D_INFO,
+		       "Lustre: can't support CPU plug-out well now, "
+		       "performance and stability could be impacted "
+		       "[CPU %u action: %lx]\n", cpu, action);
 	}
 
 	return NOTIFY_OK;
-- 
1.8.5.3

