Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3CJGrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:47:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48262 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3CJGrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:47:39 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v2 15/20] x86, mm, numa: Move emulation handling down.
Date: Sat,  9 Mar 2013 22:44:42 -0800
Message-Id: <1362897887-30808-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It needs to allocate buffer for new numa_meminfo and distance matrix,
so move it down.

Also we change the behavoir:
before this patch, if user input wrong data in command line, it
will fall back to next numa probing or disabling numa.
after this patch, if user input wrong data in command line, it will
stay with numa info from probing before, like acpi srat or amd_numa.

We need to call numa_check_memblks to reject wrong user inputs early,
so keep the original numa_meminfo not changed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/numa.c           |    6 +++---
 arch/x86/mm/numa_emulation.c |    2 +-
 arch/x86/mm/numa_internal.h  |    2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 1d5fa08..90fd123 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -537,7 +537,7 @@ static unsigned long __init node_map_pfn_alignment(struct numa_meminfo *mi)
 }
 #endif
 
-static int __init numa_check_memblks(struct numa_meminfo *mi)
+int __init numa_check_memblks(struct numa_meminfo *mi)
 {
 	nodemask_t nodes_parsed;
 	unsigned long pfn_align;
@@ -607,8 +607,6 @@ static int __init numa_init(int (*init_func)(void))
 	if (ret < 0)
 		return ret;
 
-	numa_emulation(&numa_meminfo, numa_distance_cnt);
-
 	ret = numa_check_memblks(&numa_meminfo);
 	if (ret < 0)
 		return ret;
@@ -672,6 +670,8 @@ void __init x86_numa_init(void)
 
 	early_x86_numa_init();
 
+	numa_emulation(&numa_meminfo, numa_distance_cnt);
+
 	node_possible_map = numa_nodes_parsed;
 	numa_nodemask_from_meminfo(&node_possible_map, mi);
 
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index dbbbb47..5a0433d 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -348,7 +348,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	if (ret < 0)
 		goto no_emu;
 
-	if (numa_cleanup_meminfo(&ei) < 0) {
+	if (numa_cleanup_meminfo(&ei) < 0 || numa_check_memblks(&ei) < 0) {
 		pr_warning("NUMA: Warning: constructed meminfo invalid, disabling emulation\n");
 		goto no_emu;
 	}
diff --git a/arch/x86/mm/numa_internal.h b/arch/x86/mm/numa_internal.h
index ad86ec9..bb2fbcc 100644
--- a/arch/x86/mm/numa_internal.h
+++ b/arch/x86/mm/numa_internal.h
@@ -21,6 +21,8 @@ void __init numa_reset_distance(void);
 
 void __init x86_numa_init(void);
 
+int __init numa_check_memblks(struct numa_meminfo *mi);
+
 #ifdef CONFIG_NUMA_EMU
 void __init numa_emulation(struct numa_meminfo *numa_meminfo,
 			   int numa_dist_cnt);
-- 
1.7.10.4

