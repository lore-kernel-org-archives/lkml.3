Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab3L3LlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:41:24 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39603 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3L3LlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:41:23 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/2] powerpc: Add debug checks to catch invalid cpu-to-node
 mappings
To: benh@kernel.crashing.org, paulus@samba.org, nfont@linux.vnet.ibm.com
Cc: maddy@linux.vnet.ibm.com,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Mon, 30 Dec 2013 17:06:04 +0530
Message-ID: <20131230113554.11508.45801.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20131230113517.11508.7224.stgit@srivatsabhat.in.ibm.com>
References: <20131230113517.11508.7224.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13123011-2674-0000-0000-00000C14B628
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been some weird bugs in the past where the kernel tried to associate
threads of the same core to different NUMA nodes, and things went haywire after
that point (as expected).

But unfortunately, root-causing such issues have been quite challenging, due to
the lack of appropriate debug checks in the kernel. These bugs usually lead to
some odd soft-lockups in the scheduler's build-sched-domain code in the CPU
hotplug path, which makes it very hard to trace it back to the incorrect
cpu-to-node mappings.

So add appropriate debug checks to catch such invalid cpu-to-node mappings
as early as possible.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/powerpc/mm/numa.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 6847d50..4f50c6a 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -570,16 +570,38 @@ out:
 	return nid;
 }
 
+static void verify_cpu_node_mapping(int cpu, int node)
+{
+	int base, sibling, i;
+
+	/* Verify that all the threads in the core belong to the same node */
+	base = cpu_first_thread_sibling(cpu);
+
+	for (i = 0; i < threads_per_core; i++) {
+		sibling = base + i;
+
+		if (sibling == cpu || cpu_is_offline(sibling))
+			continue;
+
+		if (cpu_to_node(sibling) != node) {
+			WARN(1, "CPU thread siblings %d and %d don't belong"
+				" to the same node!\n", cpu, sibling);
+			break;
+		}
+	}
+}
+
 static int cpu_numa_callback(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
 	unsigned long lcpu = (unsigned long)hcpu;
-	int ret = NOTIFY_DONE;
+	int ret = NOTIFY_DONE, nid;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		numa_setup_cpu(lcpu);
+		nid = numa_setup_cpu(lcpu);
+		verify_cpu_node_mapping((int)lcpu, nid);
 		ret = NOTIFY_OK;
 		break;
 #ifdef CONFIG_HOTPLUG_CPU

