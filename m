Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbaGWCca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:32:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:34020 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbaGWCc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:32:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577335011"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:58:49 -0400
Message-Id: <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from x86/x2apic_cluster.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index e66766b..bfd2369 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -154,8 +154,11 @@ update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	unsigned int cpu;
 	int err = 0;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
+		if (action & CPU_TASKS_FROZEN)
+			break;
+
 		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
 					GFP_KERNEL)) {
 			err = -ENOMEM;
@@ -165,9 +168,11 @@ update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			err = -ENOMEM;
 		}
 		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+		/* fall though to next if action == CPU_DEAD */
+		if (action & CPU_TASKS_FROZEN)
+			break;
+	case CPU_UP_CANCELED:
 		for_each_online_cpu(cpu) {
 			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
 				continue;
-- 
2.0.0.rc2

