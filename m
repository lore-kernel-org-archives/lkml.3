Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3JIRZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:25:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3JIRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:24:58 -0400
Date: Wed, 9 Oct 2013 10:24:12 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-10fc05d0e551146ad6feb0ab8902d28a2d3c5624@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-3-git-send-email-mgorman@suse.de>
References: <1381141781-10992-3-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: numa:
  Document automatic NUMA balancing sysctls
Git-Commit-ID: 10fc05d0e551146ad6feb0ab8902d28a2d3c5624
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:24:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10fc05d0e551146ad6feb0ab8902d28a2d3c5624
Gitweb:     http://git.kernel.org/tip/10fc05d0e551146ad6feb0ab8902d28a2d3c5624
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:40 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:39:20 +0200

mm: numa: Document automatic NUMA balancing sysctls

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-3-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/sysctl/kernel.txt | 66 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 9d4c1d1..1428c66 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -355,6 +355,72 @@ utilize.
 
 ==============================================================
 
+numa_balancing
+
+Enables/disables automatic page fault based NUMA memory
+balancing. Memory is moved automatically to nodes
+that access it often.
+
+Enables/disables automatic NUMA memory balancing. On NUMA machines, there
+is a performance penalty if remote memory is accessed by a CPU. When this
+feature is enabled the kernel samples what task thread is accessing memory
+by periodically unmapping pages and later trapping a page fault. At the
+time of the page fault, it is determined if the data being accessed should
+be migrated to a local memory node.
+
+The unmapping of pages and trapping faults incur additional overhead that
+ideally is offset by improved memory locality but there is no universal
+guarantee. If the target workload is already bound to NUMA nodes then this
+feature should be disabled. Otherwise, if the system overhead from the
+feature is too high then the rate the kernel samples for NUMA hinting
+faults may be controlled by the numa_balancing_scan_period_min_ms,
+numa_balancing_scan_delay_ms, numa_balancing_scan_period_reset,
+numa_balancing_scan_period_max_ms and numa_balancing_scan_size_mb sysctls.
+
+==============================================================
+
+numa_balancing_scan_period_min_ms, numa_balancing_scan_delay_ms,
+numa_balancing_scan_period_max_ms, numa_balancing_scan_period_reset,
+numa_balancing_scan_size_mb
+
+Automatic NUMA balancing scans tasks address space and unmaps pages to
+detect if pages are properly placed or if the data should be migrated to a
+memory node local to where the task is running.  Every "scan delay" the task
+scans the next "scan size" number of pages in its address space. When the
+end of the address space is reached the scanner restarts from the beginning.
+
+In combination, the "scan delay" and "scan size" determine the scan rate.
+When "scan delay" decreases, the scan rate increases.  The scan delay and
+hence the scan rate of every task is adaptive and depends on historical
+behaviour. If pages are properly placed then the scan delay increases,
+otherwise the scan delay decreases.  The "scan size" is not adaptive but
+the higher the "scan size", the higher the scan rate.
+
+Higher scan rates incur higher system overhead as page faults must be
+trapped and potentially data must be migrated. However, the higher the scan
+rate, the more quickly a tasks memory is migrated to a local node if the
+workload pattern changes and minimises performance impact due to remote
+memory accesses. These sysctls control the thresholds for scan delays and
+the number of pages scanned.
+
+numa_balancing_scan_period_min_ms is the minimum delay in milliseconds
+between scans. It effectively controls the maximum scanning rate for
+each task.
+
+numa_balancing_scan_delay_ms is the starting "scan delay" used for a task
+when it initially forks.
+
+numa_balancing_scan_period_max_ms is the maximum delay between scans. It
+effectively controls the minimum scanning rate for each task.
+
+numa_balancing_scan_size_mb is how many megabytes worth of pages are
+scanned for a given scan.
+
+numa_balancing_scan_period_reset is a blunt instrument that controls how
+often a tasks scan delay is reset to detect sudden changes in task behaviour.
+
+==============================================================
+
 osrelease, ostype & version:
 
 # cat osrelease
