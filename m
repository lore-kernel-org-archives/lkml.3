Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3FNVdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:33:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3FNVdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:33:20 -0400
Date: Fri, 14 Jun 2013 14:33:08 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-1169f9b1e7bfb609264544bf3581f038722eb10a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        rientjes@google.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        rientjes@google.com, hpa@linux.intel.com
In-Reply-To: <1371128589-8953-17-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-17-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm, numa: Move numa emulation handling down.
Git-Commit-ID: 1169f9b1e7bfb609264544bf3581f038722eb10a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:33:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1169f9b1e7bfb609264544bf3581f038722eb10a
Gitweb:     http://git.kernel.org/tip/1169f9b1e7bfb609264544bf3581f038722eb10a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:03:03 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:05:05 -0700

x86, mm, numa: Move numa emulation handling down.

numa_emulation() needs to allocate buffer for new numa_meminfo
and distance matrix, so execute it later in x86_numa_init().

Also we change the behavoir:
	- before this patch, if user input wrong data in command
	  line, it will fall back to next numa probing or disabling
	  numa.
	- after this patch, if user input wrong data in command line,
	  it will stay with numa info probed from previous probing,
	  like ACPI SRAT or amd_numa.

We need to call numa_check_memblks to reject wrong user inputs early
so that we can keep the original numa_meminfo not changed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-17-git-send-email-tangchen@cn.fujitsu.com
Cc: David Rientjes <rientjes@google.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa.c           | 6 +++---
 arch/x86/mm/numa_emulation.c | 2 +-
 arch/x86/mm/numa_internal.h  | 2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index da2ebab..3254f22 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -534,7 +534,7 @@ static unsigned long __init node_map_pfn_alignment(struct numa_meminfo *mi)
 }
 #endif
 
-static int __init numa_check_memblks(struct numa_meminfo *mi)
+int __init numa_check_memblks(struct numa_meminfo *mi)
 {
 	nodemask_t nodes_parsed;
 	unsigned long pfn_align;
@@ -604,8 +604,6 @@ static int __init numa_init(int (*init_func)(void))
 	if (ret < 0)
 		return ret;
 
-	numa_emulation(&numa_meminfo, numa_distance_cnt);
-
 	ret = numa_check_memblks(&numa_meminfo);
 	if (ret < 0)
 		return ret;
@@ -669,6 +667,8 @@ void __init x86_numa_init(void)
 
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
