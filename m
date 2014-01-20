Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaATCbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 21:31:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:34503 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaATCbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 21:31:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,688,1384329600"; 
   d="scan'208";a="335283307"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [Patch v1] ACPI, x86: fix bug in associating hot-added CPUs with corresponding NUMA node
Date: Mon, 20 Jan 2014 10:31:54 +0800
Message-Id: <1390185115-26850-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current ACPI cpu hotplug driver fails to associate hot-added CPUs with
corresponding NUMA node when doing socket online. The code path to
associate CPU with NUMA node is as below:
acpi_processor_add()
    ->acpi_processor_get_info()
	->acpi_processor_hotadd_init()
	    ->acpi_map_lsapic()
		->_acpi_map_lsapic()
		    ->acpi_map_cpu2node()
cpu_subsys_online()
    ->try_online_node()
	->node_set_online()

When doing socket online, a new NUMA node is introduced in addition to
hot-added CPU and memory device. And the new NUMA node is marked as
online when onlining hot-added CPUs through sysfs interface
/sys/devices/system/cpu/cpuxx/online.

On the other hand, acpi_map_cpu2node() will only build the CPU to node
map if corresponding NUMA node is already online, so it always fails
to associate hot-added CPUs with corresponding NUMA node because the
NUMA node is still in offline state.

For the fix, we could safely remove the "node_online(node)" check in
function acpi_map_cpu2node() because it's only called for hot-added CPUs
by acpi_processor_hotadd_init().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6c0b43b..7625de9 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -614,10 +614,10 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 	int nid;
 
 	nid = acpi_get_node(handle);
-	if (nid == -1 || !node_online(nid))
-		return;
-	set_apicid_to_node(physid, nid);
-	numa_set_node(cpu, nid);
+	if (nid != -1) {
+		set_apicid_to_node(physid, nid);
+		numa_set_node(cpu, nid);
+	}
 #endif
 }
 
-- 
1.7.10.4

