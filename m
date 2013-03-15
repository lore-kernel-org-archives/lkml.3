Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3CONGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:06:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52637 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab3CONGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:06:38 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Robert Richter <rric@kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 1/3] perf: Add persistent events
Date: Fri, 15 Mar 2013 14:06:27 +0100
Message-Id: <1363352789-17991-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1363352789-17991-1-git-send-email-bp@alien8.de>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the needed pieces for persistent events which makes them
process-agnostic. Also, make their buffers read-only when mmaping them
from userspace.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 include/uapi/linux/perf_event.h | 3 ++-
 kernel/events/core.c            | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9fa9c622a7f4..4a4ae56195e1 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -270,8 +270,9 @@ struct perf_event_attr {
 
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
+				persistent     :  1, /* always-on event */
 
-				__reserved_1   : 41;
+				__reserved_1   : 40;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd86501c30..7c712b0c3b9a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3560,6 +3560,9 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
+	if (event->attr.persistent)
+		return atomic_dec(&event->mmap_count);
+
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
 		unsigned long size = perf_data_size(event->rb);
 		struct user_struct *user = event->mmap_user;
@@ -3603,7 +3606,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
 
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!(vma->vm_flags & VM_SHARED) && !event->attr.persistent)
+		return -EINVAL;
+
+	if (event->attr.persistent && (vma->vm_flags & VM_WRITE))
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
-- 
1.8.1.3.535.ga923c31

