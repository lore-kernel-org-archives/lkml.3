Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaHDR3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:29:40 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:44448 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaHDR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:26:14 -0400
Message-Id: <20140804172610.795642714@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 21:22:57 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: gorcunov@openvz.org, keescook@chromium.org, tj@kernel.org,
        akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com,
        hpa@zytor.com, serge.hallyn@canonical.com, xemul@parallels.com,
        segoon@openwall.com, kamezawa.hiroyu@jp.fujitsu.com,
        mtk.manpages@gmail.com, jln@google.com
Subject: [patch 2/4] mm: Use may_adjust_brk helper
References: <20140804172255.109539743@openvz.org>
Content-Disposition: inline; filename=prctl-use-may_adjust_brk-2
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
 kernel/sys.c |   11 ++++-------
 mm/mmap.c    |    7 +++----
 2 files changed, 7 insertions(+), 11 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1693,7 +1693,6 @@ exit:
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
-	unsigned long rlim = rlimit(RLIMIT_DATA);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int error;
@@ -1733,9 +1732,8 @@ static int prctl_set_mm(int opt, unsigne
 		if (addr <= mm->end_data)
 			goto out;
 
-		if (rlim < RLIM_INFINITY &&
-		    (mm->brk - addr) +
-		    (mm->end_data - mm->start_data) > rlim)
+		if (check_data_rlimit(rlimit(RLIMIT_DATA), mm->brk, addr,
+				      mm->end_data, mm->start_data))
 			goto out;
 
 		mm->start_brk = addr;
@@ -1745,9 +1743,8 @@ static int prctl_set_mm(int opt, unsigne
 		if (addr <= mm->end_data)
 			goto out;
 
-		if (rlim < RLIM_INFINITY &&
-		    (addr - mm->start_brk) +
-		    (mm->end_data - mm->start_data) > rlim)
+		if (check_data_rlimit(rlimit(RLIMIT_DATA), addr, mm->start_brk,
+				      mm->end_data, mm->start_data))
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
+	if (check_data_rlimit(rlimit(RLIMIT_DATA), brk, mm->start_brk,
+			      mm->end_data, mm->start_data))
 		goto out;
 
 	newbrk = PAGE_ALIGN(brk);

