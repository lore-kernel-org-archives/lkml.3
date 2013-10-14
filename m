Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab3JNUIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:08:52 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:41492 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889Ab3JNUIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:08:49 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH] mm: Set N_CPU to node_states during boot
Date: Mon, 14 Oct 2013 14:04:56 -0600
Message-Id: <1381781096-13168-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a system booted, N_CPU is not set to any node as has_cpu
shows an empty line.

  # cat /sys/devices/system/node/has_cpu
  (show-empty-line)

setup_vmstat() registers its CPU notifier callback,
vmstat_cpuup_callback(), which marks N_CPU to a node when
a CPU is put into online.  However, setup_vmstat() is called
after all CPUs are launched in the boot sequence.

Change setup_vmstat() to mark N_CPU to the nodes with online
CPUs at boot.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 mm/vmstat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 9bb3145..c464a22 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1276,8 +1276,10 @@ static int __init setup_vmstat(void)
 
 	register_cpu_notifier(&vmstat_notifier);
 
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
 		start_cpu_timer(cpu);
+		node_set_state(cpu_to_node(cpu), N_CPU);
+	}
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
