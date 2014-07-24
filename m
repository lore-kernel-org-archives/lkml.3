Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbaGXQvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:51:00 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:51415 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622AbaGXQu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:50:56 -0400
Message-Id: <20140724165047.520230859@openvz.org>
User-Agent: quilt/0.60-1
Date: Thu, 24 Jul 2014 20:46:59 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: gorcunov@openvz.org, keescook@chromium.org, tj@kernel.org,
        akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com,
        hpa@zytor.com, serge.hallyn@canonical.com, xemul@parallels.com,
        segoon@openwall.com, kamezawa.hiroyu@jp.fujitsu.com,
        mtk.manpages@gmail.com, jln@google.com
Subject: [rfc 2/4] mm: Use may_adjust_brk helper
References: <20140724164657.452106845@openvz.org>
Content-Disposition: inline; filename=prctl-use-may_adjust_brk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Julien Tinnes <jln@google.com>
---
 kernel/sys.c |   10 ++++------
 mm/mmap.c    |    7 +++----
 2 files changed, 7 insertions(+), 10 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1733,9 +1733,8 @@ static int prctl_set_mm(int opt, unsigne
 		if (addr <= mm->end_data)
 			goto out;
 
-		if (rlim < RLIM_INFINITY &&
-		    (mm->brk - addr) +
-		    (mm->end_data - mm->start_data) > rlim)
+		if (may_adjust_brk(rlim, mm->brk, addr,
+				   mm->end_data, mm->start_data))
 			goto out;
 
 		mm->start_brk = addr;
@@ -1745,9 +1744,8 @@ static int prctl_set_mm(int opt, unsigne
 		if (addr <= mm->end_data)
 			goto out;
 
-		if (rlim < RLIM_INFINITY &&
-		    (addr - mm->start_brk) +
-		    (mm->end_data - mm->start_data) > rlim)
+		if (may_adjust_brk(rlim, addr, mm->start_brk,
+				   mm->end_data, mm->start_data))
 			goto out;
 
 		mm->brk = addr;
Index: linux-2.6.git/mm/mmap.c
===================================================================
--- linux-2.6.git.orig/mm/mmap.c
+++ linux-2.6.git/mm/mmap.c
@@ -263,7 +263,7 @@ static unsigned long do_brk(unsigned lon
 
 SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
-	unsigned long rlim, retval;
+	unsigned long retval;
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
 	unsigned long min_brk;
@@ -293,9 +293,8 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	 * segment grow beyond its set limit the in case where the limit is
 	 * not page aligned -Ram Gupta
 	 */
-	rlim = rlimit(RLIMIT_DATA);
-	if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
-			(mm->end_data - mm->start_data) > rlim)
+	if (may_adjust_brk(rlimit(RLIMIT_DATA), brk, mm->start_brk,
+			   mm->end_data, mm->start_data))
 		goto out;
 
 	newbrk = PAGE_ALIGN(brk);

