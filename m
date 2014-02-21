Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaBUDEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 22:04:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaBUDEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 22:04:13 -0500
Date: Thu, 20 Feb 2014 19:03:43 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-896dc5064083063981954f142e43548765199792@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com, hpa@zytor.com,
        mingo@kernel.org, rjw@rjwysocki.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        hpa@linux.intel.com
In-Reply-To: <1390185115-26850-1-git-send-email-jiang.liu@linux.intel.com>
References: <1390185115-26850-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/acpi] x86, acpi:
  Fix bug in associating hot-added CPUs with corresponding NUMA node
Git-Commit-ID: 896dc5064083063981954f142e43548765199792
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  896dc5064083063981954f142e43548765199792
Gitweb:     http://git.kernel.org/tip/896dc5064083063981954f142e43548765199792
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 20 Jan 2014 10:31:54 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Feb 2014 19:01:22 -0800

x86, acpi: Fix bug in associating hot-added CPUs with corresponding NUMA node

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
Link: http://lkml.kernel.org/r/1390185115-26850-1-git-send-email-jiang.liu@linux.intel.com
Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 1dac942..9f46f2b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -613,10 +613,10 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
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
 
