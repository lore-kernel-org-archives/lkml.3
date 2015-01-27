Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbbA0FwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 00:52:19 -0500
Received: from numascale.com ([213.162.240.84]:37407 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbbA0FwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 00:52:16 -0500
X-Greylist: delayed 2609 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2015 00:52:16 EST
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>,
        Daniel J Blueman <daniel@numascale.com>
Subject: [PATCH] x86: Fix sibling map with NumaChip
Date: Tue, 27 Jan 2015 13:07:23 +0800
Message-Id: <1422335243-3426-1-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On NumaChip systems, the physical processor ID assignment wasn't accounting
for the number of nodes in AMD multi-module processors, giving an incorrect
sibling map:

$ cd /sys/devices/system/cpu/cpu29/topology
$ grep . *
core_id:5
core_siblings:00000000,ff000000
core_siblings_list:24-31
physical_package_id:3
thread_siblings:00000000,30000000
thread_siblings_list:28-29

After fixing:

core_id:5
core_siblings:00000000,ffff0000
core_siblings_list:16-31
physical_package_id:1
thread_siblings:00000000,30000000
thread_siblings_list:28-29

Candidate for stable.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/kernel/apic/apic_numachip.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 19f893f..a59768b 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -180,11 +180,15 @@ static int __init numachip_probe(void)
 
 static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 {
-
-	if (c->phys_proc_id != node) {
-		c->phys_proc_id = node;
-		per_cpu(cpu_llc_id, smp_processor_id()) = node;
-	}
+	u64 val;
+	u32 nodes;
+
+	per_cpu(cpu_llc_id, smp_processor_id()) = node;
+
+	/* Account for nodes per socket in multi-core-module processors */
+	rdmsrl(MSR_FAM10H_NODE_ID, val);
+	nodes = ((val >> 3) & 7) + 1;
+	c->phys_proc_id = node / nodes;
 }
 
 static int parse_oemn(struct acpi_table_header *table)
-- 
2.1.0

