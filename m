Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaHDR0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:26:23 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:60204 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaHDR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:26:15 -0400
Message-Id: <20140804172610.714056240@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 21:22:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: gorcunov@openvz.org, keescook@chromium.org, tj@kernel.org,
        akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com,
        hpa@zytor.com, serge.hallyn@canonical.com, xemul@parallels.com,
        segoon@openwall.com, kamezawa.hiroyu@jp.fujitsu.com,
        mtk.manpages@gmail.com, jln@google.com
Subject: [patch 1/4] mm: Introduce check_data_rlimit helper, v2
References: <20140804172255.109539743@openvz.org>
Content-Disposition: inline; filename=prctl-add-may_adjust_brk-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To eliminate code duplication lets introduce check_data_rlimit
helper which we will use in brk() and prctl() syscalls.

v2 (serge.hallyn@):
 - need to check against RLIM_INFINITY rather than RLIMIT_DATA

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
 include/linux/mm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6.git/include/linux/mm.h
===================================================================
--- linux-2.6.git.orig/include/linux/mm.h
+++ linux-2.6.git/include/linux/mm.h
@@ -18,6 +18,7 @@
 #include <linux/pfn.h>
 #include <linux/bit_spinlock.h>
 #include <linux/shrinker.h>
+#include <linux/resource.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1780,6 +1781,20 @@ extern struct vm_area_struct *copy_vma(s
 	bool *need_rmap_locks);
 extern void exit_mmap(struct mm_struct *);
 
+static inline int check_data_rlimit(unsigned long rlim,
+				    unsigned long new,
+				    unsigned long start,
+				    unsigned long end_data,
+				    unsigned long start_data)
+{
+	if (rlim < RLIM_INFINITY) {
+		if (((new - start) + (end_data - start_data)) > rlim)
+			return -ENOSPC;
+	}
+
+	return 0;
+}
+
 extern int mm_take_all_locks(struct mm_struct *mm);
 extern void mm_drop_all_locks(struct mm_struct *mm);
 

