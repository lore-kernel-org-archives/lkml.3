Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3IHDV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56170 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756563Ab3IHDS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michel Lespinasse" <walken@google.com>,
        "Ingo Molnar" <mingo@elte.hu>, "Rik van Riel" <riel@redhat.com>,
        "Adrian Sendroiu" <molecula2788@gmail.com>,
        "Kamal Mostafa" <kamal@canonical.com>, "Greg KH" <greg@kroah.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Radu Caragea" <sinaelgl@gmail.com>, "Oleg Nesterov" <oleg@redhat.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.715760886@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [110/121] x86 get_unmapped_area: Access mmap_legacy_base through
 mm_struct member
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/sys_x86_64.c | 2 +-
 arch/x86/mm/mmap.c           | 6 ++++--
 include/linux/mm_types.h     | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -115,7 +115,7 @@ static void find_start_end(unsigned long
 				*begin = new_begin;
 		}
 	} else {
-		*begin = TASK_UNMAPPED_BASE;
+		*begin = current->mm->mmap_legacy_base;
 		*end = TASK_SIZE;
 	}
 }
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -112,12 +112,14 @@ static unsigned long mmap_legacy_base(vo
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
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -297,6 +297,7 @@ struct mm_struct {
 	void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
 #endif
 	unsigned long mmap_base;		/* base of mmap area */
+	unsigned long mmap_legacy_base;         /* base of mmap area in bottom-up allocations */
 	unsigned long task_size;		/* size of task vm space */
 	unsigned long cached_hole_size; 	/* if non-zero, the largest hole below free_area_cache */
 	unsigned long free_area_cache;		/* first hole of size cached_hole_size or larger */

