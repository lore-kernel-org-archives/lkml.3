Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423045Ab3CWB0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:26:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:62847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423009Ab3CWB0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:26:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455618"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 29/29] tsx: Add documentation for lock-elision
Date: Fri, 22 Mar 2013 18:25:23 -0700
Message-Id: <1364001923-10796-30-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Document the tunables and the statistics in Documentation/lock-elision.txt

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/lock-elision.txt |   94 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/lock-elision.txt

diff --git a/Documentation/lock-elision.txt b/Documentation/lock-elision.txt
new file mode 100644
index 0000000..bc5a5ac
--- /dev/null
+++ b/Documentation/lock-elision.txt
@@ -0,0 +1,94 @@
+
+The Linux kernel uses Intel TSX lock elision for most of its locking primitives,
+when the hardware supports TSX.
+
+This allows to run lock regions that follow specific conditions to run
+in parallel without explicit blocking in a memory transaction. If the
+transaction fails the code falls back to the normal lock.
+
+The lock elision is implemented using RTM.
+
+To measure transaction success the TSX perf extensions should be used.
+(At the time of this writing this requires unmerged perf patches,
+as in the full Haswell PMU patch series in hsw/pmu* in
+git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git)
+
+perf stat -T ...
+perf record -e tx-aborts ...
+
+The elision code is mostly adaptive, that is the lock predicts whether
+it should elide or not based on the history.
+
+There are various tunables available in /sys/module/rtm_locks/parameters.
+The tunables are grouped by lock types.
+
+Elision can be enabled by lock types:
+
+rwsem_elision		Enable elision for read-write semaphores
+mutex_elision		Enable elision for mutexes
+spinlock_elision	Enable elision for spinlocks
+rwlock_elision		Enable elision for read-write spinlocks
+bitlock_elision		Enable elision for bit spinlocks
+
+Some lock types use adaptive algorithms. The adaptive algorithm
+has a number of tunables which can be tuned. Each tunable 
+is named LOCKTYPE_TUNABLE. For example to tune the conflict retries
+for mutexes do
+
+echo NUMBER > /sys/module/rtm_locks/parameters/mutex_conflict_retry
+
+Valid adaptive lock types are:
+mutex, readlock, writelock, readsem, writesem, spinlock
+
+The current tunables are (subject to change):
+
+In general increasing the skip counts makes lock elision more conservative,
+while increasing retries or timeout makes it more aggressive.
+
+*_elision 			Global elision enable for the lock type.
+*_conflict_abort_skip		Number of elisions to skip when a transaction
+				failed due to a number of retried conflicts.
+*_conflict_retry		Number of retries on memory conflicts
+*_internal_abort_skip		Number of elision to skip when a transaction
+				failed due to a reason inside the transaction
+				(that is not caused by another CPU)
+*_lock_busy_retry		How often to retry wen the lock is busy on
+				elision.
+*_lock_busy_skip		How often to skip elision when retries on
+				lock busy failed.
+*_other_abort_skip		How often to skip elision when the transaction
+				failed for other reasons (e.g. capacity overflow)
+*_retry_timeout			How often to spin while waiting for a lock to free
+				before retrying
+
+Note these tunables do not present an ABI and may change as the internals
+evolve.
+
+Additional statistics:
+
+lock_el_skip			Number of times a lock didn't elide due to skipping
+lock_el_skip_start		Number of times a lock started skipping
+
+The average skip is lock_el_skip / lock_el_start_skip
+Additional statistics can be gotten using perf PMU TSX events.
+
+There is also a elision:elision_skip_start trace point that triggers every time
+a lock starts skipping elision due to non success.
+
+References:
+"Adding Lock elision to Linux"
+http://halobates.de/adding-lock-elision-to-linux.pdf
+
+"Adding lock elision to the GNU C Library"
+http://lwn.net/Articles/533894/
+
+Full TSX specification:
+http://software.intel.com/file/41417 (chapter 8)
+
+Glossary:
+cache line	Aligned 64 byte region
+conflict	Another CPU writes to a cache line read in a elided lock region,
+		or reads from a cache line written to in the region.
+abort		Rolling back the transaction and undoing its side effect
+
+Andi Kleen
-- 
1.7.7.6

