Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3HPWjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51564 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3HPWiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Adrian Sendroiu <molecula2788@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 121/133] x86 get_unmapped_area(): use proper mmap base for bottom-up direction
Date: Fri, 16 Aug 2013 15:34:23 -0700
Message-Id: <1376692475-28413-122-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Caragea <sinaelgl@gmail.com>

commit df54d6fa54275ce59660453e29d1228c2b45a826 upstream.

When the stack is set to unlimited, the bottomup direction is used for
mmap-ings but the mmap_base is not used and thus effectively renders
ASLR for mmapings along with PIE useless.

Cc: Michel Lespinasse <walken@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Sendroiu <molecula2788@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/sys_x86_64.c | 2 +-
 arch/x86/mm/mmap.c           | 2 +-
 include/linux/sched.h        | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 97ef74b..af46e18 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -101,7 +101,7 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 				*begin = new_begin;
 		}
 	} else {
-		*begin = TASK_UNMAPPED_BASE;
+		*begin = mmap_legacy_base();
 		*end = TASK_SIZE;
 	}
 }
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 845df68..c1af323 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -98,7 +98,7 @@ static unsigned long mmap_base(void)
  * Bottom-up (legacy) layout on X86_32 did not support randomization, X86_64
  * does, but not when emulating X86_32
  */
-static unsigned long mmap_legacy_base(void)
+unsigned long mmap_legacy_base(void)
 {
 	if (mmap_is_ia32())
 		return TASK_UNMAPPED_BASE;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index caa76ae..9d96429 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -360,6 +360,7 @@ extern int sysctl_max_map_count;
 #include <linux/aio.h>
 
 #ifdef CONFIG_MMU
+extern unsigned long mmap_legacy_base(void);
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
 arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
-- 
1.8.1.2

