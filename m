Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab3ICQ2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:28:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46597 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab3ICQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:28:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Radu Caragea <sinaelgl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Adrian Sendroiu <molecula2788@gmail.com>, Greg KH <greg@kroah.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 28/58] x86 get_unmapped_area: Access mmap_legacy_base through mm_struct member
Date: Tue,  3 Sep 2013 09:23:32 -0700
Message-Id: <1378225442-20654-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Caragea <sinaelgl@gmail.com>

commit 41aacc1eea645c99edbe8fbcf78a97dc9b862adc upstream.

This is the updated version of df54d6fa5427 ("x86 get_unmapped_area():
use proper mmap base for bottom-up direction") that only randomizes the
mmap base address once.

Signed-off-by: Radu Caragea <sinaelgl@gmail.com>
Reported-and-tested-by: Jeff Shorey <shoreyjeff@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Sendroiu <molecula2788@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/sys_x86_64.c | 2 +-
 arch/x86/mm/mmap.c           | 6 ++++--
 include/linux/mm_types.h     | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 97ef74b..9e9a72c 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -101,7 +101,7 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 				*begin = new_begin;
 		}
 	} else {
-		*begin = TASK_UNMAPPED_BASE;
+		*begin = current->mm->mmap_legacy_base;
 		*end = TASK_SIZE;
 	}
 }
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 845df68..5c1ae28 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -112,12 +112,14 @@ static unsigned long mmap_legacy_base(void)
  */
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
+	mm->mmap_legacy_base = mmap_legacy_base();
+	mm->mmap_base = mmap_base();
+
 	if (mmap_is_legacy()) {
-		mm->mmap_base = mmap_legacy_base();
+		mm->mmap_base = mm->mmap_legacy_base;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 		mm->unmap_area = arch_unmap_area;
 	} else {
-		mm->mmap_base = mmap_base();
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 		mm->unmap_area = arch_unmap_area_topdown;
 	}
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index f8f5162..7716e38 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -332,6 +332,7 @@ struct mm_struct {
 	void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
 #endif
 	unsigned long mmap_base;		/* base of mmap area */
+	unsigned long mmap_legacy_base;         /* base of mmap area in bottom-up allocations */
 	unsigned long task_size;		/* size of task vm space */
 	unsigned long cached_hole_size; 	/* if non-zero, the largest hole below free_area_cache */
 	unsigned long free_area_cache;		/* first hole of size cached_hole_size or larger */
-- 
1.8.1.2

