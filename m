Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaKYLnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:43:43 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:38376 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbaKYLnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:43:40 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com
Subject: [RFC 2/2] mm, sched: trigger might_sleep() in might_fault() when atomic
Date: Tue, 25 Nov 2014 12:43:26 +0100
Message-Id: <1416915806-24757-3-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112511-0025-0000-0000-000002918F3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 662bbcb2747c2422cf98d3d97619509379eee466 disabled in atomic checks
for all user access code (that uses might_fault()).

That change basically disabled CONFIG_DEBUG_ATOMIC_SLEEP for all user access
functions. However, this is a mighty debugging aid that we want.

If user memory is to be accessed while pagefault_disabled() is set, the atomic
variants of copy_(to|from)_user can be used.

This patch reverts commit 662bbcb2747c2422cf98d3d97619509379eee466 taking care
of the !MMU optimization.

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 include/linux/kernel.h |  8 ++++++--
 mm/memory.c            | 11 ++++-------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3d770f55..1d3397c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -225,9 +225,13 @@ static inline u32 reciprocal_scale(u32 val, u32 ep_ro)
 	return (u32)(((u64) val * ep_ro) >> 32);
 }
 
-#if defined(CONFIG_MMU) && \
-	(defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP))
+#if defined(CONFIG_MMU) && defined(CONFIG_PROVE_LOCKING)
 void might_fault(void);
+#elif defined(CONFIG_MMU) && defined(CONFIG_DEBUG_ATOMIC_SLEEP)
+static inline void might_fault(void)
+{
+	__might_sleep(__FILE__, __LINE__, 0);
+}
 #else
 static inline void might_fault(void) { }
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 3e50383..fe0c815 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3699,7 +3699,7 @@ void print_vma_addr(char *prefix, unsigned long ip)
 	up_read(&mm->mmap_sem);
 }
 
-#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
+#ifdef CONFIG_PROVE_LOCKING
 void might_fault(void)
 {
 	/*
@@ -3711,17 +3711,14 @@ void might_fault(void)
 	if (segment_eq(get_fs(), KERNEL_DS))
 		return;
 
+	__might_sleep(__FILE__, __LINE__, 0);
+
 	/*
 	 * it would be nicer only to annotate paths which are not under
 	 * pagefault_disable, however that requires a larger audit and
 	 * providing helpers like get_user_atomic.
 	 */
-	if (in_atomic())
-		return;
-
-	__might_sleep(__FILE__, __LINE__, 0);
-
-	if (current->mm)
+	if (!in_atomic() && current->mm)
 		might_lock_read(&current->mm->mmap_sem);
 }
 EXPORT_SYMBOL(might_fault);
-- 
1.8.5.5

