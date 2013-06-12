Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3FLEXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 00:23:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52920 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3FLEXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 00:23:21 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dgiani@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 4/8] vrange: Clear volatility on new mmaps
Date: Tue, 11 Jun 2013 21:22:47 -0700
Message-Id: <1371010971-15647-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371010971-15647-1-git-send-email-john.stultz@linaro.org>
References: <1371010971-15647-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At lsf-mm, the issue was brought up that there is a precedence with
interfaces like mlock, such that new mappings in a pre-existing range
do no inherit the mlock state.

This is mostly because mlock only modifies the existing vmas, and so
any new mmaps create new vmas, which won't be mlocked.

Since volatility is not stored in the vma (for good cause, specfically
as we'd have to have manage file volatility differently from anonymous
and we're likely to manage volatility on small chunks of memory, which
would cause lots of vma splitting and churn), this patch clears volatilty
on new mappings, to ensure that we don't inherit volatility if memory in
an existing volatile range is unmapped and then re-mapped with something
else.

Thus, this patch forces any volatility to be cleared on mmap.

XXX: We expect this patch to be not well loved by mm folks, and are open
to alternative methods here. Its more of a place holder to address
the issue from lsf-mm and hopefully will spur some further discussion.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Robert Love <rlove@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mike Hommey <mh@glandium.org>
Cc: Taras Glek <tglek@mozilla.com>
Cc: Dhaval Giani <dgiani@mozilla.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org <linux-mm@kvack.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/vrange.h | 2 ++
 mm/mmap.c              | 5 +++++
 mm/vrange.c            | 8 ++++++++
 3 files changed, 15 insertions(+)

diff --git a/include/linux/vrange.h b/include/linux/vrange.h
index 13f4887..a97ac25 100644
--- a/include/linux/vrange.h
+++ b/include/linux/vrange.h
@@ -32,6 +32,8 @@ static inline int vrange_type(struct vrange *vrange)
 }
 
 void vrange_init(void);
+extern int vrange_clear(struct vrange_root *vroot,
+				unsigned long start, unsigned long end);
 extern void vrange_root_cleanup(struct vrange_root *vroot);
 extern int vrange_fork(struct mm_struct *new,
 					struct mm_struct *old);
diff --git a/mm/mmap.c b/mm/mmap.c
index f681e18..80d3676 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -36,6 +36,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/notifier.h>
 #include <linux/memory.h>
+#include <linux/vrange.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1500,6 +1501,10 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	/* Clear old maps */
 	error = -ENOMEM;
 munmap_back:
+
+	/* zap any volatile ranges */
+	vrange_clear(&mm->vroot, addr, addr + len);
+
 	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
diff --git a/mm/vrange.c b/mm/vrange.c
index bbaa184..5ca8853 100644
--- a/mm/vrange.c
+++ b/mm/vrange.c
@@ -164,6 +164,14 @@ static int vrange_remove(struct vrange_root *vroot,
 	return 0;
 }
 
+int vrange_clear(struct vrange_root *vroot,
+					unsigned long start, unsigned long end)
+{
+	int purged;
+
+	return vrange_remove(vroot, start, end-1, &purged);
+}
+
 void vrange_root_cleanup(struct vrange_root *vroot)
 {
 	struct vrange *range;
-- 
1.8.1.2

