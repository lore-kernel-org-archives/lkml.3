Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab3JORRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:17:08 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:7073 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3JORRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:17:04 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/2] mm: Set N_CPU to node_states during boot
Date: Tue, 15 Oct 2013 11:12:55 -0600
Message-Id: <1381857176-22999-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381857176-22999-1-git-send-email-toshi.kani@hp.com>
References: <1381857176-22999-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a system booted, N_CPU is not set to any node as
has_cpu shows an empty line.

  # cat /sys/devices/system/node/has_cpu
  (show-empty-line)

setup_vmstat() registers its CPU notifier callback,
vmstat_cpuup_callback(), which marks N_CPU to a node when
a CPU is put into online.  However, setup_vmstat() is
called after all CPUs are launched in the boot sequence.

Changed setup_vmstat() to mark N_CPU to the nodes with
online CPUs at boot, which is consistent with other
operations in vmstat_cpuup_callback(), i.e. start_cpu_timer()
and refresh_zone_stat_thresholds().

Also added get_online_cpus() to protect the
for_each_online_cpu() loop.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 mm/vmstat.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 9bb3145..0a1f7de 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1276,8 +1276,12 @@ static int __init setup_vmstat(void)
 
 	register_cpu_notifier(&vmstat_notifier);
 
-	for_each_online_cpu(cpu)
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
 		start_cpu_timer(cpu);
+		node_set_state(cpu_to_node(cpu), N_CPU);
+	}
+	put_online_cpus();
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
