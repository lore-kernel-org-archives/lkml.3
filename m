Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3FKQm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:42:59 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44264 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3FKQmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:42:55 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v2 02/14] perf: Add persistent events
Date: Tue, 11 Jun 2013 18:42:28 +0200
Message-Id: <1370968960-22527-3-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

Add the needed pieces for persistent events which makes them
process-agnostic. Also, make their buffers read-only when mmaping them
from userspace.

While at it, do not return a void function, as caught by Fengguang's
build robot.

Changes made by Robert Richter <robert.richter@linaro.org>:

* mmap should return EACCES error if fd can not be opened writable.
  This error code also helps userland to map buffers readonly on
  failure.

Signed-off-by: Borislav Petkov <bp@suse.de>
[ Return -EACCES if mapped buffers must be readonly ]
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 include/uapi/linux/perf_event.h |  3 ++-
 kernel/events/core.c            | 10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index fb104e5..6032361 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -272,8 +272,9 @@ struct perf_event_attr {
 
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
+				persistent     :  1, /* always-on event */
 
-				__reserved_1   : 41;
+				__reserved_1   : 40;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b790ab6..a13e457 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3713,6 +3713,11 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
+	if (event->attr.persistent) {
+		atomic_dec(&event->mmap_count);
+		return;
+	}
+
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
 		unsigned long size = perf_data_size(event->rb);
 		struct user_struct *user = event->mmap_user;
@@ -3756,9 +3761,12 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
 
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!(vma->vm_flags & VM_SHARED) && !event->attr.persistent)
 		return -EINVAL;
 
+	if (event->attr.persistent && (vma->vm_flags & VM_WRITE))
+		return -EACCES;
+
 	vma_size = vma->vm_end - vma->vm_start;
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
-- 
1.8.1.1

