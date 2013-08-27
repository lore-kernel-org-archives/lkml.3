Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3H0BMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:12:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3H0BHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Radu Caragea <sinaelgl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Adrian Sendroiu <molecula2788@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 68/74] x86 get_unmapped_area: Access mmap_legacy_base through mm_struct member
Date: Mon, 26 Aug 2013 18:09:06 -0700
Message-Id: <20130827010438.570570474@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/sys_x86_64.c |    2 +-
 arch/x86/mm/mmap.c           |    6 ++++--
 include/linux/mm_types.h     |    1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -101,7 +101,7 @@ static void find_start_end(unsigned long
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
@@ -333,6 +333,7 @@ struct mm_struct {
 	void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
 #endif
 	unsigned long mmap_base;		/* base of mmap area */
+	unsigned long mmap_legacy_base;         /* base of mmap area in bottom-up allocations */
 	unsigned long task_size;		/* size of task vm space */
 	unsigned long cached_hole_size; 	/* if non-zero, the largest hole below free_area_cache */
 	unsigned long free_area_cache;		/* first hole of size cached_hole_size or larger */


