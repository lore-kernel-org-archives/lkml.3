Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3E2QKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:10:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:47075 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab3E2QKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:10:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,765,1363158000"; 
   d="scan'208";a="345174361"
From: Youquan Song <youquan.song@intel.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH] core: Fix maxcpus boot option broken
Date: Thu, 30 May 2013 00:00:06 -0400
Message-Id: <1369886406-14079-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maxcpus boot option to limit maximum number of CPUs on system, but this option
is broken at recent kernel. Though we use maxcpus to limit CPUs number, but
current kernel will register all of present CPUs in sysfs.
udev will enumerate all registered cpu at sysfs, and it will bring up the CPU
if the CPU is offline. So the maxcpus option is broken.

This patch will only register the CPU which is not over limitation of maxcpus 
option in sysfs. So it will keep the maxcpus limitation when udev enumeration
or other intention of bring up CPUs over the limitation by method like  
echo 1 > /sys/devices/system/cpu/online 

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/base/cpu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 3d48fc8..c7d603a 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -272,6 +272,10 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 {
 	int error;
 
+	/* return when cpu number greater than maximum number of CPUs */
+	if (num >= setup_max_cpus)
+		return 0;
+
 	cpu->node_id = cpu_to_node(num);
 	memset(&cpu->dev, 0x00, sizeof(struct device));
 	cpu->dev.id = num;
-- 
1.7.7.4

