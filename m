Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3IKE67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab3IKE5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:03 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=XzCKSsFNzgYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_BOshrSffKcA:10 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=3q3N-bn5uyPrNHFMcXwA:9 a=MSl-tDqOz04A:10 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042924.294230454@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Sendroiu <molecula2788@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [193/251] x86 get_unmapped_area(): use proper mmap base for bottom-up
 direction
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0193-x86-get_unmapped_area-use-proper-mmap-base-for-botto.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Radu Caragea <sinaelgl@gmail.com>

[ Upstream commit df54d6fa54275ce59660453e29d1228c2b45a826 ]

When the stack is set to unlimited, the bottomup direction is used for
mmap-ings but the mmap_base is not used and thus effectively renders
ASLR for mmapings along with PIE useless.

Cc: Michel Lespinasse <walken@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Sendroiu <molecula2788@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/sys_x86_64.c |    2 +-
 arch/x86/mm/mmap.c           |    2 +-
 include/linux/sched.h        |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index b4d3c39..2145c1b 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -115,7 +115,7 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
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
index 46bac3e..8c00159 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -388,6 +388,7 @@ extern int sysctl_max_map_count;
 #include <linux/aio.h>
 
 #ifdef CONFIG_MMU
+extern unsigned long mmap_legacy_base(void);
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
 arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
-- 
1.7.10.4


