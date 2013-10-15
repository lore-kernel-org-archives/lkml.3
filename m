Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253Ab3JORRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:17:20 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:36205 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab3JORRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:17:07 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/2] mm: Clear N_CPU from node_states at CPU offline
Date: Tue, 15 Oct 2013 11:12:56 -0600
Message-Id: <1381857176-22999-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381857176-22999-1-git-send-email-toshi.kani@hp.com>
References: <1381857176-22999-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmstat_cpuup_callback() is a CPU notifier callback, which
marks N_CPU to a node at CPU online event.  However, it
does not update this N_CPU info at CPU offline event.

Changed vmstat_cpuup_callback() to clear N_CPU when the last
CPU in the node is put into offline, i.e. the node no longer
has any online CPU.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 mm/vmstat.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 0a1f7de..b6d17ed 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1229,6 +1229,20 @@ static void start_cpu_timer(int cpu)
 	schedule_delayed_work_on(cpu, work, __round_jiffies_relative(HZ, cpu));
 }
 
+static void vmstat_cpu_dead(int node)
+{
+	int cpu;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (cpu_to_node(cpu) == node)
+			goto end;
+
+	node_clear_state(node, N_CPU);
+end:
+	put_online_cpus();
+}
+
 /*
  * Use the cpu notifier to insure that the thresholds are recalculated
  * when necessary.
@@ -1258,6 +1272,7 @@ static int vmstat_cpuup_callback(struct notifier_block *nfb,
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		refresh_zone_stat_thresholds();
+		vmstat_cpu_dead(cpu_to_node(cpu));
 		break;
 	default:
 		break;
