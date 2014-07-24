Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbaGXQu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:50:56 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35289 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885AbaGXQuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:50:54 -0400
Message-Id: <20140724165047.437075575@openvz.org>
User-Agent: quilt/0.60-1
Date: Thu, 24 Jul 2014 20:46:58 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: gorcunov@openvz.org, keescook@chromium.org, tj@kernel.org,
        akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com,
        hpa@zytor.com, serge.hallyn@canonical.com, xemul@parallels.com,
        segoon@openwall.com, kamezawa.hiroyu@jp.fujitsu.com,
        mtk.manpages@gmail.com, jln@google.com
Subject: [rfc 1/4] mm: Introduce may_adjust_brk helper
References: <20140724164657.452106845@openvz.org>
Content-Disposition: inline; filename=prctl-add-may_adjust_brk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To eliminate code duplication lets introduce may_adjust_brk
helper which we will use in brk() and prctl() syscalls.

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
 include/linux/mm.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

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
@@ -1780,6 +1781,19 @@ extern struct vm_area_struct *copy_vma(s
 	bool *need_rmap_locks);
 extern void exit_mmap(struct mm_struct *);
 
+static inline int may_adjust_brk(unsigned long rlim,
+				 unsigned long new_brk,
+				 unsigned long start_brk,
+				 unsigned long end_data,
+				 unsigned long start_data)
+{
+	if (rlim < RLIMIT_DATA) {
+		if (((new_brk - start_brk) + (end_data - start_data)) > rlim)
+			return -ENOSPC;
+	}
+	return 0;
+}
+
 extern int mm_take_all_locks(struct mm_struct *mm);
 extern void mm_drop_all_locks(struct mm_struct *mm);
 

